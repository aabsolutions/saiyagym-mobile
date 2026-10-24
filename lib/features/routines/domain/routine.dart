import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:saiyagym_mobile/core/training/training_types.dart';
import 'package:saiyagym_mobile/core/training/utc_date_time.dart';

part 'routine.freezed.dart';
part 'routine.g.dart';

@freezed
abstract class TargetSet with _$TargetSet {
  const factory TargetSet({
    @JsonKey(unknownEnumValue: SetType.normal) required SetType type,
    required int repsMin,
    required int repsMax,

    /// kg. Mutually exclusive with [percent1RM].
    double? weightKg,
    double? percent1RM,
    @Default(120) int restSeconds,
  }) = _TargetSet;

  factory TargetSet.fromJson(Map<String, dynamic> json) =>
      _$TargetSetFromJson(json);
}

@freezed
abstract class RoutineExercise with _$RoutineExercise {
  const factory RoutineExercise({
    /// Stable slot id (client-generated).
    required String id,
    required String exerciseId,
    @Default([]) List<TargetSet> sets,

    /// Exercises sharing it form a superset.
    String? groupId,
    @Default('') String notes,

    /// Premium auto-progression rule, kept as the API sends it.
    Map<String, dynamic>? progression,
  }) = _RoutineExercise;

  factory RoutineExercise.fromJson(Map<String, dynamic> json) =>
      _$RoutineExerciseFromJson(json);
}

@freezed
abstract class Routine with _$Routine {
  const factory Routine({
    required String id,
    required String name,
    @Default([]) List<RoutineExercise> exercises,
    @Default('') String notes,
    @NullableUtcDateTime() DateTime? archivedAt,
    @NullableUtcDateTime() DateTime? updatedAt,
  }) = _Routine;

  factory Routine.fromJson(Map<String, dynamic> json) =>
      _$RoutineFromJson(json);
}

abstract interface class RoutinesRepository {
  /// Not archived, by name. Works offline.
  Stream<List<Routine>> watchActive();

  /// One-shot read of [watchActive] (no order).
  Future<List<Routine>> active();

  Future<Routine?> find(String id);

  Future<Routine> save(Routine routine);

  Future<void> delete(String id);
}
