import 'package:dio/dio.dart';
import 'package:saiyagym_mobile/core/storage/token_storage.dart';

enum RefreshOutcome {
  /// New pair stored; retry the request.
  refreshed,

  /// The API rejected the refresh token (expired, revoked or reused):
  /// tokens were cleared and the session is over.
  rejected,

  /// The API wasn't reached. Keep the tokens — offline is not logged out.
  unreachable,
}

/// Single-flight refresh: concurrent 401s share ONE `/auth/refresh` call.
///
/// This matters because refresh tokens rotate: two parallel refreshes would
/// send the same token twice and the API answers the second one with
/// `REFRESH_TOKEN_REUSED`, revoking the whole session.
class TokenRefresher {
  /// `dio` is a bare client (no auth interceptor) so a refresh can never
  /// recurse.
  TokenRefresher({
    required this._dio,
    required this._storage,
    required this._onSessionExpired,
  });

  final Dio _dio;
  final TokenStorage _storage;
  final void Function() _onSessionExpired;

  Future<RefreshOutcome>? _inFlight;

  Future<RefreshOutcome> refresh() =>
      _inFlight ??= _refresh().whenComplete(() => _inFlight = null);

  Future<RefreshOutcome> _refresh() async {
    final tokens = await _storage.read();
    if (tokens == null) return await _expire();

    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/auth/refresh',
        data: {'refreshToken': tokens.refreshToken},
      );
      await _storage.write(AuthTokens.fromJson(response.data!));
      return RefreshOutcome.refreshed;
    } on DioException catch (error) {
      final status = error.response?.statusCode;
      // 400/401/403: INVALID_REFRESH_TOKEN, REFRESH_TOKEN_REUSED, …
      if (status != null && status >= 400 && status < 500 && status != 429) {
        return await _expire();
      }
      return RefreshOutcome.unreachable;
    }
  }

  Future<RefreshOutcome> _expire() async {
    await _storage.clear();
    _onSessionExpired();
    return RefreshOutcome.rejected;
  }
}
