import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:saiyagym_mobile/core/database/app_database.dart';
import 'package:saiyagym_mobile/core/sync/sync_collection.dart';

/// A stored synced document.
class LocalDoc {
  const LocalDoc({
    required this.id,
    required this.updatedAt,
    required this.json,
    this.deletedAt,
  });

  final String id;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final Map<String, dynamic> json;

  bool get isDeleted => deletedAt != null;
}

/// Reads and writes one synced table. Knows nothing about the queue or the
/// API: `SyncWriter` (local edits) and `SyncService` (pull) drive it.
abstract class SyncedStore<T extends SyncedColumns, R extends DataClass> {
  SyncedStore(this.db);

  final AppDatabase db;

  SyncCollection get collection;
  TableInfo<T, R> get table;

  /// Row for [json] (typed columns extracted from it).
  Insertable<R> toRow(
    Map<String, dynamic> json, {
    required String id,
    required DateTime updatedAt,
    required DateTime? deletedAt,
  });

  LocalDoc toDoc(R row);

  Future<LocalDoc?> find(String id) async {
    final row = await (db.select(
      table,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
    return row == null ? null : toDoc(row);
  }

  /// The local version of a pulled doc (by id unless the collection has a
  /// natural key, see prefs).
  Future<LocalDoc?> findIncoming(Map<String, dynamic> doc) =>
      find(doc['id'] as String);

  Future<void> put(
    Map<String, dynamic> json, {
    required String id,
    required DateTime updatedAt,
    required DateTime? deletedAt,
  }) => db
      .into(table)
      .insertOnConflictUpdate(
        toRow(json, id: id, updatedAt: updatedAt, deletedAt: deletedAt),
      );

  Future<void> remove(String id) =>
      (db.delete(table)..where((t) => t.id.equals(id))).go();

  /// Live, not deleted documents.
  Stream<List<LocalDoc>> watchActive({
    List<OrderingTerm Function(T table)> orderBy = const [],
  }) {
    final query = db.select(table)
      ..where((t) => t.deletedAt.isNull())
      ..orderBy(orderBy);
    return query.watch().map((rows) => rows.map(toDoc).toList());
  }
}

Map<String, dynamic> decodeData(String data) =>
    jsonDecode(data) as Map<String, dynamic>;

DateTime? parseUtc(Object? value) =>
    value is String ? DateTime.tryParse(value)?.toUtc() : null;
