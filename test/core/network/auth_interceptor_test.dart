import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saiyagym_mobile/core/network/api_client.dart';
import 'package:saiyagym_mobile/core/network/api_exception.dart';
import 'package:saiyagym_mobile/core/network/interceptors.dart';
import 'package:saiyagym_mobile/core/storage/token_storage.dart';

import '../../helpers/fake_http_adapter.dart';
import '../../helpers/in_memory_token_storage.dart';

void main() {
  late InMemoryTokenStorage storage;
  late int expiredCount;

  setUp(() {
    storage = InMemoryTokenStorage(
      const AuthTokens(accessToken: 'old', refreshToken: 'r1'),
    );
    expiredCount = 0;
  });

  Dio client({
    required FakeHttpAdapter api,
    required FakeHttpAdapter refresh,
  }) => buildApiClient(
    baseUrl: 'https://api.test/api/v1',
    storage: storage,
    languageCode: () => 'en',
    onSessionExpired: () => expiredCount++,
    adapter: api,
    refreshAdapter: refresh,
  );

  /// Accepts only the refreshed access token.
  FakeHttpAdapter protectedApi() => FakeHttpAdapter(
    (options) async => options.headers['Authorization'] == 'Bearer new'
        ? jsonBody({'ok': true}, 200)
        : apiError(401, 'UNAUTHORIZED'),
  );

  FakeHttpAdapter refreshReturning(ResponseBody Function() body) =>
      FakeHttpAdapter((_) async {
        // Slow enough for the concurrent 401s to pile up behind it.
        await Future<void>.delayed(const Duration(milliseconds: 20));
        return body();
      });

  ResponseBody newPair() => jsonBody({
    'accessToken': 'new',
    'refreshToken': 'r2',
    'tokenType': 'Bearer',
    'expiresIn': 900,
    'refreshTokenExpiresAt': '2026-11-01T00:00:00.000Z',
  }, 200);

  test('concurrent 401s share ONE refresh and are all retried', () async {
    final api = protectedApi();
    final refresh = refreshReturning(newPair);
    final dio = client(api: api, refresh: refresh);

    final responses = await Future.wait([
      for (var i = 0; i < 3; i++) dio.get<Map<String, dynamic>>('/workouts'),
    ]);

    expect(responses.map((r) => r.data), everyElement({'ok': true}));
    expect(refresh.requests, hasLength(1));
    expect(refresh.requests.single.data, {'refreshToken': 'r1'});
    expect((await storage.read())!.refreshToken, 'r2');
    expect(api.requests, hasLength(6)); // 3 rejected + 3 retried
    expect(api.requests.first.headers['Accept-Language'], 'en');
    expect(expiredCount, 0);
  });

  test('a rejected refresh clears tokens and ends the session once', () async {
    final refresh = refreshReturning(
      () => apiError(401, 'REFRESH_TOKEN_REUSED'),
    );
    final dio = client(api: protectedApi(), refresh: refresh);

    final results = await Future.wait([
      for (var i = 0; i < 2; i++)
        dio
            .get<void>('/workouts')
            .then<Object?>((_) => null, onError: (Object e) => e),
    ]);

    for (final error in results) {
      expect(error, isA<DioException>());
      final mapped = (error! as DioException).error! as ApiException;
      expect(mapped.code, 'UNAUTHORIZED');
    }
    expect(refresh.requests, hasLength(1));
    expect(await storage.read(), isNull);
    expect(expiredCount, 1);
  });

  test('an unreachable refresh keeps the session (offline ≠ logout)', () async {
    final refresh = FakeHttpAdapter(
      (options) async => throw DioException(
        requestOptions: options,
        type: DioExceptionType.connectionError,
      ),
    );
    final dio = client(api: protectedApi(), refresh: refresh);

    await expectLater(dio.get<void>('/workouts'), throwsA(isA<DioException>()));

    expect((await storage.read())!.refreshToken, 'r1');
    expect(expiredCount, 0);
  });

  test('public endpoints never trigger a refresh', () async {
    final api = FakeHttpAdapter(
      (_) async => apiError(401, 'INVALID_CREDENTIALS'),
    );
    final refresh = refreshReturning(newPair);
    final dio = client(api: api, refresh: refresh);

    final error = await dio
        .post<void>(
          '/auth/login',
          options: Options(extra: AuthInterceptor.publicEndpoint),
        )
        .then<Object?>((_) => null, onError: (Object e) => e);

    expect(
      ((error! as DioException).error! as ApiException).code,
      'INVALID_CREDENTIALS',
    );
    expect(api.requests.single.headers.containsKey('Authorization'), isFalse);
    expect(refresh.requests, isEmpty);
  });
}
