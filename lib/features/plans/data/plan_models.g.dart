// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plan_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_EntitlementsModel _$EntitlementsModelFromJson(Map<String, dynamic> json) =>
    _EntitlementsModel(
      statsHistoryDays: (json['statsHistoryDays'] as num?)?.toInt(),
      limits:
          (json['limits'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, (e as num?)?.toInt()),
          ) ??
          const {},
      features:
          (json['features'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as bool),
          ) ??
          const {},
    );

Map<String, dynamic> _$EntitlementsModelToJson(_EntitlementsModel instance) =>
    <String, dynamic>{
      'statsHistoryDays': instance.statsHistoryDays,
      'limits': instance.limits,
      'features': instance.features,
    };

_PublicPlanModel _$PublicPlanModelFromJson(Map<String, dynamic> json) =>
    _PublicPlanModel(
      id: json['id'] as String,
      code: json['code'] as String,
      name: json['name'] as String,
      entitlements: EntitlementsModel.fromJson(
        json['entitlements'] as Map<String, dynamic>,
      ),
      description: json['description'] as String? ?? '',
      isDefault: json['isDefault'] as bool? ?? false,
    );

Map<String, dynamic> _$PublicPlanModelToJson(_PublicPlanModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'name': instance.name,
      'entitlements': instance.entitlements.toJson(),
      'description': instance.description,
      'isDefault': instance.isDefault,
    };
