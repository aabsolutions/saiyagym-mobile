import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:saiyagym_mobile/core/notifications/notification_channels.dart';
import 'package:saiyagym_mobile/features/sounds/data/alarm_sound_platform.dart';
import 'package:saiyagym_mobile/features/sounds/domain/alarm_sound.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:wakelock_plus/wakelock_plus.dart';

/// Alert when a rest ends, even with the app in the background or killed:
/// a local notification scheduled at the end time (the countdown itself is
/// computed from the stored end time, so it survives too).
abstract interface class RestAlarm {
  /// Asks for permissions up front (session start), not mid-set.
  /// [channelName] is shown in the OS notification settings. [sound] is the
  /// user's installed custom sound; `null` (or one that is no longer usable
  /// when the rest is scheduled) means the default `rest_timer` sound.
  Future<void> prepare({required String channelName, AlarmSound? sound});

  Future<void> schedule(DateTime endsAt, {required String title, String? body});
  Future<void> cancel();
}

/// Keeps the screen on during a session (optional).
abstract interface class ScreenAwake {
  Future<void> set({required bool enabled});
}

abstract interface class Haptics {
  /// Rest is over (foreground).
  Future<void> restDone();

  /// A set was checked.
  Future<void> setDone();
}

/// Default channel; a custom sound gets `rest_timer_<assetKey>` (a channel's
/// sound can't change once created, so a replaced audio = a new channel).
const restChannelId = 'rest_timer';

String restChannelIdFor(AlarmSound? sound) =>
    sound == null ? restChannelId : '${restChannelId}_${sound.assetKey}';

/// Channels to delete: every `rest_timer_*` but [keep]. The default
/// `rest_timer` is never touched.
List<String> staleRestChannels(
  Iterable<String> existing, {
  required String keep,
}) => staleChannels(existing, prefix: '${restChannelId}_', keep: keep);

class NotificationRestAlarm implements RestAlarm {
  NotificationRestAlarm({
    FlutterLocalNotificationsPlugin? plugin,
    AlarmSoundPlatform? platform,
  }) : _plugin = plugin ?? FlutterLocalNotificationsPlugin(),
       _platform = platform ?? MethodChannelAlarmSoundPlatform();

  static const _id = 7001;

  final FlutterLocalNotificationsPlugin _plugin;
  final AlarmSoundPlatform _platform;
  Future<bool>? _ready;
  bool _exact = false;
  String _channelName = restChannelId;
  AlarmSound? _sound;

  @override
  Future<void> prepare({required String channelName, AlarmSound? sound}) async {
    _channelName = channelName;
    _sound = sound;
    if (await (_ready ??= _init())) await _syncChannels(await _effective());
  }

  Future<AlarmSound?> _effective() => usableSound(_sound, _platform);

  /// Android: makes sure the channel of [sound] exists and removes stale
  /// `rest_timer_*` ones. Failures leave the default channel in charge.
  Future<void> _syncChannels(AlarmSound? sound) async {
    final android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    if (android == null) return;
    try {
      final keep = restChannelIdFor(sound);
      if (sound?.androidUri case final uri?) {
        await android.createNotificationChannel(
          AndroidNotificationChannel(
            keep,
            '$_channelName · ${sound!.name}',
            importance: Importance.max,
            sound: UriAndroidNotificationSound(uri),
            audioAttributesUsage: AudioAttributesUsage.alarm,
          ),
        );
      }
      final existing = await android.getNotificationChannels() ?? const [];
      for (final id in staleRestChannels([
        for (final c in existing) c.id,
      ], keep: keep)) {
        await android.deleteNotificationChannel(channelId: id);
      }
    } on Object {
      // Fall back to the default channel (see schedule()).
    }
  }

  Future<bool> _init() async {
    final initialized = await _plugin.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(),
      ),
    );
    final android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    if (android != null) {
      await android.requestNotificationsPermission();
      // Exact timing matters for rest; if the user refuses, Android may
      // deliver it a bit late (inexact) — still better than nothing.
      _exact = await android.canScheduleExactNotifications() ?? false;
      if (!_exact) {
        _exact = await android.requestExactAlarmsPermission() ?? false;
      }
    }
    return initialized ?? false;
  }

  @override
  Future<void> schedule(
    DateTime endsAt, {
    required String title,
    String? body,
  }) async {
    if (!await (_ready ??= _init())) return;
    await _plugin.cancel(id: _id);
    // The file / MediaStore item may be gone since prepare(): re-check.
    final sound = await _effective();
    final androidUri = sound?.androidUri;
    if (androidUri != null) await _syncChannels(sound);
    await _plugin.zonedSchedule(
      id: _id,
      title: title,
      body: body,
      scheduledDate: tz.TZDateTime.from(endsAt.toUtc(), tz.UTC),
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          androidUri == null ? restChannelId : restChannelIdFor(sound),
          _channelName,
          importance: Importance.max,
          priority: Priority.high,
          category: AndroidNotificationCategory.alarm,
        ),
        iOS: DarwinNotificationDetails(
          presentSound: true,
          sound: sound?.iosFileName,
          interruptionLevel: InterruptionLevel.timeSensitive,
        ),
      ),
      androidScheduleMode: _exact
          ? AndroidScheduleMode.exactAllowWhileIdle
          : AndroidScheduleMode.inexactAllowWhileIdle,
    );
  }

  @override
  Future<void> cancel() async {
    if (_ready == null) return;
    await _plugin.cancel(id: _id);
  }
}

class WakelockScreenAwake implements ScreenAwake {
  @override
  Future<void> set({required bool enabled}) =>
      enabled ? WakelockPlus.enable() : WakelockPlus.disable();
}

class SystemHaptics implements Haptics {
  @override
  Future<void> restDone() async {
    await HapticFeedback.heavyImpact();
    await Future<void>.delayed(const Duration(milliseconds: 150));
    await HapticFeedback.heavyImpact();
  }

  @override
  Future<void> setDone() => HapticFeedback.mediumImpact();
}

/// No-ops (tests, unsupported platforms).
class SilentDeviceServices implements RestAlarm, ScreenAwake, Haptics {
  @visibleForTesting
  final scheduled = <DateTime>[];
  @visibleForTesting
  int cancelled = 0;
  @visibleForTesting
  bool? awake;

  @override
  Future<void> prepare({
    required String channelName,
    AlarmSound? sound,
  }) async {}

  @override
  Future<void> schedule(
    DateTime endsAt, {
    required String title,
    String? body,
  }) async => scheduled.add(endsAt);

  @override
  Future<void> cancel() async => cancelled++;

  @override
  Future<void> set({required bool enabled}) async => awake = enabled;

  @override
  Future<void> restDone() async {}

  @override
  Future<void> setDone() async {}
}
