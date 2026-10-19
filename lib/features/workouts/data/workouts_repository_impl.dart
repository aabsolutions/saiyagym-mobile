import 'package:drift/drift.dart';
import 'package:saiyagym_mobile/core/sync/stores.dart';
import 'package:saiyagym_mobile/core/sync/sync_writer.dart';
import 'package:saiyagym_mobile/features/workouts/domain/workout.dart';

class WorkoutsRepositoryImpl implements WorkoutsRepository {
  WorkoutsRepositoryImpl({required this._store, required this._writer});

  final WorkoutsStore _store;
  final SyncWriter _writer;

  @override
  Stream<List<Workout>> watchHistory() {
    final query = _store.db.select(_store.table)
      ..where((w) => w.deletedAt.isNull() & w.finishedAt.isNotNull())
      ..orderBy([(w) => OrderingTerm.desc(w.startedAt)]);
    return query.watch().map(
      (rows) => [
        for (final row in rows) Workout.fromJson(_store.toDoc(row).json),
      ],
    );
  }

  @override
  Stream<Workout?> watchInProgress() {
    final query = _store.db.select(_store.table)
      ..where((w) => w.deletedAt.isNull() & w.finishedAt.isNull())
      ..orderBy([(w) => OrderingTerm.desc(w.startedAt)])
      ..limit(1);
    return query.watchSingleOrNull().map(
      (row) => row == null ? null : Workout.fromJson(_store.toDoc(row).json),
    );
  }

  @override
  Future<Workout?> find(String id) async {
    final doc = await _store.find(id);
    return doc == null || doc.isDeleted ? null : Workout.fromJson(doc.json);
  }

  @override
  Future<Workout> save(Workout workout) async {
    final doc = await _writer.save(_store, workout.id, workout.toJson());
    return Workout.fromJson(doc.json);
  }

  @override
  Future<void> delete(String id) => _writer.delete(_store, id);
}
