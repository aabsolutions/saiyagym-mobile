import 'package:drift/drift.dart';
import 'package:saiyagym_mobile/core/sync/stores.dart';
import 'package:saiyagym_mobile/core/sync/sync_writer.dart';
import 'package:saiyagym_mobile/features/routines/domain/routine.dart';

class RoutinesRepositoryImpl implements RoutinesRepository {
  RoutinesRepositoryImpl({required this._store, required this._writer});

  final RoutinesStore _store;
  final SyncWriter _writer;

  @override
  Stream<List<Routine>> watchActive() => _store
      .watchActive(orderBy: [(r) => OrderingTerm.asc(r.name)])
      .map(
        (docs) => [
          for (final doc in docs)
            if (doc.json['archivedAt'] == null) Routine.fromJson(doc.json),
        ],
      );

  @override
  Future<List<Routine>> active() async => [
    for (final doc in await _store.active())
      if (doc.json['archivedAt'] == null) Routine.fromJson(doc.json),
  ];

  @override
  Future<Routine?> find(String id) async {
    final doc = await _store.find(id);
    return doc == null || doc.isDeleted ? null : Routine.fromJson(doc.json);
  }

  @override
  Future<Routine> save(Routine routine) async {
    final doc = await _writer.save(_store, routine.id, routine.toJson());
    return Routine.fromJson(doc.json);
  }

  @override
  Future<void> delete(String id) => _writer.delete(_store, id);
}
