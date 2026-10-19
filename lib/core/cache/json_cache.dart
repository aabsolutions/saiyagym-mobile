import 'dart:convert';

import 'package:clock/clock.dart';
import 'package:saiyagym_mobile/core/database/app_database.dart';
import 'package:saiyagym_mobile/core/network/api_exception.dart';
import 'package:saiyagym_mobile/core/sync/synced_store.dart';

/// A value plus when it was fetched from the API.
class Cached<T> {
  const Cached(this.data, {required this.fetchedAt, this.error});

  final T data;
  final DateTime fetchedAt;

  /// Why the API wasn't used (null = fresh answer).
  final ApiException? error;

  bool get fromCache => error != null;

  Cached<R> map<R>(R Function(T data) convert) =>
      Cached(convert(data), fetchedAt: fetchedAt, error: error);
}

/// Read-only API answers (stats) kept in `app_meta`: the last good answer
/// is shown, with its date, whenever the API can't be reached. Wiped on
/// logout with the rest of the local data.
class JsonCache {
  JsonCache(this._db);

  static const prefix = 'cache.';

  final AppDatabase _db;

  /// Calls [remote]; on ANY failure falls back to the last stored answer
  /// (rethrows when there is none).
  Future<Cached<Map<String, dynamic>>> fetch(
    String key,
    Future<Map<String, dynamic>> Function() remote,
  ) async {
    try {
      final body = await remote();
      final now = clock.now().toUtc();
      await _db.writeMeta(
        '$prefix$key',
        jsonEncode({'fetchedAt': now.toIso8601String(), 'body': body}),
      );
      return Cached(body, fetchedAt: now);
    } on ApiException catch (error) {
      final stored = await read(key);
      if (stored == null) rethrow;
      return Cached(stored.data, fetchedAt: stored.fetchedAt, error: error);
    }
  }

  Future<Cached<Map<String, dynamic>>?> read(String key) async {
    final raw = await _db.readMeta('$prefix$key');
    if (raw == null) return null;
    final json = jsonDecode(raw) as Map<String, dynamic>;
    return Cached(
      Map<String, dynamic>.from(json['body'] as Map),
      fetchedAt: parseUtc(json['fetchedAt'] as String?) ?? DateTime.utc(1970),
    );
  }
}
