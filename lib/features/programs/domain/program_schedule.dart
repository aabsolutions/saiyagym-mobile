// Port of the API's `programs/progression/program-schedule.ts`, used to know
// "today's routine" OFFLINE. Dates are LOCAL calendar dates (YYYY-MM-DD):
// "today" depends on the user's time zone.

class ScheduleDay {
  const ScheduleDay({
    required this.weekday,
    required this.routineId,
    this.label,
  });

  /// ISO weekday: 1 = Monday … 7 = Sunday.
  final int weekday;
  final String routineId;
  final String? label;
}

class ScheduleInput {
  const ScheduleInput({
    required this.startDate,
    required this.durationWeeks,
    required this.weeks,
    this.deloadWeeks = const [],
  });

  final String startDate;
  final int durationWeeks;
  final List<List<ScheduleDay>> weeks;
  final List<int> deloadWeeks;
}

sealed class ScheduleResult {
  const ScheduleResult();
}

final class NotStarted extends ScheduleResult {
  const NotStarted(this.startsInDays);
  final int startsInDays;
}

final class Finished extends ScheduleResult {
  const Finished();
}

final class RestDay extends ScheduleResult {
  const RestDay({required this.week, required this.isDeloadWeek});
  final int week;
  final bool isDeloadWeek;
}

final class TrainingDay extends ScheduleResult {
  const TrainingDay({
    required this.week,
    required this.isDeloadWeek,
    required this.day,
  });
  final int week;
  final bool isDeloadWeek;
  final ScheduleDay day;
}

/// Calendar date at UTC midnight: only for day arithmetic.
DateTime _parse(String date) => DateTime.parse('${date}T00:00:00Z');

/// The device's local calendar date.
String localDate(DateTime moment) {
  final local = moment.toLocal();
  return '${local.year.toString().padLeft(4, '0')}-'
      '${local.month.toString().padLeft(2, '0')}-'
      '${local.day.toString().padLeft(2, '0')}';
}

/// Week N covers days [7(N-1), 7N) from startDate; the routine is chosen by
/// weekday within the week.
ScheduleResult scheduleFor(ScheduleInput program, String date) {
  final elapsedDays = _parse(date).difference(_parse(program.startDate)).inDays;
  if (elapsedDays < 0) return NotStarted(-elapsedDays);

  final week = elapsedDays ~/ 7 + 1;
  if (week > program.durationWeeks) return const Finished();

  final isDeloadWeek = program.deloadWeeks.contains(week);
  final weekday = _parse(date).weekday; // DateTime.weekday is ISO already
  final days = week - 1 < program.weeks.length
      ? program.weeks[week - 1]
      : const <ScheduleDay>[];
  for (final day in days) {
    if (day.weekday == weekday) {
      return TrainingDay(week: week, isDeloadWeek: isDeloadWeek, day: day);
    }
  }
  return RestDay(week: week, isDeloadWeek: isDeloadWeek);
}

/// From a pulled program document (`weeks[].days[]`, `deload.weeks`).
ScheduleInput? scheduleInputFrom(Map<String, dynamic> program) {
  final startDate = program['startDate'];
  if (startDate is! String) return null;
  final weeks = [
    for (final week in (program['weeks'] as List? ?? const []))
      [
        for (final day in ((week as Map)['days'] as List? ?? const []))
          ScheduleDay(
            weekday: ((day as Map)['weekday'] as num).toInt(),
            routineId: day['routineId'] as String,
            label: day['label'] as String?,
          ),
      ],
  ];
  final deload = program['deload'];
  return ScheduleInput(
    startDate: startDate,
    durationWeeks: (program['durationWeeks'] as num?)?.toInt() ?? weeks.length,
    weeks: weeks,
    deloadWeeks: [
      if (deload is Map)
        for (final week in (deload['weeks'] as List? ?? const []))
          (week as num).toInt(),
    ],
  );
}
