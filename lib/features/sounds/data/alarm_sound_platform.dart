import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:saiyagym_mobile/features/sounds/domain/alarm_sound.dart';

/// Which delivery format / mechanism the device uses.
enum SoundTarget {
  /// mp3 inserted into MediaStore `Notifications/SaiyaGym` (API 29+).
  android,

  /// wav copied to `Library/Sounds`.
  ios,

  /// Unsupported (tests, desktop): the default sound is always used.
  none;

  static SoundTarget get current {
    if (kIsWeb) return none;
    return switch (defaultTargetPlatform) {
      TargetPlatform.android => android,
      TargetPlatform.iOS => ios,
      _ => none,
    };
  }
}

/// Native side of custom alarm sounds. Every method fails soft: a platform
/// error means "not available" and the alarm uses the default sound.
abstract interface class AlarmSoundPlatform {
  /// Android: inserts [path] into MediaStore and returns its `content://`
  /// uri (idempotent per [assetKey]); `null` when unsupported (API < 29) or
  /// on any failure.
  Future<String?> install({required String path, required String assetKey});

  /// Android: deletes the MediaStore item.
  Future<void> remove(String androidUri);

  /// Android: deletes every MediaStore item this app put under
  /// `Notifications/SaiyaGym` (items it doesn't own are skipped). Returns how
  /// many were removed. iOS / unsupported: `0`.
  Future<int> removeAll();

  /// Is [sound] still usable right now (uri resolvable / file present)?
  Future<bool> isAvailable(AlarmSound sound);

  Future<void> preview(String path);
  Future<void> stopPreview();
}

class MethodChannelAlarmSoundPlatform implements AlarmSoundPlatform {
  MethodChannelAlarmSoundPlatform({MethodChannel? channel, SoundTarget? target})
    : _channel = channel ?? const MethodChannel(channelName),
      _target = target ?? SoundTarget.current;

  /// Same name in `MainActivity.kt` and `AppDelegate.swift`.
  static const channelName = 'saiyagym/alarm_sound';

  final MethodChannel _channel;
  final SoundTarget _target;

  @override
  Future<String?> install({
    required String path,
    required String assetKey,
  }) async {
    if (_target != SoundTarget.android) return null;
    try {
      return await _channel.invokeMethod<String>('install', {
        'path': path,
        'assetKey': assetKey,
      });
    } on PlatformException {
      return null;
    } on MissingPluginException {
      return null;
    }
  }

  @override
  Future<void> remove(String androidUri) async {
    if (_target != SoundTarget.android) return;
    try {
      await _channel.invokeMethod<void>('remove', {'uri': androidUri});
    } on PlatformException {
      // Best effort.
    } on MissingPluginException {
      // Best effort.
    }
  }

  @override
  Future<int> removeAll() async {
    if (_target != SoundTarget.android) return 0;
    try {
      return await _channel.invokeMethod<int>('removeAll') ?? 0;
    } on PlatformException {
      return 0;
    } on MissingPluginException {
      return 0;
    }
  }

  @override
  Future<bool> isAvailable(AlarmSound sound) async {
    try {
      switch (_target) {
        case SoundTarget.android:
          final uri = sound.androidUri;
          if (uri == null) return false;
          return await _channel.invokeMethod<bool>('exists', {'uri': uri}) ??
              false;
        case SoundTarget.ios:
          return sound.iosFileName != null &&
              File(sound.localPath).existsSync();
        case SoundTarget.none:
          return false;
      }
    } on PlatformException {
      return false;
    } on MissingPluginException {
      return false;
    }
  }

  @override
  Future<void> preview(String path) async {
    try {
      await _channel.invokeMethod<void>('preview', {'path': path});
    } on PlatformException {
      // Preview is a convenience.
    } on MissingPluginException {
      // Preview is a convenience.
    }
  }

  @override
  Future<void> stopPreview() async {
    try {
      await _channel.invokeMethod<void>('stopPreview');
    } on PlatformException {
      // Preview is a convenience.
    } on MissingPluginException {
      // Preview is a convenience.
    }
  }
}

/// [sound] when it is still usable now (uri / file present), else `null`
/// (= default sound). Never throws: the alarm must always ring.
Future<AlarmSound?> usableSound(
  AlarmSound? sound,
  AlarmSoundPlatform platform,
) async {
  if (sound == null) return null;
  try {
    return await platform.isAvailable(sound) ? sound : null;
  } on Object {
    return null;
  }
}
