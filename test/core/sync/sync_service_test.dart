import 'package:clock/clock.dart';
import 'package:dio/dio.dart';
import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saiyagym_mobile/core/database/app_database.dart';
import 'package:saiyagym_mobile/core/network/api_client.dart';
import 'package:saiyagym_mobile/core/storage/token_storage.dart';
import 'package:saiyagym_mobile/core/sync/exercise_catalog_sync.dart';
import 'package:saiyagym_mobile/core/sync/stores.dart';
import 'package:saiyagym_mobile/core/sync/sync_collection.dart';
import 'package:saiyagym_mobile/core/sync/sync_queue.dart';
import 'package:saiyagym_mobile/core/sync/sync_service.dart';
import 'package:saiyagym_mobile/core/sync/sync_state.dart';
import 'package:saiyagym_mobile/core/sync/sync_writer.dart';
import 'package:saiyagym_mobile/core/training/training_types.dart';
import 'package:saiyagym_mobile/features/exercises/data/exercises_repository_impl.dart';
import 'package:saiyagym_mobile/features/workouts/data/workouts_repository_impl.dart';
import 'package:saiyagym_mobile/features/workouts/domain/workout.dart';

import '../../helpers/fake_sync_api.dart';
import '../../helpers/in_memory_token_storage.dart';

void main() {
  final t0 = DateTime.utc(2026, 10, 18, 9);
  late DateTime now;
  late AppDatabase db;
  late SyncStores stores;
  late SyncQueueDao queue;
  late FakeSyncApi api;
  late SyncService service;
  late WorkoutsRepositoryImpl workouts;
  late String language;

  setUp(() {
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
    now = t0;
    language = 'es';
    db = AppDatabase(NativeDatabase.memory());
    stores = SyncStores(db, languageCode: () => language);
    queue = SyncQueueDao(db);
    api = FakeSyncApi();
    final dio = buildApiClient(
      baseUrl: 'https://api.test/api/v1',
      storage: InMemoryTokenStorage(
        const AuthTokens(accessToken: 'a', refreshToken: 'r'),
      ),
      languageCode: () => language,
      onSessionExpired: () {},
      adapter: api.adapter,
    );
    service = SyncService(
      dio: dio,
      db: db,
      stores: stores,
      queue: queue,
      catalog: ExerciseCatalogSync(
        dio: dio,
        db: db,
        store: stores.exercises,
        languageCode: () => language,
      ),
      jitter: () => 0.5, // factor 1.0: exact backoff
    );
    workouts = WorkoutsRepositoryImpl(
      store: stores.workouts,
      writer: SyncWriter(db, queue),
    );
  });

  tearDown(() async {
    await service.dispose();
    await db.close();
  });

  /// Runs [body] with the test clock (the service reads time via `clock`).
  Future<T> at<T>(Future<T> Function() body) =>
      withClock(Clock(() => now), body);

  Workout workout({String id = '6f1b8f5e-0000-4000-8000-000000000001'}) =>
      Workout(
        id: id,
        name: 'Pierna',
        startedAt: t0,
        finishedAt: t0.add(const Duration(hours: 1)),
        // Server-computed: must never be pushed back.
        volumeKg: 9999,
        exercises: const [
          WorkoutExercise(
            id: 'we-1',
            exerciseId: 'ex-squat',
            sets: [
              WorkoutSet(
                id: 's-1',
                type: SetType.normal,
                weightKg: 100,
                reps: 5,
                completed: true,
              ),
            ],
          ),
        ],
      );

  Map<String, Object?> serverWorkout(
    String id, {
    required DateTime updatedAt,
    DateTime? deletedAt,
    String name = 'Pierna (servidor)',
  }) => {
    'id': id,
    'name': name,
    'startedAt': t0.toIso8601String(),
    'finishedAt': t0.add(const Duration(hours: 1)).toIso8601String(),
    'exercises': <Object>[],
    'volumeKg': 500,
    'workingSets': 1,
    'durationSeconds': 3600,
    'createdAt': t0.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    'deletedAt': deletedAt?.toIso8601String(),
  };

  group('push', () {
    test('sends whitelisted docs and clears the queue on applied', () async {
      await at(() async {
        await workouts.save(workout());
        expect(await queue.countAll(), 1);

        final report = await service.sync();

        expect(report.ok, isTrue);
        expect(report.pushed, 1);
        final change = api.pushes.single.single;
        expect(change['collection'], 'workouts');
        expect(change['op'], 'upsert');
        final doc = docOf(change);
        expect(doc['id'], workout().id);
        expect(doc['updatedAt'], t0.toIso8601String());
        expect(doc['createdAt'], t0.toIso8601String());
        expect(doc.containsKey('volumeKg'), isFalse);
        expect(doc.containsKey('deletedAt'), isFalse);
        final set = ((doc['exercises'] as List).single as Map)['sets'] as List;
        expect(set.single, {
          'id': 's-1',
          'type': 'normal',
          'weightKg': 100.0,
          'reps': 5,
          'completed': true,
          'completedAt': null,
        });
        expect(await queue.countAll(), 0);
        expect(service.state.value.indicator, SyncIndicator.synced);
      });
    });

    test('many edits offline → one change with the final state', () async {
      await at(() async {
        await workouts.save(workout());
        now = now.add(const Duration(minutes: 1));
        await workouts.save(workout().copyWith(name: 'Pierna pesada'));

        await service.sync();

        final change = api.pushes.single.single;
        expect(docOf(change)['name'], 'Pierna pesada');
      });
    });

    test('a logical delete pushes op delete with deletedAt', () async {
      await at(() async {
        await workouts.save(workout());
        await service.sync();
        now = now.add(const Duration(minutes: 5));

        await workouts.delete(workout().id);
        await service.sync();

        final change = api.pushes.last.single;
        expect(change['op'], 'delete');
        expect(docOf(change), {
          'id': workout().id,
          'updatedAt': now.toIso8601String(),
          'deletedAt': now.toIso8601String(),
        });
        expect(await workouts.watchHistory().first, isEmpty);
      });
    });

    test('versions never go back, even if the device clock does', () async {
      await at(() async {
        await workouts.save(workout());
        now = now.subtract(const Duration(hours: 2)); // clock moved back
        await workouts.save(workout().copyWith(name: 'Otra'));

        final entry = await queue.find(SyncCollection.workouts, workout().id);
        expect(entry!.docUpdatedAt, t0.add(const Duration(milliseconds: 1)));
      });
    });

    test('prefs adopt the id the server keeps (keyed by exercise)', () async {
      await at(() async {
        final exercises = ExercisesRepositoryImpl(
          stores: stores,
          writer: SyncWriter(db, queue),
          languageCode: () => language,
        );
        await exercises.setFavorite('ex-bench', favorite: true);
        api.onPush = (changes) => [
          {
            'index': 0,
            'collection': 'user_exercise_prefs',
            'id': 'server-pref-id',
            'status': 'applied',
          },
        ];

        await service.sync();

        final pref = await stores.exercisePrefs.findByExercise('ex-bench');
        expect(pref!.id, 'server-pref-id');
        expect(pref.json['isFavorite'], isTrue);
      });
    });
  });

  group('pull', () {
    test('stores every collection and advances the cursor', () async {
      await at(() async {
        api.pullChanges = {
          'workouts': [serverWorkout('w-1', updatedAt: t0)],
          'routines': [
            {
              'id': 'r-1',
              'name': 'Torso',
              'exercises': <Object>[],
              'archivedAt': null,
              'updatedAt': t0.toIso8601String(),
              'deletedAt': null,
            },
          ],
          'exercises': [
            {
              'id': 'ex-custom',
              'name': {'es': 'Remo Meadows', 'en': 'Meadows row'},
              'primaryMuscle': 'lats',
              'equipment': 'barbell',
              'isGlobal': false,
              'updatedAt': t0.toIso8601String(),
              'deletedAt': null,
            },
          ],
          'programs': [
            {
              'id': 'p-1',
              'name': 'Bloque de fuerza',
              'status': 'active',
              'updatedAt': t0.toIso8601String(),
              'deletedAt': null,
            },
          ],
          'teleporters': [
            {'id': 'x'},
          ], // a newer API: ignored
        };

        final report = await service.sync();

        expect(report.pulled, 4);
        expect(api.pulls.single, isNull); // first sync: full pull
        final history = await workouts.watchHistory().first;
        expect(history.single.volumeKg, 500); // server-computed kept locally
        expect((await stores.routines.find('r-1'))!.json['name'], 'Torso');
        expect((await stores.programs.find('p-1'))!.json['status'], 'active');
        final custom = await ExercisesRepositoryImpl(
          stores: stores,
          writer: SyncWriter(db, queue),
          languageCode: () => language,
        ).find('ex-custom');
        expect(custom!.name, 'Remo Meadows');
        expect(
          await db.readMeta(SyncService.cursorKey),
          '2026-10-18T10:00:00.000Z',
        );

        await service.sync();
        expect(api.pulls.last, '2026-10-18T10:00:00.000Z');
      });
    });

    test('a deletion from another device hides the doc', () async {
      await at(() async {
        api.pullChanges = {
          'workouts': [serverWorkout('w-1', updatedAt: t0)],
        };
        await service.sync();

        api.pullChanges = {
          'workouts': [
            serverWorkout(
              'w-1',
              updatedAt: t0.add(const Duration(minutes: 1)),
              deletedAt: t0.add(const Duration(minutes: 1)),
            ),
          ],
        };
        await service.sync();

        expect(await workouts.watchHistory().first, isEmpty);
        expect((await stores.workouts.find('w-1'))!.isDeleted, isTrue);
      });
    });

    test('our own write pulled back is adopted (same version)', () async {
      await at(() async {
        await workouts.save(workout());
        // The server answers the pull with what we pushed + derived fields.
        api.pullChanges = {
          'workouts': [serverWorkout(workout().id, updatedAt: t0)],
        };

        await service.sync();

        final stored = await workouts.find(workout().id);
        expect(stored!.volumeKg, 500);
        expect(await queue.countAll(), 0);
      });
    });
  });

  group('conflicts (last write wins on updatedAt)', () {
    /// A local edit at t0+10min that couldn't be pushed (backoff).
    Future<void> pendingLocalEdit() async {
      now = t0.add(const Duration(minutes: 10));
      await workouts.save(workout().copyWith(name: 'Local'));
      api.onPush = (changes) => [
        {
          'index': 0,
          'collection': 'workouts',
          'id': workout().id,
          'status': 'error',
          'error': {'code': 'INTERNAL_ERROR', 'message': 'boom'},
        },
      ];
    }

    test(
      'local newer than the server: local stays and is pushed later',
      () async {
        await at(() async {
          await pendingLocalEdit();
          api.pullChanges = {
            'workouts': [
              serverWorkout(
                workout().id,
                updatedAt: t0.add(const Duration(minutes: 5)),
                name: 'Servidor (viejo)',
              ),
            ],
          };

          await service.sync();

          expect((await workouts.find(workout().id))!.name, 'Local');
          final entry = await queue.find(SyncCollection.workouts, workout().id);
          expect(entry, isNotNull, reason: 'still waiting to be pushed');
        });
      },
    );

    test(
      'server newer than the local edit: server wins, edit dropped',
      () async {
        await at(() async {
          await pendingLocalEdit();
          api.pullChanges = {
            'workouts': [
              serverWorkout(
                workout().id,
                updatedAt: t0.add(const Duration(minutes: 20)),
                name: 'Servidor (nuevo)',
              ),
            ],
          };

          await service.sync();

          expect((await workouts.find(workout().id))!.name, 'Servidor (nuevo)');
          expect(await queue.countAll(), 0);
        });
      },
    );

    test(
      'ignored_older: queue cleared, the newer server doc comes in',
      () async {
        await at(() async {
          await workouts.save(workout().copyWith(name: 'Local'));
          // Parenthesized: a bare lambda would swallow the next cascade.
          api
            ..onPush = ((changes) => [
              {
                'index': 0,
                'collection': 'workouts',
                'id': workout().id,
                'status': 'ignored_older',
              },
            ])
            ..pullChanges = {
              'workouts': [
                serverWorkout(
                  workout().id,
                  updatedAt: t0.add(const Duration(minutes: 1)),
                  name: 'Otro dispositivo',
                ),
              ],
            };

          await service.sync();

          expect(await queue.countAll(), 0);
          expect((await workouts.find(workout().id))!.name, 'Otro dispositivo');
        });
      },
    );
  });

  group('retries', () {
    test('a failed request backs off exponentially', () async {
      await at(() async {
        await workouts.save(workout());
        api.pushStatus = 500;

        final first = await service.sync();
        expect(first.error?.code, 'INTERNAL_ERROR');
        var entry = await queue.find(SyncCollection.workouts, workout().id);
        expect(entry!.attempts, 1);
        expect(entry.nextAttemptAt, t0.add(const Duration(seconds: 30)));
        expect(service.state.value.indicator, SyncIndicator.error);

        // Not due yet: nothing is sent.
        api.pushStatus = null;
        await service.sync();
        expect(api.pushes, isEmpty);

        // Due, fails again → twice the wait.
        now = t0.add(const Duration(seconds: 31));
        api.pushStatus = 503;
        await service.sync();
        entry = await queue.find(SyncCollection.workouts, workout().id);
        expect(entry!.attempts, 2);
        expect(entry.nextAttemptAt, now.add(const Duration(minutes: 1)));

        // Recovered.
        now = now.add(const Duration(minutes: 2));
        api.pushStatus = null;
        final last = await service.sync();
        expect(last.ok, isTrue);
        expect(api.pushes, hasLength(1));
        expect(await queue.countAll(), 0);
      });
    });

    test('the backoff is capped', () async {
      await at(() async {
        await workouts.save(workout());
        api.pushStatus = 500;
        for (var i = 0; i < 12; i++) {
          await service.sync();
          now = now.add(const Duration(hours: 2));
        }

        final entry = await queue.find(SyncCollection.workouts, workout().id);
        expect(
          entry!.nextAttemptAt!.difference(
            now.subtract(const Duration(hours: 2)),
          ),
          const Duration(hours: 1),
        );
      });
    });

    test('offline does not count as an attempt', () async {
      await at(() async {
        await workouts.save(workout());
        api.transportError = DioExceptionType.connectionError;

        final report = await service.sync();

        expect(report.offline, isTrue);
        expect(service.state.value.indicator, SyncIndicator.offline);
        final entry = await queue.find(SyncCollection.workouts, workout().id);
        expect(entry!.attempts, 0);
        expect(entry.nextAttemptAt, isNull);

        api.transportError = null;
        expect((await service.sync()).ok, isTrue);
        expect(service.state.value.offline, isFalse);
      });
    });

    test('a permanent rejection is marked and not resent', () async {
      await at(() async {
        service.start();
        await workouts.save(workout());
        api.onPush = (changes) => [
          {
            'index': 0,
            'collection': 'workouts',
            'id': workout().id,
            'status': 'error',
            'error': {'code': 'VALIDATION_ERROR', 'message': 'Datos inválidos'},
          },
        ];

        final report = await service.sync();
        expect(report.failed, 1);
        final failed = await queue.watchFailed().first;
        expect(failed.single.code, 'VALIDATION_ERROR');
        expect(failed.single.message, 'Datos inválidos');
        await pumpEventQueue();
        expect(service.state.value.failed, 1);
        expect(service.state.value.indicator, SyncIndicator.error);

        await service.sync();
        expect(api.pushes, hasLength(1), reason: 'failed changes wait');

        // Editing it again gives it a new chance.
        api.onPush = FakeSyncApi.applyAll;
        now = now.add(const Duration(minutes: 1));
        await workouts.save(workout().copyWith(name: 'Corregido'));
        await service.sync();
        expect(api.pushes, hasLength(2));
        expect(await queue.countAll(), 0);
      });
    });

    test('retryFailed puts rejected changes back in line', () async {
      await at(() async {
        await workouts.save(workout());
        api.onPush = (changes) => [
          {
            'index': 0,
            'collection': 'workouts',
            'id': workout().id,
            'status': 'error',
            'error': {'code': 'PLAN_LIMIT_REACHED', 'message': 'Límite'},
          },
        ];
        await service.sync();
        api.onPush = FakeSyncApi.applyAll;

        await queue.resetFailed();
        await service.sync();

        expect(api.pushes, hasLength(2));
        expect(await queue.countAll(), 0);
      });
    });

    test('discard drops the change and re-pulls the server copy', () async {
      await at(() async {
        api.pullChanges = {
          'workouts': [serverWorkout(workout().id, updatedAt: t0)],
        };
        await service.sync();
        now = t0.add(const Duration(minutes: 1));
        await workouts.save(workout().copyWith(name: 'Rechazado'));
        api.onPush = (changes) => [
          {
            'index': 0,
            'collection': 'workouts',
            'id': workout().id,
            'status': 'error',
            'error': {'code': 'VALIDATION_ERROR', 'message': 'x'},
          },
        ];
        await service.sync();
        final failed = (await queue.watchFailed().first).single;

        api
          ..onPush = FakeSyncApi.applyAll
          ..pullChanges = {
            'workouts': [serverWorkout(workout().id, updatedAt: t0)],
          };
        final pullsBefore = api.pulls.length;
        await service.discard(failed);
        await service.sync();

        expect(await queue.countAll(), 0);
        expect(
          api.pulls[pullsBefore],
          isNull,
          reason: 'cursor reset: the next pull is a full one',
        );
        expect((await workouts.find(workout().id))!.name, 'Pierna (servidor)');
      });
    });
  });

  test('single-flight: concurrent calls share a run', () async {
    await at(() async {
      await workouts.save(workout());

      final results = await Future.wait([service.sync(), service.sync()]);

      expect(api.pushes, hasLength(1));
      expect(identical(results[0], results[1]), isTrue);
      // The second call asked for one more pass (cheap: nothing to push).
      expect(api.pulls, hasLength(2));
    });
  });

  group('exercise catalog', () {
    List<Map<String, Object?>> catalog(int n) => [
      for (var i = 0; i < n; i++)
        {
          'id': 'g-$i',
          'name': 'Ejercicio $i',
          'primaryMuscle': 'chest',
          'equipment': 'barbell',
          'isGlobal': true,
          'isCustom': false,
          'tiers': {'hypertrophy': 'A', 'powerlifting': null},
        },
    ];

    test('downloads every page once, then only when stale', () async {
      await at(() async {
        api.catalog = catalog(150);

        await service.sync();
        expect(api.catalogPages, [1, 2]);
        final exercises = ExercisesRepositoryImpl(
          stores: stores,
          writer: SyncWriter(db, queue),
          languageCode: () => language,
        );
        final all = await exercises.watchCatalog().first;
        expect(all, hasLength(150));
        expect(all.first.tiers.hypertrophy, Tier.a);

        await service.sync();
        expect(api.catalogPages, [1, 2], reason: 'still fresh');

        now = now.add(const Duration(hours: 25));
        await service.sync();
        expect(api.catalogPages, [1, 2, 1, 2], reason: 'older than 24 h');
      });
    });

    test(
      'a new UI language downloads it again; removed ones are hidden',
      () async {
        await at(() async {
          api.catalog = catalog(3);
          await service.sync();

          language = 'en';
          api.catalog = catalog(2);
          await service.sync();

          expect(api.catalogPages, [1, 1]);
          final exercises = ExercisesRepositoryImpl(
            stores: stores,
            writer: SyncWriter(db, queue),
            languageCode: () => language,
          );
          expect(await exercises.watchCatalog().first, hasLength(2));
          // Still resolvable for old workouts.
          expect(await exercises.find('g-2'), isNotNull);
        });
      },
    );
  });
}
