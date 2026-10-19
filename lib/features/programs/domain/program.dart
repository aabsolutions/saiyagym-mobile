import 'package:freezed_annotation/freezed_annotation.dart';

part 'program.freezed.dart';
part 'program.g.dart';

enum ProgramStatus { draft, active, completed }

/// Read-only on mobile (programs are planned on the web / via the API).
@freezed
abstract class Program with _$Program {
  const factory Program({
    required String id,
    required String name,
    @JsonKey(unknownEnumValue: ProgramStatus.draft)
    @Default(ProgramStatus.draft)
    ProgramStatus status,
    @Default(0) int durationWeeks,

    /// Local `YYYY-MM-DD` (never a UTC instant).
    String? startDate,
    @Default('') String notes,
  }) = _Program;

  factory Program.fromJson(Map<String, dynamic> json) =>
      _$ProgramFromJson(json);
}

abstract interface class ProgramsRepository {
  Stream<List<Program>> watchAll();
}
