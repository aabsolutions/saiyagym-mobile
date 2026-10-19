import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:saiyagym_mobile/core/database/app_database.dart';
import 'package:saiyagym_mobile/core/sync/sync_collection.dart';
import 'package:saiyagym_mobile/core/sync/sync_state.dart';

enum QueueStatus { pending, failed }

/// The `sync_queue` table: pending local changes, one per document.
class SyncQueueDao {
  SyncQueueDao(this._db);

  final AppDatabase _db;

  $SyncQueueTable get _queue => _db.syncQueue;

  /// Adds or replaces the change of one document. Replacing keeps the
  /// entry's position (creation order) and resets retries: new content
  /// deserves a fresh chance even if the previous one failed.
  Future<void> enqueue({
    required SyncCollection collection,
    required String docId,
    required SyncOp op,
    required Map<String, Object?> payload,
    required DateTime docUpdatedAt,
    required DateTime now,
  }) async {
    final existing = await find(collection, docId);
    if (existing == null) {
      await _db
          .into(_queue)
          .insert(
            SyncQueueCompanion.insert(
              collection: collection.wire,
              docId: docId,
              op: op.name,
              payload: jsonEncode(payload),
              docUpdatedAt: docUpdatedAt,
              createdAt: now,
            ),
          );
      return;
    }
    await (_db.update(_queue)..where((q) => q.id.equals(existing.id))).write(
      SyncQueueCompanion(
        op: Value(op.name),
        payload: Value(jsonEncode(payload)),
        docUpdatedAt: Value(docUpdatedAt),
        attempts: const Value(0),
        status: Value(QueueStatus.pending.name),
        errorCode: const Value(null),
        errorMessage: const Value(null),
        nextAttemptAt: const Value(null),
      ),
    );
  }

  Future<SyncQueueEntry?> find(SyncCollection collection, String docId) =>
      (_db.select(_queue)..where(
            (q) => q.collection.equals(collection.wire) & q.docId.equals(docId),
          ))
          .getSingleOrNull();

  /// Pending changes whose backoff is over, oldest first.
  Future<List<SyncQueueEntry>> due({
    required DateTime now,
    required int limit,
  }) =>
      (_db.select(_queue)
            ..where(
              (q) =>
                  q.status.equals(QueueStatus.pending.name) &
                  (q.nextAttemptAt.isNull() |
                      q.nextAttemptAt.isSmallerOrEqualValue(now)),
            )
            ..orderBy([(q) => OrderingTerm.asc(q.id)])
            ..limit(limit))
          .get();

  /// Drops the entry if it still holds the version that was pushed (an
  /// edit made during the request must still be sent).
  Future<void> complete(SyncQueueEntry sent) =>
      (_db.delete(_queue)..where(
            (q) =>
                q.id.equals(sent.id) & q.docUpdatedAt.equals(sent.docUpdatedAt),
          ))
          .go();

  Future<void> remove(int id) =>
      (_db.delete(_queue)..where((q) => q.id.equals(id))).go();

  Future<void> retryLater(
    SyncQueueEntry sent, {
    required DateTime nextAttemptAt,
    required String code,
    String? message,
  }) => _updateIfUnchanged(
    sent,
    SyncQueueCompanion(
      attempts: Value(sent.attempts + 1),
      nextAttemptAt: Value(nextAttemptAt),
      errorCode: Value(code),
      errorMessage: Value(message),
    ),
  );

  /// Permanent rejection: stays until the user retries or discards it.
  Future<void> fail(
    SyncQueueEntry sent, {
    required String code,
    String? message,
  }) => _updateIfUnchanged(
    sent,
    SyncQueueCompanion(
      attempts: Value(sent.attempts + 1),
      status: Value(QueueStatus.failed.name),
      errorCode: Value(code),
      errorMessage: Value(message),
    ),
  );

  Future<void> _updateIfUnchanged(
    SyncQueueEntry sent,
    SyncQueueCompanion changes,
  ) =>
      (_db.update(_queue)..where(
            (q) =>
                q.id.equals(sent.id) & q.docUpdatedAt.equals(sent.docUpdatedAt),
          ))
          .write(changes);

  /// Back to pending, now (user pressed "retry").
  Future<void> resetFailed({int? id}) =>
      (_db.update(_queue)..where(
            (q) =>
                q.status.equals(QueueStatus.failed.name) &
                (id == null ? const Constant(true) : q.id.equals(id)),
          ))
          .write(
            SyncQueueCompanion(
              status: Value(QueueStatus.pending.name),
              attempts: const Value(0),
              nextAttemptAt: const Value(null),
            ),
          );

  Future<int> countAll() {
    final count = _queue.id.count();
    return (_db.selectOnly(
      _queue,
    )..addColumns([count])).map((row) => row.read(count) ?? 0).getSingle();
  }

  /// (pending, failed), live.
  Stream<({int pending, int failed})> watchCounts() {
    final count = _queue.id.count();
    final query = _db.selectOnly(_queue)
      ..addColumns([_queue.status, count])
      ..groupBy([_queue.status]);
    return query.watch().map((rows) {
      var pending = 0;
      var failed = 0;
      for (final row in rows) {
        final n = row.read(count) ?? 0;
        if (row.read(_queue.status) == QueueStatus.failed.name) {
          failed = n;
        } else {
          pending = n;
        }
      }
      return (pending: pending, failed: failed);
    });
  }

  Stream<List<FailedChange>> watchFailed() =>
      (_db.select(_queue)
            ..where((q) => q.status.equals(QueueStatus.failed.name))
            ..orderBy([(q) => OrderingTerm.asc(q.id)]))
          .watch()
          .map(
            (rows) => [
              for (final row in rows)
                FailedChange(
                  id: row.id,
                  collection: row.collection,
                  docId: row.docId,
                  code: row.errorCode,
                  message: row.errorMessage,
                ),
            ],
          );
}
