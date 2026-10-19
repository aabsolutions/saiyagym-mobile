// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WorkoutSet _$WorkoutSetFromJson(Map<String, dynamic> json) => _WorkoutSet(
  id: json['id'] as String,
  type: $enumDecode(
    _$SetTypeEnumMap,
    json['type'],
    unknownValue: SetType.normal,
  ),
  weightKg: (json['weightKg'] as num?)?.toDouble(),
  reps: (json['reps'] as num?)?.toInt(),
  completed: json['completed'] as bool? ?? false,
  completedAt: const NullableUtcDateTime().fromJson(
    json['completedAt'] as String?,
  ),
);

Map<String, dynamic> _$WorkoutSetToJson(_WorkoutSet instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': _$SetTypeEnumMap[instance.type]!,
      'weightKg': instance.weightKg,
      'reps': instance.reps,
      'completed': instance.completed,
      'completedAt': const NullableUtcDateTime().toJson(instance.completedAt),
    };

const _$SetTypeEnumMap = {
  SetType.warmup: 'warmup',
  SetType.normal: 'normal',
  SetType.dropset: 'dropset',
  SetType.failure: 'failure',
};

_WorkoutExercise _$WorkoutExerciseFromJson(Map<String, dynamic> json) =>
    _WorkoutExercise(
      id: json['id'] as String,
      exerciseId: json['exerciseId'] as String,
      sets:
          (json['sets'] as List<dynamic>?)
              ?.map((e) => WorkoutSet.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      routineExerciseId: json['routineExerciseId'] as String?,
      groupId: json['groupId'] as String?,
      notes: json['notes'] as String? ?? '',
    );

Map<String, dynamic> _$WorkoutExerciseToJson(_WorkoutExercise instance) =>
    <String, dynamic>{
      'id': instance.id,
      'exerciseId': instance.exerciseId,
      'sets': instance.sets.map((e) => e.toJson()).toList(),
      'routineExerciseId': instance.routineExerciseId,
      'groupId': instance.groupId,
      'notes': instance.notes,
    };

_Workout _$WorkoutFromJson(Map<String, dynamic> json) => _Workout(
  id: json['id'] as String,
  startedAt: const UtcDateTime().fromJson(json['startedAt'] as String),
  exercises:
      (json['exercises'] as List<dynamic>?)
          ?.map((e) => WorkoutExercise.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  name: json['name'] as String? ?? '',
  routineId: json['routineId'] as String?,
  programId: json['programId'] as String?,
  finishedAt: const NullableUtcDateTime().fromJson(
    json['finishedAt'] as String?,
  ),
  notes: json['notes'] as String? ?? '',
  rating: (json['rating'] as num?)?.toInt(),
  volumeKg: (json['volumeKg'] as num?)?.toDouble(),
  durationSeconds: (json['durationSeconds'] as num?)?.toInt(),
  updatedAt: const NullableUtcDateTime().fromJson(json['updatedAt'] as String?),
);

Map<String, dynamic> _$WorkoutToJson(_Workout instance) => <String, dynamic>{
  'id': instance.id,
  'startedAt': const UtcDateTime().toJson(instance.startedAt),
  'exercises': instance.exercises.map((e) => e.toJson()).toList(),
  'name': instance.name,
  'routineId': instance.routineId,
  'programId': instance.programId,
  'finishedAt': const NullableUtcDateTime().toJson(instance.finishedAt),
  'notes': instance.notes,
  'rating': instance.rating,
  'volumeKg': instance.volumeKg,
  'durationSeconds': instance.durationSeconds,
  'updatedAt': const NullableUtcDateTime().toJson(instance.updatedAt),
};
