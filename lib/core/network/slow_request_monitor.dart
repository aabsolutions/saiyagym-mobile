import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// `true` while some request has been waiting longer than [threshold].
///
/// Render's free plan sleeps when idle: the first request after a while
/// takes up to ~50 s. Telling the user beats a frozen-looking spinner.
///
/// Wraps a [ValueNotifier] instead of extending it: Riverpod providers must
/// not expose a ChangeNotifier (riverpod_lint: unsupported_provider_value).
class SlowRequestMonitor implements ValueListenable<bool> {
  SlowRequestMonitor({this.threshold = const Duration(seconds: 3)});

  final Duration threshold;
  final ValueNotifier<bool> _state = ValueNotifier(false);
  final _timers = <RequestOptions, Timer>{};
  final _slow = <RequestOptions>{};

  @override
  bool get value => _state.value;

  @override
  void addListener(VoidCallback listener) => _state.addListener(listener);

  @override
  void removeListener(VoidCallback listener) => _state.removeListener(listener);

  void started(RequestOptions request) {
    _timers.remove(request)?.cancel();
    _timers[request] = Timer(threshold, () {
      _slow.add(request);
      _state.value = true;
    });
  }

  void finished(RequestOptions request) {
    _timers.remove(request)?.cancel();
    _slow.remove(request);
    if (_slow.isEmpty) _state.value = false;
  }

  void dispose() {
    for (final timer in _timers.values) {
      timer.cancel();
    }
    _state.dispose();
  }
}

/// First in the chain so it sees every request; a retry after a refresh is
/// timed as a new request.
class SlowRequestInterceptor extends Interceptor {
  SlowRequestInterceptor(this._monitor);

  final SlowRequestMonitor _monitor;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _monitor.started(options);
    handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    _monitor.finished(response.requestOptions);
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _monitor.finished(err.requestOptions);
    handler.next(err);
  }
}
