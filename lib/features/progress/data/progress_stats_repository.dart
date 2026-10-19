import 'package:dio/dio.dart';
import 'package:saiyagym_mobile/core/cache/json_cache.dart';
import 'package:saiyagym_mobile/core/network/api_exception.dart';
import 'package:saiyagym_mobile/features/progress/domain/progress_stats.dart';

/// `/stats/*` with a local copy: offline (or with the server asleep) the
/// last answer is shown with its date. No `from`/`to`: the API applies the
/// plan's window itself.
class ProgressStatsRepository {
  ProgressStatsRepository({
    required this._dio,
    required this._cache,
    required this._timezone,
  });

  final Dio _dio;
  final JsonCache _cache;
  final Future<String> Function() _timezone;

  Future<Cached<ExerciseProgress>> exercise(String exerciseId) async =>
      (await _get(
        'stats.exercise.$exerciseId',
        '/stats/exercise/$exerciseId',
      )).map(ExerciseProgress.fromJson);

  Future<Cached<MuscleVolume>> muscleVolume() async => (await _get(
    'stats.muscleVolume',
    '/stats/muscle-volume',
  )).map(MuscleVolume.fromJson);

  Future<Cached<PowerliftingTotal>> powerliftingTotal(
    PowerliftingMetric metric,
  ) async => (await _get(
    'stats.powerlifting.${metric.api}',
    '/stats/powerlifting-total',
    {'metric': metric.api},
  )).map(PowerliftingTotal.fromJson);

  Future<Cached<Map<String, dynamic>>> _get(
    String key,
    String path, [
    Map<String, Object> query = const {},
  ]) async {
    final tz = await _timezone();
    return await _cache.fetch(
      key,
      () => guardApi(() async {
        final response = await _dio.get<Map<String, dynamic>>(
          path,
          queryParameters: {'tz': tz, ...query},
        );
        return response.data!;
      }),
    );
  }
}
