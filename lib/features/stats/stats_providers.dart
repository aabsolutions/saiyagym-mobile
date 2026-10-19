import 'package:clock/clock.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:saiyagym_mobile/features/auth/presentation/controllers/session_controller.dart';
import 'package:saiyagym_mobile/features/records/data/records_service.dart';
import 'package:saiyagym_mobile/features/stats/domain/training_stats.dart';
import 'package:saiyagym_mobile/features/workouts/domain/workout.dart';
import 'package:saiyagym_mobile/features/workouts/workouts_providers.dart';

part 'stats_providers.g.dart';

class TodayStats {
  const TodayStats({required this.summary, this.lastRecord});

  final WeeklySummary summary;
  final ({Workout workout, List<WorkoutRecord> records})? lastRecord;
}

/// Streak, this week's totals and the latest PR — from local data, so the
/// Today screen works offline (same rules as `/stats/summary`).
@riverpod
Future<TodayStats> todayStats(Ref ref) async {
  final history = await ref.watch(workoutHistoryProvider.future);
  final firstDayOfWeek = ref.watch(
    currentUserProvider.select((u) => u?.preferences.firstDayOfWeek ?? 1),
  );
  return TodayStats(
    summary: weeklySummary(
      history,
      now: clock.now(),
      firstDayOfWeek: firstDayOfWeek,
    ),
    lastRecord: lastRecord(history),
  );
}
