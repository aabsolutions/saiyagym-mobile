import 'package:dio/dio.dart';
import 'package:saiyagym_mobile/core/network/api_exception.dart';
import 'package:saiyagym_mobile/core/network/token_refresher.dart';
import 'package:saiyagym_mobile/core/storage/token_storage.dart';

/// Sends the current UI language so API error messages come back localized.
class AcceptLanguageInterceptor extends Interceptor {
  AcceptLanguageInterceptor(this._languageCode);

  final String Function() _languageCode;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers['Accept-Language'] = _languageCode();
    handler.next(options);
  }
}

/// Adds the Bearer token and, on 401, refreshes once and retries.
///
/// Requests to public endpoints (login, register, …) must set
/// [skipAuth] so a wrong password isn't treated as an expired session.
class AuthInterceptor extends Interceptor {
  AuthInterceptor({
    required this._storage,
    required this._refresher,
    required this._retry,
  });

  static const skipAuth = 'auth.skip';
  static const _retried = 'auth.retried';
  static const _sentToken = 'auth.sentToken';

  /// `Options(extra: AuthInterceptor.publicEndpoint)`.
  static const Map<String, Object> publicEndpoint = {skipAuth: true};

  final TokenStorage _storage;

  /// `null`: never refresh (see `buildApiClient(refreshTokens:)`).
  final TokenRefresher? _refresher;
  final Future<Response<dynamic>> Function(RequestOptions) _retry;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (options.extra[skipAuth] != true) {
      final tokens = await _storage.read();
      if (tokens != null) {
        options.headers['Authorization'] = 'Bearer ${tokens.accessToken}';
        options.extra[_sentToken] = tokens.accessToken;
      }
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final options = err.requestOptions;
    final refresher = _refresher;
    final canRefresh =
        refresher != null &&
        err.response?.statusCode == 401 &&
        options.extra[skipAuth] != true &&
        options.extra[_retried] != true;
    if (!canRefresh) return handler.next(err);

    // Another request already refreshed while this one was in flight.
    final current = await _storage.read();
    final alreadyRefreshed =
        current != null && current.accessToken != options.extra[_sentToken];
    final outcome = alreadyRefreshed
        ? RefreshOutcome.refreshed
        : await refresher.refresh();

    if (outcome != RefreshOutcome.refreshed) return handler.next(err);

    options.extra[_retried] = true;
    try {
      handler.resolve(await _retry(options));
    } on DioException catch (retryError) {
      handler.next(retryError);
    }
  }
}

/// Last in the chain: attaches an [ApiException] to every failure.
class ErrorMappingInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) =>
      handler.next(err.copyWith(error: ApiException.fromDio(err)));
}
