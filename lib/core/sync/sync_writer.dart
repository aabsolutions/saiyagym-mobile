import 'package:clock/clock.dart';
import 'package:drift/drift.dart' show DataClass;
import 'package:saiyagym_mobile/core/database/app_database.dart';
import 'package:saiyagym_mobile/core/sync/push_codecs.dart';
import 'package:saiyagym_mobile/core/sync/sync_collection.dart';
import 'package:saiyagym_mobile/core/sync/sync_queue.dart';
import 'package:saiyagym_mobile/core/sync/synced_store.dart';

/// The ONLY way repositories write synced data: local row + queued change,
/// in one transaction (a crash can't leave one without the other).
class SyncWriter {
  SyncWriter(this._db, this._queue, {this._onChange});

  final AppDatabase _db;
  final SyncQueueDao _queue;

  /// Usually `SyncService.requestSync`, debounced there.
  final void Function()? _onChange;

  Future<LocalDoc> save(
    SyncedStore<SyncedColumns, DataClass> store,
    String id,
    Map<String, dynamic> json,
  ) => _write(store, id, json, SyncOp.upsert);

  /// Logical delete: the row stays with `deletedAt` so the deletion syncs.
  Future<LocalDoc?> delete(
    SyncedStore<SyncedColumns, DataClass> store,
    String id,
  ) async {
    final current = await store.find(id);
    if (current == null || current.isDeleted) return current;
    return await _write(store, id, current.json, SyncOp.delete);
  }

  Future<LocalDoc> _write(
    SyncedStore<SyncedColumns, DataClass> store,
    String id,
    Map<String, dynamic> json,
    SyncOp op,
  ) async {
    assert(store.collection.pushable, '${store.collection.wire} is pull-only');
    final doc = await _db.transaction(() async {
      final previous = await store.find(id);
      final now = utcMillisNow();
      final updatedAt = _nextVersion(previous?.updatedAt, now);
      final createdAt =
          parseUtc(previous?.json['createdAt']) ??
          parseUtc(json['createdAt']) ??
          updatedAt;
      final deletedAt = op == SyncOp.delete
          ? (previous?.deletedAt ?? updatedAt)
          : null;

      final stored = <String, dynamic>{
        ...json,
        'id': id,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
        'deletedAt': deletedAt?.toIso8601String(),
      };
      await store.put(
        stored,
        id: id,
        updatedAt: updatedAt,
        deletedAt: deletedAt,
      );
      await _queue.enqueue(
        collection: store.collection,
        docId: id,
        op: op,
        docUpdatedAt: updatedAt,
        now: now,
        payload: {
          'id': id,
          'updatedAt': updatedAt.toIso8601String(),
          if (op == SyncOp.delete)
            'deletedAt': deletedAt!.toIso8601String()
          else ...{
            'createdAt': createdAt.toIso8601String(),
            ...pushBody(store.collection, stored),
          },
        },
      );
      return LocalDoc(
        id: id,
        updatedAt: updatedAt,
        deletedAt: deletedAt,
        json: stored,
      );
    });
    _onChange?.call();
    return doc;
  }

  /// The server stores milliseconds (Mongo dates): versions must too, or a
  /// pulled copy of our own write would look older than the local one.
  static DateTime utcMillisNow() => DateTime.fromMillisecondsSinceEpoch(
    clock.now().millisecondsSinceEpoch,
    isUtc: true,
  );

  /// Strictly increasing per document even if the device clock goes back:
  /// an older `updatedAt` would make the server ignore the edit (LWW).
  static DateTime _nextVersion(DateTime? previous, DateTime now) =>
      previous != null && !now.isAfter(previous)
      ? previous.add(const Duration(milliseconds: 1))
      : now;
}
