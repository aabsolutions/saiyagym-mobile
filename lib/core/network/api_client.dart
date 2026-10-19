import 'dart:async';

import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:saiyagym_mobile/core/config/app_config.dart';
import 'package:saiyagym_mobile/core/i18n/app_locales.dart';
import 'package:saiyagym_mobile/core/network/interceptors.dart';
import 'package:saiyagym_mobile/core/network/slow_request_monitor.dart';
import 'package:saiyagym_mobile/core/network/token_refresher.dart';
import 'package:saiyagym_mobile/core/storage/token_storage.dart';

part 'api_client.g.dart';

/// Builds the API client. Separate from the provider so tests can plug in
/// fake [adapter]s and assert on the real interceptor chain.
Dio buildApiClient({
  required String baseUrl,
  required TokenStorage storage,
  required String Function() languageCode,
  required void Function() onSessionExpired,
  SlowRequestMonitor? monitor,
  HttpClientAdapter? adapter,
  HttpClientAdapter? refreshAdapter,
}) {
  // Render's free plan cold-starts in up to ~50 s: be patient on receive.
  BaseOptions options() => BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 60),
    contentType: Headers.jsonContentType,
  );
  final language = AcceptLanguageInterceptor(languageCode);
  final slow = monitor == null ? null : SlowRequestInterceptor(monitor);

  final refreshDio = Dio(options())..interceptors.addAll([?slow, language]);
  if (refreshAdapter != null) refreshDio.httpClientAdapter = refreshAdapter;

  final dio = Dio(options());
  if (adapter != null) dio.httpClientAdapter = adapter;
  dio.interceptors.addAll([
    ?slow,
    language,
    AuthInterceptor(
      storage: storage,
      refresher: TokenRefresher(
        dio: refreshDio,
        storage: storage,
        onSessionExpired: onSessionExpired,
      ),
      retry: dio.fetch,
    ),
    // Must stay last: onError runs in insertion order.
    ErrorMappingInterceptor(),
  ]);
  return dio;
}

/// Current UI language for `Accept-Language`. A plain holder (not state):
/// the app updates it when the locale changes, requests read it lazily.
class RequestLanguage {
  String code = AppLocales.fallback.languageCode;
}

@Riverpod(keepAlive: true)
RequestLanguage requestLanguage(Ref ref) => RequestLanguage();

/// Emits when the API rejects the refresh token: the session is over.
/// Core can't depend on the auth feature, so it publishes instead of calling.
class SessionEvents {
  final _expired = StreamController<void>.broadcast();

  Stream<void> get expired => _expired.stream;

  void notifyExpired() => _expired.add(null);

  Future<void> dispose() => _expired.close();
}

@Riverpod(keepAlive: true)
SessionEvents sessionEvents(Ref ref) {
  final events = SessionEvents();
  ref.onDispose(events.dispose);
  return events;
}

@Riverpod(keepAlive: true)
SlowRequestMonitor slowRequestMonitor(Ref ref) {
  final monitor = SlowRequestMonitor();
  ref.onDispose(monitor.dispose);
  return monitor;
}

@Riverpod(keepAlive: true)
Dio apiClient(Ref ref) {
  final language = ref.watch(requestLanguageProvider);
  final events = ref.watch(sessionEventsProvider);
  final dio = buildApiClient(
    baseUrl: ref.watch(appConfigProvider).apiBaseUrl,
    storage: ref.watch(tokenStorageProvider),
    languageCode: () => language.code,
    onSessionExpired: events.notifyExpired,
    monitor: ref.watch(slowRequestMonitorProvider),
  );
  ref.onDispose(dio.close);
  return dio;
}
