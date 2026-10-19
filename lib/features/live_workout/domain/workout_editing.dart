import 'package:saiyagym_mobile/core/training/training_types.dart';
import 'package:saiyagym_mobile/features/live_workout/domain/live_session.dart';
import 'package:saiyagym_mobile/features/workouts/domain/workout.dart';

/// Pure edits of an in-progress workout. Ids come from [newId] so the
/// functions stay deterministic in tests.

/// Builds the workout of a plan. Weight and reps are PREFILLED (so marking
/// a set is one tap): the plan's target first, else what was done last
/// time at the same position, else empty.
Workout buildWorkout({
  required String id,
  required StartPlan plan,
  required DateTime startedAt,
  required Map<String, List<WorkoutSet>> previous,
  required String Function() newId,
}) => Workout(
  id: id,
  name: plan.name,
  routineId: plan.routineId,
  programId: plan.programId,
  startedAt: startedAt,
  exercises: [
    for (final planned in plan.exercises)
      WorkoutExercise(
        id: newId(),
        exerciseId: planned.exerciseId,
        routineExerciseId: planned.routineExerciseId,
        groupId: planned.groupId,
        notes: planned.notes,
        sets: [
          for (final (index, target) in planned.sets.indexed)
            prefilledSet(
              id: newId(),
              target: target,
              last: _at(previous[planned.exerciseId], index),
            ),
        ],
      ),
  ],
);

WorkoutSet prefilledSet({
  required String id,
  SetTarget? target,
  WorkoutSet? last,
}) => WorkoutSet(
  id: id,
  type: target?.type ?? last?.type ?? SetType.normal,
  weightKg: target?.weightKg ?? last?.weightKg,
  reps: last?.reps ?? target?.repsMin ?? target?.repsMax,
);

T? _at<T>(List<T>? list, int index) =>
    list != null && index < list.length ? list[index] : null;

extension WorkoutEditing on Workout {
  Workout _mapExercise(
    String exerciseRowId,
    WorkoutExercise Function(WorkoutExercise exercise) change,
  ) => copyWith(
    exercises: [
      for (final exercise in exercises)
        if (exercise.id == exerciseRowId) change(exercise) else exercise,
    ],
  );

  Workout _mapSet(
    String exerciseRowId,
    String setId,
    WorkoutSet Function(WorkoutSet set) change,
  ) => _mapExercise(
    exerciseRowId,
    (exercise) => exercise.copyWith(
      sets: [
        for (final set in exercise.sets)
          if (set.id == setId) change(set) else set,
      ],
    ),
  );

  WorkoutExercise? exerciseRow(String id) {
    for (final exercise in exercises) {
      if (exercise.id == id) return exercise;
    }
    return null;
  }

  /// One tap: complete (stamping the time) or undo.
  Workout toggleSet(String exerciseRowId, String setId, DateTime now) =>
      _mapSet(
        exerciseRowId,
        setId,
        (set) => set.completed
            ? set.copyWith(completed: false, completedAt: null)
            : set.copyWith(completed: true, completedAt: now),
      );

  Workout updateSet(
    String exerciseRowId,
    String setId, {
    double? Function()? weightKg,
    int? Function()? reps,
    SetType? type,
  }) => _mapSet(
    exerciseRowId,
    setId,
    (set) => set.copyWith(
      weightKg: weightKg == null ? set.weightKg : weightKg(),
      reps: reps == null ? set.reps : reps(),
      type: type ?? set.type,
    ),
  );

  /// New set copying the last one's values (the usual next set).
  Workout addSet(String exerciseRowId, String setId) =>
      _mapExercise(exerciseRowId, (exercise) {
        final last = exercise.sets.isEmpty ? null : exercise.sets.last;
        return exercise.copyWith(
          sets: [
            ...exercise.sets,
            WorkoutSet(
              id: setId,
              type: last?.type == SetType.warmup
                  ? SetType.normal
                  : (last?.type ?? SetType.normal),
              weightKg: last?.weightKg,
              reps: last?.reps,
            ),
          ],
        );
      });

  Workout removeSet(String exerciseRowId, String setId) => _mapExercise(
    exerciseRowId,
    (exercise) => exercise.copyWith(
      sets: [
        for (final set in exercise.sets)
          if (set.id != setId) set,
      ],
    ),
  );

  Workout addExercise(WorkoutExercise exercise) =>
      copyWith(exercises: [...exercises, exercise]);

  Workout removeExercise(String exerciseRowId) => _fixGroups(
    copyWith(
      exercises: [
        for (final exercise in exercises)
          if (exercise.id != exerciseRowId) exercise,
      ],
    ),
  );

  Workout moveExercise(int from, int to) {
    final list = [...exercises];
    final moved = list.removeAt(from);
    list.insert(to.clamp(0, list.length), moved);
    return _fixGroups(copyWith(exercises: list));
  }

  /// Same slot, another exercise (machine taken, …). Values are kept.
  Workout replaceExercise(String exerciseRowId, String exerciseId) =>
      _mapExercise(
        exerciseRowId,
        (exercise) => exercise.copyWith(exerciseId: exerciseId),
      );

  Workout setExerciseNotes(String exerciseRowId, String notes) => _mapExercise(
    exerciseRowId,
    (exercise) => exercise.copyWith(notes: notes),
  );

  /// Joins the exercise with the NEXT one in a superset, or takes it out of
  /// its superset. A group is always contiguous (API rule).
  Workout toggleSupersetWithNext(String exerciseRowId, String newGroupId) {
    final index = exercises.indexWhere((e) => e.id == exerciseRowId);
    if (index < 0) return this;
    final current = exercises[index];
    if (current.groupId != null) {
      return _fixGroups(
        _mapExercise(exerciseRowId, (e) => e.copyWith(groupId: null)),
      );
    }
    if (index + 1 >= exercises.length) return this;
    final next = exercises[index + 1];
    final groupId = next.groupId ?? newGroupId;
    final list = [...exercises];
    list[index] = current.copyWith(groupId: groupId);
    list[index + 1] = next.copyWith(groupId: groupId);
    return copyWith(exercises: list);
  }

  /// A group of one (or split by a move) is not a superset.
  static Workout _fixGroups(Workout workout) {
    final list = [...workout.exercises];
    for (var i = 0; i < list.length; i++) {
      final group = list[i].groupId;
      if (group == null) continue;
      final before = i > 0 && list[i - 1].groupId == group;
      final after = i + 1 < list.length && list[i + 1].groupId == group;
      if (!before && !after) list[i] = list[i].copyWith(groupId: null);
    }
    return workout.copyWith(exercises: list);
  }

  /// What was actually done: prefilled sets never marked weren't lifted,
  /// and an exercise left without sets wasn't trained.
  Workout onlyCompleted() => _fixGroups(
    copyWith(
      exercises: [
        for (final exercise in exercises)
          if (exercise.sets.any((set) => set.completed))
            exercise.copyWith(
              sets: [
                for (final set in exercise.sets)
                  if (set.completed) set,
              ],
            ),
      ],
    ),
  );

  bool get hasCompletedSets =>
      exercises.any((exercise) => exercise.sets.any((set) => set.completed));
}
