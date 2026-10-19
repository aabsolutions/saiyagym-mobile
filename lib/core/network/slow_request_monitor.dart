import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// `true` while some request has been waiting longer than [threshold].
///
/// Render's free plan sleeps when idle: the first request after a while
/// takes up to ~50 s. Telling the user beats a frozen-looking spinner.
class SlowRequestMonitor extends ValueNotifier<bool> {
  SlowRequestMonitor({this.threshold = const Duration(seconds: 3)})
    : super(false);

  final Duration threshold;
  final _timers = <RequestOptions, Timer>{};
  final _slow = <RequestOptions>{};

  void started(RequestOptions request) {
    _timers.remove(request)?.cancel();
    _timers[request] = Timer(threshold, () {
      _slow.add(request);
      value = true;
    });
  }

  void finished(RequestOptions request) {
    _timers.remove(request)?.cancel();
    _slow.remove(request);
    if (_slow.isEmpty) value = false;
  }

  @override
  void dispose() {
    for (final timer in _timers.values) {
      timer.cancel();
    }
    super.dispose();
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
