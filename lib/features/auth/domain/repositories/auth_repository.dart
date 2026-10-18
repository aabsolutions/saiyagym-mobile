import 'package:saiyagym_mobile/features/auth/domain/entities/user.dart';

/// Failures surface as `ApiException` (branch on its `code`).
abstract interface class AuthRepository {
  Future<User> login({required String email, required String password});

  Future<User> register({
    required String email,
    required String password,
    required String language,
    String? name,
  });

  /// The stored session, or `null` when signed out. Offline it falls back to
  /// the cached user: no network is not the same as no session.
  Future<User?> restoreSession();

  /// Revokes the refresh token when online; always clears local session.
  Future<void> logout();

  /// Clears the local session without calling the API (it already
  /// rejected the refresh token).
  Future<void> clearSession();
}
