// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'body_metric.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BodyMetric _$BodyMetricFromJson(Map<String, dynamic> json) => _BodyMetric(
  id: json['id'] as String,
  measuredAt: const UtcDateTime().fromJson(json['measuredAt'] as String),
  weightKg: (json['weightKg'] as num?)?.toDouble(),
  bodyFatPercent: (json['bodyFatPercent'] as num?)?.toDouble(),
  waistCm: (json['waistCm'] as num?)?.toDouble(),
  chestCm: (json['chestCm'] as num?)?.toDouble(),
  hipsCm: (json['hipsCm'] as num?)?.toDouble(),
  armCm: (json['armCm'] as num?)?.toDouble(),
  thighCm: (json['thighCm'] as num?)?.toDouble(),
  calfCm: (json['calfCm'] as num?)?.toDouble(),
  neckCm: (json['neckCm'] as num?)?.toDouble(),
  notes: json['notes'] as String? ?? '',
);

Map<String, dynamic> _$BodyMetricToJson(_BodyMetric instance) =>
    <String, dynamic>{
      'id': instance.id,
      'measuredAt': const UtcDateTime().toJson(instance.measuredAt),
      'weightKg': instance.weightKg,
      'bodyFatPercent': instance.bodyFatPercent,
      'waistCm': instance.waistCm,
      'chestCm': instance.chestCm,
      'hipsCm': instance.hipsCm,
      'armCm': instance.armCm,
      'thighCm': instance.thighCm,
      'calfCm': instance.calfCm,
      'neckCm': instance.neckCm,
      'notes': instance.notes,
    };
