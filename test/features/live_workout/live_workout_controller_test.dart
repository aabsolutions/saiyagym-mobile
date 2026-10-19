import 'package:clock/clock.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saiyagym_mobile/core/database/app_database.dart';
import 'package:saiyagym_mobile/core/database/database_provider.dart';
import 'package:saiyagym_mobile/core/network/api_client.dart';
import 'package:saiyagym_mobile/core/sync/sync_collection.dart';
import 'package:saiyagym_mobile/core/sync/sync_providers.dart';
import 'package:saiyagym_mobile/core/sync/sync_queue.dart';
import 'package:saiyagym_mobile/core/sync/sync_state.dart';
import 'package:saiyagym_mobile/core/sync/sync_writer.dart';
import 'package:saiyagym_mobile/core/training/training_types.dart';
import 'package:saiyagym_mobile/features/auth/presentation/controllers/session_controller.dart';
import 'package:saiyagym_mobile/features/live_workout/data/device_services.dart';
import 'package:saiyagym_mobile/features/live_workout/data/start_plans.dart';
import 'package:saiyagym_mobile/features/live_workout/domain/live_session.dart';
import 'package:saiyagym_mobile/features/live_workout/live_workout_providers.dart';
import 'package:saiyagym_mobile/features/live_workout/presentation/live_workout_controller.dart';
import 'package:saiyagym_mobile/features/records/domain/personal_records.dart';
import 'package:saiyagym_mobile/features/routines/domain/routine.dart';
import 'package:saiyagym_mobile/features/workouts/workouts_providers.dart';

import '../../helpers/fake_session.dart';
import '../../helpers/fixtures.dart';
import '../../helpers/seed.dart';
import '../../helpers/test_infra.dart';

class _Scheduler implements SyncScheduler {
  final reasons = <SyncReason>[];

  @override
  void requestSync(SyncReason reason) => reasons.add(reason);
}

void main() {
  late AppDatabase db;
  late SilentDeviceServices device;
  late _Scheduler scheduler;
  late DateTime now;

  setUp(() async {
    db = testDatabase();
    device = SilentDeviceServices();
    scheduler = _Scheduler();
    now = DateTime.utc(2026, 10, 18, 9);
    final seed = Seed(db);
    await seed.exercise('ex-squat', 'Sentadilla');
    await seed.exercise('ex-row', 'Remo');
    await seed.workout(lastWeekSquat());
  });

  /// A fresh container on the SAME database = the app after being killed.
  ProviderContainer app() {
    final container = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        // Never called here (no network in these flows).
        apiClientProvider.overrideWithValue(Dio()),
        syncWriterProvider.overrideWithValue(SyncWriter(db, SyncQueueDao(db))),
        syncSchedulerProvider.overrideWithValue(scheduler),
        restAlarmProvider.overrideWithValue(device),
        hapticsProvider.overrideWithValue(device),
        screenAwakeProvider.overrideWithValue(device),
        sessionControllerProvider.overrideWith(
          () => FakeSession.user(testUser()),
        ),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  Future<T> at<T>(Future<T> Function() body) =>
      withClock(Clock(() => now), body);

  LiveWorkoutController controllerOf(ProviderContainer c) =>
      c.read(liveWorkoutControllerProvider.notifier);

  test('starts from a routine: prefilled sets, last time, names', () async {
    await at(() async {
      final c = app();
      await c.read(sessionControllerProvider.future);
      final session = await controllerOf(c).start(planFromRoutine(legDay));

      final squat = session.workout.exercises.single;
      expect(session.workout.routineId, 'r-legs');
      expect(session.names['ex-squat'], 'Sentadilla');
      expect(session.previous['ex-squat']!.first.weightKg, 95);
      expect(squat.sets.map((s) => (s.weightKg, s.reps)), [(100, 5), (100, 5)]);
      // Already in Drift, in progress.
      final stored = await c
          .read(workoutsRepositoryProvider)
          .watchInProgress()
          .first;
      expect(stored!.id, session.workout.id);
    });
  });

  test('survives an app kill: workout, targets and rest come back', () async {
    await at(() async {
      final first = app();
      await first.read(sessionControllerProvider.future);
      final session = await controllerOf(first).start(planFromRoutine(legDay));
      final squat = session.workout.exercises.single;
      await controllerOf(first).toggleSet(squat.id, squat.sets.first.id);
      await controllerOf(first)
          .updateSet(squat.id, squat.sets.last.id, reps: () => 3);
      first.dispose(); // killed

      now = now.add(const Duration(seconds: 30));
      final second = app();
      await second.read(sessionControllerProvider.future);
      final restored = await controllerOf(second).restore();

      expect(restored!.workout.id, session.workout.id);
      final sets = restored.workout.exercises.single.sets;
      expect(sets.first.completed, isTrue);
      expect(sets.last.reps, 3);
      expect(restored.meta.targets[squat.id]!.first.weightKg, 100);
      expect(restored.meta.rest, isNotNull, reason: '90 s left of 120');
      expect(restored.previous['ex-squat'], isNotEmpty);
    });
  });

  test('a rest that ended while the app was closed is cleared', () async {
    await at(() async {
      final first = app();
      await first.read(sessionControllerProvider.future);
      final session = await controllerOf(first).start(planFromRoutine(legDay));
      final squat = session.workout.exercises.single;
      await controllerOf(first).toggleSet(squat.id, squat.sets.first.id);
      first.dispose();

      now = now.add(const Duration(minutes: 5));
      final second = app();
      final restored = await controllerOf(second).restore();
      expect(restored!.meta.rest, isNull);
    });
  });

  group('rest timer', () {
    test(
      'starts on completion with the routine rest, and is adjustable',
      () async {
        await at(() async {
          final c = app();
          await c.read(sessionControllerProvider.future);
          final session = await controllerOf(c).start(planFromRoutine(legDay));
          final squat = session.workout.exercises.single;

          await controllerOf(c).toggleSet(squat.id, squat.sets.first.id);
          var rest = c.read(liveWorkoutControllerProvider)!.meta.rest!;
          // The routine's TargetSet default (120 s).
          expect(rest.endsAt, now.add(const Duration(seconds: 120)));
          expect(device.scheduled.last, rest.endsAt);

          await controllerOf(c).adjustRest(15);
          rest = c.read(liveWorkoutControllerProvider)!.meta.rest!;
          expect(rest.endsAt, now.add(const Duration(seconds: 135)));
          expect(device.scheduled.last, rest.endsAt);

          await controllerOf(c).skipRest();
          expect(c.read(liveWorkoutControllerProvider)!.meta.rest, isNull);
          expect(device.cancelled, greaterThan(0));
        });
      },
    );

    test('in a superset it starts only after the last exercise', () async {
      await at(() async {
        final c = app();
        await c.read(sessionControllerProvider.future);
        await controllerOf(c).start(planFromRoutine(legDay));
        await controllerOf(c).addExercise('ex-row');
        var workout = c.read(liveWorkoutControllerProvider)!.workout;
        await controllerOf(c).toggleSuperset(workout.exercises.first.id);
        workout = c.read(liveWorkoutControllerProvider)!.workout;
        final [squat, row] = workout.exercises;

        await controllerOf(c).toggleSet(squat.id, squat.sets.first.id);
        expect(c.read(liveWorkoutControllerProvider)!.meta.rest, isNull);

        await controllerOf(c).toggleSet(row.id, row.sets.first.id);
        expect(c.read(liveWorkoutControllerProvider)!.meta.rest, isNotNull);
      });
    });
  });

  test(
    'finishing keeps what was done, queues it and finds the records',
    () async {
      await at(() async {
        final c = app();
        await c.read(sessionControllerProvider.future);
        final session = await controllerOf(c).start(planFromRoutine(legDay));
        final squat = session.workout.exercises.single;
        await controllerOf(c).toggleSet(squat.id, squat.sets.first.id);
        now = now.add(const Duration(minutes: 40));

        final outcome = await controllerOf(c).finish(rating: 4, notes: 'Bien');

        expect(c.read(liveWorkoutControllerProvider), isNull);
        final saved = outcome!.workout;
        expect(saved.finishedAt, now);
        expect(saved.rating, 4);
        expect(
          saved.exercises.single.sets,
          hasLength(1),
          reason: 'only the done set',
        );
        expect(
          outcome.records.map((r) => r.record.type),
          unorderedEquals([RecordType.maxWeight, RecordType.bestE1RM]),
          reason: '100×5 beats 95×5; 500 kg volume < 950; 100 kg first time',
        );
        expect(scheduler.reasons, contains(SyncReason.workoutFinished));
        final queued = await SyncQueueDao(db)
            .find(SyncCollection.workouts, saved.id);
        expect(queued, isNotNull);
        expect(await db.readMeta(LiveWorkoutController.metaKey), isNull);
      });
    },
  );

  test('discarding deletes the session (logically, so it syncs)', () async {
    await at(() async {
      final c = app();
      await c.read(sessionControllerProvider.future);
      final session = await controllerOf(c).start(const StartPlan(name: 'X'));

      await controllerOf(c).discard();

      expect(c.read(liveWorkoutControllerProvider), isNull);
      expect(
        await c.read(workoutsRepositoryProvider).watchInProgress().first,
        isNull,
      );
      final queued = await SyncQueueDao(db)
          .find(SyncCollection.workouts, session.workout.id);
      expect(queued!.op, 'delete');
    });
  });

  test('one session at a time: start returns the running one', () async {
    await at(() async {
      final c = app();
      await c.read(sessionControllerProvider.future);
      final first = await controllerOf(c).start(planFromRoutine(legDay));
      final second = await controllerOf(c).start(const StartPlan(name: 'Otro'));
      expect(second.workout.id, first.workout.id);
    });
  });

  test('a routine without targets prefills from last time', () async {
    await at(() async {
      final c = app();
      await c.read(sessionControllerProvider.future);
      const bare = Routine(
        id: 'r',
        name: 'Libre',
        exercises: [
          RoutineExercise(
            id: 's',
            exerciseId: 'ex-squat',
            sets: [TargetSet(type: SetType.normal, repsMin: 5, repsMax: 8)],
          ),
        ],
      );
      final session = await controllerOf(c).start(planFromRoutine(bare));
      final set = session.workout.exercises.single.sets.single;
      expect((set.weightKg, set.reps), (95, 5));
    });
  });
}
