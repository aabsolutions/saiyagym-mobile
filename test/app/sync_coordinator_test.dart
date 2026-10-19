import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:saiyagym_mobile/app/sync/sync_coordinator.dart';
import 'package:saiyagym_mobile/core/database/app_database.dart';
import 'package:saiyagym_mobile/core/database/database_provider.dart';
import 'package:saiyagym_mobile/core/sync/connectivity_monitor.dart';
import 'package:saiyagym_mobile/core/sync/sync_providers.dart';
import 'package:saiyagym_mobile/core/sync/sync_service.dart';
import 'package:saiyagym_mobile/core/sync/sync_state.dart';
import 'package:saiyagym_mobile/features/auth/domain/entities/session.dart';
import 'package:saiyagym_mobile/features/auth/presentation/controllers/session_controller.dart';
import 'package:saiyagym_mobile/features/progress_photos/data/photo_upload_queue.dart';
import 'package:saiyagym_mobile/features/progress_photos/data/progress_photos_api.dart';
import 'package:saiyagym_mobile/features/progress_photos/progress_photos_providers.dart';
import 'package:saiyagym_mobile/features/reminders/data/reminder_scheduler.dart';
import 'package:saiyagym_mobile/features/reminders/domain/reminder_settings.dart';
import 'package:saiyagym_mobile/features/reminders/reminders_providers.dart';

import '../helpers/fake_photos.dart';
import '../helpers/fixtures.dart';
import '../helpers/test_infra.dart';

class _MockSyncService extends Mock implements SyncService;

class _CountingQueue extends PhotoUploadQueue {
  _CountingQueue(AppDatabase db)
    : super(
        db: db,
        api: ProgressPhotosApi(dio: Dio(), upload: Dio()),
        compressor: FakeCompressor(),
        directory: () async => Directory.systemTemp,
      );

  int processed = 0;

  @override
  Future<void> process() async => processed++;
}

/// Session whose state the test drives.
class _Session extends SessionController {
  _Session(this._initial);

  final Session? _initial;

  @override
  Future<Session?> build() async => _initial;

  void set(Session? session) => state = AsyncData(session);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late _MockSyncService sync;
  late FakeConnectivity connectivity;
  late FakeBackgroundSync background;
  late AppDatabase db;
  late _CountingQueue photos;
  late FakeReminderScheduler reminders;

  setUpAll(() => registerFallbackValue(SyncReason.manual));

  setUp(() {
    sync = _MockSyncService();
    when(() => sync.stop()).thenAnswer((_) async {});
    connectivity = FakeConnectivity();
    background = FakeBackgroundSync();
    db = testDatabase();
    photos = _CountingQueue(db);
    reminders = FakeReminderScheduler();
  });

  Future<ProviderContainer> start({Session? session}) async {
    final container = ProviderContainer(
      overrides: [
        syncServiceProvider.overrideWithValue(sync),
        connectivityMonitorProvider.overrideWithValue(
          connectivity as ConnectivityMonitor,
        ),
        backgroundSyncSchedulerProvider.overrideWithValue(background),
        sessionControllerProvider.overrideWith(() => _Session(session)),
        appDatabaseProvider.overrideWithValue(db),
        photoUploadQueueProvider.overrideWithValue(photos),
        reminderSchedulerProvider.overrideWithValue(reminders),
      ],
    );
    addTearDown(container.dispose);
    container.read(syncCoordinatorProvider);
    await container.read(sessionControllerProvider.future);
    await pumpEventQueue();
    return container;
  }

  test('signing in starts sync, syncs once and schedules background', () async {
    await start(session: Session(user: testUser()));

    verify(() => sync.start()).called(1);
    verify(() => sync.requestSync(SyncReason.appOpen)).called(1);
    expect(background.scheduled, 1);
  });

  test('signed out: nothing runs', () async {
    await start();

    verifyNever(() => sync.start());
    verifyNever(() => sync.requestSync(any()));
    expect(background.scheduled, 0);
  });

  test('network back → sync (only on the offline → online edge)', () async {
    await start(session: Session(user: testUser()));
    clearInteractions(sync);

    connectivity.set(online: true); // was already online
    await pumpEventQueue();
    verifyNever(() => sync.requestSync(SyncReason.connectivity));

    connectivity
      ..set(online: false)
      ..set(online: true);
    await pumpEventQueue();
    verify(() => sync.requestSync(SyncReason.connectivity)).called(1);
  });

  test('a language change refreshes the catalog through a sync', () async {
    final container = await start(session: Session(user: testUser()));
    clearInteractions(sync);

    container.read(syncCoordinatorProvider.notifier).languageChanged();

    verify(() => sync.requestSync(SyncReason.languageChanged)).called(1);
  });

  test('signing out stops sync and cancels background work', () async {
    final container = await start(session: Session(user: testUser()));

    (container.read(sessionControllerProvider.notifier) as _Session).set(null);
    await pumpEventQueue();

    verify(() => sync.stop()).called(1);
    expect(background.cancelled, 1);

    // Network changes no longer trigger anything.
    clearInteractions(sync);
    connectivity
      ..set(online: false)
      ..set(online: true);
    await pumpEventQueue();
    verifyNever(() => sync.requestSync(any()));
  });

  test(
    'queued photos upload on sign-in and when the network is back',
    () async {
      await start(session: Session(user: testUser()));
      expect(photos.processed, 1);

      connectivity
        ..set(online: false)
        ..set(online: true);
      await pumpEventQueue();
      expect(photos.processed, 2);
    },
  );

  test(
    'reminders are cancelled only when logout wiped their settings',
    () async {
      await ReminderSettingsStore(db)
          .write(const ReminderSettings(trainingEnabled: true));
      final container = await start(session: Session(user: testUser()));
      final session =
          container.read(sessionControllerProvider.notifier) as _Session;
      expect(reminders.applied, isEmpty, reason: 'settings exist');

      // Expired session: local data (and settings) kept → reminders stay.
      session.set(null);
      await pumpEventQueue();
      expect(reminders.applied, isEmpty);

      // Logout: wiped → nothing may stay scheduled.
      session.set(Session(user: testUser()));
      await pumpEventQueue();
      await db.wipe();
      session.set(null);
      await pumpEventQueue();
      expect(reminders.applied, [const ReminderSettings()]);
    },
  );
}
