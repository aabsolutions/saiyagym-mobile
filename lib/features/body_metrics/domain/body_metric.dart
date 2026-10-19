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

enum MeasureKind { weight, percent, length }

/// Every measurement, with the API's accepted range (in kg / % / cm) — the
/// push would be rejected outside it.
enum BodyMeasure {
  weightKg(20, 400, MeasureKind.weight),
  bodyFatPercent(2, 75, MeasureKind.percent),
  waistCm(30, 250, MeasureKind.length),
  chestCm(40, 250, MeasureKind.length),
  hipsCm(40, 250, MeasureKind.length),
  armCm(10, 80, MeasureKind.length),
  thighCm(20, 120, MeasureKind.length),
  calfCm(15, 80, MeasureKind.length),
  neckCm(20, 80, MeasureKind.length);

  BodyMeasure(this.min, this.max, this.kind);

  final double min;
  final double max;
  final MeasureKind kind;

  bool accepts(double value) => value >= min && value <= max;

  double? of(BodyMetric metric) => switch (this) {
    weightKg => metric.weightKg,
    bodyFatPercent => metric.bodyFatPercent,
    waistCm => metric.waistCm,
    chestCm => metric.chestCm,
    hipsCm => metric.hipsCm,
    armCm => metric.armCm,
    thighCm => metric.thighCm,
    calfCm => metric.calfCm,
    neckCm => metric.neckCm,
  };

  BodyMetric put(BodyMetric metric, double? value) => switch (this) {
    weightKg => metric.copyWith(weightKg: value),
    bodyFatPercent => metric.copyWith(bodyFatPercent: value),
    waistCm => metric.copyWith(waistCm: value),
    chestCm => metric.copyWith(chestCm: value),
    hipsCm => metric.copyWith(hipsCm: value),
    armCm => metric.copyWith(armCm: value),
    thighCm => metric.copyWith(thighCm: value),
    calfCm => metric.copyWith(calfCm: value),
    neckCm => metric.copyWith(neckCm: value),
  };
}

extension BodyMetricValues on BodyMetric {
  bool get isEmpty => BodyMeasure.values.every((m) => m.of(this) == null);
}
