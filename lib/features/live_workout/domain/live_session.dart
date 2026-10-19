import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:saiyagym_mobile/core/training/training_types.dart';
import 'package:saiyagym_mobile/core/training/utc_date_time.dart';
import 'package:saiyagym_mobile/features/workouts/domain/workout.dart';

part 'live_session.freezed.dart';
part 'live_session.g.dart';

/// What the plan asks for one set (from a routine or today's program).
@freezed
abstract class SetTarget with _$SetTarget {
  const factory SetTarget({
    @JsonKey(unknownEnumValue: SetType.normal)
    @Default(SetType.normal)
    SetType type,
    int? repsMin,
    int? repsMax,
    double? weightKg,
    int? restSeconds,
  }) = _SetTarget;

  factory SetTarget.fromJson(Map<String, dynamic> json) =>
      _$SetTargetFromJson(json);
}

/// One exercise of a start plan.
class PlannedExercise {
  const PlannedExercise({
    required this.exerciseId,
    this.sets = const [],
    this.routineExerciseId,
    this.groupId,
    this.notes = '',
  });

  final String exerciseId;
  final List<SetTarget> sets;
  final String? routineExerciseId;
  final String? groupId;
  final String notes;
}

/// How a session starts: a routine, today's program day, or empty.
class StartPlan {
  const StartPlan({
    this.name = '',
    this.routineId,
    this.programId,
    this.exercises = const [],
  });

  const StartPlan.empty() : this();

  final String name;
  final String? routineId;
  final String? programId;
  final List<PlannedExercise> exercises;
}

@freezed
abstract class RestTimer with _$RestTimer {
  const factory RestTimer({
    @UtcDateTime() required DateTime endsAt,
    required int totalSeconds,

    /// The set that started it (to highlight the next one).
    String? setId,
  }) = _RestTimer;

  const RestTimer._();

  factory RestTimer.fromJson(Map<String, dynamic> json) =>
      _$RestTimerFromJson(json);

  Duration remaining(DateTime now) {
    final left = endsAt.difference(now);
    return left.isNegative ? Duration.zero : left;
  }
}

/// UI state that is NOT part of the workout document, persisted next to it
/// (app_meta): a pull of our own write replaces the document's JSON, so
/// extra keys stored there would be lost.
@freezed
abstract class LiveMeta with _$LiveMeta {
  const factory LiveMeta({
    required String workoutId,

    /// Targets by workout-exercise id, aligned with its sets by index.
    @Default({}) Map<String, List<SetTarget>> targets,

    /// Rest by workout-exercise id (routine slot), else the user default.
    @Default({}) Map<String, int> restSeconds,
    RestTimer? rest,
  }) = _LiveMeta;

  factory LiveMeta.fromJson(Map<String, dynamic> json) =>
      _$LiveMetaFromJson(json);
}

/// Everything the live screen shows.
@freezed
abstract class LiveSession with _$LiveSession {
  const factory LiveSession({
    required Workout workout,
    required LiveMeta meta,

    /// Last time each exercise was done: its sets (by exercise id).
    @Default({}) Map<String, List<WorkoutSet>> previous,

    /// Display names by exercise id.
    @Default({}) Map<String, String> names,
  }) = _LiveSession;
}

/// Totals over completed WORKING sets (warmups never count, as in the API).
extension WorkoutTotals on Workout {
  Iterable<WorkoutSet> get _countedSets => exercises
      .expand((exercise) => exercise.sets)
      .where((set) => set.completed && set.type.countsForVolume);

  double get liveVolumeKg => _countedSets.fold(
    0,
    (total, set) => total + (set.weightKg ?? 0) * (set.reps ?? 0),
  );

  int get completedWorkingSets => _countedSets.length;

  Duration elapsed(DateTime now) => (finishedAt ?? now).difference(startedAt);
}
