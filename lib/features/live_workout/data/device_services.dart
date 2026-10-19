import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:wakelock_plus/wakelock_plus.dart';

/// Alert when a rest ends, even with the app in the background or killed:
/// a local notification scheduled at the end time (the countdown itself is
/// computed from the stored end time, so it survives too).
abstract interface class RestAlarm {
  /// Asks for permissions up front (session start), not mid-set.
  /// [channelName] is shown in the OS notification settings.
  Future<void> prepare({required String channelName});

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

class NotificationRestAlarm implements RestAlarm {
  NotificationRestAlarm([FlutterLocalNotificationsPlugin? plugin])
    : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  static const _id = 7001;
  static const _channelId = 'rest_timer';

  final FlutterLocalNotificationsPlugin _plugin;
  Future<bool>? _ready;
  bool _exact = false;
  String _channelName = _channelId;

  @override
  Future<void> prepare({required String channelName}) async {
    _channelName = channelName;
    await (_ready ??= _init());
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
    await _plugin.zonedSchedule(
      id: _id,
      title: title,
      body: body,
      scheduledDate: tz.TZDateTime.from(endsAt.toUtc(), tz.UTC),
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          _channelName,
          importance: Importance.max,
          priority: Priority.high,
          category: AndroidNotificationCategory.alarm,
        ),
        iOS: const DarwinNotificationDetails(
          presentSound: true,
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
  Future<void> prepare({required String channelName}) async {}

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
