import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;

import 'package:clock/clock.dart';
import 'package:dio/dio.dart';
import 'package:drift/drift.dart' show DataClass;
import 'package:flutter/foundation.dart';
import 'package:saiyagym_mobile/core/database/app_database.dart';
import 'package:saiyagym_mobile/core/network/api_exception.dart';
import 'package:saiyagym_mobile/core/sync/exercise_catalog_sync.dart';
import 'package:saiyagym_mobile/core/sync/stores.dart';
import 'package:saiyagym_mobile/core/sync/sync_collection.dart';
import 'package:saiyagym_mobile/core/sync/sync_queue.dart';
import 'package:saiyagym_mobile/core/sync/sync_state.dart';
import 'package:saiyagym_mobile/core/sync/synced_store.dart';

/// Push the queue, then pull everything changed since the last cursor.
///
/// Conflicts are last-write-wins per document on `updatedAt` (client clock),
/// the same rule the API applies. Deletions travel as `deletedAt`.
class SyncService implements SyncScheduler {
  SyncService({
    required this._dio,
    required this._db,
    required this._stores,
    required this._queue,
    this._catalog,
    this.batchSize = 100,
    this.baseBackoff = const Duration(seconds: 30),
    this.maxBackoff = const Duration(hours: 1),
    this.debounce = const Duration(seconds: 2),
    double Function()? jitter,
  }) : _jitter = jitter ?? math.Random().nextDouble;

  static const cursorKey = 'sync.cursor';

  /// Retrying can fix these; anything else is permanent (validation, plan
  /// limits, unknown references, …) and needs the user.
  static const Set<String> transientCodes = {
    'CONFLICT',
    'INTERNAL_ERROR',
    'SERVICE_UNAVAILABLE',
    'TOO_MANY_REQUESTS',
  };

  final Dio _dio;
  final AppDatabase _db;
  final SyncStores _stores;
  final SyncQueueDao _queue;
  final ExerciseCatalogSync? _catalog;
  final double Function() _jitter;

  final int batchSize;
  final Duration baseBackoff;
  final Duration maxBackoff;

  /// Local edits come in bursts (one per set): sync once they settle.
  final Duration debounce;

  final ValueNotifier<SyncState> _state = ValueNotifier(const SyncState());
  ValueListenable<SyncState> get state => _state;

  StreamSubscription<({int pending, int failed})>? _counts;
  Future<SyncReport>? _running;
  bool _runAgain = false;
  Timer? _debounceTimer;
  bool _disposed = false;

  /// Keeps pending/failed counts live (call once the user is signed in).
  void start() {
    _counts ??= _queue.watchCounts().listen(
      (counts) => _update(
        _state.value.copyWith(pending: counts.pending, failed: counts.failed),
      ),
    );
  }

  Future<void> stop() async {
    _debounceTimer?.cancel();
    await _counts?.cancel();
    _counts = null;
    _update(const SyncState());
  }

  @override
  void requestSync(SyncReason reason) {
    if (reason != SyncReason.localChange) {
      // Never synchronously: triggers fire from listeners during builds,
      // and the first state update would land mid-build.
      scheduleMicrotask(() => unawaited(sync(reason: reason)));
      return;
    }
    _debounceTimer?.cancel();
    _debounceTimer = Timer(debounce, () => unawaited(sync(reason: reason)));
  }

  /// Single-flight: a call while running schedules ONE more run afterwards
  /// (changes made meanwhile must not wait for the next trigger).
  Future<SyncReport> sync({SyncReason reason = SyncReason.manual}) {
    final running = _running;
    if (running != null) {
      _runAgain = true;
      return running;
    }
    return _running = _loop().whenComplete(() => _running = null);
  }

  Future<SyncReport> _loop() async {
    SyncReport report;
    do {
      _runAgain = false;
      report = await _runOnce();
    } while (_runAgain && report.ok && !_disposed);
    return report;
  }

  Future<SyncReport> _runOnce() async {
    _update(_state.value.copyWith(syncing: true));
    var pushed = 0;
    var failed = 0;
    var pulled = 0;
    try {
      final push = await _push();
      pushed = push.pushed;
      failed = push.failed;
      if (push.offline) {
        return _finish(SyncReport(pushed: pushed, offline: true));
      }
      pulled = await _pull();
      await _catalog?.refreshIfStale();
      _update(
        _state.value.copyWith(
          offline: false,
          lastError: () => null,
          lastSyncedAt: clock.now().toUtc(),
        ),
      );
      return _finish(
        SyncReport(pushed: pushed, pulled: pulled, failed: failed),
      );
    } on ApiException catch (error) {
      if (error.isConnectivity) {
        return _finish(SyncReport(pushed: pushed, offline: true));
      }
      _update(_state.value.copyWith(offline: false, lastError: () => error));
      return _finish(
        SyncReport(
          pushed: pushed,
          pulled: pulled,
          failed: failed,
          error: error,
        ),
      );
    }
  }

  SyncReport _finish(SyncReport report) {
    _update(
      _state.value.copyWith(
        syncing: false,
        offline: report.offline ? true : null,
      ),
    );
    return report;
  }

  // ===== push =====

  Future<({int pushed, int failed, bool offline})> _push() async {
    var pushed = 0;
    var failed = 0;
    while (true) {
      final now = clock.now().toUtc();
      final batch = await _queue.due(now: now, limit: batchSize);
      if (batch.isEmpty) break;

      final List<Map<String, dynamic>> results;
      try {
        results = await _postPush(batch);
      } on ApiException catch (error) {
        if (error.isConnectivity) {
          // Offline isn't the changes' fault: don't burn their attempts.
          return (pushed: pushed, failed: failed, offline: true);
        }
        if (error.code != ApiException.unauthorized) {
          for (final entry in batch) {
            await _retryLater(entry, error.code, error.message, now);
          }
        }
        rethrow;
      }

      for (final result in results) {
        final index = (result['index'] as num).toInt();
        if (index < 0 || index >= batch.length) continue;
        final entry = batch[index];
        switch (result['status']) {
          case 'applied':
            await _adoptServerId(entry, result['id']);
            await _queue.complete(entry);
            pushed++;
          case 'ignored_older':
            // The server has a newer version; the pull below brings it.
            await _queue.complete(entry);
          default:
            final error = result['error'] is Map
                ? Map<String, dynamic>.from(result['error'] as Map)
                : const <String, dynamic>{};
            final code = error['code'] as String? ?? ApiException.unknown;
            final message = error['message'] as String?;
            if (transientCodes.contains(code)) {
              await _retryLater(entry, code, message, now);
            } else {
              await _queue.fail(entry, code: code, message: message);
              failed++;
            }
        }
      }
      // Smaller than a full batch: nothing else is due.
      if (batch.length < batchSize) break;
    }
    return (pushed: pushed, failed: failed, offline: false);
  }

  Future<List<Map<String, dynamic>>> _postPush(List<SyncQueueEntry> batch) =>
      guardApi(() async {
        final response = await _dio.post<Map<String, dynamic>>(
          '/sync/push',
          data: {
            'changes': [
              for (final entry in batch)
                {
                  'collection': entry.collection,
                  'op': entry.op,
                  'doc': jsonDecode(entry.payload),
                },
            ],
          },
        );
        return [
          for (final result in response.data!['results'] as List)
            Map<String, dynamic>.from(result as Map),
        ];
      });

  /// Exponential backoff with jitter: base · 2^attempts, capped.
  Future<void> _retryLater(
    SyncQueueEntry entry,
    String code,
    String? message,
    DateTime now,
  ) {
    final exponent = math.min(entry.attempts, 16);
    final raw = baseBackoff * math.pow(2, exponent).toDouble();
    final capped = raw > maxBackoff ? maxBackoff : raw;
    // ±20 % so many devices don't retry in lockstep after an outage.
    final factor = 0.8 + 0.4 * _jitter();
    return _queue.retryLater(
      entry,
      code: code,
      message: message,
      nextAttemptAt: now.add(capped * factor),
    );
  }

  /// Prefs are keyed by exercise on the server: it may answer with the id
  /// of the document it already had.
  Future<void> _adoptServerId(SyncQueueEntry entry, Object? serverId) async {
    if (serverId is! String || serverId == entry.docId) return;
    if (entry.collection == SyncCollection.userExercisePrefs.wire) {
      await _stores.exercisePrefs.adoptServerId(entry.docId, serverId);
    }
  }

  // ===== pull =====

  Future<int> _pull() async {
    final since = await _db.readMeta(cursorKey);
    final body = await guardApi(() async {
      final response = await _dio.get<Map<String, dynamic>>(
        '/sync/pull',
        queryParameters: {'since': ?since},
      );
      return response.data!;
    });
    final changes = Map<String, dynamic>.from(body['changes'] as Map);
    var applied = 0;
    await _db.transaction(() async {
      for (final MapEntry(:key, :value) in changes.entries) {
        final collection = SyncCollection.fromWire(key);
        if (collection == null || value is! List) continue; // newer API
        final store = _stores.of(collection);
        for (final doc in value) {
          if (doc is! Map) continue;
          if (await _applyIncoming(store, Map<String, dynamic>.from(doc))) {
            applied++;
          }
        }
      }
      // Only once everything is stored: a crash re-pulls the same window.
      await _db.writeMeta(cursorKey, body['serverTime'] as String);
    });
    return applied;
  }

  /// Last write wins: keep the local version only if it is newer.
  Future<bool> _applyIncoming(
    SyncedStore<SyncedColumns, DataClass> store,
    Map<String, dynamic> doc,
  ) async {
    final id = doc['id'] as String?;
    final incoming = parseUtc(doc['updatedAt']);
    if (id == null || incoming == null) return false;

    final local = await store.findIncoming(doc);
    if (local != null && local.updatedAt.isAfter(incoming)) {
      return false; // ours is newer and still queued: the server will take it
    }
    if (local != null && local.id != id) await store.remove(local.id);
    await store.put(
      doc,
      id: id,
      updatedAt: incoming,
      deletedAt: parseUtc(doc['deletedAt']),
    );
    // An older (or identical) local change is superseded: don't push it.
    final pending = await _queue.find(store.collection, local?.id ?? id);
    if (pending != null) await _queue.remove(pending.id);
    return true;
  }

  // ===== user actions on failed changes =====

  Future<void> retryFailed({int? id}) async {
    await _queue.resetFailed(id: id);
    requestSync(SyncReason.manual);
  }

  /// Drops a rejected change and restores the server's version: the local
  /// row goes and the cursor resets, so the next pull brings it back (if it
  /// ever existed there).
  Future<void> discard(FailedChange entry) async {
    final collection = SyncCollection.fromWire(entry.collection);
    await _db.transaction(() async {
      await _queue.remove(entry.id);
      if (collection != null) await _stores.of(collection).remove(entry.docId);
      await _db.deleteMeta(cursorKey);
    });
    requestSync(SyncReason.manual);
  }

  void _update(SyncState next) {
    if (!_disposed) _state.value = next;
  }

  Future<void> dispose() async {
    _disposed = true;
    await stop();
    _state.dispose();
  }
}
