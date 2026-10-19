import 'package:clock/clock.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saiyagym_mobile/core/cache/json_cache.dart';
import 'package:saiyagym_mobile/core/database/app_database.dart';
import 'package:saiyagym_mobile/core/network/api_client.dart';
import 'package:saiyagym_mobile/core/network/api_exception.dart';
import 'package:saiyagym_mobile/core/storage/token_storage.dart';
import 'package:saiyagym_mobile/features/progress/data/progress_stats_repository.dart';
import 'package:saiyagym_mobile/features/progress/domain/progress_stats.dart';

import '../../helpers/fake_http_adapter.dart';
import '../../helpers/in_memory_token_storage.dart';
import '../../helpers/test_infra.dart';

const Map<String, Object?> _window = {
  'from': '2026-07-21T00:00:00.000Z',
  'to': '2026-10-19T10:00:00.000Z',
  'limitedByPlan': true,
};

void main() {
  late AppDatabase db;
  late FakeHttpAdapter api;
  late ResponseBody Function(RequestOptions options) respond;
  late ProgressStatsRepository repository;

  setUp(() {
    db = testDatabase();
    respond = (_) => apiError(404, 'NOT_FOUND');
    api = FakeHttpAdapter((options) async => respond(options));
    repository = ProgressStatsRepository(
      dio: buildApiClient(
        baseUrl: 'https://api.test',
        storage: InMemoryTokenStorage(
          const AuthTokens(accessToken: 'a', refreshToken: 'r'),
        ),
        languageCode: () => 'es',
        onSessionExpired: () {},
        adapter: api,
      ),
      cache: JsonCache(db),
      timezone: () async => 'Europe/Madrid',
    );
  });

  final exerciseBody = {
    'exerciseId': 'ex-squat',
    'points': [
      {
        'date': '2026-10-15',
        'workoutId': 'w2',
        'maxWeightKg': 110,
        'volumeKg': 1650,
        'bestE1RM': 128.3,
      },
      {
        'date': '2026-10-08',
        'workoutId': 'w1',
        'maxWeightKg': 100,
        'volumeKg': 1500,
        'bestE1RM': null,
      },
    ],
    'window': _window,
  };

  test("asks with the device's timezone and parses oldest first", () async {
    respond = (_) => jsonBody(exerciseBody, 200);

    final result = await repository.exercise('ex-squat');

    final request = api.requests.single;
    expect(request.path, '/stats/exercise/ex-squat');
    expect(request.queryParameters['tz'], 'Europe/Madrid');
    expect(result.fromCache, isFalse);
    expect(
      [for (final p in result.data.points) p.date],
      ['2026-10-08', '2026-10-15'],
    );
    expect(result.data.points.first.bestE1RM, isNull);
    expect(result.data.window.limitedByPlan, isTrue);
  });

  test('offline: the last answer, with the date it was fetched', () async {
    respond = (_) => jsonBody(exerciseBody, 200);
    final fetchedAt = DateTime.utc(2026, 10, 18, 9, 30);
    await withClock(
      Clock.fixed(fetchedAt),
      () => repository.exercise('ex-squat'),
    );

    respond = (options) => throw DioException(
      requestOptions: options,
      type: DioExceptionType.connectionError,
    );
    final result = await repository.exercise('ex-squat');

    expect(result.fromCache, isTrue);
    expect(result.error!.code, ApiException.networkError);
    expect(result.fetchedAt, fetchedAt);
    expect(result.data.points, hasLength(2));
  });

  test('offline without a local copy: the error goes up', () async {
    respond = (options) => throw DioException(
      requestOptions: options,
      type: DioExceptionType.connectionError,
    );

    await expectLater(repository.muscleVolume(), throwsA(isA<ApiException>()));
  });

  test('each powerlifting metric is cached on its own', () async {
    respond = (options) => jsonBody({
      'metric': options.queryParameters['metric'],
      'points': [
        {
          'weekStart': '2026-10-12',
          'squat': 140,
          'bench': 100,
          'deadlift': 180,
          'total': options.queryParameters['metric'] == 'e1rm' ? 420 : 400,
        },
      ],
      'bestTotal': 420,
      'window': _window,
    }, 200);
    await repository.powerliftingTotal(PowerliftingMetric.e1rm);
    await repository.powerliftingTotal(PowerliftingMetric.maxWeight);

    respond = (_) => apiError(503, 'SERVICE_UNAVAILABLE');
    final e1rm = await repository.powerliftingTotal(PowerliftingMetric.e1rm);
    final max = await repository.powerliftingTotal(
      PowerliftingMetric.maxWeight,
    );

    expect(e1rm.data.points.single.total, 420);
    expect(max.data.points.single.total, 400);
    expect(max.fromCache, isTrue);
  });

  test('muscle volume: muscles by sets, weeks with gaps', () {
    final volume = MuscleVolume.fromJson({
      'rows': [
        {'week': '2026-10-05', 'muscle': 'chest', 'sets': 10, 'volumeKg': 5000},
        {'week': '2026-10-05', 'muscle': 'quads', 'sets': 12, 'volumeKg': 9000},
        {'week': '2026-10-12', 'muscle': 'quads', 'sets': 14, 'volumeKg': 9900},
      ],
      'window': _window,
    });

    expect(volume.muscles, ['quads', 'chest']);
    expect(volume.weeks, ['2026-10-05', '2026-10-12']);
    expect([for (final row in volume.seriesOf('chest')) row?.sets], [10, null]);
    expect(localDay('2026-10-12'), DateTime.utc(2026, 10, 12));
  });
}
