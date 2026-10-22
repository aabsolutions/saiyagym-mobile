import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:saiyagym_mobile/core/database/app_database.dart';
import 'package:saiyagym_mobile/features/sounds/data/alarm_sound_platform.dart';
import 'package:saiyagym_mobile/features/sounds/domain/alarm_sound.dart';
import 'package:saiyagym_mobile/features/sounds/domain/rest_sound.dart';

typedef SoundDirectory = Future<Directory> Function();

/// Downloads the sounds the user picked (one per `SoundPurpose`, possibly
/// the same one) and installs them where the OS notification can play them.
/// Works offline once installed: [installed] never touches the network.
///
/// Downloads go through the plain upload client (no JWT to Cloudinary).
/// The record of what is installed lives in `app_meta` (`sounds.installed`,
/// soundId -> [AlarmSound]) so it is wiped with the rest of the local data
/// on logout; the leftover files are then purged (see [purgeAll]). Every
/// operation that changes the record runs one at a time: two purposes
/// prefetching in parallel would otherwise lose each other's update.
class SoundCache {
  SoundCache({
    required this._dio,
    required this._db,
    required this._platform,
    required this._target,
    required this._directory,
  });

  static const installedKey = 'sounds.installed';

  final Dio _dio;
  final AppDatabase _db;
  final AlarmSoundPlatform _platform;
  final SoundTarget _target;

  /// Android: app files; iOS: `Library/Sounds` (where notifications look).
  final SoundDirectory _directory;

  Future<void> _tail = Future.value();

  /// The installed sound for [soundId], or `null` when there is none, it is
  /// not installed or the OS copy is gone (caller falls back to default).
  Future<AlarmSound?> installed(String? soundId) async {
    if (soundId == null) return null;
    final sound = (await _read())[soundId];
    if (sound == null) return null;
    return await _platform.isAvailable(sound) ? sound : null;
  }

  /// Is there a record of installed sounds at all? (Absent after a logout
  /// wipe, which is how leftover files are recognised as orphans.)
  Future<bool> hasRecord() async => await _db.readMeta(installedKey) != null;

  /// Makes [sound] ready for the alarm (download + install). Only its own
  /// entry is added / replaced; other sounds stay until [retain] drops them.
  /// `null` = couldn't (locked, offline, unsupported device, install
  /// failure): the default sound is used.
  Future<AlarmSound?> ensure(RestSound sound) =>
      _serialized(() => _ensure(sound));

  Future<AlarmSound?> _ensure(RestSound sound) async {
    if (_target == SoundTarget.none || sound.locked) return null;
    final key = sound.assetKey;
    final url = _target == SoundTarget.android ? sound.mp3Url : sound.wavUrl;
    if (key == null || url == null) return null;

    final current = await installed(sound.id);
    if (current != null && current.assetKey == key) return current;

    try {
      // Another sound with the same asset: already downloaded and installed.
      final shared = await _sharedInstall(sound.id, key);
      final AlarmSound? alarm;
      if (shared != null) {
        alarm = shared;
      } else {
        final file = await _download(url, key);
        alarm = switch (_target) {
          SoundTarget.android => await _installAndroid(sound, key, file),
          SoundTarget.ios => AlarmSound(
            assetKey: key,
            name: sound.name,
            localPath: file.path,
            iosFileName: _fileName(key),
          ),
          SoundTarget.none => null,
        };
      }
      if (alarm == null) return null;
      final record = await _read();
      final previous = record[sound.id];
      record[sound.id] = alarm;
      await _write(record);
      if (previous != null) await _removeIfUnused(previous, record);
      await _prune(keep: record.values.map((s) => s.localPath).toSet());
      return alarm;
    } on DioException {
      return null;
    } on FileSystemException {
      return null;
    }
  }

  /// Keeps only the sounds in [soundIds] (those some purpose still needs):
  /// the rest lose their OS copy and file, unless a kept one shares it.
  Future<void> retain(Set<String> soundIds) => _serialized(() async {
    final record = await _read();
    final dropped = {
      for (final entry in record.entries)
        if (!soundIds.contains(entry.key)) entry.key: entry.value,
    };
    if (dropped.isEmpty) return;
    record.removeWhere((id, _) => dropped.containsKey(id));
    for (final old in dropped.values) {
      await _removeIfUnused(old, record);
    }
    await _write(record);
    await _prune(keep: record.values.map((s) => s.localPath).toSet());
  });

  /// Removes EVERYTHING this app installed (logout / another user): every
  /// MediaStore item under the app folder, the record and the downloaded
  /// files. Works even when the record is already gone.
  Future<void> purgeAll() => _serialized(() async {
    await _platform.removeAll();
    await _db.deleteMeta(installedKey);
    await _prune();
  });

  /// Local file of [sound] for the preview (downloads it if needed), or
  /// `null` when it can't be had (locked / offline / unsupported).
  Future<String?> previewFile(RestSound sound) async {
    if (_target == SoundTarget.none || sound.locked) return null;
    final key = sound.assetKey;
    final url = _target == SoundTarget.android ? sound.mp3Url : sound.wavUrl;
    if (key == null || url == null) return null;
    try {
      return (await _download(url, key)).path;
    } on DioException {
      return null;
    } on FileSystemException {
      return null;
    }
  }

  String _fileName(String key) =>
      '$key.${_target == SoundTarget.android ? 'mp3' : 'wav'}';

  Future<AlarmSound?> _installAndroid(
    RestSound sound,
    String key,
    File file,
  ) async {
    final uri = await _platform.install(path: file.path, assetKey: key);
    if (uri == null) return null;
    return AlarmSound(
      assetKey: key,
      name: sound.name,
      localPath: file.path,
      androidUri: uri,
    );
  }

  Future<File> _download(String url, String key) async {
    final dir = await _directory();
    final file = File('${dir.path}${Platform.pathSeparator}${_fileName(key)}');
    if (file.existsSync() && file.lengthSync() > 0) return file;
    final partial = File('${file.path}.part');
    await _dio.download(url, partial.path);
    return await partial.rename(file.path);
  }

  /// Runs [action] after every earlier serialized one finished.
  Future<T> _serialized<T>(Future<T> Function() action) {
    final result = _tail.then((_) => action());
    _tail = result.then<void>((_) {}, onError: (_) {});
    return result;
  }

  Future<AlarmSound?> _sharedInstall(String soundId, String key) async {
    for (final entry in (await _read()).entries) {
      if (entry.key != soundId &&
          entry.value.assetKey == key &&
          await _platform.isAvailable(entry.value)) {
        return entry.value;
      }
    }
    return null;
  }

  /// Drops the OS copy of [old] unless a sound still in [record] uses it.
  Future<void> _removeIfUnused(
    AlarmSound old,
    Map<String, AlarmSound> record,
  ) async {
    final uri = old.androidUri;
    if (uri == null) return;
    if (record.values.any((s) => s.assetKey == old.assetKey)) return;
    await _platform.remove(uri);
  }

  /// An empty record stays present (`{}`): "no record" means wiped.
  Future<void> _write(Map<String, AlarmSound> record) => _db.writeMeta(
    installedKey,
    jsonEncode({for (final e in record.entries) e.key: e.value.toJson()}),
  );

  /// Deletes downloaded files not in [keep] (and half downloads). Only
  /// `.mp3` / `.wav` / `.part`: never the whole iOS `Library/Sounds` dir.
  Future<void> _prune({Set<String> keep = const {}}) async {
    try {
      final dir = await _directory();
      if (!dir.existsSync()) return;
      final extension = _target == SoundTarget.android ? '.mp3' : '.wav';
      for (final entity in dir.listSync()) {
        if (entity is! File || keep.contains(entity.path)) continue;
        if (entity.path.endsWith(extension) || entity.path.endsWith('.part')) {
          entity.deleteSync();
        }
      }
    } on FileSystemException {
      // Housekeeping only.
    }
  }

  Future<Map<String, AlarmSound>> _read() async {
    final raw = await _db.readMeta(installedKey);
    if (raw == null) return {};
    try {
      final json = jsonDecode(raw) as Map<String, dynamic>;
      return {
        for (final MapEntry(:key, :value) in json.entries)
          key: AlarmSound.fromJson(Map<String, dynamic>.from(value as Map)),
      };
    } on Object {
      return {};
    }
  }
}
