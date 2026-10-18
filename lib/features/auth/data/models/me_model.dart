import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:saiyagym_mobile/core/storage/token_storage.dart';
import 'package:saiyagym_mobile/core/units/unit_formatter.dart';
import 'package:saiyagym_mobile/features/auth/domain/entities/user.dart';

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
    name: profile.name,
    role: UserRole.values.asNameMap()[role] ?? UserRole.user,
    emailVerified: emailVerified,
    plan: UserPlan(code: plan.code, name: plan.name),
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
  const factory ProfileModel({String? name}) = _ProfileModel;

  factory ProfileModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileModelFromJson(json);
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

@freezed
abstract class PlanModel with _$PlanModel {
  const factory PlanModel({
    required String id,
    required String code,
    required String name,
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
