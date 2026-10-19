// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'routine.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TargetSet _$TargetSetFromJson(Map<String, dynamic> json) => _TargetSet(
  type: $enumDecode(
    _$SetTypeEnumMap,
    json['type'],
    unknownValue: SetType.normal,
  ),
  repsMin: (json['repsMin'] as num).toInt(),
  repsMax: (json['repsMax'] as num).toInt(),
  weightKg: (json['weightKg'] as num?)?.toDouble(),
  percent1RM: (json['percent1RM'] as num?)?.toDouble(),
  restSeconds: (json['restSeconds'] as num?)?.toInt() ?? 120,
);

Map<String, dynamic> _$TargetSetToJson(_TargetSet instance) =>
    <String, dynamic>{
      'type': _$SetTypeEnumMap[instance.type]!,
      'repsMin': instance.repsMin,
      'repsMax': instance.repsMax,
      'weightKg': instance.weightKg,
      'percent1RM': instance.percent1RM,
      'restSeconds': instance.restSeconds,
    };

const _$SetTypeEnumMap = {
  SetType.warmup: 'warmup',
  SetType.normal: 'normal',
  SetType.dropset: 'dropset',
  SetType.failure: 'failure',
};

_RoutineExercise _$RoutineExerciseFromJson(Map<String, dynamic> json) =>
    _RoutineExercise(
      id: json['id'] as String,
      exerciseId: json['exerciseId'] as String,
      sets:
          (json['sets'] as List<dynamic>?)
              ?.map((e) => TargetSet.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      groupId: json['groupId'] as String?,
      notes: json['notes'] as String? ?? '',
      progression: json['progression'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$RoutineExerciseToJson(_RoutineExercise instance) =>
    <String, dynamic>{
      'id': instance.id,
      'exerciseId': instance.exerciseId,
      'sets': instance.sets.map((e) => e.toJson()).toList(),
      'groupId': instance.groupId,
      'notes': instance.notes,
      'progression': instance.progression,
    };

_Routine _$RoutineFromJson(Map<String, dynamic> json) => _Routine(
  id: json['id'] as String,
  name: json['name'] as String,
  exercises:
      (json['exercises'] as List<dynamic>?)
          ?.map((e) => RoutineExercise.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  notes: json['notes'] as String? ?? '',
  archivedAt: const NullableUtcDateTime().fromJson(
    json['archivedAt'] as String?,
  ),
  updatedAt: const NullableUtcDateTime().fromJson(json['updatedAt'] as String?),
);

Map<String, dynamic> _$RoutineToJson(_Routine instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'exercises': instance.exercises.map((e) => e.toJson()).toList(),
  'notes': instance.notes,
  'archivedAt': const NullableUtcDateTime().toJson(instance.archivedAt),
  'updatedAt': const NullableUtcDateTime().toJson(instance.updatedAt),
};
