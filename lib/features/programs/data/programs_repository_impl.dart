import 'package:dio/dio.dart';
import 'package:drift/drift.dart';
import 'package:saiyagym_mobile/core/network/api_exception.dart';
import 'package:saiyagym_mobile/core/sync/stores.dart';
import 'package:saiyagym_mobile/core/sync/synced_store.dart';
import 'package:saiyagym_mobile/features/programs/domain/program.dart';

class ProgramsRepositoryImpl implements ProgramsRepository {
  ProgramsRepositoryImpl(this._store, this._dio);

  final ProgramsStore _store;
  final Dio _dio;

  @override
  Stream<List<Program>> watchAll() => _store
      .watchActive(orderBy: [(p) => OrderingTerm.asc(p.name)])
      .map((docs) => [for (final doc in docs) Program.fromJson(doc.json)]);

  @override
  Future<Program> activate(String id, {String? startDate}) =>
      _post('/programs/$id/activate', {'startDate': ?startDate});

  @override
  Future<Program> deactivate(String id) =>
      _post('/programs/$id/deactivate', const {});

  /// The answer is the full ProgramDto: store it so the screen updates now
  /// instead of after the next pull (same version, the pull is a no-op).
  Future<Program> _post(String path, Map<String, Object> body) async {
    final json = await guardApi(() async {
      final response = await _dio.post<Map<String, dynamic>>(path, data: body);
      return response.data!;
    });
    await _store.put(
      json,
      id: json['id'] as String,
      updatedAt: parseUtc(json['updatedAt']) ?? DateTime.now().toUtc(),
      deletedAt: null,
    );
    return Program.fromJson(json);
  }
}
