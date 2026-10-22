import 'dart:async';

import 'package:drift/drift.dart' show DatabaseConnection, driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saiyagym_mobile/app/sync/background_sync.dart';
import 'package:saiyagym_mobile/app/sync/sync_coordinator.dart';
import 'package:saiyagym_mobile/core/config/app_config.dart';
import 'package:saiyagym_mobile/core/database/app_database.dart';
import 'package:saiyagym_mobile/core/database/database_provider.dart';
import 'package:saiyagym_mobile/core/network/api_client.dart';
import 'package:saiyagym_mobile/core/notifications/notification_channels.dart';
import 'package:saiyagym_mobile/core/storage/token_storage.dart';
import 'package:saiyagym_mobile/core/sync/connectivity_monitor.dart';
import 'package:saiyagym_mobile/core/sync/sync_providers.dart';
import 'package:saiyagym_mobile/core/time/local_timezone.dart';
import 'package:saiyagym_mobile/features/live_workout/data/device_services.dart';
import 'package:saiyagym_mobile/features/live_workout/live_workout_providers.dart';
import 'package:saiyagym_mobile/features/reminders/data/reminder_scheduler.dart';
import 'package:saiyagym_mobile/features/reminders/reminders_providers.dart';
import 'package:saiyagym_mobile/features/sounds/data/alarm_sound_platform.dart';
import 'package:saiyagym_mobile/features/sounds/data/sound_preview.dart';
import 'package:saiyagym_mobile/features/sounds/sounds_providers.dart';

import 'fake_alarm_sound_platform.dart';
import 'fake_notification_channels.dart';
import 'fake_sync_api.dart';
import 'in_memory_token_storage.dart';

class FakeConnectivity implements ConnectivityMonitor {
  final controller = StreamController<bool>.broadcast();
  bool online = true;

  void set({required bool online}) {
    this.online = online;
    controller.add(online);
  }

  @override
  Future<bool> isOnline() async => online;

  @override
  Stream<bool> get changes => controller.stream;
}

class FakeBackgroundSync implements BackgroundSyncScheduler {
  int scheduled = 0;
  int cancelled = 0;

  @override
  Future<void> schedule() async => scheduled++;

  @override
  Future<void> cancel() async => cancelled++;
}

/// Infrastructure every app-level widget test needs: in-memory database,
/// a quiet fake API (empty, successful syncs), fixed connectivity and no
/// background work. Real sync code runs against them.
/// In-memory database for tests. Drift closes cancelled stream queries on a
/// 0 ms timer, which widget tests report as pending at teardown; close them
/// synchronously instead.
AppDatabase testDatabase() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  final database = AppDatabase(
    DatabaseConnection(
      NativeDatabase.memory(),
      closeStreamsSynchronously: true,
    ),
  );
  addTearDown(database.close);
  return database;
}

List<Override> testInfraOverrides({
  FakeSyncApi? api,
  AppDatabase? database,
  SilentDeviceServices? device,
  ReminderScheduler? reminders,
  SilentSoundPreview? preview,
  FakeAlarmSoundPlatform? soundPlatform,
  FakeNotificationChannels? channels,
}) {
  final db = database ?? testDatabase();
  final services = device ?? SilentDeviceServices();
  final fakeApi = api ?? FakeSyncApi();
  final storage = InMemoryTokenStorage(
    const AuthTokens(accessToken: 'a', refreshToken: 'r'),
  );
  return [
    appConfigProvider.overrideWithValue(
      const AppConfig(flavor: Flavor.dev, apiBaseUrl: 'https://api.test'),
    ),
    appDatabaseProvider.overrideWithValue(db),
    restAlarmProvider.overrideWithValue(services),
    // No native audio / MediaStore and no device-specific target in tests.
    alarmSoundPlatformProvider.overrideWithValue(
      soundPlatform ?? FakeAlarmSoundPlatform(),
    ),
    notificationChannelsProvider.overrideWithValue(
      channels ?? FakeNotificationChannels(),
    ),
    soundTargetProvider.overrideWithValue(SoundTarget.none),
    soundPreviewProvider.overrideWithValue(preview ?? SilentSoundPreview()),
    hapticsProvider.overrideWithValue(services),
    screenAwakeProvider.overrideWithValue(services),
    tokenStorageProvider.overrideWithValue(storage),
    apiClientProvider.overrideWith(
      (ref) => buildApiClient(
        baseUrl: 'https://api.test',
        storage: storage,
        languageCode: () => 'es',
        onSessionExpired: () {},
        adapter: fakeApi.adapter,
      ),
    ),
    connectivityMonitorProvider.overrideWithValue(FakeConnectivity()),
    localTimezoneProvider.overrideWith((ref) async => 'Europe/Madrid'),
    reminderSchedulerProvider.overrideWithValue(
      reminders ?? FakeReminderScheduler(),
    ),
    backgroundSyncSchedulerProvider.overrideWithValue(FakeBackgroundSync()),
  ];
}
