// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercise.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Tiers _$TiersFromJson(Map<String, dynamic> json) => _Tiers(
  hypertrophy: $enumDecodeNullable(
    _$TierEnumMap,
    json['hypertrophy'],
    unknownValue: JsonKey.nullForUndefinedEnumValue,
  ),
  powerlifting: $enumDecodeNullable(
    _$TierEnumMap,
    json['powerlifting'],
    unknownValue: JsonKey.nullForUndefinedEnumValue,
  ),
);

Map<String, dynamic> _$TiersToJson(_Tiers instance) => <String, dynamic>{
  'hypertrophy': _$TierEnumMap[instance.hypertrophy],
  'powerlifting': _$TierEnumMap[instance.powerlifting],
};

const _$TierEnumMap = {Tier.s: 'S', Tier.a: 'A', Tier.b: 'B', Tier.c: 'C'};

_Exercise _$ExerciseFromJson(Map<String, dynamic> json) => _Exercise(
  id: json['id'] as String,
  name: json['name'] as String,
  primaryMuscle: json['primaryMuscle'] as String,
  equipment: json['equipment'] as String,
  secondaryMuscles:
      (json['secondaryMuscles'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  mechanic: json['mechanic'] as String?,
  category: json['category'] as String?,
  slug: json['slug'] as String?,
  imageUrl: json['imageUrl'] as String?,
  tags:
      (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  tiers: json['tiers'] == null
      ? const Tiers()
      : Tiers.fromJson(json['tiers'] as Map<String, dynamic>),
  isGlobal: json['isGlobal'] as bool? ?? false,
  isCustom: json['isCustom'] as bool? ?? false,
  description: json['description'] as String? ?? '',
  instructions: json['instructions'] as String? ?? '',
);

Map<String, dynamic> _$ExerciseToJson(_Exercise instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'primaryMuscle': instance.primaryMuscle,
  'equipment': instance.equipment,
  'secondaryMuscles': instance.secondaryMuscles,
  'mechanic': instance.mechanic,
  'category': instance.category,
  'slug': instance.slug,
  'imageUrl': instance.imageUrl,
  'tags': instance.tags,
  'tiers': instance.tiers.toJson(),
  'isGlobal': instance.isGlobal,
  'isCustom': instance.isCustom,
  'description': instance.description,
  'instructions': instance.instructions,
};

_ExercisePref _$ExercisePrefFromJson(Map<String, dynamic> json) =>
    _ExercisePref(
      exerciseId: json['exerciseId'] as String,
      isFavorite: json['isFavorite'] as bool? ?? false,
      personalTiers: json['personalTiers'] == null
          ? const Tiers()
          : Tiers.fromJson(json['personalTiers'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ExercisePrefToJson(_ExercisePref instance) =>
    <String, dynamic>{
      'exerciseId': instance.exerciseId,
      'isFavorite': instance.isFavorite,
      'personalTiers': instance.personalTiers.toJson(),
    };
