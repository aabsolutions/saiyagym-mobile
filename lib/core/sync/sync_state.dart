import 'package:saiyagym_mobile/core/network/api_exception.dart';

/// What the global indicator shows, by priority.
enum SyncIndicator { offline, error, syncing, pending, synced }

class SyncState {
  const SyncState({
    this.syncing = false,
    this.offline = false,
    this.pending = 0,
    this.failed = 0,
    this.lastError,
    this.lastSyncedAt,
  });

  final bool syncing;

  /// The last attempt couldn't reach the API (or the device has no network).
  final bool offline;

  /// Local changes waiting to be pushed (including those in backoff).
  final int pending;

  /// Changes the API rejected permanently: need the user.
  final int failed;

  /// Last run's failure that wasn't about connectivity (5xx, …).
  final ApiException? lastError;
  final DateTime? lastSyncedAt;

  SyncIndicator get indicator {
    if (offline) return SyncIndicator.offline;
    if (failed > 0 || lastError != null) return SyncIndicator.error;
    if (syncing) return SyncIndicator.syncing;
    if (pending > 0) return SyncIndicator.pending;
    return SyncIndicator.synced;
  }

  SyncState copyWith({
    bool? syncing,
    bool? offline,
    int? pending,
    int? failed,
    ApiException? Function()? lastError,
    DateTime? lastSyncedAt,
  }) => SyncState(
    syncing: syncing ?? this.syncing,
    offline: offline ?? this.offline,
    pending: pending ?? this.pending,
    failed: failed ?? this.failed,
    lastError: lastError == null ? this.lastError : lastError(),
    lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
  );
}

enum SyncReason {
  appOpen,
  appResumed,
  appPaused,
  connectivity,
  localChange,
  workoutFinished,
  languageChanged,
  background,
  manual,
}

/// Port for domain code that needs a sync soon (e.g. a finished workout)
/// without knowing how it happens.
abstract interface class SyncScheduler {
  void requestSync(SyncReason reason);
}

/// A change the API rejected permanently, for the UI (not a database row).
class FailedChange {
  const FailedChange({
    required this.id,
    required this.collection,
    required this.docId,
    this.code,
    this.message,
  });

  /// Queue entry id.
  final int id;

  /// Wire name (`workouts`, `routines`, …).
  final String collection;
  final String docId;
  final String? code;
  final String? message;
}

/// Outcome of one `SyncService.sync` call.
class SyncReport {
  const SyncReport({
    this.pushed = 0,
    this.pulled = 0,
    this.failed = 0,
    this.offline = false,
    this.error,
  });

  final int pushed;
  final int pulled;

  /// Rejected (permanently) in this run.
  final int failed;
  final bool offline;
  final ApiException? error;

  bool get ok => !offline && error == null;
}
