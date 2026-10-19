import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saiyagym_mobile/core/database/app_database.dart';
import 'package:saiyagym_mobile/core/network/api_client.dart';
import 'package:saiyagym_mobile/core/storage/token_storage.dart';
import 'package:saiyagym_mobile/features/progress_photos/data/photo_upload_queue.dart';
import 'package:saiyagym_mobile/features/progress_photos/data/progress_photos_api.dart';
import 'package:saiyagym_mobile/features/progress_photos/domain/progress_photo.dart';

import '../../helpers/fake_http_adapter.dart';
import '../../helpers/fake_photos.dart';
import '../../helpers/in_memory_token_storage.dart';
import '../../helpers/test_infra.dart';

const _uploadUrl = 'https://api.cloudinary.test/v1_1/demo/image/upload';

void main() {
  late AppDatabase db;
  late Directory dir;
  late FakeCompressor compressor;
  late FakeHttpAdapter api;
  late FakeHttpAdapter cloudinary;
  late PhotoUploadQueue queue;
  var online = true;
  var registerStatus = 201;

  DioException offline(RequestOptions options) => DioException(
    requestOptions: options,
    type: DioExceptionType.connectionError,
  );

  setUp(() async {
    online = true;
    registerStatus = 201;
    db = testDatabase();
    dir = await tempPhotosDir();
    addTearDown(() => dir.delete(recursive: true));
    compressor = FakeCompressor();
    api = FakeHttpAdapter((options) async {
      if (!online) throw offline(options);
      switch (options.path) {
        case '/media/upload-signature':
          return jsonBody({
            'uploadUrl': _uploadUrl,
            'apiKey': 'key-1',
            'signature': 'sig-1',
            'params': {
              'type': 'authenticated',
              'timestamp': 1792400000,
              'public_id': 'u1/progress/abc',
              'asset_folder': 'u1/progress',
              'allowed_formats': 'jpg,png,webp,heic',
              'transformation': 'c_limit,w_2000,h_2000',
            },
            'maxFileSizeBytes': 10485760,
            'expiresAt': '2026-10-19T11:00:00.000Z',
          }, 201);
        case '/progress-photos':
          if (registerStatus != 201) {
            return apiError(registerStatus, 'PLAN_FEATURE_REQUIRED');
          }
          final body = options.data as Map;
          return jsonBody({
            'id': 'photo-1',
            'view': body['view'],
            'takenAt': body['takenAt'],
            'url': 'https://res.cloudinary.test/signed/abc.jpg',
            'publicId': body['publicId'],
            'notes': body['notes'] ?? '',
          }, 201);
      }
      return apiError(404, 'NOT_FOUND');
    });
    cloudinary = FakeHttpAdapter((options) async {
      if (!online) throw offline(options);
      return jsonBody({
        'public_id': 'u1/progress/abc',
        'format': 'jpg',
        'secure_url': 'https://res.cloudinary.test/image/authenticated/v1/u1/progress/abc.jpg',
      }, 200);
    });
    queue = PhotoUploadQueue(
      db: db,
      api: ProgressPhotosApi(
        dio: buildApiClient(
          baseUrl: 'https://api.test',
          storage: InMemoryTokenStorage(
            const AuthTokens(accessToken: 'jwt', refreshToken: 'r'),
          ),
          languageCode: () => 'es',
          onSessionExpired: () {},
          adapter: api,
        ),
        upload: Dio()..httpClientAdapter = cloudinary,
      ),
      compressor: compressor,
      directory: () async => dir,
    );
    addTearDown(queue.dispose);
  });

  List<String> paths(FakeHttpAdapter adapter) => [
    for (final r in adapter.requests) r.path,
  ];

  test('offline: compressed, kept on disk and counted as unsent', () async {
    online = false;

    final photo = await queue.enqueue(
      'camera.heic',
      view: PhotoView.side,
      notes: ' semana 1 ',
    );
    await queue.process();

    expect(compressor.calls.single.$1, 'camera.heic');
    expect((await queue.fileOf(photo)).existsSync(), isTrue);
    final pending = await queue.pending();
    expect(pending.single.view, PhotoView.side);
    expect(pending.single.notes, 'semana 1');
    expect(pending.single.error, isNull, reason: 'offline is not a failure');
    expect(await queue.count(), 1);
    expect(cloudinary.requests, isEmpty);
  });

  test(
    'online: fresh signature → Cloudinary → register → file removed',
    () async {
      online = false;
      final photo = await queue.enqueue('camera.jpg', view: PhotoView.front);
      online = true;
      final uploaded = queue.uploaded.first;

      await queue.process();

      expect(paths(api), ['/media/upload-signature', '/progress-photos']);
      final upload = cloudinary.requests.single;
      expect(upload.uri.toString(), _uploadUrl);
      expect(
        upload.headers['Authorization'],
        isNull,
        reason: 'the JWT never goes to Cloudinary',
      );
      final form = upload.data as FormData;
      final fields = Map.fromEntries(form.fields);
      expect(fields['api_key'], 'key-1');
      expect(fields['signature'], 'sig-1');
      expect(fields['type'], 'authenticated');
      expect(fields['timestamp'], '1792400000');
      expect(form.files.single.key, 'file');

      final register = api.requests.last.data as Map;
      expect(register['publicId'], 'u1/progress/abc');
      expect(register['format'], 'jpg');
      expect(register['view'], 'front');
      expect((await uploaded).id, 'photo-1');
      expect(await queue.pending(), isEmpty);
      expect((await queue.fileOf(photo)).existsSync(), isFalse);
    },
  );

  test('uploaded but not registered: the retry only registers', () async {
    online = false;
    await queue.enqueue('camera.jpg', view: PhotoView.back);
    online = true;
    registerStatus = 503;

    await queue.process();
    expect(cloudinary.requests, hasLength(1));
    expect(
      (await queue.pending()).single.uploaded?.publicId,
      'u1/progress/abc',
    );

    registerStatus = 201;
    await queue.process();

    expect(cloudinary.requests, hasLength(1), reason: 'not uploaded twice');
    expect(await queue.pending(), isEmpty);
  });

  test('refused by the API: marked failed, retried only on demand', () async {
    online = false;
    final photo = await queue.enqueue('camera.jpg', view: PhotoView.front);
    online = true;
    registerStatus = 403;

    await queue.process();
    expect((await queue.pending()).single.error, 'PLAN_FEATURE_REQUIRED');

    await queue.process();
    expect(cloudinary.requests, hasLength(1), reason: 'skipped while failed');

    registerStatus = 201;
    await queue.retry(photo.id);
    expect(await queue.pending(), isEmpty);
  });

  test('discard removes the entry and the file', () async {
    online = false;
    final photo = await queue.enqueue('camera.jpg', view: PhotoView.front);

    await queue.discard(photo.id);

    expect(await queue.count(), 0);
    expect((await queue.fileOf(photo)).existsSync(), isFalse);
  });
}
