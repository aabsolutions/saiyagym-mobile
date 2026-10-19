import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:saiyagym_mobile/core/config/app_config.dart';
import 'package:saiyagym_mobile/core/database/app_database.dart';
import 'package:saiyagym_mobile/core/network/api_client.dart';
import 'package:saiyagym_mobile/core/storage/token_storage.dart';
import 'package:saiyagym_mobile/core/sync/exercise_catalog_sync.dart';
import 'package:saiyagym_mobile/core/sync/stores.dart';
import 'package:saiyagym_mobile/core/sync/sync_queue.dart';
import 'package:saiyagym_mobile/core/sync/sync_service.dart';
import 'package:saiyagym_mobile/core/sync/sync_state.dart';
import 'package:workmanager/workmanager.dart';

const backgroundSyncTask = 'saiyagym.sync';

abstract interface class BackgroundSyncScheduler {
  Future<void> schedule();
  Future<void> cancel();
}

/// Periodic sync with WorkManager (Android). iOS needs BGTaskScheduler
/// wiring in Xcode first (see README), so it is skipped there for now.
class WorkmanagerBackgroundSync implements BackgroundSyncScheduler {
  bool _initialized = false;

  bool get _supported => defaultTargetPlatform == TargetPlatform.android;

  @override
  Future<void> schedule() async {
    if (!_supported) return;
    if (!_initialized) {
      await Workmanager().initialize(backgroundSyncDispatcher);
      _initialized = true;
    }
    await Workmanager().registerPeriodicTask(
      backgroundSyncTask,
      backgroundSyncTask,
      frequency: const Duration(minutes: 30),
      constraints: Constraints(networkType: NetworkType.connected),
      existingWorkPolicy: ExistingPeriodicWorkPolicy.keep,
    );
  }

  @override
  Future<void> cancel() async {
    if (!_supported || !_initialized) return;
    await Workmanager().cancelByUniqueName(backgroundSyncTask);
  }
}

@pragma('vm:entry-point')
void backgroundSyncDispatcher() {
  Workmanager().executeTask((task, _) async {
    if (task == backgroundSyncTask) {
      try {
        await runBackgroundSync();
      } on Object {
        // Next period retries; queued changes are safe on disk.
      }
    }
    return true;
  });
}

/// Runs in a separate isolate: no providers, so the pieces are built here.
///
/// Never refreshes tokens (`refreshTokens: false`): refresh tokens rotate,
/// and refreshing here while the app also does would revoke the session
/// (REFRESH_TOKEN_REUSED). With an expired access token the run just ends;
/// the app syncs on its next open / resume.
Future<void> runBackgroundSync() async {
  DartPluginRegistrant.ensureInitialized();
  final config = AppConfig.resolve(
    flavorName: appFlavor ?? const String.fromEnvironment('FLAVOR'),
  );
  final db = AppDatabase();
  try {
    final storage = SecureTokenStorage(secureStorage);
    if (await storage.read() == null) return;
    final language = await db.readMeta(ExerciseCatalogSync.languageKey) ?? 'es';
    final dio = buildApiClient(
      baseUrl: config.apiBaseUrl,
      storage: storage,
      languageCode: () => language,
      onSessionExpired: () {},
      refreshTokens: false,
    );
    final service = SyncService(
      dio: dio,
      db: db,
      stores: SyncStores(db, languageCode: () => language),
      queue: SyncQueueDao(db),
    );
    await service.sync(reason: SyncReason.background);
    await service.dispose();
    dio.close();
  } finally {
    await db.close();
  }
}
