import 'package:clock/clock.dart';
import 'package:dio/dio.dart';
import 'package:drift/drift.dart';
import 'package:saiyagym_mobile/core/database/app_database.dart';
import 'package:saiyagym_mobile/core/network/api_exception.dart';
import 'package:saiyagym_mobile/core/sync/stores.dart';
import 'package:saiyagym_mobile/core/sync/synced_store.dart';

/// Keeps a local copy of the global exercise catalog for offline use.
///
/// `/sync/pull` only returns the user's CUSTOM exercises; the global ones
/// come from `GET /exercises`, localized by `Accept-Language` and without an
/// incremental cursor. So: download it whole (≈120 items, 100 per page)
/// when missing, older than [maxAge] or in another language.
class ExerciseCatalogSync {
  ExerciseCatalogSync({
    required this._dio,
    required this._db,
    required this._store,
    required this._languageCode,
    this.maxAge = const Duration(hours: 24),
    this.pageSize = 100,
  });

  static const languageKey = 'catalog.language';
  static const syncedAtKey = 'catalog.syncedAt';

  final Dio _dio;
  final AppDatabase _db;
  final ExercisesStore _store;
  final String Function() _languageCode;
  final Duration maxAge;
  final int pageSize;

  Future<bool> isStale() async {
    final language = await _db.readMeta(languageKey);
    final syncedAt = parseUtc(await _db.readMeta(syncedAtKey));
    return language != _languageCode() ||
        syncedAt == null ||
        clock.now().toUtc().difference(syncedAt) > maxAge;
  }

  /// Returns how many global exercises were stored (0 when still fresh).
  Future<int> refreshIfStale() async {
    if (!await isStale()) return 0;
    final language = _languageCode();
    final items = await _fetchAll();
    final now = clock.now().toUtc();
    await _db.transaction(() async {
      final ids = <String>{};
      for (final item in items) {
        // Custom ones arrive raw (with their name map) through sync pull.
        if (item['isCustom'] == true || item['isGlobal'] != true) continue;
        final id = item['id'] as String;
        ids.add(id);
        await _store.put(item, id: id, updatedAt: now, deletedAt: null);
      }
      // Gone from the catalog: keep the row (old workouts still need the
      // name) but hide it.
      await (_db.update(_db.exercises)..where(
            (e) =>
                e.isGlobal.equals(true) &
                e.id.isNotIn(ids) &
                e.deletedAt.isNull(),
          ))
          .write(ExercisesCompanion(deletedAt: Value(now)));
      await _db.writeMeta(languageKey, language);
      await _db.writeMeta(syncedAtKey, now.toIso8601String());
    });
    return items.length;
  }

  Future<List<Map<String, dynamic>>> _fetchAll() async {
    final items = <Map<String, dynamic>>[];
    for (var page = 1; ; page++) {
      final body = await guardApi(() async {
        final response = await _dio.get<Map<String, dynamic>>(
          '/exercises',
          queryParameters: {'page': page, 'limit': pageSize},
        );
        return response.data!;
      });
      final pageItems = [
        for (final item in body['items'] as List)
          Map<String, dynamic>.from(item as Map),
      ];
      items.addAll(pageItems);
      final total = (body['meta'] as Map)['total'] as num;
      if (pageItems.isEmpty || items.length >= total) return items;
    }
  }
}
