import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:clock/clock.dart';
import 'package:saiyagym_mobile/core/database/app_database.dart';
import 'package:saiyagym_mobile/core/network/api_exception.dart';
import 'package:saiyagym_mobile/features/progress_photos/data/photo_device.dart';
import 'package:saiyagym_mobile/features/progress_photos/data/progress_photos_api.dart';
import 'package:saiyagym_mobile/features/progress_photos/domain/progress_photo.dart';
import 'package:uuid/uuid.dart';

/// Photos taken offline (or while uploading) wait here: compressed file
/// on disk + entry in `app_meta`. Each upload asks for a FRESH signature
/// (they last 1 h; a queued photo may wait days). Registered in
/// `UnsyncedChanges`, so logout warns about them.
class PhotoUploadQueue {
  PhotoUploadQueue({
    required this._db,
    required this._api,
    required this._compressor,
    required this._directory,
  });

  static const key = 'photos.pending';
  static const _uuid = Uuid();

  final AppDatabase _db;
  final ProgressPhotosApi _api;
  final ImageCompressor _compressor;
  final DirectoryResolver _directory;

  final _changes = StreamController<List<PendingPhoto>>.broadcast();
  final _uploaded = StreamController<ProgressPhoto>.broadcast();
  Future<void>? _running;
  bool _again = false;

  /// Every change of the pending list.
  Stream<List<PendingPhoto>> watch() async* {
    yield await pending();
    yield* _changes.stream;
  }

  /// Each photo that reached the API.
  Stream<ProgressPhoto> get uploaded => _uploaded.stream;

  Future<List<PendingPhoto>> pending() async {
    final raw = await _db.readMeta(key);
    if (raw == null) return const [];
    return [
      for (final item in jsonDecode(raw) as List)
        PendingPhoto.fromJson(Map<String, dynamic>.from(item as Map)),
    ];
  }

  Future<int> count() async => (await pending()).length;

  Future<File> fileOf(PendingPhoto photo) async =>
      File('${(await _directory()).path}/${photo.fileName}');

  /// Compresses [sourcePath] into the queue and starts uploading.
  Future<PendingPhoto> enqueue(
    String sourcePath, {
    required PhotoView view,
    String notes = '',
  }) async {
    final id = _uuid.v4();
    final fileName = '$id.jpg';
    final target = '${(await _directory()).path}/$fileName';
    if (!await _compressor.compress(sourcePath, target)) {
      throw const ApiException(code: 'PHOTO_UNREADABLE');
    }
    final photo = PendingPhoto(
      id: id,
      view: view,
      takenAt: clock.now().toUtc(),
      fileName: fileName,
      notes: notes.trim(),
    );
    await _write([...await pending(), photo]);
    unawaited(process());
    return photo;
  }

  /// Retries a failed photo.
  Future<void> retry(String id) async {
    await _update(id, (p) => p.copyWith(clearError: true));
    await process();
  }

  Future<void> discard(String id) async {
    final all = await pending();
    final photo = all.where((p) => p.id == id).firstOrNull;
    if (photo == null) return;
    await _write([...all.where((p) => p.id != id)]);
    await _deleteFile(photo);
  }

  /// Uploads what it can, oldest first; stops at the first connectivity
  /// problem (the next trigger retries). Single-flight: a call while
  /// running schedules one more pass (a photo queued meanwhile).
  Future<void> process() {
    if (_running case final running?) {
      _again = true;
      return running;
    }
    return _running = () async {
      do {
        _again = false;
        await _process();
      } while (_again);
    }().whenComplete(() => _running = null);
  }

  Future<void> _process() async {
    final queue = await pending();
    if (queue.isEmpty) {
      await _pruneOrphans();
      return;
    }
    for (final photo in queue) {
      if (photo.error != null) continue;
      try {
        await _upload(photo);
      } on ApiException catch (error) {
        if (error.isConnectivity || error.isServerError) return;
        await _update(photo.id, (p) => p.copyWith(error: error.code));
      } on FileSystemException {
        await _update(photo.id, (p) => p.copyWith(error: 'PHOTO_MISSING'));
      }
    }
  }

  Future<void> _upload(PendingPhoto photo) async {
    var asset = photo.uploaded;
    if (asset == null) {
      final file = await fileOf(photo);
      final signature = await _api.signature();
      final size = await file.length();
      if (signature.maxFileSizeBytes > 0 && size > signature.maxFileSizeBytes) {
        throw const ApiException(code: 'PAYLOAD_TOO_LARGE');
      }
      asset = await _api.uploadFile(signature, file);
      // Uploaded: if registering fails now, the retry only registers.
      await _update(photo.id, (p) => p.copyWith(uploaded: asset));
    }
    final saved = await _api.register(photo, asset);
    await _write([...(await pending()).where((p) => p.id != photo.id)]);
    await _deleteFile(photo);
    _uploaded.add(saved);
  }

  Future<void> _update(
    String id,
    PendingPhoto Function(PendingPhoto) change,
  ) async {
    final photos = await pending();
    await _write(photos.map((p) => p.id == id ? change(p) : p).toList());
  }

  Future<void> _write(List<PendingPhoto> photos) async {
    if (photos.isEmpty) {
      await _db.deleteMeta(key);
    } else {
      await _db.writeMeta(
        key,
        jsonEncode([for (final p in photos) p.toJson()]),
      );
    }
    _changes.add(photos);
  }

  Future<void> _deleteFile(PendingPhoto photo) async {
    final file = await fileOf(photo);
    if (file.existsSync()) await file.delete();
  }

  /// Files left behind by a logout (the list is wiped, files aren't).
  /// Only old ones: a photo being queued right now has its file written
  /// before its entry.
  Future<void> _pruneOrphans() async {
    try {
      final directory = await _directory();
      final cutoff = clock.now().subtract(const Duration(hours: 1));
      for (final entity in directory.listSync()) {
        if (entity is File && entity.lastModifiedSync().isBefore(cutoff)) {
          await entity.delete();
        }
      }
    } on Object {
      // Best effort.
    }
  }

  Future<void> dispose() async {
    await _changes.close();
    await _uploaded.close();
  }
}
