import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saiyagym_mobile/core/cache/json_cache.dart';
import 'package:saiyagym_mobile/core/database/app_database.dart';
import 'package:saiyagym_mobile/core/network/api_client.dart';
import 'package:saiyagym_mobile/features/guides/data/guide_files.dart';
import 'package:saiyagym_mobile/features/guides/data/guides_api.dart';
import 'package:saiyagym_mobile/features/guides/domain/exercise_guide.dart';

import '../../helpers/fake_http_adapter.dart';
import '../../helpers/in_memory_token_storage.dart';
import 'exercise_guide_test.dart' show guideJson;

void main() {
  late AppDatabase database;

  setUp(() {
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
    database = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() => database.close());

  group('GuidesApi', () {
    late bool online;
    late FakeHttpAdapter http;
    late GuidesApi api;

    setUp(() {
      online = true;
      http = FakeHttpAdapter((options) async {
        if (!online) {
          throw DioException(
            requestOptions: options,
            type: DioExceptionType.connectionError,
          );
        }
        return jsonBody({
          'guidesPerRoutine': 5,
          'items': [
            {
              'exerciseId': 'squat',
              'guides': [guideJson('g1')],
            },
          ],
          'lockedExerciseIds': ['bench'],
        }, 200);
      });
      api = GuidesApi(
        dio: buildApiClient(
          baseUrl: 'https://api.test/api/v1',
          storage: InMemoryTokenStorage(),
          languageCode: () => 'es',
          onSessionExpired: () {},
          adapter: http,
        ),
        cache: JsonCache(database),
        languageCode: () => 'es',
      );
    });

    test('GET /guides is stored and served offline with its date', () async {
      expect(await api.cached(), isNull);
      final fresh = await api.fetch();
      expect(fresh.fromCache, isFalse);
      expect(fresh.data.statusOf('squat'), isA<GuideUnlocked>());

      online = false;
      final offline = await api.fetch();
      expect(offline.fromCache, isTrue);
      expect(offline.data.statusOf('bench'), isA<GuideLocked>());
      expect((await api.cached())!.data.unlocked.keys, ['squat']);
    });

    test('resolve posts the session exercises in order', () async {
      await api.resolve(['b', 'a']);
      final request = http.requests.single;
      expect(request.method, 'POST');
      expect(request.path, endsWith('/guides/resolve'));
      expect(request.data, {
        'exerciseIds': ['b', 'a'],
      });
    });
  });

  group('GuideFiles', () {
    late Directory dir;
    late FakeHttpAdapter downloads;
    late bool online;
    late GuideFiles files;

    const gif = (
      id: 'g1',
      url: 'https://res.cloudinary.com/demo/image/upload/q_auto/p/g1.gif',
    );
    const png = (
      id: 'g2',
      url: 'https://res.cloudinary.com/demo/image/upload/q_auto/p/g2.png',
    );

    File fileOf(GuideSource source) =>
        File('${dir.path}${Platform.pathSeparator}${guideFileName(source)}');

    setUp(() {
      dir = Directory.systemTemp.createTempSync('guide_files_test');
      online = true;
      downloads = FakeHttpAdapter((options) async {
        if (!online) {
          throw DioException(
            requestOptions: options,
            type: DioExceptionType.connectionError,
          );
        }
        return ResponseBody.fromBytes(utf8.encode('GIF89a'), 200);
      });
      files = GuideFiles(
        dio: Dio()..httpClientAdapter = downloads,
        db: database,
        directory: () async => dir,
      );
    });

    tearDown(() => dir.deleteSync(recursive: true));

    test('downloads once with the plain client; then it is local', () async {
      expect(await files.local(gif), isNull);
      final file = await files.ensure(gif);
      expect(file!.path, fileOf(gif).path);
      expect(downloads.requests.single.uri.toString(), gif.url);
      // No JWT to a third party.
      expect(downloads.requests.single.headers['Authorization'], isNull);

      expect(await files.ensure(gif), isNotNull);
      expect(downloads.requests, hasLength(1));
      expect(await files.local(gif), isNotNull);
    });

    test('two requests for the same file share one download', () async {
      await Future.wait([files.ensure(gif), files.ensure(gif)]);
      expect(downloads.requests, hasLength(1));
    });

    test('offline: null, and prefetch stops at the first failure', () async {
      online = false;
      expect(await files.ensure(gif), isNull);
      await files.prefetch([gif, png]);
      expect(downloads.requests, hasLength(2)); // gif twice, png never
      expect(fileOf(png).existsSync(), isFalse);
    });

    test('retain keeps only the given files', () async {
      await files.prefetch([gif, png]);
      await files.retain([png]);
      expect(fileOf(gif).existsSync(), isFalse);
      expect(fileOf(png).existsSync(), isTrue);
    });

    test(
      'purgeIfWiped: deletes everything only when the marker is gone',
      () async {
        await files.ensure(gif);
        await files.purgeIfWiped();
        expect(fileOf(gif).existsSync(), isTrue); // Same user (or expired).

        await database.wipe(); // Logout.
        await files.purgeIfWiped();
        expect(fileOf(gif).existsSync(), isFalse);
      },
    );
  });
}
