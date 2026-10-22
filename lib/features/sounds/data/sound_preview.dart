import 'package:flutter/foundation.dart';
import 'package:saiyagym_mobile/features/sounds/data/alarm_sound_platform.dart';
import 'package:saiyagym_mobile/features/sounds/data/sound_cache.dart';
import 'package:saiyagym_mobile/features/sounds/domain/rest_sound.dart';

/// Plays a sound for the picker. An interface so widget tests don't touch
/// audio (they use [SilentSoundPreview]).
abstract interface class SoundPreview {
  Future<void> play(RestSound sound);
  Future<void> stop();
}

/// Downloads the file if needed and plays it natively.
class PlatformSoundPreview implements SoundPreview {
  PlatformSoundPreview({required this._cache, required this._platform});

  final SoundCache _cache;
  final AlarmSoundPlatform _platform;

  @override
  Future<void> play(RestSound sound) async {
    final path = await _cache.previewFile(sound);
    if (path == null) return;
    await _platform.preview(path);
  }

  @override
  Future<void> stop() => _platform.stopPreview();
}

/// No-op (tests).
class SilentSoundPreview implements SoundPreview {
  @visibleForTesting
  final played = <String>[];

  @override
  Future<void> play(RestSound sound) async => played.add(sound.id);

  @override
  Future<void> stop() async {}
}
