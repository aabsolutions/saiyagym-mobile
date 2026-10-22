import 'package:saiyagym_mobile/core/units/unit_formatter.dart';
import 'package:saiyagym_mobile/features/auth/domain/entities/user.dart';

/// Fields to change in `profile` (`null` = leave as is).
class ProfileUpdate {
  const ProfileUpdate({
    this.name,
    this.birthDate,
    this.sex,
    this.heightCm,
    this.level,
    this.goal,
  });

  final String? name;
  final DateTime? birthDate;
  final Sex? sex;
  final double? heightCm;
  final TrainingLevel? level;
  final TrainingGoal? goal;
}

/// Fields to change in `preferences` (`null` = leave as is).
class PreferencesUpdate {
  const PreferencesUpdate({
    this.units,
    this.theme,
    this.language,
    this.defaultRestSeconds,
    this.restSoundId,
    this.resetRestSound = false,
  });

  final UnitSystem? units;
  final ThemePreference? theme;
  final String? language;
  final int? defaultRestSeconds;

  /// Sound to use (`null` = leave as is; to go back to the default sound set
  /// [resetRestSound], because `null` already means "unchanged").
  final String? restSoundId;

  /// Sends `restSoundId: null` (default sound). Wins over [restSoundId].
  final bool resetRestSound;
}

abstract interface class ProfileRepository {
  /// Partial `PATCH /users/me`. Returns the updated user.
  Future<User> updateMe({
    ProfileUpdate? profile,
    PreferencesUpdate? preferences,
  });

  /// Adds a body-weight entry measured now (stored in kg).
  Future<void> recordBodyWeight(double weightKg);
}

class UpdatePreferencesUseCase {
  const UpdatePreferencesUseCase(this._repository);

  final ProfileRepository _repository;

  Future<User> call(PreferencesUpdate preferences) =>
      _repository.updateMe(preferences: preferences);
}

class UpdateProfileUseCase {
  const UpdateProfileUseCase(this._repository);

  final ProfileRepository _repository;

  Future<User> call(ProfileUpdate profile) =>
      _repository.updateMe(profile: profile);
}
