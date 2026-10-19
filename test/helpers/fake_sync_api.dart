import 'dart:convert';

import 'package:dio/dio.dart';

import 'fake_http_adapter.dart';

typedef PushHandler = List<Map<String, Object?>> Function(
  List<Map<String, dynamic>> changes,
);

/// In-memory stand-in for `/sync/push`, `/sync/pull` and `/exercises`
/// (plus [other] for the rest),
/// speaking the real wire format.
class FakeSyncApi {
  FakeSyncApi() {
    adapter = FakeHttpAdapter(_handle);
  }

  late final FakeHttpAdapter adapter;

  /// Default: every change applied.
  PushHandler onPush = applyAll;

  /// What the next pull returns, per collection.
  Map<String, List<Map<String, Object?>>> pullChanges = {};
  String serverTime = '2026-10-18T10:00:00.000Z';

  List<Map<String, Object?>> catalog = [];

  /// Any other endpoint (stats, photos…); 404 when null or it returns null.
  ResponseBody? Function(RequestOptions options)? other;

  /// Fails the whole request (status) or the transport (DioExceptionType).
  int? pushStatus;
  DioExceptionType? transportError;

  final pushes = <List<Map<String, dynamic>>>[];
  final pulls = <String?>[];
  final catalogPages = <int>[];

  static List<Map<String, Object?>> applyAll(
    List<Map<String, dynamic>> changes,
  ) => [
    for (final (index, change) in changes.indexed)
      {
        'index': index,
        'collection': change['collection'],
        'id': (change['doc'] as Map)['id'],
        'status': 'applied',
      },
  ];

  Future<ResponseBody> _handle(RequestOptions options) async {
    final transport = transportError;
    if (transport != null) {
      throw DioException(requestOptions: options, type: transport);
    }
    switch (options.path) {
      case '/sync/push':
        final status = pushStatus;
        if (status != null) return apiError(status, 'INTERNAL_ERROR');
        final body = options.data is String
            ? jsonDecode(options.data as String) as Map<String, dynamic>
            : options.data as Map<String, dynamic>;
        final changes = [
          for (final change in body['changes'] as List)
            Map<String, dynamic>.from(change as Map),
        ];
        pushes.add(changes);
        return jsonBody({
          'results': onPush(changes),
          'serverTime': serverTime,
        }, 200);
      case '/sync/pull':
        pulls.add(options.queryParameters['since'] as String?);
        final changes = pullChanges;
        pullChanges = {};
        return jsonBody({'changes': changes, 'serverTime': serverTime}, 200);
      case '/exercises':
        final page = options.queryParameters['page'] as int;
        final limit = options.queryParameters['limit'] as int;
        catalogPages.add(page);
        return jsonBody({
          'items': catalog.skip((page - 1) * limit).take(limit).toList(),
          'meta': {'page': page, 'limit': limit, 'total': catalog.length},
        }, 200);
    }
    return other?.call(options) ?? apiError(404, 'NOT_FOUND');
  }
}

/// A pushed change's `doc`.
Map<String, dynamic> docOf(Map<String, dynamic> change) =>
    Map<String, dynamic>.from(change['doc'] as Map);
