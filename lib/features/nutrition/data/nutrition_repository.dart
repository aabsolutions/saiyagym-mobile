import 'package:dio/dio.dart';
import 'package:saiyagym_mobile/core/cache/json_cache.dart';
import 'package:saiyagym_mobile/core/network/api_exception.dart';
import 'package:saiyagym_mobile/features/nutrition/domain/nutrition_catalog.dart';

/// The nutrition base, downloaded whole and kept in `app_meta` per language
/// (it comes localized): offline, the last copy is shown with its date.
class NutritionRepository {
  NutritionRepository({
    required this._dio,
    required this._cache,
    required this._languageCode,
    this.pageSize = 100,
  });

  final Dio _dio;
  final JsonCache _cache;
  final String Function() _languageCode;
  final int pageSize;

  Future<Cached<List<Food>>> foods() async =>
      (await _all('foods', '/nutrition/foods')).map(
        (body) => [
          for (final item in body['items'] as List)
            Food.fromJson(Map<String, dynamic>.from(item as Map)),
        ],
      );

  /// Free gets the sample only (`limitedByPlan`); the API decides.
  Future<Cached<MealSuggestions>> meals() async =>
      (await _all('meals', '/nutrition/meal-suggestions')).map(
        (body) => MealSuggestions(
          items: [
            for (final item in body['items'] as List)
              MealSuggestion.fromJson(Map<String, dynamic>.from(item as Map)),
          ],
          limitedByPlan: body['limitedByPlan'] == true,
          lockedCount: (body['lockedCount'] as num?)?.toInt() ?? 0,
        ),
      );

  Future<Cached<List<Guideline>>> guidelines() async =>
      (await _cache.fetch(
        'nutrition.guidelines.${_languageCode()}',
        () => guardApi(() async {
          final response = await _dio.get<Map<String, dynamic>>(
            '/nutrition/guidelines',
          );
          return response.data!;
        }),
      )).map(
        (body) => [
          for (final item in body['items'] as List)
            Guideline.fromJson(Map<String, dynamic>.from(item as Map)),
        ],
      );

  /// Every page merged into one `{items, limitedByPlan, lockedCount}`.
  Future<Cached<Map<String, dynamic>>> _all(String name, String path) =>
      _cache.fetch(
        'nutrition.$name.${_languageCode()}',
        () => guardApi(() async {
          final items = <Object?>[];
          var last = const <String, dynamic>{};
          for (var page = 1; ; page++) {
            final response = await _dio.get<Map<String, dynamic>>(
              path,
              queryParameters: {'page': page, 'limit': pageSize},
            );
            last = response.data!;
            final pageItems = last['items'] as List;
            items.addAll(pageItems);
            final total = ((last['meta'] as Map?)?['total'] as num?) ?? 0;
            if (pageItems.isEmpty || items.length >= total) break;
          }
          return {
            'items': items,
            'limitedByPlan': last['limitedByPlan'],
            'lockedCount': last['lockedCount'],
          };
        }),
      );
}
