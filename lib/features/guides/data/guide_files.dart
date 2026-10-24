import 'dart:io';

import 'package:dio/dio.dart';
import 'package:saiyagym_mobile/core/database/app_database.dart';
import 'package:saiyagym_mobile/features/guides/domain/exercise_guide.dart';

typedef GuideDirectory = Future<Directory> Function();

/// Downloaded copies of guide files, so the live session shows them
/// offline. Downloads go through the plain upload client (no JWT to
/// Cloudinary).
///
/// Files are named by [guideFileName]. A marker in `app_meta`
/// ([markerKey]) is written whenever a file is stored: a logout wipes it
/// with the rest of the local data, which is how [purgeIfWiped] knows the
/// files on disk belong to nobody any more (an expired session keeps both).
class GuideFiles {
  GuideFiles({required this._dio, required this._db, required this._directory});

  static const markerKey = 'guides.files';

  final Dio _dio;
  final AppDatabase _db;
  final GuideDirectory _directory;

  /// One download per file at a time (two widgets may ask for the same).
  final _inFlight = <String, Future<File?>>{};

  /// The stored copy, never the network.
  Future<File?> local(GuideSource source) async {
    final file = await _fileFor(source);
    return file.existsSync() && file.lengthSync() > 0 ? file : null;
  }

  /// The stored copy, downloading it if needed. `null` = can't (offline).
  Future<File?> ensure(GuideSource source) {
    final name = guideFileName(source);
    return _inFlight[name] ??= _ensureOnce(name, source);
  }

  Future<File?> _ensureOnce(String name, GuideSource source) async {
    try {
      return await _ensure(source);
    } finally {
      // Not `remove`: it returns this very future (an un-awaited future).
      _inFlight.removeWhere((key, _) => key == name);
    }
  }

  Future<File?> _ensure(GuideSource source) async {
    final existing = await local(source);
    if (existing != null) return existing;
    try {
      final file = await _fileFor(source);
      final partial = File('${file.path}.part');
      await _db.writeMeta(markerKey, '1');
      await _dio.download(source.url, partial.path);
      return await partial.rename(file.path);
    } on DioException {
      return null;
    } on FileSystemException {
      return null;
    }
  }

  /// Downloads what's missing of [sources], one by one (best effort).
  Future<void> prefetch(Iterable<GuideSource> sources) async {
    for (final source in sources) {
      if (await ensure(source) == null) return; // Offline: try next time.
    }
  }

  /// Deletes every file not in [sources] (removed by the admin, or no longer
  /// unlocked by the plan) and half downloads.
  Future<void> retain(Iterable<GuideSource> sources) =>
      _prune(keep: {for (final source in sources) guideFileName(source)});

  /// Logout / another user wiped `app_meta`: nothing on disk is valid.
  Future<void> purgeIfWiped() async {
    if (await _db.readMeta(markerKey) != null) return;
    await _prune();
  }

  Future<File> _fileFor(GuideSource source) async {
    final dir = await _directory();
    return File('${dir.path}${Platform.pathSeparator}${guideFileName(source)}');
  }

  Future<void> _prune({Set<String> keep = const {}}) async {
    try {
      final dir = await _directory();
      if (!dir.existsSync()) return;
      for (final entity in dir.listSync()) {
        if (entity is! File) continue;
        final name = entity.uri.pathSegments.last;
        // A download running right now (e.g. a guide opened while retaining).
        final downloading =
            name.endsWith('.part') &&
            _inFlight.containsKey(name.substring(0, name.length - 5));
        if (!keep.contains(name) && !downloading) entity.deleteSync();
      }
    } on FileSystemException {
      // Housekeeping only.
    }
  }
}
