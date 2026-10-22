import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saiyagym_mobile/core/database/app_database.dart';
import 'package:saiyagym_mobile/features/sounds/data/alarm_sound_platform.dart';
import 'package:saiyagym_mobile/features/sounds/data/sound_cache.dart';
import 'package:saiyagym_mobile/features/sounds/domain/rest_sound.dart';

import '../../helpers/fake_alarm_sound_platform.dart';
import '../../helpers/fake_http_adapter.dart';

const _mp3 =
    'https://res.cloudinary.com/demo/video/upload/saiyagym/sounds/aaaa-1111.mp3';
const _wav =
    'https://res.cloudinary.com/demo/video/upload/af_22050/'
    'saiyagym/sounds/aaaa-1111.wav';

RestSound sound({
  String id = 'sound-1',
  bool locked = false,
  String? mp3 = _mp3,
  String? wav = _wav,
}) => RestSound(
  id: id,
  slug: 'bell',
  name: 'Bell',
  access: SoundAccess.free,
  locked: locked,
  durationSec: 3,
  mp3Url: locked ? null : mp3,
  wavUrl: locked ? null : wav,
);

void main() {
  late AppDatabase database;
  late Directory dir;
  late FakeHttpAdapter downloads;
  late FakeAlarmSoundPlatform platform;

  SoundCache cacheFor(SoundTarget target) => SoundCache(
    dio: Dio()..httpClientAdapter = downloads,
    db: database,
    platform: platform,
    target: target,
    directory: () async => dir,
  );

  setUp(() {
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
    database = AppDatabase(NativeDatabase.memory());
    dir = Directory.systemTemp.createTempSync('sound_cache_test');
    platform = FakeAlarmSoundPlatform();
    downloads = FakeHttpAdapter(
      (options) async => ResponseBody.fromBytes(utf8.encode('audio'), 200),
    );
  });

  tearDown(() async {
    await database.close();
    dir.deleteSync(recursive: true);
  });

  test('assetKey is the file name of the delivery url without extension', () {
    expect(sound().assetKey, 'aaaa-1111');
    expect(sound(mp3: null, wav: null).assetKey, isNull);
  });

  group('Android', () {
    test('downloads the mp3 with the plain client and installs it', () async {
      final cache = cacheFor(SoundTarget.android);

      final alarm = await cache.ensure(sound());

      expect(downloads.requests.single.uri.toString(), _mp3);
      // No JWT / API headers to a third party.
      expect(
        downloads.requests.single.headers.containsKey('Authorization'),
        isFalse,
      );
      expect(platform.installed, ['aaaa-1111']);
      expect(alarm!.androidUri, platform.installUri);
      expect(File(alarm.localPath).existsSync(), isTrue);
    });

    test('installed() works without any network', () async {
      final cache = cacheFor(SoundTarget.android);
      await cache.ensure(sound());
      downloads.requests.clear();

      final alarm = await cache.installed('sound-1');

      expect(alarm!.assetKey, 'aaaa-1111');
      expect(downloads.requests, isEmpty);
    });

    test(
      'selecting the same installed sound again does not re-download',
      () async {
        final cache = cacheFor(SoundTarget.android);
        await cache.ensure(sound());
        await cache.ensure(sound());

        expect(downloads.requests, hasLength(1));
        expect(platform.installed, hasLength(1));
      },
    );

    test('installed() is null when the OS copy is gone', () async {
      final cache = cacheFor(SoundTarget.android);
      await cache.ensure(sound());
      platform.available = false;

      expect(await cache.installed('sound-1'), isNull);
    });

    test('the OS refusing the install means default sound (null)', () async {
      platform.installUri = null;
      final cache = cacheFor(SoundTarget.android);

      expect(await cache.ensure(sound()), isNull);
      expect(await cache.installed('sound-1'), isNull);
    });

    test('a new selection discards the previous sound', () async {
      final cache = cacheFor(SoundTarget.android);
      final first = await cache.ensure(sound());
      final second = await cache.ensure(
        sound(id: 'sound-2', mp3: _mp3.replaceFirst('aaaa-1111', 'bbbb-2222')),
      );

      expect(platform.removed, [first!.androidUri]);
      expect(File(first.localPath).existsSync(), isFalse);
      expect(File(second!.localPath).existsSync(), isTrue);
      expect(await cache.installed('sound-1'), isNull);
    });

    test('offline download failure returns null, no crash', () async {
      downloads = FakeHttpAdapter(
        (options) async => throw DioException(
          requestOptions: options,
          type: DioExceptionType.connectionError,
        ),
      );

      expect(await cacheFor(SoundTarget.android).ensure(sound()), isNull);
    });

    test('a locked sound is never downloaded', () async {
      expect(
        await cacheFor(SoundTarget.android).ensure(sound(locked: true)),
        isNull,
      );
      expect(downloads.requests, isEmpty);
    });

    test('clear() removes the OS copy and the file', () async {
      final cache = cacheFor(SoundTarget.android);
      final alarm = await cache.ensure(sound());

      await cache.clear();

      expect(platform.removed, [alarm!.androidUri]);
      expect(File(alarm.localPath).existsSync(), isFalse);
      expect(await cache.installed('sound-1'), isNull);
    });
  });

  group('iOS', () {
    test('downloads the wav into the sounds directory by assetKey', () async {
      final alarm = await cacheFor(SoundTarget.ios).ensure(sound());

      expect(downloads.requests.single.uri.toString(), _wav);
      expect(alarm!.iosFileName, 'aaaa-1111.wav');
      expect(alarm.androidUri, isNull);
      expect(File(alarm.localPath).existsSync(), isTrue);
      expect(platform.installed, isEmpty);
    });
  });

  test('unsupported platform never downloads', () async {
    expect(await cacheFor(SoundTarget.none).ensure(sound()), isNull);
    expect(downloads.requests, isEmpty);
  });
}
