import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:saiyagym_mobile/core/units/unit_formatter.dart';

part 'user.freezed.dart';

enum UserRole { user, admin, coach }

enum ThemePreference { system, light, dark }

/// The signed-in user (`GET /users/me`), reduced to what the app uses.
@freezed
abstract class User with _$User {
  const factory User({
    required String id,
    required String email,
    required UserRole role,
    required bool emailVerified,
    required UserPreferences preferences,
    required UserPlan plan,
    String? name,
  }) = _User;
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
  }) = _UserPreferences;
}

/// Effective plan. Entitlements are decided by the API; the client only
/// uses them to hide UI.
@freezed
abstract class UserPlan with _$UserPlan {
  const factory UserPlan({required String code, required String name}) =
      _UserPlan;
}
