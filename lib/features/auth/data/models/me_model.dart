import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:saiyagym_mobile/core/storage/token_storage.dart';
import 'package:saiyagym_mobile/core/units/unit_formatter.dart';
import 'package:saiyagym_mobile/features/auth/domain/entities/user.dart';
import 'package:saiyagym_mobile/features/plans/data/plan_models.dart';

part 'me_model.freezed.dart';
part 'me_model.g.dart';

/// `MeDto`. Enums stay strings here and are mapped leniently in
/// [toEntity]: a new value on the API must not crash an old app.
@freezed
abstract class MeModel with _$MeModel {
  const factory MeModel({
    required String id,
    required String email,
    required String role,
    required bool emailVerified,
    required ProfileModel profile,
    required PreferencesModel preferences,
    required PlanModel plan,
  }) = _MeModel;

  const MeModel._();

  factory MeModel.fromJson(Map<String, dynamic> json) =>
      _$MeModelFromJson(json);

  User toEntity() => User(
    id: id,
    email: email,
    role: UserRole.values.asNameMap()[role] ?? UserRole.user,
    emailVerified: emailVerified,
    profile: profile.toEntity(),
    plan: UserPlan(
      code: plan.code,
      name: plan.name,
      entitlements: plan.entitlements.toEntity(),
    ),
    preferences: UserPreferences(
      units: UnitSystem.fromApi(preferences.units),
      theme:
          ThemePreference.values.asNameMap()[preferences.theme] ??
          ThemePreference.system,
      language: preferences.language,
      defaultRestSeconds: preferences.defaultRestSeconds,
      firstDayOfWeek: preferences.firstDayOfWeek,
    ),
  );
}

@freezed
abstract class ProfileModel with _$ProfileModel {
  const factory ProfileModel({
    String? name,

    /// ISO date-time at UTC midnight (`ProfileDto.birthDate`).
    String? birthDate,
    String? sex,
    double? heightCm,
    String? level,
    String? goal,
  }) = _ProfileModel;

  const ProfileModel._();

  factory ProfileModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileModelFromJson(json);

  UserProfile toEntity() => UserProfile(
    name: name,
    birthDate: _calendarDate(birthDate),
    sex: Sex.values.asNameMap()[sex],
    heightCm: heightCm,
    level: TrainingLevel.values.asNameMap()[level],
    goal: TrainingGoal.values.asNameMap()[goal],
  );

  /// The API keeps the date at UTC midnight: read the UTC parts, so a user
  /// west of Greenwich doesn't see the day before.
  static DateTime? _calendarDate(String? value) {
    final parsed = value == null ? null : DateTime.tryParse(value)?.toUtc();
    return parsed == null
        ? null
        : DateTime(parsed.year, parsed.month, parsed.day);
  }
}

@freezed
abstract class PreferencesModel with _$PreferencesModel {
  const factory PreferencesModel({
    required String units,
    required String theme,
    required String language,
    required int defaultRestSeconds,
    required int firstDayOfWeek,
  }) = _PreferencesModel;

  factory PreferencesModel.fromJson(Map<String, dynamic> json) =>
      _$PreferencesModelFromJson(json);
}

/// `EffectivePlanDto`.
@freezed
abstract class PlanModel with _$PlanModel {
  const factory PlanModel({
    required String id,
    required String code,
    required String name,
    @Default(EntitlementsModel()) EntitlementsModel entitlements,
  }) = _PlanModel;

  factory PlanModel.fromJson(Map<String, dynamic> json) =>
      _$PlanModelFromJson(json);
}

/// `AuthResponseDto` (login / register).
@freezed
abstract class AuthResponseModel with _$AuthResponseModel {
  const factory AuthResponseModel({
    required AuthTokens tokens,
    required MeModel user,
  }) = _AuthResponseModel;

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseModelFromJson(json);
}
