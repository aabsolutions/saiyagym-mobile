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
    @Default([]) List<ProgramWeek> weeks,
  }) = _Program;

  factory Program.fromJson(Map<String, dynamic> json) =>
      _$ProgramFromJson(json);
}

@freezed
abstract class ProgramWeek with _$ProgramWeek {
  const factory ProgramWeek({@Default([]) List<ProgramDay> days}) =
      _ProgramWeek;

  factory ProgramWeek.fromJson(Map<String, dynamic> json) =>
      _$ProgramWeekFromJson(json);
}

@freezed
abstract class ProgramDay with _$ProgramDay {
  const factory ProgramDay({
    /// ISO weekday 1–7.
    required int weekday,
    required String routineId,
    String? label,
  }) = _ProgramDay;

  factory ProgramDay.fromJson(Map<String, dynamic> json) =>
      _$ProgramDayFromJson(json);
}

abstract interface class ProgramsRepository {
  Stream<List<Program>> watchAll();

  /// Online only: programs are pull-only in sync. Free plans allow one
  /// active program (the API answers PLAN_LIMIT_REACHED).
  Future<Program> activate(String id, {String? startDate});

  Future<Program> deactivate(String id);
}
