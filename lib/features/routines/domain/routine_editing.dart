import 'package:saiyagym_mobile/core/training/training_types.dart';
import 'package:saiyagym_mobile/features/routines/domain/routine.dart';

/// Pure edits of a routine (simplified mobile editor). New ids come from
/// the caller, so the edits stay deterministic.
extension RoutineEditing on Routine {
  Routine _map(String slotId, RoutineExercise Function(RoutineExercise e) f) =>
      copyWith(
        exercises: [
          for (final e in exercises)
            if (e.id == slotId) f(e) else e,
        ],
      );

  /// New slot with 3 working sets of 8–12 (a sensible default to edit).
  Routine addExercise(String exerciseId, {required String slotId}) => copyWith(
    exercises: [
      ...exercises,
      RoutineExercise(
        id: slotId,
        exerciseId: exerciseId,
        sets: List.filled(
          3,
          const TargetSet(type: SetType.normal, repsMin: 8, repsMax: 12),
        ),
      ),
    ],
  );

  Routine removeExercise(String slotId) => _fixGroups(
    copyWith(
      exercises: [
        for (final e in exercises)
          if (e.id != slotId) e,
      ],
    ),
  );

  Routine moveExercise(int from, int to) {
    final list = [...exercises];
    final moved = list.removeAt(from);
    list.insert(to.clamp(0, list.length), moved);
    return _fixGroups(copyWith(exercises: list));
  }

  /// Adds a set copying the last one.
  Routine addSet(String slotId) => _map(
    slotId,
    (e) => e.copyWith(
      sets: [
        ...e.sets,
        if (e.sets.isEmpty)
          const TargetSet(type: SetType.normal, repsMin: 8, repsMax: 12)
        else
          e.sets.last.copyWith(
            type: e.sets.last.type == SetType.warmup
                ? SetType.normal
                : e.sets.last.type,
          ),
      ],
    ),
  );

  Routine removeSet(String slotId, int index) => _map(
    slotId,
    (e) => e.copyWith(
      sets: [
        for (final (i, set) in e.sets.indexed)
          if (i != index) set,
      ],
    ),
  );

  Routine updateSet(String slotId, int index, TargetSet set) => _map(
    slotId,
    (e) => e.copyWith(
      sets: [
        for (final (i, current) in e.sets.indexed)
          if (i == index) _valid(set) else current,
      ],
    ),
  );

  Routine setNotes(String slotId, String notes) =>
      _map(slotId, (e) => e.copyWith(notes: notes));

  /// API rules: reps ≥ 1 and min ≤ max; one of weight / %1RM.
  static TargetSet _valid(TargetSet set) {
    final min = set.repsMin < 1 ? 1 : set.repsMin;
    final max = set.repsMax < min ? min : set.repsMax;
    return set.copyWith(
      repsMin: min,
      repsMax: max,
      restSeconds: set.restSeconds.clamp(0, 1800),
      percent1RM: set.weightKg != null ? null : set.percent1RM,
    );
  }

  static Routine _fixGroups(Routine routine) {
    final list = [...routine.exercises];
    for (var i = 0; i < list.length; i++) {
      final group = list[i].groupId;
      if (group == null) continue;
      final before = i > 0 && list[i - 1].groupId == group;
      final after = i + 1 < list.length && list[i + 1].groupId == group;
      if (!before && !after) list[i] = list[i].copyWith(groupId: null);
    }
    return routine.copyWith(exercises: list);
  }

  /// Can be saved: a name and at least one exercise.
  bool get isValid => name.trim().isNotEmpty && exercises.isNotEmpty;
}
