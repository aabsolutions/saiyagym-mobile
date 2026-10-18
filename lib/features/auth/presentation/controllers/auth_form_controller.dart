import 'package:riverpod_annotation/riverpod_annotation.dart';
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
    switch (result) {
      case AsyncData(:final value):
        state = const AsyncData(null);
        // The router then leaves this page, disposing this notifier.
        ref.read(sessionControllerProvider.notifier).signedIn(value);
      case AsyncError(:final error, :final stackTrace):
        state = AsyncError(error, stackTrace);
      case AsyncLoading():
        break;
    }
  }
}
