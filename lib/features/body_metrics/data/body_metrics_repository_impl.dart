import 'package:drift/drift.dart';
import 'package:saiyagym_mobile/core/sync/stores.dart';
import 'package:saiyagym_mobile/core/sync/sync_writer.dart';
import 'package:saiyagym_mobile/features/body_metrics/domain/body_metric.dart';

class BodyMetricsRepositoryImpl implements BodyMetricsRepository {
  BodyMetricsRepositoryImpl({required this._store, required this._writer});

  final BodyMetricsStore _store;
  final SyncWriter _writer;

  @override
  Stream<List<BodyMetric>> watchAll() => _store
      .watchActive(orderBy: [(m) => OrderingTerm.desc(m.measuredAt)])
      .map((docs) => [for (final doc in docs) BodyMetric.fromJson(doc.json)]);

  @override
  Future<BodyMetric> save(BodyMetric metric) async {
    final doc = await _writer.save(_store, metric.id, metric.toJson());
    return BodyMetric.fromJson(doc.json);
  }

  @override
  Future<void> delete(String id) => _writer.delete(_store, id);
}
