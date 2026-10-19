import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:saiyagym_mobile/core/state/submission.dart';
import 'package:saiyagym_mobile/features/auth/domain/entities/user.dart';
import 'package:saiyagym_mobile/features/auth/presentation/controllers/session_controller.dart';
import 'package:saiyagym_mobile/features/onboarding/domain/complete_onboarding.dart';
import 'package:saiyagym_mobile/features/profile/presentation/preferences_providers.dart';

part 'onboarding_controller.g.dart';

@riverpod
CompleteOnboardingUseCase completeOnboardingUseCase(Ref ref) =>
    CompleteOnboardingUseCase(ref.watch(profileRepositoryProvider));

/// The answers so far, prefilled from what the account already has.
@riverpod
class OnboardingDraft extends _$OnboardingDraft {
  @override
  OnboardingData build() {
    // Restart only when the account changes (e.g. the session finishes
    // loading); updates of the same user must not wipe the answers.
    ref.watch(currentUserProvider.select((user) => user?.id));
    final user = ref.read(currentUserProvider);
    final profile = user?.profile ?? const UserProfile();
    final preferences = user?.preferences ?? const UserPreferences();
    return OnboardingData(
      units: preferences.units,
      language: preferences.language,
      defaultRestSeconds: preferences.defaultRestSeconds,
      birthDate: profile.birthDate,
      sex: profile.sex,
      heightCm: profile.heightCm,
      level: profile.level,
      goal: profile.goal,
    );
  }

  void update(OnboardingData Function(OnboardingData current) change) =>
      state = change(state);
}

@riverpod
class OnboardingSubmit extends _$OnboardingSubmit {
  @override
  FutureOr<void> build() {}

  Future<void> submit() async {
    if (state.isLoading) return;
    state = const AsyncLoading();
    final data = ref.read(onboardingDraftProvider);
    final result = await AsyncValue.guard(
      () => ref.read(completeOnboardingUseCaseProvider)(data),
    );
    if (!ref.mounted) return;
    state = submissionOf(result);
    // A complete profile makes the router leave onboarding.
    if (result case AsyncData(:final value)) {
      ref.read(sessionControllerProvider.notifier).userUpdated(value);
    }
  }
}
