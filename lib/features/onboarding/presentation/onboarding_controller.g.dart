// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onboarding_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(completeOnboardingUseCase)
final completeOnboardingUseCaseProvider = CompleteOnboardingUseCaseProvider._();

final class CompleteOnboardingUseCaseProvider
    extends
        $FunctionalProvider<
          CompleteOnboardingUseCase,
          CompleteOnboardingUseCase,
          CompleteOnboardingUseCase
        >
    with $Provider<CompleteOnboardingUseCase> {
  CompleteOnboardingUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'completeOnboardingUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$completeOnboardingUseCaseHash();

  @$internal
  @override
  $ProviderElement<CompleteOnboardingUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CompleteOnboardingUseCase create(Ref ref) {
    return completeOnboardingUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CompleteOnboardingUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CompleteOnboardingUseCase>(value),
    );
  }
}

String _$completeOnboardingUseCaseHash() =>
    r'0da1aab5b0daa7bd6194290105fa4be815b3f548';

/// The answers so far, prefilled from what the account already has.

@ProviderFor(OnboardingDraft)
final onboardingDraftProvider = OnboardingDraftProvider._();

/// The answers so far, prefilled from what the account already has.
final class OnboardingDraftProvider
    extends $NotifierProvider<OnboardingDraft, OnboardingData> {
  /// The answers so far, prefilled from what the account already has.
  OnboardingDraftProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'onboardingDraftProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$onboardingDraftHash();

  @$internal
  @override
  OnboardingDraft create() => OnboardingDraft();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OnboardingData value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<OnboardingData>(value),
    );
  }
}

String _$onboardingDraftHash() => r'3423654ee7bafef9b3b7bde2e7cb3ec1d4a68aa3';

/// The answers so far, prefilled from what the account already has.

abstract class _$OnboardingDraft extends $Notifier<OnboardingData> {
  OnboardingData build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<OnboardingData, OnboardingData>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<OnboardingData, OnboardingData>,
              OnboardingData,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(OnboardingSubmit)
final onboardingSubmitProvider = OnboardingSubmitProvider._();

final class OnboardingSubmitProvider
    extends $AsyncNotifierProvider<OnboardingSubmit, void> {
  OnboardingSubmitProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'onboardingSubmitProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$onboardingSubmitHash();

  @$internal
  @override
  OnboardingSubmit create() => OnboardingSubmit();
}

String _$onboardingSubmitHash() => r'4213d9153798da7440862bed089081203ba7e769';

abstract class _$OnboardingSubmit extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
