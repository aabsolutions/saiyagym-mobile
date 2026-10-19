import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:saiyagym_mobile/core/database/database_provider.dart';
import 'package:saiyagym_mobile/core/network/api_client.dart';
import 'package:saiyagym_mobile/core/sync/unsynced_changes.dart';
import 'package:saiyagym_mobile/features/progress_photos/data/photo_device.dart';
import 'package:saiyagym_mobile/features/progress_photos/data/photo_upload_queue.dart';
import 'package:saiyagym_mobile/features/progress_photos/data/progress_photos_api.dart';
import 'package:saiyagym_mobile/features/progress_photos/domain/progress_photo.dart';

part 'progress_photos_providers.g.dart';

/// Plain client for Cloudinary: no auth / language interceptors.
@Riverpod(keepAlive: true)
Dio uploadClient(Ref ref) {
  final dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 20),
      sendTimeout: const Duration(minutes: 2),
      receiveTimeout: const Duration(seconds: 30),
    ),
  );
  ref.onDispose(dio.close);
  return dio;
}

@Riverpod(keepAlive: true)
PhotoPicker photoPicker(Ref ref) => SystemPhotoPicker();

@Riverpod(keepAlive: true)
ImageCompressor imageCompressor(Ref ref) => JpegCompressor();

@Riverpod(keepAlive: true)
DirectoryResolver pendingPhotosDir(Ref ref) => pendingPhotosDirectory;

@Riverpod(keepAlive: true)
ProgressPhotosApi progressPhotosApi(Ref ref) => ProgressPhotosApi(
  dio: ref.watch(apiClientProvider),
  upload: ref.watch(uploadClientProvider),
);

@Riverpod(keepAlive: true)
PhotoUploadQueue photoUploadQueue(Ref ref) {
  final queue = PhotoUploadQueue(
    db: ref.watch(appDatabaseProvider),
    api: ref.watch(progressPhotosApiProvider),
    compressor: ref.watch(imageCompressorProvider),
    directory: ref.watch(pendingPhotosDirProvider),
  );
  // Logout asks before wiping photos that never left the device.
  final unregister = ref.read(unsyncedChangesProvider).register(queue.count);
  ref
    ..onDispose(unregister)
    ..onDispose(queue.dispose);
  return queue;
}

@riverpod
Stream<List<PendingPhoto>> pendingPhotos(Ref ref) =>
    ref.watch(photoUploadQueueProvider).watch();

@riverpod
Future<List<ProgressPhoto>> progressPhotos(Ref ref, PhotoView view) =>
    ref.watch(progressPhotosApiProvider).list(view);

@riverpod
Future<PhotoComparison> photoComparison(Ref ref, PhotoView view) =>
    ref.watch(progressPhotosApiProvider).compare(view);
