// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'email_verification_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Actions of the "verify your email" banner. The link in the email opens
/// the web app; the app only learns about it by re-fetching `/users/me`.

@ProviderFor(EmailVerificationController)
final emailVerificationControllerProvider =
    EmailVerificationControllerProvider._();

/// Actions of the "verify your email" banner. The link in the email opens
/// the web app; the app only learns about it by re-fetching `/users/me`.
final class EmailVerificationControllerProvider
    extends
        $AsyncNotifierProvider<
          EmailVerificationController,
          VerificationOutcome?
        > {
  /// Actions of the "verify your email" banner. The link in the email opens
  /// the web app; the app only learns about it by re-fetching `/users/me`.
  EmailVerificationControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'emailVerificationControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$emailVerificationControllerHash();

  @$internal
  @override
  EmailVerificationController create() => EmailVerificationController();
}

String _$emailVerificationControllerHash() =>
    r'a45f6600693a56c8d21f48fd99fe550f96f775c0';

/// Actions of the "verify your email" banner. The link in the email opens
/// the web app; the app only learns about it by re-fetching `/users/me`.

abstract class _$EmailVerificationController
    extends $AsyncNotifier<VerificationOutcome?> {
  FutureOr<VerificationOutcome?> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<AsyncValue<VerificationOutcome?>, VerificationOutcome?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<VerificationOutcome?>,
                VerificationOutcome?
              >,
              AsyncValue<VerificationOutcome?>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
