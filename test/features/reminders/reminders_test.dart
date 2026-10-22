import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saiyagym_mobile/core/database/app_database.dart';
import 'package:saiyagym_mobile/core/database/database_provider.dart';
import 'package:saiyagym_mobile/features/reminders/data/reminder_scheduler.dart';
import 'package:saiyagym_mobile/features/reminders/domain/reminder_settings.dart';
import 'package:saiyagym_mobile/features/reminders/reminders_providers.dart';
import 'package:saiyagym_mobile/features/sounds/domain/alarm_sound.dart';
import 'package:saiyagym_mobile/features/sounds/domain/sound_purpose.dart';
import 'package:saiyagym_mobile/features/sounds/sounds_providers.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import '../../helpers/fake_alarm_sound_platform.dart';
import '../../helpers/fake_notification_channels.dart';
import '../../helpers/test_infra.dart';

const _texts = ReminderTexts(
  channelName: 'c',
  trainingTitle: 't',
  trainingBody: 'tb',
  weighInTitle: 'w',
  weighInBody: 'wb',
);

const _bell = AlarmSound(
  assetKey: 'bell-1',
  name: 'Bell',
  localPath: '/f/bell-1.mp3',
  androidUri: 'content://media/external/audio/media/1',
  iosFileName: 'bell-1.wav',
);

class _SoundChoice extends Notifier<AlarmSound?> {
  @override
  AlarmSound? build() => null;

  // ignore: use_setters_to_change_properties, a setter can't be torn off here.
  void set(AlarmSound? sound) => state = sound;
}

final _trainingChoice = NotifierProvider<_SoundChoice, AlarmSound?>(
  _SoundChoice.new,
);

void main() {
  test('channel: per-sound when usable on Android, else the default', () {
    expect(
      reminderChannelId(ReminderKind.training, _bell),
      'reminder_training_bell-1',
    );
    expect(
      reminderChannelId(ReminderKind.weighIn, _bell),
      'reminder_weighin_bell-1',
    );
    expect(reminderChannelId(ReminderKind.training, null), 'reminders');
    expect(
      reminderChannelId(
        ReminderKind.weighIn,
        const AlarmSound(assetKey: 'k', name: 'n', localPath: '/p'),
      ),
      'reminders',
      reason: 'no MediaStore uri (Android < 10 / iOS)',
    );
  });

  test('ReminderTexts survives a json round trip', () {
    final back = ReminderTexts.fromJson(_texts.toJson());
    expect(back.channelName, 'c');
    expect(back.trainingTitle, 't');
    expect(back.trainingBody, 'tb');
    expect(back.weighInTitle, 'w');
    expect(back.weighInBody, 'wb');
  });

  test(
    'pruneChannels keeps the used sound channel, drops stale ones',
    () async {
      final channels = FakeNotificationChannels([
        'reminders',
        'rest_timer_x',
        'reminder_training_bell-1',
        'reminder_training_old',
        'reminder_weighin_old',
      ]);
      final scheduler = LocalReminderScheduler(
        timezone: () async => 'Europe/Madrid',
        platform: FakeAlarmSoundPlatform(),
        channels: channels,
      );

      await scheduler.pruneChannels(
        sounds: const ReminderSounds(training: _bell),
      );

      expect(
        channels.deleted,
        unorderedEquals(['reminder_training_old', 'reminder_weighin_old']),
      );
      expect(channels.existing, contains('reminder_training_bell-1'));
      expect(channels.existing, contains('rest_timer_x'));
    },
  );

  test(
    'pruneChannels: an unavailable sound is the default (channel dropped)',
    () async {
      final channels = FakeNotificationChannels(['reminder_training_bell-1']);
      final scheduler = LocalReminderScheduler(
        timezone: () async => 'Europe/Madrid',
        platform: FakeAlarmSoundPlatform()..available = false,
        channels: channels,
      );

      await scheduler.pruneChannels(
        sounds: const ReminderSounds(training: _bell),
      );

      expect(channels.deleted, ['reminder_training_bell-1']);
    },
  );

  group('nextWeekly', () {
    late tz.Location madrid;

    setUpAll(() {
      tzdata.initializeTimeZones();
      madrid = tz.getLocation('Europe/Madrid');
    });

    // 2026-10-19 is a Monday.
    tz.TZDateTime at(int day, int hour, [int minute = 0]) =>
        tz.TZDateTime(madrid, 2026, 10, day, hour, minute);

    test('later today, later this week, or next week', () {
      expect(
        nextWeekly(at(19, 10), weekday: 1, hour: 18, minute: 0),
        at(19, 18),
      );
      expect(
        nextWeekly(at(19, 10), weekday: 3, hour: 7, minute: 30),
        at(21, 7, 30),
      );
      expect(
        nextWeekly(at(19, 18), weekday: 1, hour: 18, minute: 0),
        at(26, 18),
        reason: 'exactly now is already past',
      );
    });

    test('keeps the local time across the DST change (Oct 25)', () {
      final next = nextWeekly(at(24, 12), weekday: 1, hour: 8, minute: 0);
      expect(next.day, 26);
      expect(next.hour, 8);
      expect(next.timeZoneOffset, const Duration(hours: 1));
    });
  });

  test('one notification per training day, plus the weigh-in', () {
    final slots = slotsOf(
      const ReminderSettings(
        trainingEnabled: true,
        trainingDays: {5, 1},
        weighInEnabled: true,
        weighInDay: 7,
        weighInHour: 9,
      ),
    );
    expect([for (final s in slots) s.id], [8001, 8005, 8100]);
    expect(slots.last.kind, ReminderKind.weighIn);
    expect(slotsOf(const ReminderSettings()), isEmpty);
    expect(allReminderIds, hasLength(8));
  });

  group('controller', () {
    late AppDatabase db;
    late FakeReminderScheduler scheduler;
    late ProviderContainer container;

    setUp(() {
      db = testDatabase();
      scheduler = FakeReminderScheduler();
      container = ProviderContainer(
        overrides: [
          appDatabaseProvider.overrideWithValue(db),
          reminderSchedulerProvider.overrideWithValue(scheduler),
          installedAlarmSoundProvider(SoundPurpose.trainingReminder)
              .overrideWith((ref) => ref.watch(_trainingChoice)),
          installedAlarmSoundProvider(SoundPurpose.weighIn)
              .overrideWith((ref) => null),
        ],
      );
      addTearDown(container.dispose);
    });

    RemindersController controller() =>
        container.read(remindersControllerProvider.notifier);

    /// Builds the controller, wires it like `SyncCoordinator` does and lets
    /// the startup reapply settle.
    Future<RemindersController> started() async {
      final c = controller();
      container.listen(reminderSoundsProvider, (_, next) {
        final sounds = next.value;
        if (sounds != null) unawaited(c.soundsChanged(sounds));
      }, fireImmediately: true);
      await container.read(remindersControllerProvider.future);
      await pumpEventQueue();
      return c;
    }

    test('turning a reminder on asks for permission, then schedules', () async {
      await started();
      final saved = await controller().save(
        const ReminderSettings(trainingEnabled: true),
        _texts,
      );

      expect(saved, isTrue);
      expect(scheduler.permissionRequests, 1);
      expect(scheduler.applied.last.trainingEnabled, isTrue);
      expect(
        (await ReminderSettingsStore(db).read()).trainingEnabled,
        isTrue,
        reason: 'stored on this device',
      );

      // Changing the time of an active reminder doesn't ask again.
      await controller().save(
        const ReminderSettings(trainingEnabled: true, trainingHour: 7),
        _texts,
      );
      expect(scheduler.permissionRequests, 1);
    });

    test('save caches the texts: reapply needs no BuildContext', () async {
      await started();
      await controller().save(
        const ReminderSettings(trainingEnabled: true),
        _texts,
      );

      expect((await ReminderTextsStore(db).read())?.trainingTitle, 't');
    });

    test('a sound change reapplies with the cached texts', () async {
      await started();
      await controller().save(
        const ReminderSettings(trainingEnabled: true),
        _texts,
      );
      final before = scheduler.applied.length;

      container.read(_trainingChoice.notifier).set(_bell);
      await pumpEventQueue();

      expect(scheduler.applied.length, before + 1);
      expect(scheduler.applied.last.trainingEnabled, isTrue);
      expect(scheduler.appliedSounds.last.training, _bell);

      // Nothing else changed: no loop, no extra apply.
      await pumpEventQueue();
      expect(scheduler.applied.length, before + 1);
    });

    test(
      'app start reapplies when sounds differ (downgrade while closed)',
      () async {
        await ReminderSettingsStore(db)
            .write(const ReminderSettings(trainingEnabled: true));
        await ReminderTextsStore(db).write(_texts);

        await started();

        expect(scheduler.applied, hasLength(1));
        expect(scheduler.appliedSounds.single.training, isNull);
      },
    );

    test('no cached texts: only stale channels are pruned', () async {
      await started();
      container.read(_trainingChoice.notifier).set(_bell);
      await pumpEventQueue();

      expect(scheduler.applied, isEmpty);
      expect(scheduler.pruned.last.training, _bell);
    });

    test('permission refused: nothing changes', () async {
      await started();
      scheduler.grant = false;

      final saved = await controller().save(
        const ReminderSettings(weighInEnabled: true),
        _texts,
      );

      expect(saved, isFalse);
      expect(scheduler.applied, isEmpty);
      expect(
        (await container.read(remindersControllerProvider.future))
            .weighInEnabled,
        isFalse,
      );
    });
  });
}
