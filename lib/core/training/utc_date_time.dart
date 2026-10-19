import 'package:json_annotation/json_annotation.dart';

/// Dates travel as UTC ISO 8601 (`…Z`) whatever zone the value was built
/// in; a local `DateTime` would otherwise serialize without an offset.
class UtcDateTime implements JsonConverter<DateTime, String> {
  const UtcDateTime();

  @override
  DateTime fromJson(String json) => DateTime.parse(json).toUtc();

  @override
  String toJson(DateTime object) => object.toUtc().toIso8601String();
}

class NullableUtcDateTime implements JsonConverter<DateTime?, String?> {
  const NullableUtcDateTime();

  @override
  DateTime? fromJson(String? json) =>
      json == null ? null : DateTime.parse(json).toUtc();

  @override
  String? toJson(DateTime? object) => object?.toUtc().toIso8601String();
}
