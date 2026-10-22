import 'package:flutter_test/flutter_test.dart';
import 'package:saiyagym_mobile/core/cache/json_cache.dart';
import 'package:saiyagym_mobile/features/auth/presentation/controllers/session_controller.dart';
import 'package:saiyagym_mobile/features/reminders/data/reminder_scheduler.dart';
import 'package:saiyagym_mobile/features/reminders/domain/reminder_settings.dart';
import 'package:saiyagym_mobile/features/reminders/presentation/reminders_page.dart';
import 'package:saiyagym_mobile/features/sounds/domain/rest_sound.dart';
import 'package:saiyagym_mobile/features/sounds/presentation/sound_picker_sheet.dart';
import 'package:saiyagym_mobile/features/sounds/sounds_providers.dart';

import '../../helpers/fake_session.dart';
import '../../helpers/fixtures.dart';
import '../../helpers/pump_app.dart';
import '../../helpers/test_infra.dart';

const _free = RestSound(
  id: 'free-1',
  slug: 'bell',
  name: 'Campana',
  access: SoundAccess.free,
  locked: false,
  durationSec: 2,
);

void main() {
  Future<void> pumpPage(
    WidgetTester tester, {
    required ReminderSettings settings,
  }) async {
    final db = testDatabase();
    await ReminderSettingsStore(db).write(settings);
    await pumpLocalized(
      tester,
      const LocalizedTestApp(home: RemindersPage()),
      infra: testInfraOverrides(database: db),
      overrides: [
        sessionControllerProvider.overrideWith(
          () => FakeSession.user(testUser()),
        ),
        restSoundsProvider.overrideWith(
          (_) async =>
              Cached(const [_free], fetchedAt: DateTime.utc(2026, 10, 20)),
        ),
      ],
    );
    await tester.pump();
    await tester.pump();
  }

  testWidgets('a sound row sits under each enabled reminder', (tester) async {
    await pumpPage(
      tester,
      settings: const ReminderSettings(
        trainingEnabled: true,
        weighInEnabled: true,
      ),
    );

    // The second row is below the fold of the lazy list.
    expect(find.text('Sonido', skipOffstage: false), findsNWidgets(2));
    expect(find.text('Predeterminado', skipOffstage: false), findsNWidgets(2));
  });

  testWidgets('no sound row while the reminder is off', (tester) async {
    await pumpPage(tester, settings: const ReminderSettings());

    expect(find.text('Sonido'), findsNothing);
  });

  testWidgets('tapping the training row opens its own picker', (tester) async {
    await pumpPage(
      tester,
      settings: const ReminderSettings(trainingEnabled: true),
    );

    await tester.tap(find.text('Sonido'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.byType(SoundPickerSheet), findsOneWidget);
    expect(find.text('Sonido del recordatorio de entreno'), findsOneWidget);
    expect(find.text('Campana'), findsOneWidget);
  });
}
