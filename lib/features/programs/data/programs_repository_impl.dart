import 'package:drift/drift.dart';
import 'package:saiyagym_mobile/core/sync/stores.dart';
import 'package:saiyagym_mobile/features/programs/domain/program.dart';

class ProgramsRepositoryImpl implements ProgramsRepository {
  ProgramsRepositoryImpl(this._store);

  final ProgramsStore _store;

  @override
  Stream<List<Program>> watchAll() => _store
      .watchActive(orderBy: [(p) => OrderingTerm.asc(p.name)])
      .map((docs) => [for (final doc in docs) Program.fromJson(doc.json)]);
}
