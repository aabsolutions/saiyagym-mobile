import 'package:drift/drift.dart';
import 'package:saiyagym_mobile/core/database/app_database.dart';
import 'package:saiyagym_mobile/core/sync/stores.dart';
import 'package:saiyagym_mobile/core/sync/sync_writer.dart';
import 'package:saiyagym_mobile/features/workouts/domain/workout.dart';

class WorkoutsRepositoryImpl implements WorkoutsRepository {
  WorkoutsRepositoryImpl({required this._store, required this._writer});

  final WorkoutsStore _store;
  final SyncWriter _writer;

  SimpleSelectStatement<$WorkoutsTable, WorkoutRow> _history() =>
      _store.db.select(_store.table)
        ..where((w) => w.deletedAt.isNull() & w.finishedAt.isNotNull())
        ..orderBy([(w) => OrderingTerm.desc(w.startedAt)]);

  SimpleSelectStatement<$WorkoutsTable, WorkoutRow> _running() =>
      _store.db.select(_store.table)
        ..where((w) => w.deletedAt.isNull() & w.finishedAt.isNull())
        ..orderBy([(w) => OrderingTerm.desc(w.startedAt)])
        ..limit(1);

  Workout _decode(WorkoutRow row) => Workout.fromJson(_store.toDoc(row).json);

  @override
  Stream<List<Workout>> watchHistory() =>
      _history().watch().map((rows) => rows.map(_decode).toList());

  @override
  Stream<Workout?> watchInProgress() => _running().watchSingleOrNull().map(
    (row) => row == null ? null : _decode(row),
  );

  // One-shot reads use plain queries: a stream query built just to take
  // its first value sets up (and tears down) change tracking for nothing.
  @override
  Future<Workout?> inProgress() async {
    final row = await _running().getSingleOrNull();
    return row == null ? null : _decode(row);
  }

  @override
  Future<Workout?> find(String id) async {
    final doc = await _store.find(id);
    return doc == null || doc.isDeleted ? null : Workout.fromJson(doc.json);
  }

  @override
  Future<List<Workout>> finished() async =>
      (await _history().get()).map(_decode).toList();

  @override
  Future<List<WorkoutSet>?> lastPerformance(
    String exerciseId, {
    String? excludingWorkoutId,
  }) async {
    // Newest first; a scan is fine at personal-log scale.
    for (final workout in await finished()) {
      if (workout.id == excludingWorkoutId) continue;
      for (final exercise in workout.exercises) {
        if (exercise.exerciseId == exerciseId) return exercise.sets;
      }
    }
    return null;
  }

  @override
  Future<Workout> save(Workout workout) async {
    final doc = await _writer.save(_store, workout.id, workout.toJson());
    return Workout.fromJson(doc.json);
  }

  @override
  Future<void> delete(String id) => _writer.delete(_store, id);
}
