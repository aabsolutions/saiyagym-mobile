import 'package:saiyagym_mobile/core/database/app_database.dart';
import 'package:saiyagym_mobile/core/sync/stores.dart';
import 'package:saiyagym_mobile/core/training/training_types.dart';
import 'package:saiyagym_mobile/features/routines/domain/routine.dart';
import 'package:saiyagym_mobile/features/workouts/domain/workout.dart';

/// Local data as a previous sync would have left it.
class Seed {
  Seed(AppDatabase db) : _stores = SyncStores(db, languageCode: () => 'es');

  final SyncStores _stores;
  final _at = DateTime.utc(2026, 10);

  Future<void> exercise(
    String id,
    String name, {
    String muscle = 'quads',
    String? hypertrophyTier,
  }) => _stores.exercises.put(
    {
      'id': id,
      'name': name,
      'primaryMuscle': muscle,
      'equipment': 'barbell',
      'isGlobal': true,
      'tiers': {'hypertrophy': hypertrophyTier, 'powerlifting': null},
    },
    id: id,
    updatedAt: _at,
    deletedAt: null,
  );

  Future<void> routine(Routine routine) => _stores.routines.put(
    routine.toJson(),
    id: routine.id,
    updatedAt: _at,
    deletedAt: null,
  );

  Future<void> workout(Workout workout) => _stores.workouts.put(
    workout.toJson(),
    id: workout.id,
    updatedAt: _at,
    deletedAt: null,
  );
}

/// "Pierna": squat, 2 × 5 at 100 kg, 120 s rest.
const legDay = Routine(
  id: 'r-legs',
  name: 'Pierna',
  exercises: [
    RoutineExercise(
      id: 'slot-squat',
      exerciseId: 'ex-squat',
      sets: [
        TargetSet(type: SetType.normal, repsMin: 5, repsMax: 5, weightKg: 100),
        TargetSet(type: SetType.normal, repsMin: 5, repsMax: 5, weightKg: 100),
      ],
    ),
  ],
);

/// Last week's squat session: 2 × 5 at 95 kg.
Workout lastWeekSquat() => Workout(
  id: 'w-last-week',
  name: 'Pierna',
  startedAt: DateTime.utc(2026, 10, 11, 9),
  finishedAt: DateTime.utc(2026, 10, 11, 10),
  exercises: const [
    WorkoutExercise(
      id: 'we-old',
      exerciseId: 'ex-squat',
      sets: [
        WorkoutSet(
          id: 'o1',
          type: SetType.normal,
          weightKg: 95,
          reps: 5,
          completed: true,
        ),
        WorkoutSet(
          id: 'o2',
          type: SetType.normal,
          weightKg: 95,
          reps: 5,
          completed: true,
        ),
      ],
    ),
  ],
);
