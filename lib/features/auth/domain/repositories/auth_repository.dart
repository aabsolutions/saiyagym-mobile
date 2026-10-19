import 'package:saiyagym_mobile/features/auth/domain/entities/session.dart';
import 'package:saiyagym_mobile/features/auth/domain/entities/user.dart';

/// Failures surface as `ApiException` (branch on its `code`).
abstract interface class AuthRepository {
  /// Signing in as a different user than the last one wipes local data.
  Future<User> login({required String email, required String password});

  Future<User> register({
    required String email,
    required String password,
    required String language,
    String? name,
  });

  /// The stored session, or `null` when signed out. Offline it opens with
  /// the last user's local copy: no network is not the same as no session.
  Future<Session?> restoreSession();

  /// Fetches `/users/me` again (after verifying the email, when back
  /// online, …) and refreshes the local copy.
  Future<User> refreshUser();

  /// Always answers the same (the API never reveals if the email exists).
  Future<void> requestPasswordReset(String email);

  Future<void> resendVerificationEmail();

  /// Revokes the refresh token when online, then deletes ALL local data.
  Future<void> logout();

  /// Session over without the user asking (refresh rejected): forget the
  /// tokens but keep local data — unsynced work must survive a re-login.
  Future<void> clearSession();
}
