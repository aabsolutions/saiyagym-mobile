import 'package:flutter_test/flutter_test.dart';
import 'package:saiyagym_mobile/core/training/training_types.dart';
import 'package:saiyagym_mobile/features/records/data/records_service.dart';
import 'package:saiyagym_mobile/features/workouts/domain/workout.dart';

void main() {
  WorkoutSet set(
    String id,
    double weight,
    int reps, {
    SetType type = SetType.normal,
  }) => WorkoutSet(
    id: id,
    type: type,
    weightKg: weight,
    reps: reps,
    completed: true,
  );

  Workout workout(
    String id,
    DateTime startedAt,
    Map<String, List<WorkoutSet>> byExercise,
  ) => Workout(
    id: id,
    startedAt: startedAt,
    finishedAt: startedAt.add(const Duration(hours: 1)),
    exercises: [
      for (final MapEntry(key: exerciseId, value: sets) in byExercise.entries)
        WorkoutExercise(
          id: '$id-$exerciseId',
          exerciseId: exerciseId,
          sets: sets,
        ),
    ],
  );

  test('records per exercise across sessions', () {
    final records = recordsByExercise([
      workout('w2', DateTime.utc(2026, 10, 15), {
        'squat': [set('a', 120, 3), set('b', 100, 8)],
      }),
      workout('w1', DateTime.utc(2026, 10, 8), {
        'squat': [set('c', 110, 5)],
        'bench': [set('d', 80, 6), set('e', 140, 1, type: SetType.warmup)],
      }),
    ]);

    expect(records.keys, unorderedEquals(['squat', 'bench']));
    final squat = records['squat']!;
    expect(squat.maxWeight!.value, 120);
    expect(squat.maxWeight!.workoutId, 'w2');
    // Epley: 120 × 3 → 132 beats 100 × 8 → 126.7.
    expect(squat.bestE1RM!.value, 132);
    expect(squat.maxVolume!.value, 120 * 3 + 100 * 8);
    // The warm-up never counts.
    expect(records['bench']!.maxWeight!.value, 80);
  });

  test('no history, no records', () {
    expect(recordsByExercise(const []), isEmpty);
  });
}
