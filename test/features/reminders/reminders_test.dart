import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saiyagym_mobile/core/database/app_database.dart';
import 'package:saiyagym_mobile/core/database/database_provider.dart';
import 'package:saiyagym_mobile/features/reminders/data/reminder_scheduler.dart';
import 'package:saiyagym_mobile/features/reminders/domain/reminder_settings.dart';
import 'package:saiyagym_mobile/features/reminders/reminders_providers.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import '../../helpers/test_infra.dart';

const _texts = ReminderTexts(
  channelName: 'c',
  trainingTitle: 't',
  trainingBody: 'tb',
  weighInTitle: 'w',
  weighInBody: 'wb',
);

void main() {
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
        ],
      );
      addTearDown(container.dispose);
    });

    RemindersController controller() =>
        container.read(remindersControllerProvider.notifier);

    test('turning a reminder on asks for permission, then schedules', () async {
      final saved = await controller().save(
        const ReminderSettings(trainingEnabled: true),
        _texts,
      );

      expect(saved, isTrue);
      expect(scheduler.permissionRequests, 1);
      expect(scheduler.applied.single.trainingEnabled, isTrue);
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

    test('permission refused: nothing changes', () async {
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
