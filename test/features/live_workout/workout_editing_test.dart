import 'package:flutter_test/flutter_test.dart';
import 'package:saiyagym_mobile/core/training/training_types.dart';
import 'package:saiyagym_mobile/features/live_workout/domain/live_session.dart';
import 'package:saiyagym_mobile/features/live_workout/domain/workout_editing.dart';
import 'package:saiyagym_mobile/features/workouts/domain/workout.dart';

void main() {
  final t0 = DateTime.utc(2026, 10, 18, 9);
  late int counter;
  String newId() => 'id-${counter++}';

  setUp(() => counter = 0);

  Workout build(
    StartPlan plan, {
    Map<String, List<WorkoutSet>> previous = const {},
  }) => buildWorkout(
    id: 'w',
    plan: plan,
    startedAt: t0,
    previous: previous,
    newId: newId,
  );

  group('prefill (one tap per set)', () {
    test('the target weight wins; reps from last time, else the target', () {
      final workout = build(
        const StartPlan(
          exercises: [
            PlannedExercise(
              exerciseId: 'squat',
              sets: [
                SetTarget(
                  type: SetType.warmup,
                  repsMin: 5,
                  repsMax: 5,
                  weightKg: 60,
                ),
                SetTarget(repsMin: 6, repsMax: 8, weightKg: 100),
                SetTarget(repsMin: 6, repsMax: 8),
              ],
            ),
          ],
        ),
        previous: {
          'squat': const [
            WorkoutSet(id: 'p1', type: SetType.warmup, weightKg: 50, reps: 5),
            WorkoutSet(id: 'p2', type: SetType.normal, weightKg: 97.5, reps: 7),
          ],
        },
      );
      final sets = workout.exercises.single.sets;
      expect(sets.map((s) => (s.type, s.weightKg, s.reps)), [
        (SetType.warmup, 60, 5),
        (SetType.normal, 100, 7), // target weight, last reps
        (SetType.normal, null, 6), // no target weight, nothing last time
      ]);
      expect(sets.every((s) => !s.completed), isTrue);
    });
  });

  group('edits', () {
    Workout two() => build(
      const StartPlan(
        exercises: [
          PlannedExercise(
            exerciseId: 'a',
            sets: [SetTarget(repsMin: 5, weightKg: 50)],
          ),
          PlannedExercise(
            exerciseId: 'b',
            sets: [SetTarget(repsMin: 8, weightKg: 20)],
          ),
          PlannedExercise(
            exerciseId: 'c',
            sets: [SetTarget(repsMin: 10, weightKg: 10)],
          ),
        ],
      ),
    );

    test('toggling stamps and clears the completion time', () {
      final workout = two();
      final exercise = workout.exercises.first;
      final done = workout.toggleSet(exercise.id, exercise.sets.single.id, t0);
      expect(done.exercises.first.sets.single.completedAt, t0);
      final undone = done.toggleSet(exercise.id, exercise.sets.single.id, t0);
      expect(undone.exercises.first.sets.single.completed, isFalse);
      expect(undone.exercises.first.sets.single.completedAt, isNull);
    });

    test('a new set copies the last one (a warmup becomes a working set)', () {
      var workout = two();
      final row = workout.exercises.first;
      workout = workout
          .updateSet(row.id, row.sets.single.id, type: SetType.warmup)
          .addSet(row.id, 'new');
      final added = workout.exercises.first.sets.last;
      expect((added.type, added.weightKg, added.reps), (SetType.normal, 50, 5));
    });

    test('supersets stay contiguous and dissolve when split', () {
      var workout = two();
      final [a, b, c] = workout.exercises;
      workout = workout.toggleSupersetWithNext(a.id, 'g1');
      expect(workout.exercises.map((e) => e.groupId), ['g1', 'g1', null]);

      // Moving b away leaves a alone → no longer a superset.
      workout = workout.moveExercise(1, 2);
      expect(workout.exercises.map((e) => e.exerciseId), ['a', 'c', 'b']);
      expect(workout.exercises.map((e) => e.groupId), [null, null, null]);

      // Removing one of a pair dissolves it too.
      workout = workout.toggleSupersetWithNext(c.id, 'g2').removeExercise(b.id);
      expect(workout.exercises.map((e) => e.groupId), [null, null]);
    });

    test('replacing keeps the logged values', () {
      final workout = two();
      final row = workout.exercises.first;
      final replaced = workout.replaceExercise(row.id, 'a2');
      expect(replaced.exercises.first.exerciseId, 'a2');
      expect(replaced.exercises.first.sets, row.sets);
    });

    test('finishing keeps only what was done', () {
      var workout = two();
      final [a, b, _] = workout.exercises;
      workout = workout
          .addSet(a.id, 'a-2')
          .toggleSet(a.id, a.sets.single.id, t0)
          .toggleSupersetWithNext(a.id, 'g')
          .toggleSet(b.id, b.sets.single.id, t0);

      final done = workout.onlyCompleted();
      expect(done.exercises.map((e) => e.exerciseId), ['a', 'b']);
      expect(done.exercises.first.sets, hasLength(1));
      expect(workout.hasCompletedSets, isTrue);
      expect(two().hasCompletedSets, isFalse);
    });
  });

  test('volume and set count ignore warmups and unchecked sets', () {
    final workout = Workout(
      id: 'w',
      startedAt: t0,
      exercises: const [
        WorkoutExercise(
          id: 'e',
          exerciseId: 'x',
          sets: [
            WorkoutSet(
              id: '1',
              type: SetType.warmup,
              weightKg: 60,
              reps: 5,
              completed: true,
            ),
            WorkoutSet(
              id: '2',
              type: SetType.normal,
              weightKg: 100,
              reps: 5,
              completed: true,
            ),
            WorkoutSet(
              id: '3',
              type: SetType.dropset,
              weightKg: 80,
              reps: 8,
              completed: true,
            ),
            WorkoutSet(id: '4', type: SetType.normal, weightKg: 100, reps: 5),
          ],
        ),
      ],
    );
    expect(workout.liveVolumeKg, 100 * 5 + 80 * 8);
    expect(workout.completedWorkingSets, 2);
  });
}
