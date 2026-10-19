import 'package:clock/clock.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:saiyagym_mobile/core/sync/sync_state.dart';
import 'package:saiyagym_mobile/core/training/training_types.dart';
import 'package:saiyagym_mobile/core/training/utc_date_time.dart';

part 'workout.freezed.dart';
part 'workout.g.dart';

@freezed
abstract class WorkoutSet with _$WorkoutSet {
  const factory WorkoutSet({
    required String id,
    @JsonKey(unknownEnumValue: SetType.normal) required SetType type,

    /// Always kg.
    double? weightKg,
    int? reps,
    @Default(false) bool completed,
    @NullableUtcDateTime() DateTime? completedAt,
  }) = _WorkoutSet;

  factory WorkoutSet.fromJson(Map<String, dynamic> json) =>
      _$WorkoutSetFromJson(json);
}

@freezed
abstract class WorkoutExercise with _$WorkoutExercise {
  const factory WorkoutExercise({
    required String id,
    required String exerciseId,
    @Default([]) List<WorkoutSet> sets,

    /// Routine slot it came from.
    String? routineExerciseId,
    String? groupId,
    @Default('') String notes,
  }) = _WorkoutExercise;

  factory WorkoutExercise.fromJson(Map<String, dynamic> json) =>
      _$WorkoutExerciseFromJson(json);
}

@freezed
abstract class Workout with _$Workout {
  const factory Workout({
    required String id,
    @UtcDateTime() required DateTime startedAt,
    @Default([]) List<WorkoutExercise> exercises,
    @Default('') String name,
    String? routineId,
    String? programId,

    /// `null` = in progress.
    @NullableUtcDateTime() DateTime? finishedAt,
    @Default('') String notes,

    /// 1–5.
    int? rating,

    /// Server-computed (absent until synced).
    double? volumeKg,
    int? durationSeconds,
    @NullableUtcDateTime() DateTime? updatedAt,
  }) = _Workout;

  const Workout._();

  factory Workout.fromJson(Map<String, dynamic> json) =>
      _$WorkoutFromJson(json);

  bool get inProgress => finishedAt == null;
}

abstract interface class WorkoutsRepository {
  /// Finished workouts, newest first. Works offline.
  Stream<List<Workout>> watchHistory();

  /// The workout being logged, if any (survives app kills: it's local).
  Stream<Workout?> watchInProgress();

  Future<Workout?> inProgress();

  Future<Workout?> find(String id);

  /// Every finished workout, newest first (previous sets, records).
  Future<List<Workout>> finished();

  /// Sets of the last finished workout that included [exerciseId].
  Future<List<WorkoutSet>?> lastPerformance(
    String exerciseId, {
    String? excludingWorkoutId,
  });

  Future<Workout> save(Workout workout);

  Future<void> delete(String id);
}

/// Closes the session and gets it to the server as soon as possible.
class FinishWorkoutUseCase {
  const FinishWorkoutUseCase(this._repository, this._sync);

  final WorkoutsRepository _repository;
  final SyncScheduler _sync;

  Future<Workout> call(Workout workout) async {
    final finished = await _repository.save(
      workout.copyWith(finishedAt: workout.finishedAt ?? clock.now().toUtc()),
    );
    _sync.requestSync(SyncReason.workoutFinished);
    return finished;
  }
}
