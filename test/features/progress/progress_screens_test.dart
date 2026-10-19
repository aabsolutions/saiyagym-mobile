import 'dart:convert';
import 'dart:io';

import 'package:clock/clock.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saiyagym_mobile/app/app.dart';
import 'package:saiyagym_mobile/core/cache/json_cache.dart';
import 'package:saiyagym_mobile/core/database/app_database.dart';
import 'package:saiyagym_mobile/core/sync/stores.dart';
import 'package:saiyagym_mobile/core/sync/sync_collection.dart';
import 'package:saiyagym_mobile/core/sync/sync_queue.dart';
import 'package:saiyagym_mobile/core/training/training_types.dart';
import 'package:saiyagym_mobile/features/auth/presentation/controllers/session_controller.dart';
import 'package:saiyagym_mobile/features/body_metrics/presentation/body_metric_form_page.dart';
import 'package:saiyagym_mobile/features/live_workout/data/device_services.dart';
import 'package:saiyagym_mobile/features/profile/presentation/profile_page.dart';
import 'package:saiyagym_mobile/features/progress/presentation/progress_page.dart';
import 'package:saiyagym_mobile/features/progress_photos/data/photo_upload_queue.dart';
import 'package:saiyagym_mobile/features/progress_photos/progress_photos_providers.dart';
import 'package:saiyagym_mobile/features/reminders/data/reminder_scheduler.dart';
import 'package:saiyagym_mobile/features/workouts/domain/workout.dart';

import '../../helpers/fake_photos.dart';
import '../../helpers/fake_session.dart';
import '../../helpers/fake_sync_api.dart';
import '../../helpers/fixtures.dart';
import '../../helpers/pump_app.dart';
import '../../helpers/seed.dart';
import '../../helpers/test_infra.dart';

const Map<String, Object?> _window = {
  'from': null,
  'to': '2026-10-19T10:00:00.000Z',
  'limitedByPlan': false,
};

void main() {
  late AppDatabase db;
  late FakeSyncApi api;
  late FakeReminderScheduler reminders;

  setUp(() async {
    db = testDatabase();
    api = FakeSyncApi();
    reminders = FakeReminderScheduler();
    final seed = Seed(db);
    await seed.exercise('ex-squat', 'Sentadilla');
    final startedAt = DateTime(2026, 10, 14, 18);
    await seed.workout(
      Workout(
        id: 'w1',
        name: 'Pierna',
        startedAt: startedAt,
        finishedAt: startedAt.add(const Duration(hours: 1)),
        exercises: [
          const WorkoutExercise(
            id: 'e1',
            exerciseId: 'ex-squat',
            sets: [
              WorkoutSet(
                id: 's1',
                type: SetType.normal,
                weightKg: 110,
                reps: 5,
                completed: true,
              ),
            ],
          ),
        ],
      ),
    );
  });

  Future<void> pumpApp(
    WidgetTester tester, {
    bool premium = false,
    List<Override> extra = const [],
  }) => pumpLocalized(
    tester,
    const SaiyaGymApp(),
    infra: testInfraOverrides(
      api: api,
      database: db,
      device: SilentDeviceServices(),
      reminders: reminders,
    ),
    overrides: [
      sessionControllerProvider.overrideWith(
        () => FakeSession.user(testUser(premium: premium)),
      ),
      ...extra,
    ],
  );

  Future<void> settle(WidgetTester tester, [int frames = 8]) async {
    for (var i = 0; i < frames; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
  }

  Future<void> openProgress(WidgetTester tester) async {
    await tester.tap(
      find.descendant(
        of: find.byType(NavigationBar),
        matching: find.text('Progreso'),
      ),
    );
    await settle(tester);
  }

  /// Scrolls [page]'s list until [finder] is on screen. Not
  /// scrollUntilVisible: it settles, and other tabs stay mounted.
  Future<void> scrollTo(
    WidgetTester tester,
    Finder finder, {
    Type page = ProgressPage,
  }) async {
    final list = find
        .descendant(of: find.byType(page), matching: find.byType(Scrollable))
        .first;
    for (var i = 0; i < 20 && finder.hitTestable().evaluate().isEmpty; i++) {
      await tester.drag(list, const Offset(0, -300));
      await settle(tester, 2);
    }
  }

  Future<void> tapVisible(
    WidgetTester tester,
    Finder finder, {
    Type page = ProgressPage,
  }) async {
    await scrollTo(tester, finder, page: page);
    await tester.tap(finder.hitTestable().first);
    await settle(tester);
  }

  void goOffline() => api.other = (options) => throw DioException(
    requestOptions: options,
    type: DioExceptionType.connectionError,
  );

  testWidgets('offline: the last stats are shown with their date', (
    tester,
  ) async {
    final cache = JsonCache(db);
    await withClock(Clock.fixed(DateTime.utc(2026, 10, 18, 9)), () async {
      await cache.fetch(
        'stats.exercise.ex-squat',
        () async => {
          'exerciseId': 'ex-squat',
          'points': [
            {
              'date': '2026-10-14',
              'workoutId': 'w1',
              'maxWeightKg': 110,
              'volumeKg': 550,
              'bestE1RM': 128.3,
            },
          ],
          'window': _window,
        },
      );
      await cache.fetch(
        'stats.muscleVolume',
        () async => {
          'rows': [
            {
              'week': '2026-10-12',
              'muscle': 'quads',
              'sets': 1,
              'volumeKg': 550,
            },
          ],
          'window': _window,
        },
      );
      await cache.fetch(
        'stats.powerlifting.e1rm',
        () async => {
          'metric': 'e1rm',
          'points': <Object>[],
          'bestTotal': 420,
          'window': _window,
        },
      );
    });
    goOffline();

    await pumpApp(tester);
    await openProgress(tester);

    expect(find.text('Evolución por ejercicio'), findsOneWidget);
    expect(find.textContaining('Sin conexión · datos del'), findsWidgets);
    await scrollTo(tester, find.text('Cuádriceps'));
    expect(find.text('Cuádriceps'), findsOneWidget);
    await scrollTo(tester, find.text('Mejor total: 420 kg'));
    expect(find.text('Mejor total: 420 kg'), findsOneWidget);
  });

  testWidgets('quick weigh-in, then the weekly reminder is offered once', (
    tester,
  ) async {
    goOffline();
    await pumpApp(tester);
    await openProgress(tester);

    await tester.tap(find.text('Registrar peso'));
    await settle(tester);
    await tester.enterText(find.byType(TextField).last, '81,5');
    await tester.tap(find.widgetWithText(FilledButton, 'Guardar'));
    await settle(tester);

    final stores = SyncStores(db, languageCode: () => 'es');
    final metric = (await stores.bodyMetrics.active()).single;
    expect(metric.json['weightKg'], 81.5);
    expect(
      await SyncQueueDao(db).find(SyncCollection.bodyMetrics, metric.id),
      isNotNull,
      reason: 'saved offline, queued for sync',
    );
    expect(find.text('81,5 kg'), findsOneWidget);

    // Permission is asked only once the user accepts the reminder.
    expect(reminders.permissionRequests, 0);
    await tester.tap(find.text('Activar'));
    await settle(tester);
    expect(reminders.permissionRequests, 1);
    expect(reminders.applied.last.weighInEnabled, isTrue);
  });

  testWidgets('full measurements form validates the API ranges', (
    tester,
  ) async {
    goOffline();
    await pumpApp(tester);
    await openProgress(tester);

    await tester.tap(find.text('Todas las medidas'));
    await settle(tester);
    await tester.enterText(find.widgetWithText(TextFormField, 'Cintura'), '10');
    await tapVisible(
      tester,
      find.widgetWithText(FilledButton, 'Guardar'),
      page: BodyMetricFormPage,
    );
    expect(find.text('Entre 30 y 250.'), findsOneWidget);

    await tester.enterText(find.widgetWithText(TextFormField, 'Cintura'), '82');
    await tapVisible(
      tester,
      find.widgetWithText(FilledButton, 'Guardar'),
      page: BodyMetricFormPage,
    );

    final stores = SyncStores(db, languageCode: () => 'es');
    final metric = (await stores.bodyMetrics.active()).single;
    expect(metric.json['waistCm'], 82);
    expect(metric.json['weightKg'], isNull);
  });

  testWidgets('personal records per exercise', (tester) async {
    goOffline();
    await pumpApp(tester);
    await openProgress(tester);

    await tapVisible(tester, find.text('Récords personales'));

    expect(find.text('Sentadilla'), findsOneWidget);
    expect(find.text('110 kg × 5'), findsOneWidget);
  });

  testWidgets('reminders: permission asked when turning one on', (
    tester,
  ) async {
    await pumpApp(tester);
    await tester.tap(
      find.descendant(
        of: find.byType(NavigationBar),
        matching: find.text('Perfil'),
      ),
    );
    await settle(tester);
    await tapVisible(
      tester,
      find.text('Entrenos y pesaje semanal'),
      page: ProfilePage,
    );

    reminders.grant = false;
    await tester.tap(find.text('Recordatorio de entreno'));
    await settle(tester);
    expect(
      find.textContaining('Las notificaciones están desactivadas'),
      findsOneWidget,
    );
    final before = reminders.applied.length;

    reminders.grant = true;
    await tester.tap(find.text('Recordatorio de entreno'));
    await settle(tester);
    expect(reminders.permissionRequests, 2);
    expect(reminders.applied, hasLength(before + 1));
    final applied = reminders.applied.last;
    expect(applied.trainingEnabled, isTrue);
    expect(applied.trainingDays, {1, 3, 5});
    expect(find.byType(FilterChip), findsNWidgets(7));
  });

  testWidgets('photos are Premium', (tester) async {
    goOffline();
    await pumpApp(tester);
    await openProgress(tester);

    await tapVisible(tester, find.text('Fotos de progreso'));

    expect(find.text('Nueva foto'), findsNothing);
    expect(find.textContaining('Premium'), findsWidgets);
  });

  testWidgets('photo taken offline waits in the queue', (tester) async {
    goOffline();
    final dir = await tester.runAsync(tempPhotosDir);
    addTearDown(() => dir!.deleteSync(recursive: true));
    final picker = FakePhotoPicker();
    await pumpApp(
      tester,
      premium: true,
      extra: [
        photoPickerProvider.overrideWithValue(picker),
        imageCompressorProvider.overrideWithValue(FakeCompressor()),
        pendingPhotosDirProvider.overrideWithValue(() async => dir!),
      ],
    );
    await openProgress(tester);
    await tapVisible(tester, find.text('Fotos de progreso'));

    await tester.tap(find.text('Nueva foto'));
    await settle(tester);
    expect(find.text('Foto frontal'), findsOneWidget, reason: 'framing tips');
    await tester.tap(find.text('Hacer foto'));
    await settle(tester);
    expect(picker.sources.single.name, 'camera');
    await tester.tap(find.text('Usar foto'));
    await settle(tester);

    final pending =
        jsonDecode((await db.readMeta(PhotoUploadQueue.key))!) as List;
    final photo = pending.single as Map;
    expect(photo['view'], 'front');
    expect(File('${dir!.path}/${photo['fileName']}').existsSync(), isTrue);
    expect(find.text('Pendiente'), findsOneWidget);
  });
}
