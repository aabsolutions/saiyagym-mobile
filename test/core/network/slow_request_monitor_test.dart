import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saiyagym_mobile/core/network/api_client.dart';
import 'package:saiyagym_mobile/core/network/slow_request_monitor.dart';

import '../../helpers/fake_http_adapter.dart';
import '../../helpers/in_memory_token_storage.dart';

void main() {
  // Real timers, short durations: the monitor is about wall-clock time.
  const threshold = Duration(milliseconds: 40);

  late SlowRequestMonitor monitor;
  late List<bool> changes;

  setUp(() {
    monitor = SlowRequestMonitor(threshold: threshold);
    changes = [];
    monitor.addListener(() => changes.add(monitor.value));
  });

  tearDown(() => monitor.dispose());

  Dio client(Duration latency, {int status = 200}) => buildApiClient(
    baseUrl: 'https://api.test/api/v1',
    storage: InMemoryTokenStorage(),
    languageCode: () => 'es',
    onSessionExpired: () {},
    monitor: monitor,
    adapter: FakeHttpAdapter((_) async {
      await Future<void>.delayed(latency);
      return status == 200
          ? jsonBody({'ok': true}, 200)
          : apiError(status, 'INTERNAL_ERROR');
    }),
  );

  test('a fast request never shows the notice', () async {
    await client(Duration.zero).get<void>('/health');

    expect(changes, isEmpty);
  });

  test('a slow request shows it, and hides it when done', () async {
    final request = client(const Duration(milliseconds: 120))
        .get<void>('/health');

    await Future<void>.delayed(const Duration(milliseconds: 80));
    expect(monitor.value, isTrue);

    await request;
    expect(monitor.value, isFalse);
    expect(changes, [true, false]);
  });

  test('a slow request that fails also hides it', () async {
    await expectLater(
      client(const Duration(milliseconds: 80), status: 500).get<void>('/x'),
      throwsA(isA<DioException>()),
    );

    expect(changes, [true, false]);
  });

  test('stays visible until the last slow request finishes', () async {
    final slow = client(const Duration(milliseconds: 150));
    final first = slow.get<void>('/a');
    final second = client(const Duration(milliseconds: 60)).get<void>('/b');

    await second;
    expect(monitor.value, isTrue, reason: '/a still running');

    await first;
    expect(monitor.value, isFalse);
  });
}
