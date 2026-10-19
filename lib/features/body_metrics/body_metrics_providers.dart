import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:saiyagym_mobile/core/sync/sync_providers.dart';
import 'package:saiyagym_mobile/features/body_metrics/data/body_metrics_repository_impl.dart';
import 'package:saiyagym_mobile/features/body_metrics/domain/body_metric.dart';

part 'body_metrics_providers.g.dart';

@Riverpod(keepAlive: true)
BodyMetricsRepository bodyMetricsRepository(Ref ref) =>
    BodyMetricsRepositoryImpl(
      store: ref.watch(syncStoresProvider).bodyMetrics,
      writer: ref.watch(syncWriterProvider),
    );
