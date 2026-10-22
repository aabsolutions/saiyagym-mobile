import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:saiyagym_mobile/core/database/app_database.dart';
import 'package:saiyagym_mobile/core/notifications/notification_channels.dart';
import 'package:saiyagym_mobile/features/reminders/domain/reminder_settings.dart';
import 'package:saiyagym_mobile/features/sounds/data/alarm_sound_platform.dart';
import 'package:saiyagym_mobile/features/sounds/domain/alarm_sound.dart';
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

  factory ReminderTexts.fromJson(Map<String, dynamic> json) => ReminderTexts(
    channelName: json['channelName'] as String,
    trainingTitle: json['trainingTitle'] as String,
    trainingBody: json['trainingBody'] as String,
    weighInTitle: json['weighInTitle'] as String,
    weighInBody: json['weighInBody'] as String,
  );

  final String channelName;
  final String trainingTitle;
  final String trainingBody;
  final String weighInTitle;
  final String weighInBody;

  Map<String, dynamic> toJson() => {
    'channelName': channelName,
    'trainingTitle': trainingTitle,
    'trainingBody': trainingBody,
    'weighInTitle': weighInTitle,
    'weighInBody': weighInBody,
  };
}

/// The installed sounds the reminders may use (`null` = default sound).
class ReminderSounds {
  const ReminderSounds({this.training, this.weighIn});

  final AlarmSound? training;
  final AlarmSound? weighIn;

  AlarmSound? of(ReminderKind kind) =>
      kind == ReminderKind.training ? training : weighIn;

  /// Equal signature = same channels / files: avoids reapplying for nothing.
  String get signature =>
      '${training?.assetKey}|${training?.androidUri}|${training?.iosFileName}'
      '#${weighIn?.assetKey}|${weighIn?.androidUri}|${weighIn?.iosFileName}';
}

const defaultReminderChannelId = 'reminders';
const _trainingChannelPrefix = 'reminder_training_';
const _weighInChannelPrefix = 'reminder_weighin_';

String _channelPrefix(ReminderKind kind) => kind == ReminderKind.training
    ? _trainingChannelPrefix
    : _weighInChannelPrefix;

/// Channel of a reminder: `reminder_<kind>_<assetKey>` when [sound] is usable
/// on Android (has a MediaStore uri), else the default `reminders` one. A
/// channel's sound can't change once created, so each sound gets its own.
String reminderChannelId(ReminderKind kind, AlarmSound? sound) =>
    sound?.androidUri == null
    ? defaultReminderChannelId
    : '${_channelPrefix(kind)}${sound!.assetKey}';

abstract interface class ReminderScheduler {
  /// Asks the OS. Called only when the user turns a reminder ON (never at
  /// startup), so the request makes sense to them. false = denied.
  Future<bool> requestPermission();

  /// Cancels every reminder and schedules [settings] again.
  /// [sounds] picks the per-sound channel (Android) / file (iOS).
  Future<void> apply(
    ReminderSettings settings,
    ReminderTexts texts, {
    ReminderSounds sounds = const ReminderSounds(),
  });

  /// Deletes the sound channels [sounds] no longer uses (schedule untouched).
  Future<void> pruneChannels({ReminderSounds sounds = const ReminderSounds()});

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
    required this._platform,
    required this._channels,
    FlutterLocalNotificationsPlugin? plugin,
  }) : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  final FlutterLocalNotificationsPlugin _plugin;
  final AlarmSoundPlatform _platform;
  final NotificationChannels _channels;
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
  Future<void> apply(
    ReminderSettings settings,
    ReminderTexts texts, {
    ReminderSounds sounds = const ReminderSounds(),
  }) async {
    await cancelAll();
    // The file / MediaStore item may be gone: only usable sounds count.
    final usable = await _usable(sounds);
    final channelIds = {
      for (final kind in ReminderKind.values)
        kind: await _channelFor(kind, usable[kind], texts.channelName),
    };
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
          android: AndroidNotificationDetails(
            channelIds[slot.kind]!,
            texts.channelName,
          ),
          iOS: DarwinNotificationDetails(
            presentSound: true,
            sound: usable[slot.kind]?.iosFileName,
          ),
        ),
        // A reminder a few minutes late is fine: no exact-alarm permission.
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
      );
    }
    await _prune(channelIds);
  }

  Future<Map<ReminderKind, AlarmSound?>> _usable(ReminderSounds sounds) async =>
      {
        for (final kind in ReminderKind.values)
          kind: await usableSound(sounds.of(kind), _platform),
      };

  /// Android: creates the channel of [sound] (if any) and returns the id to
  /// notify on; any failure falls back to the default channel.
  Future<String> _channelFor(
    ReminderKind kind,
    AlarmSound? sound,
    String channelName,
  ) async {
    final uri = sound?.androidUri;
    if (uri == null) return defaultReminderChannelId;
    final android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    if (android == null) return defaultReminderChannelId;
    try {
      final id = reminderChannelId(kind, sound);
      await android.createNotificationChannel(
        AndroidNotificationChannel(
          id,
          '$channelName · ${sound!.name}',
          sound: UriAndroidNotificationSound(uri),
        ),
      );
      return id;
    } on Object {
      return defaultReminderChannelId;
    }
  }

  @override
  Future<void> pruneChannels({
    ReminderSounds sounds = const ReminderSounds(),
  }) async {
    final usable = await _usable(sounds);
    await _prune({
      for (final kind in ReminderKind.values)
        kind: reminderChannelId(kind, usable[kind]),
    });
  }

  /// Deletes every sound channel of each kind except the one in use.
  Future<void> _prune(Map<ReminderKind, String> keep) async {
    try {
      final existing = await _channels.ids();
      for (final kind in ReminderKind.values) {
        for (final id in staleChannels(
          existing,
          prefix: _channelPrefix(kind),
          keep: keep[kind]!,
        )) {
          await _channels.delete(id);
        }
      }
    } on Object {
      // Leftover channels are harmless.
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
  @visibleForTesting
  final appliedSounds = <ReminderSounds>[];
  @visibleForTesting
  final pruned = <ReminderSounds>[];

  @override
  Future<bool> requestPermission() async {
    permissionRequests++;
    return grant;
  }

  @override
  Future<void> apply(
    ReminderSettings settings,
    ReminderTexts texts, {
    ReminderSounds sounds = const ReminderSounds(),
  }) async {
    applied.add(settings);
    appliedSounds.add(sounds);
  }

  @override
  Future<void> pruneChannels({
    ReminderSounds sounds = const ReminderSounds(),
  }) async => pruned.add(sounds);

  @override
  Future<void> cancelAll() async => applied.add(const ReminderSettings());
}

/// The texts of the last save, so a reapply (sound changed) needs no UI.
class ReminderTextsStore {
  ReminderTextsStore(this._db);

  static const key = 'reminders.texts';

  final AppDatabase _db;

  Future<ReminderTexts?> read() async {
    final raw = await _db.readMeta(key);
    if (raw == null) return null;
    try {
      return ReminderTexts.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } on Object {
      return null;
    }
  }

  Future<void> write(ReminderTexts texts) =>
      _db.writeMeta(key, jsonEncode(texts.toJson()));
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
