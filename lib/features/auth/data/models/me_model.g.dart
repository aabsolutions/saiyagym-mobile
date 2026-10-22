// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'me_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MeModel _$MeModelFromJson(Map<String, dynamic> json) => _MeModel(
  id: json['id'] as String,
  email: json['email'] as String,
  role: json['role'] as String,
  emailVerified: json['emailVerified'] as bool,
  profile: ProfileModel.fromJson(json['profile'] as Map<String, dynamic>),
  preferences: PreferencesModel.fromJson(
    json['preferences'] as Map<String, dynamic>,
  ),
  plan: PlanModel.fromJson(json['plan'] as Map<String, dynamic>),
);

Map<String, dynamic> _$MeModelToJson(_MeModel instance) => <String, dynamic>{
  'id': instance.id,
  'email': instance.email,
  'role': instance.role,
  'emailVerified': instance.emailVerified,
  'profile': instance.profile.toJson(),
  'preferences': instance.preferences.toJson(),
  'plan': instance.plan.toJson(),
};

_ProfileModel _$ProfileModelFromJson(Map<String, dynamic> json) =>
    _ProfileModel(
      name: json['name'] as String?,
      birthDate: json['birthDate'] as String?,
      sex: json['sex'] as String?,
      heightCm: (json['heightCm'] as num?)?.toDouble(),
      level: json['level'] as String?,
      goal: json['goal'] as String?,
    );

Map<String, dynamic> _$ProfileModelToJson(_ProfileModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'birthDate': instance.birthDate,
      'sex': instance.sex,
      'heightCm': instance.heightCm,
      'level': instance.level,
      'goal': instance.goal,
    };

_PreferencesModel _$PreferencesModelFromJson(Map<String, dynamic> json) =>
    _PreferencesModel(
      units: json['units'] as String,
      theme: json['theme'] as String,
      language: json['language'] as String,
      defaultRestSeconds: (json['defaultRestSeconds'] as num).toInt(),
      firstDayOfWeek: (json['firstDayOfWeek'] as num).toInt(),
      restSoundId: json['restSoundId'] as String?,
    );

Map<String, dynamic> _$PreferencesModelToJson(_PreferencesModel instance) =>
    <String, dynamic>{
      'units': instance.units,
      'theme': instance.theme,
      'language': instance.language,
      'defaultRestSeconds': instance.defaultRestSeconds,
      'firstDayOfWeek': instance.firstDayOfWeek,
      'restSoundId': instance.restSoundId,
    };

_PlanModel _$PlanModelFromJson(Map<String, dynamic> json) => _PlanModel(
  id: json['id'] as String,
  code: json['code'] as String,
  name: json['name'] as String,
  entitlements: json['entitlements'] == null
      ? const EntitlementsModel()
      : EntitlementsModel.fromJson(
          json['entitlements'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$PlanModelToJson(_PlanModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'name': instance.name,
      'entitlements': instance.entitlements.toJson(),
    };

_AuthResponseModel _$AuthResponseModelFromJson(Map<String, dynamic> json) =>
    _AuthResponseModel(
      tokens: AuthTokens.fromJson(json['tokens'] as Map<String, dynamic>),
      user: MeModel.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AuthResponseModelToJson(_AuthResponseModel instance) =>
    <String, dynamic>{
      'tokens': instance.tokens.toJson(),
      'user': instance.user.toJson(),
    };
