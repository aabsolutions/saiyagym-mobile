// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'live_session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SetTarget _$SetTargetFromJson(Map<String, dynamic> json) => _SetTarget(
  type:
      $enumDecodeNullable(
        _$SetTypeEnumMap,
        json['type'],
        unknownValue: SetType.normal,
      ) ??
      SetType.normal,
  repsMin: (json['repsMin'] as num?)?.toInt(),
  repsMax: (json['repsMax'] as num?)?.toInt(),
  weightKg: (json['weightKg'] as num?)?.toDouble(),
  restSeconds: (json['restSeconds'] as num?)?.toInt(),
);

Map<String, dynamic> _$SetTargetToJson(_SetTarget instance) =>
    <String, dynamic>{
      'type': _$SetTypeEnumMap[instance.type]!,
      'repsMin': instance.repsMin,
      'repsMax': instance.repsMax,
      'weightKg': instance.weightKg,
      'restSeconds': instance.restSeconds,
    };

const _$SetTypeEnumMap = {
  SetType.warmup: 'warmup',
  SetType.normal: 'normal',
  SetType.dropset: 'dropset',
  SetType.failure: 'failure',
};

_RestTimer _$RestTimerFromJson(Map<String, dynamic> json) => _RestTimer(
  endsAt: const UtcDateTime().fromJson(json['endsAt'] as String),
  totalSeconds: (json['totalSeconds'] as num).toInt(),
  setId: json['setId'] as String?,
);

Map<String, dynamic> _$RestTimerToJson(_RestTimer instance) =>
    <String, dynamic>{
      'endsAt': const UtcDateTime().toJson(instance.endsAt),
      'totalSeconds': instance.totalSeconds,
      'setId': instance.setId,
    };

_LiveMeta _$LiveMetaFromJson(Map<String, dynamic> json) => _LiveMeta(
  workoutId: json['workoutId'] as String,
  targets:
      (json['targets'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(
          k,
          (e as List<dynamic>)
              .map((e) => SetTarget.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
      ) ??
      const {},
  restSeconds:
      (json['restSeconds'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toInt()),
      ) ??
      const {},
  rest: json['rest'] == null
      ? null
      : RestTimer.fromJson(json['rest'] as Map<String, dynamic>),
);

Map<String, dynamic> _$LiveMetaToJson(_LiveMeta instance) => <String, dynamic>{
  'workoutId': instance.workoutId,
  'targets': instance.targets.map(
    (k, e) => MapEntry(k, e.map((e) => e.toJson()).toList()),
  ),
  'restSeconds': instance.restSeconds,
  'rest': instance.rest?.toJson(),
};
