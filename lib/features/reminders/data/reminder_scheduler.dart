import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:saiyagym_mobile/core/database/app_database.dart';
import 'package:saiyagym_mobile/features/reminders/domain/reminder_settings.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

/// Localized notification texts (resolved by the UI when applying).
class ReminderTexts {
  const ReminderTexts({
    required this.channelName,
    required this.trainingTitle,
    required this.trainingBody,
    required this.weighInTitle,
    required this.weighInBody,
  });

  final String channelName;
  final String trainingTitle;
  final String trainingBody;
  final String weighInTitle;
  final String weighInBody;
}

abstract interface class ReminderScheduler {
  /// Asks the OS. Called only when the user turns a reminder ON (never at
  /// startup), so the request makes sense to them. false = denied.
  Future<bool> requestPermission();

  /// Cancels every reminder and schedules [settings] again.
  Future<void> apply(ReminderSettings settings, ReminderTexts texts);

  /// Logout: the settings are wiped with the local data, so are these.
  Future<void> cancelAll();
}

/// Next [weekday] at [hour]:[minute] in [now]'s location, strictly after
/// [now] (DST-safe: built from local fields, not by adding hours).
tz.TZDateTime nextWeekly(
  tz.TZDateTime now, {
  required int weekday,
  required int hour,
  required int minute,
}) {
  var candidate = tz.TZDateTime(
    now.location,
    now.year,
    now.month,
    now.day,
    hour,
    minute,
  );
  final days = (weekday - candidate.weekday) % 7;
  candidate = tz.TZDateTime(
    now.location,
    candidate.year,
    candidate.month,
    candidate.day + days,
    hour,
    minute,
  );
  if (!candidate.isAfter(now)) {
    candidate = tz.TZDateTime(
      now.location,
      candidate.year,
      candidate.month,
      candidate.day + 7,
      hour,
      minute,
    );
  }
  return candidate;
}

/// Weekly local notifications (`zonedSchedule` repeating on day + time),
/// in the device's timezone. They survive reboots (boot receiver in the
/// manifest) and need no network.
class LocalReminderScheduler implements ReminderScheduler {
  LocalReminderScheduler({
    required this._timezone,
    FlutterLocalNotificationsPlugin? plugin,
  }) : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  static const _channelId = 'reminders';

  final FlutterLocalNotificationsPlugin _plugin;
  final Future<String> Function() _timezone;
  Future<void>? _ready;

  Future<void> _init() async {
    tzdata.initializeTimeZones();
    try {
      tz.setLocalLocation(tz.getLocation(await _timezone()));
    } on Object {
      tz.setLocalLocation(tz.UTC);
    }
    await _plugin.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        // Don't ask on init: only through requestPermission().
        iOS: DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
        ),
      ),
    );
  }

  @override
  Future<bool> requestPermission() async {
    await (_ready ??= _init());
    final android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    if (android != null) {
      return await android.requestNotificationsPermission() ?? false;
    }
    final ios = _plugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >();
    return await ios?.requestPermissions(alert: true, sound: true) ?? false;
  }

  @override
  Future<void> apply(ReminderSettings settings, ReminderTexts texts) async {
    await cancelAll();
    final now = tz.TZDateTime.now(tz.local);
    for (final slot in slotsOf(settings)) {
      final training = slot.kind == ReminderKind.training;
      await _plugin.zonedSchedule(
        id: slot.id,
        title: training ? texts.trainingTitle : texts.weighInTitle,
        body: training ? texts.trainingBody : texts.weighInBody,
        scheduledDate: nextWeekly(
          now,
          weekday: slot.weekday,
          hour: slot.hour,
          minute: slot.minute,
        ),
        notificationDetails: NotificationDetails(
          android: AndroidNotificationDetails(_channelId, texts.channelName),
          iOS: const DarwinNotificationDetails(),
        ),
        // A reminder a few minutes late is fine: no exact-alarm permission.
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
      );
    }
  }

  @override
  Future<void> cancelAll() async {
    await (_ready ??= _init());
    for (final id in allReminderIds) {
      await _plugin.cancel(id: id);
    }
  }
}

/// Records calls (tests).
class FakeReminderScheduler implements ReminderScheduler {
  bool grant = true;
  @visibleForTesting
  int permissionRequests = 0;
  @visibleForTesting
  final applied = <ReminderSettings>[];

  @override
  Future<bool> requestPermission() async {
    permissionRequests++;
    return grant;
  }

  @override
  Future<void> apply(ReminderSettings settings, ReminderTexts texts) async =>
      applied.add(settings);

  @override
  Future<void> cancelAll() async => applied.add(const ReminderSettings());
}

class ReminderSettingsStore {
  ReminderSettingsStore(this._db);

  static const key = 'reminders.settings';

  final AppDatabase _db;

  Future<ReminderSettings> read() async {
    final raw = await _db.readMeta(key);
    if (raw == null) return const ReminderSettings();
    try {
      return ReminderSettings.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } on Object {
      return const ReminderSettings();
    }
  }

  Future<bool> exists() async => await _db.readMeta(key) != null;

  Future<void> write(ReminderSettings settings) =>
      _db.writeMeta(key, jsonEncode(settings.toJson()));
}
