import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:saiyagym_mobile/core/state/submission.dart';
import 'package:saiyagym_mobile/features/auth/auth_providers.dart';
import 'package:saiyagym_mobile/features/auth/domain/entities/user.dart';
import 'package:saiyagym_mobile/features/auth/presentation/controllers/session_controller.dart';

part 'auth_form_controller.g.dart';

/// Submission state of the login / register forms (loading + error).
@riverpod
class AuthFormController extends _$AuthFormController {
  @override
  FutureOr<void> build() {}

  Future<void> login({required String email, required String password}) =>
      _submit(
        () => ref.read(loginUseCaseProvider)(email: email, password: password),
      );

  Future<void> register({
    required String email,
    required String password,
    required String language,
    String? name,
  }) => _submit(
    () => ref.read(registerUseCaseProvider)(
      email: email,
      password: password,
      language: language,
      name: name,
    ),
  );

  Future<void> _submit(Future<User> Function() action) async {
    if (state.isLoading) return;
    state = const AsyncLoading();
    final result = await AsyncValue.guard(action);
    if (!ref.mounted) return;
    state = submissionOf(result);
    // The router then leaves this page, disposing this notifier.
    if (result case AsyncData(:final value)) {
      ref.read(sessionControllerProvider.notifier).signedIn(value);
    }
  }
}

/// `POST /auth/password/forgot`. Success means "email sent if the account
/// exists" — the API never tells which.
@riverpod
class ForgotPasswordController extends _$ForgotPasswordController {
  @override
  FutureOr<bool> build() => false;

  Future<void> submit(String email) async {
    if (state.isLoading) return;
    state = const AsyncLoading();
    final result = await AsyncValue.guard(
      () => ref.read(requestPasswordResetUseCaseProvider)(email),
    );
    if (!ref.mounted) return;
    state = switch (result) {
      AsyncError(:final error, :final stackTrace) => AsyncError(
        error,
        stackTrace,
      ),
      _ => const AsyncData(true),
    };
  }
}
