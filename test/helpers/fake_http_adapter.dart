import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';

typedef FakeHandler = Future<ResponseBody> Function(RequestOptions options);

/// In-process HTTP: the real Dio interceptor chain runs, no sockets.
class FakeHttpAdapter implements HttpClientAdapter {
  FakeHttpAdapter(this._handler);

  final FakeHandler _handler;
  final requests = <RequestOptions>[];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) {
    requests.add(options);
    return _handler(options);
  }

  @override
  void close({bool force = false}) {}
}

ResponseBody jsonBody(Object? body, int status) => ResponseBody.fromString(
  jsonEncode(body),
  status,
  headers: {
    Headers.contentTypeHeader: [Headers.jsonContentType],
  },
);

/// The API's error body: `{ statusCode, code, message }`.
ResponseBody apiError(int status, String code) =>
    jsonBody({'statusCode': status, 'code': code, 'message': code}, status);
