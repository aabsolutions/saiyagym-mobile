import 'package:saiyagym_mobile/core/network/api_exception.dart';
import 'package:saiyagym_mobile/core/storage/token_storage.dart';
import 'package:saiyagym_mobile/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:saiyagym_mobile/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:saiyagym_mobile/features/auth/data/models/me_model.dart';
import 'package:saiyagym_mobile/features/auth/domain/entities/session.dart';
import 'package:saiyagym_mobile/features/auth/domain/entities/user.dart';
import 'package:saiyagym_mobile/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl({
    required this._remote,
    required this._local,
    required this._tokens,
  });

  final AuthRemoteDataSource _remote;
  final AuthLocalDataSource _local;
  final TokenStorage _tokens;

  @override
  Future<User> login({required String email, required String password}) async {
    final response = await _remote.login(email: email, password: password);
    return await _startSession(response);
  }

  @override
  Future<User> register({
    required String email,
    required String password,
    required String language,
    String? name,
  }) async {
    final response = await _remote.register(
      email: email,
      password: password,
      language: language,
      name: name,
    );
    return await _startSession(response);
  }

  Future<User> _startSession(AuthResponseModel response) async {
    // Local data left by an expired session belongs to its owner only.
    final previous = await _local.readUser();
    if (previous != null && previous.id != response.user.id) {
      await _local.wipeAll();
    }
    await _tokens.write(response.tokens);
    await _local.cacheUser(response.user);
    return response.user.toEntity();
  }

  @override
  Future<Session?> restoreSession() async {
    if (await _tokens.read() == null) return null;
    try {
      return Session(user: await refreshUser());
    } on ApiException catch (error) {
      if (error.code == ApiException.unauthorized) {
        await clearSession();
        return null;
      }
      // Offline / API down: open with the last known user.
      final cached = await _local.readUser();
      if (cached != null) {
        return Session(user: cached.toEntity(), isOffline: true);
      }
      rethrow;
    }
  }

  @override
  Future<User> refreshUser() async {
    final me = await _remote.me();
    await _local.cacheUser(me);
    return me.toEntity();
  }

  @override
  Future<void> requestPasswordReset(String email) =>
      _remote.forgotPassword(email);

  @override
  Future<void> resendVerificationEmail() => _remote.resendVerification();

  @override
  Future<void> logout() async {
    final tokens = await _tokens.read();
    if (tokens != null) {
      try {
        await _remote.logout(tokens.refreshToken);
      } on ApiException {
        // Offline logout still signs out locally; the refresh token expires.
      }
    }
    await _tokens.clear();
    await _local.wipeAll();
  }

  @override
  Future<void> clearSession() => _tokens.clear();
}
