import 'package:dio/dio.dart';
import 'package:saiyagym_mobile/core/cache/json_cache.dart';
import 'package:saiyagym_mobile/core/network/api_exception.dart';
import 'package:saiyagym_mobile/features/guides/domain/exercise_guide.dart';

/// `GET /guides` (cached per language in `app_meta`: captions come
/// localized) and `POST /guides/resolve` (online only).
class GuidesApi {
  GuidesApi({
    required this._dio,
    required this._cache,
    required this._languageCode,
  });

  final Dio _dio;
  final JsonCache _cache;
  final String Function() _languageCode;

  String get _key => 'guides.${_languageCode()}';

  /// Fresh answer, or the last stored one when the API can't be reached
  /// (rethrows when there is none).
  Future<Cached<GuideAccess>> fetch() async => (await _cache.fetch(
    _key,
    () => guardApi(() async {
      final response = await _dio.get<Map<String, dynamic>>('/guides');
      return response.data!;
    }),
  )).map(GuideAccess.fromJson);

  /// The last stored answer, never the network. `null` = never fetched (or
  /// wiped by a logout).
  Future<Cached<GuideAccess>?> cached() async =>
      (await _cache.read(_key))?.map(GuideAccess.fromJson);

  /// A session without a routine: the API also unlocks its first N guided
  /// exercises, in the order given.
  Future<GuideAccess> resolve(List<String> exerciseIds) => guardApi(() async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/guides/resolve',
      data: {'exerciseIds': exerciseIds},
    );
    return GuideAccess.fromJson(response.data!);
  });
}
