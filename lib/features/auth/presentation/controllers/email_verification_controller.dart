import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:saiyagym_mobile/core/network/api_exception.dart';
import 'package:saiyagym_mobile/features/auth/auth_providers.dart';
import 'package:saiyagym_mobile/features/auth/presentation/controllers/session_controller.dart';

part 'email_verification_controller.g.dart';

enum VerificationOutcome { emailSent, verified, stillPending }

/// Actions of the "verify your email" banner. The link in the email opens
/// the web app; the app only learns about it by re-fetching `/users/me`.
@riverpod
class EmailVerificationController extends _$EmailVerificationController {
  @override
  FutureOr<VerificationOutcome?> build() => null;

  Future<void> resend() => _run(() async {
    try {
      await ref.read(authRepositoryProvider).resendVerificationEmail();
      return VerificationOutcome.emailSent;
    } on ApiException catch (error) {
      if (error.code != 'EMAIL_ALREADY_VERIFIED') rethrow;
      return await _check();
    }
  });

  Future<void> check() => _run(_check);

  Future<VerificationOutcome> _check() async {
    await ref.read(sessionControllerProvider.notifier).refreshUser();
    final verified = ref.read(currentUserProvider)?.emailVerified ?? false;
    return verified
        ? VerificationOutcome.verified
        : VerificationOutcome.stillPending;
  }

  Future<void> _run(Future<VerificationOutcome> Function() action) async {
    if (state.isLoading) return;
    state = const AsyncLoading();
    final result = await AsyncValue.guard(action);
    if (ref.mounted) state = result;
  }
}
