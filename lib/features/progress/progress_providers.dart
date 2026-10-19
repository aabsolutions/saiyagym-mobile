import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:saiyagym_mobile/core/cache/json_cache.dart';
import 'package:saiyagym_mobile/core/database/database_provider.dart';
import 'package:saiyagym_mobile/core/network/api_client.dart';
import 'package:saiyagym_mobile/core/time/local_timezone.dart';
import 'package:saiyagym_mobile/features/body_metrics/body_metrics_providers.dart';
import 'package:saiyagym_mobile/features/body_metrics/domain/body_metric.dart';
import 'package:saiyagym_mobile/features/progress/data/progress_stats_repository.dart';
import 'package:saiyagym_mobile/features/progress/domain/progress_stats.dart';
import 'package:saiyagym_mobile/features/records/data/records_service.dart';
import 'package:saiyagym_mobile/features/records/domain/personal_records.dart';
import 'package:saiyagym_mobile/features/workouts/workouts_providers.dart';

part 'progress_providers.g.dart';

@Riverpod(keepAlive: true)
ProgressStatsRepository progressStatsRepository(Ref ref) =>
    ProgressStatsRepository(
      dio: ref.watch(apiClientProvider),
      cache: JsonCache(ref.watch(appDatabaseProvider)),
      timezone: () => ref.read(localTimezoneProvider.future),
    );

@riverpod
Future<Cached<ExerciseProgress>> exerciseProgress(Ref ref, String exerciseId) =>
    ref.watch(progressStatsRepositoryProvider).exercise(exerciseId);

@riverpod
Future<Cached<MuscleVolume>> muscleVolume(Ref ref) =>
    ref.watch(progressStatsRepositoryProvider).muscleVolume();

@riverpod
Future<Cached<PowerliftingTotal>> powerliftingTotal(
  Ref ref,
  PowerliftingMetric metric,
) => ref.watch(progressStatsRepositoryProvider).powerliftingTotal(metric);

/// Exercises the user has trained, most recent first (chart picker).
@riverpod
Future<List<String>> trainedExercises(Ref ref) async {
  final history = await ref.watch(workoutHistoryProvider.future);
  return {
    for (final workout in history)
      for (final exercise in workout.exercises) exercise.exerciseId,
  }.toList();
}

/// Personal records per exercise, from local history (works offline and
/// includes sessions not synced yet; same rules as the API).
@riverpod
Future<Map<String, ExerciseRecords>> personalRecords(Ref ref) async =>
    recordsByExercise(await ref.watch(workoutHistoryProvider.future));

/// Newest first. Local, so unsynced entries show up right away.
@riverpod
Stream<List<BodyMetric>> bodyMetrics(Ref ref) =>
    ref.watch(bodyMetricsRepositoryProvider).watchAll();
