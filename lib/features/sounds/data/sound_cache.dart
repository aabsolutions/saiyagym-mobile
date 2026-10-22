import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:saiyagym_mobile/core/database/app_database.dart';
import 'package:saiyagym_mobile/features/sounds/data/alarm_sound_platform.dart';
import 'package:saiyagym_mobile/features/sounds/domain/alarm_sound.dart';
import 'package:saiyagym_mobile/features/sounds/domain/rest_sound.dart';

typedef SoundDirectory = Future<Directory> Function();

/// Downloads the selected sound and installs it where the OS notification
/// can play it. Works offline once installed: [installed] never touches
/// the network.
///
/// Downloads go through the plain upload client (no JWT to Cloudinary).
/// Only ONE sound is kept installed (the selected one); the record of
/// what is installed lives in `app_meta` (`sounds.installed`, soundId ->
/// [AlarmSound]) so it is wiped with the rest of the local data on logout
/// (the leftover files are pruned on the next install).
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

  /// The installed sound for [soundId], or `null` when there is none, it is
  /// not installed or the OS copy is gone (caller falls back to default).
  Future<AlarmSound?> installed(String? soundId) async {
    if (soundId == null) return null;
    final sound = (await _read())[soundId];
    if (sound == null) return null;
    return await _platform.isAvailable(sound) ? sound : null;
  }

  /// Makes [sound] ready for the alarm (download + install) and discards
  /// any other installed sound. `null` = couldn't (locked, offline,
  /// unsupported device, install failure): the default sound is used.
  Future<AlarmSound?> ensure(RestSound sound) async {
    if (_target == SoundTarget.none || sound.locked) return null;
    final key = sound.assetKey;
    final url = _target == SoundTarget.android ? sound.mp3Url : sound.wavUrl;
    if (key == null || url == null) return null;

    final current = await installed(sound.id);
    if (current != null && current.assetKey == key) return current;

    try {
      final file = await _download(url, key);
      final alarm = switch (_target) {
        SoundTarget.android => await _installAndroid(sound, key, file),
        SoundTarget.ios => AlarmSound(
          assetKey: key,
          name: sound.name,
          localPath: file.path,
          iosFileName: _fileName(key),
        ),
        SoundTarget.none => null,
      };
      if (alarm == null) return null;
      final previous = await _read();
      await _db.writeMeta(installedKey, jsonEncode({sound.id: alarm.toJson()}));
      for (final old in previous.values) {
        if (old.assetKey != key && old.androidUri != null) {
          await _platform.remove(old.androidUri!);
        }
      }
      await _prune(keep: file.path);
      return alarm;
    } on DioException {
      return null;
    } on FileSystemException {
      return null;
    }
  }

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

  /// Forgets the installed sound (the selection went back to the default).
  Future<void> clear() async {
    for (final old in (await _read()).values) {
      if (old.androidUri != null) await _platform.remove(old.androidUri!);
    }
    await _db.deleteMeta(installedKey);
    await _prune();
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

  /// Deletes downloaded files other than [keep] (and half downloads).
  Future<void> _prune({String? keep}) async {
    try {
      final dir = await _directory();
      if (!dir.existsSync()) return;
      final extension = _target == SoundTarget.android ? '.mp3' : '.wav';
      for (final entity in dir.listSync()) {
        if (entity is! File || entity.path == keep) continue;
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
