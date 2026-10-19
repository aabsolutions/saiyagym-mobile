import 'package:saiyagym_mobile/features/live_workout/domain/live_session.dart';
import 'package:saiyagym_mobile/features/programs/domain/program_schedule.dart';
import 'package:saiyagym_mobile/features/records/data/records_service.dart';
import 'package:saiyagym_mobile/features/workouts/domain/workout.dart';

// Same rules as the API's `/stats/summary` (stats.service.ts), computed on
// local data so Today works offline: sessions bucketed by the LOCAL date of
// `startedAt`, weeks starting on the user's `firstDayOfWeek`.

DateTime _day(String date) => DateTime.parse('${date}T00:00:00Z');

String _date(DateTime utcMidnight) =>
    utcMidnight.toIso8601String().substring(0, 10);

String addDays(String date, int days) =>
    _date(_day(date).add(Duration(days: days)));

/// First day of the week containing [date] (ISO 1–7 [firstDayOfWeek]).
String weekStartOf(String date, int firstDayOfWeek) =>
    addDays(date, -((_day(date).weekday - firstDayOfWeek + 7) % 7));

/// Consecutive weeks with at least one session. The current week only
/// extends the streak: an empty current week doesn't break it yet.
int weeklyStreak({
  required Iterable<String> trainedDays,
  required String today,
  required int firstDayOfWeek,
}) {
  final weeks = {
    for (final day in trainedDays) weekStartOf(day, firstDayOfWeek),
  };
  final thisWeek = weekStartOf(today, firstDayOfWeek);
  var cursor = weeks.contains(thisWeek) ? thisWeek : addDays(thisWeek, -7);
  var streak = 0;
  while (weeks.contains(cursor)) {
    streak++;
    cursor = addDays(cursor, -7);
  }
  return streak;
}

class PeriodTotals {
  const PeriodTotals({
    required this.from,
    required this.sessions,
    required this.volumeKg,
    required this.workingSets,
    required this.duration,
  });

  final String from;
  final int sessions;
  final double volumeKg;
  final int workingSets;
  final Duration duration;
}

PeriodTotals periodTotals(Iterable<Workout> finished, String from, String to) {
  var sessions = 0;
  var volume = 0.0;
  var sets = 0;
  var duration = Duration.zero;
  for (final workout in finished) {
    final day = localDate(workout.startedAt);
    if (day.compareTo(from) < 0 || day.compareTo(to) > 0) continue;
    sessions++;
    volume += workout.volumeKg ?? workout.liveVolumeKg;
    sets += workout.completedWorkingSets;
    duration += workout.elapsed(workout.finishedAt ?? workout.startedAt);
  }
  return PeriodTotals(
    from: from,
    sessions: sessions,
    volumeKg: volume,
    workingSets: sets,
    duration: duration,
  );
}

class WeeklySummary {
  const WeeklySummary({required this.week, required this.streakWeeks});

  final PeriodTotals week;
  final int streakWeeks;
}

WeeklySummary weeklySummary(
  List<Workout> finished, {
  required DateTime now,
  required int firstDayOfWeek,
}) {
  final today = localDate(now);
  return WeeklySummary(
    week: periodTotals(finished, weekStartOf(today, firstDayOfWeek), today),
    streakWeeks: weeklyStreak(
      trainedDays: finished.map((w) => localDate(w.startedAt)),
      today: today,
      firstDayOfWeek: firstDayOfWeek,
    ),
  );
}

/// The most recent workout that broke a record, with its records.
/// [history] newest first; only the latest [lookBack] are checked.
({Workout workout, List<WorkoutRecord> records})? lastRecord(
  List<Workout> history, {
  int lookBack = 30,
}) {
  for (final workout in history.take(lookBack)) {
    final records = detectWorkoutRecords(workout, history);
    if (records.isNotEmpty) return (workout: workout, records: records);
  }
  return null;
}
