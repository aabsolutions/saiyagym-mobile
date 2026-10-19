import 'package:saiyagym_mobile/core/sync/synced_store.dart';

// Read models of the API's /stats endpoints. Computed server-side (the Free
// 90-day window lives there), so the app only displays them.

/// Range the API used. [limitedByPlan]: older data exists but the plan
/// doesn't include it.
class StatsWindow {
  const StatsWindow({required this.to, this.from, this.limitedByPlan = false});

  factory StatsWindow.fromJson(Map<String, dynamic>? json) => StatsWindow(
    from: parseUtc(json?['from']),
    to: parseUtc(json?['to']) ?? DateTime.utc(1970),
    limitedByPlan: json?['limitedByPlan'] == true,
  );

  final DateTime? from;
  final DateTime to;
  final bool limitedByPlan;
}

class ExercisePoint {
  const ExercisePoint({
    required this.date,
    required this.maxWeightKg,
    required this.volumeKg,
    this.bestE1RM,
  });

  factory ExercisePoint.fromJson(Map<String, dynamic> json) => ExercisePoint(
    date: json['date'] as String,
    maxWeightKg: (json['maxWeightKg'] as num?)?.toDouble() ?? 0,
    volumeKg: (json['volumeKg'] as num?)?.toDouble() ?? 0,
    bestE1RM: (json['bestE1RM'] as num?)?.toDouble(),
  );

  /// Local `YYYY-MM-DD` of the session.
  final String date;
  final double maxWeightKg;
  final double volumeKg;
  final double? bestE1RM;
}

/// One point per session with the exercise, oldest first.
class ExerciseProgress {
  const ExerciseProgress({required this.points, required this.window});

  factory ExerciseProgress.fromJson(Map<String, dynamic> json) =>
      ExerciseProgress(
        points: [
          for (final p in json['points'] as List? ?? const [])
            ExercisePoint.fromJson(Map<String, dynamic>.from(p as Map)),
        ]..sort((a, b) => a.date.compareTo(b.date)),
        window: StatsWindow.fromJson(_map(json['window'])),
      );

  final List<ExercisePoint> points;
  final StatsWindow window;
}

class MuscleWeek {
  const MuscleWeek({
    required this.week,
    required this.muscle,
    required this.sets,
    required this.volumeKg,
  });

  factory MuscleWeek.fromJson(Map<String, dynamic> json) => MuscleWeek(
    week: json['week'] as String,
    muscle: json['muscle'] as String,
    sets: (json['sets'] as num?)?.toInt() ?? 0,
    volumeKg: (json['volumeKg'] as num?)?.toDouble() ?? 0,
  );

  /// Local `YYYY-MM-DD` the week starts on.
  final String week;
  final String muscle;
  final int sets;
  final double volumeKg;
}

class MuscleVolume {
  const MuscleVolume({required this.rows, required this.window});

  factory MuscleVolume.fromJson(Map<String, dynamic> json) => MuscleVolume(
    rows: [
      for (final r in json['rows'] as List? ?? const [])
        MuscleWeek.fromJson(Map<String, dynamic>.from(r as Map)),
    ],
    window: StatsWindow.fromJson(_map(json['window'])),
  );

  final List<MuscleWeek> rows;
  final StatsWindow window;

  /// Muscles by total sets, most trained first.
  List<String> get muscles {
    final totals = <String, int>{};
    for (final row in rows) {
      totals[row.muscle] = (totals[row.muscle] ?? 0) + row.sets;
    }
    return totals.keys.toList()
      ..sort((a, b) => totals[b]!.compareTo(totals[a]!));
  }

  /// Every week in range (oldest first), so empty weeks show as gaps.
  List<String> get weeks => {for (final r in rows) r.week}.toList()..sort();

  /// [muscle]'s row per week (null = not trained that week).
  List<MuscleWeek?> seriesOf(String muscle) {
    final byWeek = {
      for (final r in rows)
        if (r.muscle == muscle) r.week: r,
    };
    return [for (final week in weeks) byWeek[week]];
  }
}

enum PowerliftingMetric {
  e1rm('e1rm'),
  maxWeight('max_weight');

  PowerliftingMetric(this.api);

  final String api;
}

class PowerliftingWeek {
  const PowerliftingWeek({
    required this.weekStart,
    this.squat,
    this.bench,
    this.deadlift,
    this.total,
  });

  factory PowerliftingWeek.fromJson(Map<String, dynamic> json) =>
      PowerliftingWeek(
        weekStart: json['weekStart'] as String,
        squat: (json['squat'] as num?)?.toDouble(),
        bench: (json['bench'] as num?)?.toDouble(),
        deadlift: (json['deadlift'] as num?)?.toDouble(),
        total: (json['total'] as num?)?.toDouble(),
      );

  final String weekStart;
  final double? squat;
  final double? bench;
  final double? deadlift;

  /// Only when all three lifts have a value.
  final double? total;
}

class PowerliftingTotal {
  const PowerliftingTotal({
    required this.points,
    required this.window,
    this.bestTotal,
  });

  factory PowerliftingTotal.fromJson(Map<String, dynamic> json) =>
      PowerliftingTotal(
        points: [
          for (final p in json['points'] as List? ?? const [])
            PowerliftingWeek.fromJson(Map<String, dynamic>.from(p as Map)),
        ]..sort((a, b) => a.weekStart.compareTo(b.weekStart)),
        bestTotal: (json['bestTotal'] as num?)?.toDouble(),
        window: StatsWindow.fromJson(_map(json['window'])),
      );

  final List<PowerliftingWeek> points;
  final double? bestTotal;
  final StatsWindow window;
}

Map<String, dynamic>? _map(Object? value) =>
    value is Map ? Map<String, dynamic>.from(value) : null;

/// A local `YYYY-MM-DD` as a UTC midnight (chart x positions, formatting).
DateTime localDay(String date) => DateTime.parse('${date}T00:00:00Z');
