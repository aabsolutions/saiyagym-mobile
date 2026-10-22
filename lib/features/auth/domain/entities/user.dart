import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:saiyagym_mobile/core/units/unit_formatter.dart';
import 'package:saiyagym_mobile/features/plans/domain/entitlements.dart';

part 'user.freezed.dart';

enum UserRole { user, admin, coach }

enum ThemePreference { system, light, dark }

enum Sex { male, female, other }

enum TrainingLevel { beginner, intermediate, advanced }

enum TrainingGoal { hypertrophy, powerlifting, both }

/// The signed-in user (`GET /users/me`), reduced to what the app uses.
@freezed
abstract class User with _$User {
  const factory User({
    required String id,
    required String email,
    required UserRole role,
    required bool emailVerified,
    required UserProfile profile,
    required UserPreferences preferences,
    required UserPlan plan,
  }) = _User;

  const User._();

  /// Level and goal drive the whole app (tiers, suggestions): without them
  /// the user goes through onboarding first.
  bool get needsOnboarding => profile.level == null || profile.goal == null;
}

@freezed
abstract class UserProfile with _$UserProfile {
  const factory UserProfile({
    String? name,

    /// Calendar date (no time zone meaning).
    DateTime? birthDate,
    Sex? sex,
    double? heightCm,
    TrainingLevel? level,
    TrainingGoal? goal,
  }) = _UserProfile;
}

@freezed
abstract class UserPreferences with _$UserPreferences {
  const factory UserPreferences({
    @Default(UnitSystem.metric) UnitSystem units,
    @Default(ThemePreference.system) ThemePreference theme,
    @Default('es') String language,
    @Default(90) int defaultRestSeconds,

    /// ISO weekday: 1 = Monday … 7 = Sunday.
    @Default(1) int firstDayOfWeek,

    /// Rest-alarm sound. The API returns the EFFECTIVE id: `null` when none
    /// is chosen, it was deleted, or the plan no longer allows it.
    String? restSoundId,
  }) = _UserPreferences;
}

/// Effective plan. Entitlements are decided by the API; the client only
/// uses them to hide or explain UI.
@freezed
abstract class UserPlan with _$UserPlan {
  const factory UserPlan({
    required String code,
    required String name,
    @Default(Entitlements.none) Entitlements entitlements,
  }) = _UserPlan;
}
