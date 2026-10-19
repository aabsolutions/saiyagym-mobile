import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:saiyagym_mobile/core/network/api_exception.dart';
import 'package:saiyagym_mobile/core/units/unit_formatter.dart';
import 'package:saiyagym_mobile/features/auth/domain/entities/user.dart';
import 'package:saiyagym_mobile/features/profile/domain/profile_repository.dart';

part 'complete_onboarding.freezed.dart';

/// Everything onboarding collects. Measurements are kg / cm already.
@freezed
abstract class OnboardingData with _$OnboardingData {
  const factory OnboardingData({
    required UnitSystem units,
    required String language,
    required int defaultRestSeconds,
    DateTime? birthDate,
    Sex? sex,
    double? heightCm,
    double? weightKg,
    TrainingLevel? level,
    TrainingGoal? goal,
  }) = _OnboardingData;

  const OnboardingData._();

  bool get isComplete => level != null && goal != null;
}

class CompleteOnboardingUseCase {
  const CompleteOnboardingUseCase(this._repository);

  final ProfileRepository _repository;

  Future<User> call(OnboardingData data) async {
    if (!data.isComplete) {
      throw ArgumentError('level and goal are required');
    }
    final user = await _repository.updateMe(
      profile: ProfileUpdate(
        birthDate: data.birthDate,
        sex: data.sex,
        heightCm: data.heightCm,
        level: data.level,
        goal: data.goal,
      ),
      preferences: PreferencesUpdate(
        units: data.units,
        language: data.language,
        defaultRestSeconds: data.defaultRestSeconds,
      ),
    );
    final weight = data.weightKg;
    if (weight != null) {
      try {
        await _repository.recordBodyWeight(weight);
      } on ApiException {
        // The profile is saved; a missing first weigh-in must not block the
        // app. It can be added later from body metrics.
      }
    }
    return user;
  }
}
