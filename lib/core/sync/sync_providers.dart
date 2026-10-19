import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:saiyagym_mobile/core/database/database_provider.dart';
import 'package:saiyagym_mobile/core/network/api_client.dart';
import 'package:saiyagym_mobile/core/sync/connectivity_monitor.dart';
import 'package:saiyagym_mobile/core/sync/exercise_catalog_sync.dart';
import 'package:saiyagym_mobile/core/sync/stores.dart';
import 'package:saiyagym_mobile/core/sync/sync_queue.dart';
import 'package:saiyagym_mobile/core/sync/sync_service.dart';
import 'package:saiyagym_mobile/core/sync/sync_state.dart';
import 'package:saiyagym_mobile/core/sync/sync_writer.dart';
import 'package:saiyagym_mobile/core/sync/unsynced_changes.dart';

part 'sync_providers.g.dart';

@Riverpod(keepAlive: true)
SyncStores syncStores(Ref ref) {
  final language = ref.watch(requestLanguageProvider);
  return SyncStores(
    ref.watch(appDatabaseProvider),
    languageCode: () => language.code,
  );
}

@Riverpod(keepAlive: true)
SyncQueueDao syncQueue(Ref ref) => SyncQueueDao(ref.watch(appDatabaseProvider));

@Riverpod(keepAlive: true)
SyncService syncService(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  final dio = ref.watch(apiClientProvider);
  final stores = ref.watch(syncStoresProvider);
  final queue = ref.watch(syncQueueProvider);
  final language = ref.watch(requestLanguageProvider);
  final service = SyncService(
    dio: dio,
    db: db,
    stores: stores,
    queue: queue,
    catalog: ExerciseCatalogSync(
      dio: dio,
      db: db,
      store: stores.exercises,
      languageCode: () => language.code,
    ),
  );
  // Logout asks before wiping changes that never reached the server.
  final unregister = ref.read(unsyncedChangesProvider).register(queue.countAll);
  ref
    ..onDispose(unregister)
    ..onDispose(service.dispose);
  return service;
}

/// Writer for repositories: every local edit schedules a (debounced) sync.
@Riverpod(keepAlive: true)
SyncWriter syncWriter(Ref ref) {
  final service = ref.watch(syncServiceProvider);
  return SyncWriter(
    ref.watch(appDatabaseProvider),
    ref.watch(syncQueueProvider),
    onChange: () => service.requestSync(SyncReason.localChange),
  );
}

/// Changes the API rejected permanently (for the sync sheet).
@riverpod
Stream<List<FailedChange>> failedChanges(Ref ref) =>
    ref.watch(syncQueueProvider).watchFailed();

@Riverpod(keepAlive: true)
SyncScheduler syncScheduler(Ref ref) => ref.watch(syncServiceProvider);

@Riverpod(keepAlive: true)
ConnectivityMonitor connectivityMonitor(Ref ref) =>
    PlatformConnectivityMonitor();

/// Live sync state for the UI.
@Riverpod(keepAlive: true)
class SyncStatus extends _$SyncStatus {
  @override
  SyncState build() {
    final service = ref.watch(syncServiceProvider);
    void listener() => state = service.state.value;
    service.state.addListener(listener);
    ref.onDispose(() => service.state.removeListener(listener));
    return service.state.value;
  }
}
