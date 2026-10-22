import 'package:dio/dio.dart';
import 'package:saiyagym_mobile/core/cache/json_cache.dart';
import 'package:saiyagym_mobile/core/network/api_exception.dart';
import 'package:saiyagym_mobile/features/sounds/domain/rest_sound.dart';
import 'package:saiyagym_mobile/features/sounds/domain/sound_repository.dart';

/// `GET /sounds`, cached per language in `app_meta` (names come localized).
class SoundsApi implements SoundRepository {
  SoundsApi({
    required this._dio,
    required this._cache,
    required this._languageCode,
  });

  final Dio _dio;
  final JsonCache _cache;
  final String Function() _languageCode;

  @override
  Future<Cached<List<RestSound>>> list() async =>
      (await _cache.fetch(
        'sounds.${_languageCode()}',
        () => guardApi(() async {
          final response = await _dio.get<Map<String, dynamic>>('/sounds');
          return response.data!;
        }),
      )).map(
        (body) => [
          for (final item in body['items'] as List)
            RestSound.fromJson(Map<String, dynamic>.from(item as Map)),
        ],
      );
}
