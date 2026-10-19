import 'package:saiyagym_mobile/features/auth/domain/entities/session.dart';
import 'package:saiyagym_mobile/features/auth/domain/entities/user.dart';
import 'package:saiyagym_mobile/features/auth/domain/repositories/auth_repository.dart';

class LoginUseCase {
  const LoginUseCase(this._repository);

  final AuthRepository _repository;

  Future<User> call({required String email, required String password}) =>
      _repository.login(email: email.trim(), password: password);
}

class RegisterUseCase {
  const RegisterUseCase(this._repository);

  final AuthRepository _repository;

  Future<User> call({
    required String email,
    required String password,
    required String language,
    String? name,
  }) {
    final trimmedName = name?.trim();
    return _repository.register(
      email: email.trim(),
      password: password,
      language: language,
      name: trimmedName == null || trimmedName.isEmpty ? null : trimmedName,
    );
  }
}

class RestoreSessionUseCase {
  const RestoreSessionUseCase(this._repository);

  final AuthRepository _repository;

  Future<Session?> call() => _repository.restoreSession();
}

class RequestPasswordResetUseCase {
  const RequestPasswordResetUseCase(this._repository);

  final AuthRepository _repository;

  Future<void> call(String email) =>
      _repository.requestPasswordReset(email.trim());
}

class LogoutUseCase {
  const LogoutUseCase(this._repository);

  final AuthRepository _repository;

  Future<void> call() => _repository.logout();
}
