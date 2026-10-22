import 'package:dio/dio.dart';
import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saiyagym_mobile/core/cache/json_cache.dart';
import 'package:saiyagym_mobile/core/database/app_database.dart';
import 'package:saiyagym_mobile/core/network/api_client.dart';
import 'package:saiyagym_mobile/features/sounds/data/sounds_api.dart';
import 'package:saiyagym_mobile/features/sounds/domain/rest_sound.dart';

import '../../helpers/fake_http_adapter.dart';
import '../../helpers/in_memory_token_storage.dart';

const Map<String, Object> _body = {
  'items': [
    {
      'id': 'a',
      'slug': 'bell',
      'name': 'Campana',
      'access': 'free',
      'locked': false,
      'durationSec': 2.5,
      'wavUrl': 'https://res.cloudinary.com/x/video/upload/af_22050/p/k1.wav',
      'mp3Url': 'https://res.cloudinary.com/x/video/upload/p/k1.mp3',
    },
    {
      'id': 'b',
      'slug': 'gong',
      'name': 'Gong',
      'access': 'premium',
      'locked': true,
      'durationSec': 4,
      'wavUrl': null,
      'mp3Url': null,
    },
  ],
};

void main() {
  late AppDatabase database;
  late bool online;
  late SoundsApi api;

  setUp(() {
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
    database = AppDatabase(NativeDatabase.memory());
    online = true;
    final dio = buildApiClient(
      baseUrl: 'https://api.test/api/v1',
      storage: InMemoryTokenStorage(),
      languageCode: () => 'es',
      onSessionExpired: () {},
      adapter: FakeHttpAdapter((options) async {
        if (!online) {
          throw DioException(
            requestOptions: options,
            type: DioExceptionType.connectionError,
          );
        }
        return jsonBody(_body, 200);
      }),
    );
    api = SoundsApi(
      dio: dio,
      cache: JsonCache(database),
      languageCode: () => 'es',
    );
  });

  tearDown(() => database.close());

  test('parses the catalog; locked premium has no urls', () async {
    final sounds = (await api.list()).data;

    expect(sounds.map((s) => s.id), ['a', 'b']);
    expect(sounds[0].access, SoundAccess.free);
    expect(sounds[0].mp3Url, isNotNull);
    expect(sounds[1].locked, isTrue);
    expect(sounds[1].wavUrl, isNull);
  });

  test('offline: the last copy is served and flagged as cached', () async {
    await api.list();
    online = false;

    final cached = await api.list();

    expect(cached.fromCache, isTrue);
    expect(cached.data, hasLength(2));
  });
}
