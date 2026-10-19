import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:saiyagym_mobile/core/training/utc_date_time.dart';

part 'body_metric.freezed.dart';
part 'body_metric.g.dart';

/// Measurements in kg / cm / %, always.
@freezed
abstract class BodyMetric with _$BodyMetric {
  const factory BodyMetric({
    required String id,
    @UtcDateTime() required DateTime measuredAt,
    double? weightKg,
    double? bodyFatPercent,
    double? waistCm,
    double? chestCm,
    double? hipsCm,
    double? armCm,
    double? thighCm,
    double? calfCm,
    double? neckCm,
    @Default('') String notes,
  }) = _BodyMetric;

  factory BodyMetric.fromJson(Map<String, dynamic> json) =>
      _$BodyMetricFromJson(json);
}

abstract interface class BodyMetricsRepository {
  /// Newest first. Works offline.
  Stream<List<BodyMetric>> watchAll();

  Future<BodyMetric> save(BodyMetric metric);

  Future<void> delete(String id);
}
