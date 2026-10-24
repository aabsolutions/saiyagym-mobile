import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saiyagym_mobile/app/app.dart';
import 'package:saiyagym_mobile/core/database/app_database.dart';
import 'package:saiyagym_mobile/core/sync/stores.dart';
import 'package:saiyagym_mobile/features/auth/presentation/controllers/session_controller.dart';
import 'package:saiyagym_mobile/features/guides/domain/exercise_guide.dart';
import 'package:saiyagym_mobile/features/guides/guides_providers.dart';
import 'package:saiyagym_mobile/features/live_workout/data/device_services.dart';
import 'package:saiyagym_mobile/features/live_workout/presentation/live_workout_page.dart';
import 'package:saiyagym_mobile/features/workouts/domain/workout.dart';

import '../../helpers/fake_session.dart';
import '../../helpers/fixtures.dart';
import '../../helpers/pump_app.dart';
import '../../helpers/seed.dart';
import '../../helpers/test_infra.dart';

/// Fixed guide access: no API call, no downloads.
class _FixedGuides extends GuidesController {
  _FixedGuides(this._access);

  final GuideAccess _access;

  @override
  Future<GuideAccess> build() async => _access;

  @override
  Future<void> refresh() async {}
}

void main() {
  late AppDatabase db;
  late SilentDeviceServices device;

  setUp(() {
    db = testDatabase();
    device = SilentDeviceServices();
  });

  Future<void> pumpApp(
    WidgetTester tester, {
    GuideAccess guides = GuideAccess.empty,
  }) => pumpLocalized(
    tester,
    const SaiyaGymApp(),
    infra: testInfraOverrides(database: db, device: device),
    overrides: [
      sessionControllerProvider.overrideWith(
        () => FakeSession.user(testUser()),
      ),
      guidesControllerProvider.overrideWith(() => _FixedGuides(guides)),
    ],
  );

  /// The session clock ticks every second: pump frames instead of settling.
  Future<void> settle(WidgetTester tester, [int frames = 10]) async {
    for (var i = 0; i < frames; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
  }

  Future<void> seedLegDay() async {
    final seed = Seed(db);
    await seed.exercise('ex-squat', 'Sentadilla');
    await seed.routine(legDay);
    await seed.workout(lastWeekSquat());
  }

  Future<List<Workout>> finished() async => [
    for (final doc in await SyncStores(
      db,
      languageCode: () => 'es',
    ).workouts.active())
      Workout.fromJson(doc.json),
  ].where((w) => !w.inProgress).toList();

  testWidgets('start a routine, log sets, finish and celebrate records', (
    tester,
  ) async {
    await seedLegDay();
    await pumpApp(tester);

    // Start from a routine.
    await tester.tap(find.text('Entrenar'));
    await settle(tester);
    await tester.tap(find.text('Pierna'));
    await settle(tester);

    expect(find.byType(LiveWorkoutPage), findsOneWidget);
    expect(find.text('Sentadilla'), findsOneWidget);
    expect(find.text('95 × 5'), findsNWidgets(2), reason: 'last time');
    expect(
      find.text('100'),
      findsNWidgets(2),
      reason: 'target weight prefilled',
    );

    // In-app keypad: +2.5 kg on the first set, then back.
    await tester.tap(find.text('100').first);
    await settle(tester, 3);
    await tester.tap(find.text('+2,5'));
    await settle(tester, 3);
    expect(find.text('102,5'), findsOneWidget);
    await tester.tap(find.text('-2,5'));
    await settle(tester, 3);
    await tester.tap(find.byIcon(Icons.check).last); // keypad OK
    await settle(tester, 3);

    // One tap per set; the rest timer starts.
    await tester.tap(find.byTooltip('Completar serie').first);
    await settle(tester, 3);
    expect(find.byTooltip('Desmarcar serie'), findsOneWidget);
    expect(find.text('Saltar'), findsOneWidget);
    expect(device.scheduled, hasLength(1), reason: 'rest alert scheduled');
    expect(
      find.textContaining('500 kg'),
      findsOneWidget,
      reason: 'header volume',
    );

    await tester.tap(find.text('Saltar'));
    await settle(tester, 3);
    expect(find.text('Saltar'), findsNothing);
    await tester.tap(find.byTooltip('Completar serie').first);
    await settle(tester, 3);
    expect(find.byTooltip('Desmarcar serie'), findsNWidgets(2));

    // Finish: summary, rating, save.
    await tester.tap(find.text('Terminar'));
    await settle(tester);
    expect(find.text('Terminar entreno'), findsOneWidget);
    await tester.tap(find.byTooltip('4'));
    await settle(tester, 2);
    await tester.tap(find.text('Guardar entreno'));
    await settle(tester, 25);

    // 100×5 ×2 beats last week's 95×5 ×2: weight, e1RM and volume.
    expect(find.text('¡3 récords nuevos!'), findsOneWidget);
    expect(
      find.textContaining('Peso máximo: 100 kg (antes 95 kg)'),
      findsOneWidget,
    );

    final saved = (await finished()).firstWhere((w) => w.id != 'w-last-week');
    expect(saved.rating, 4);
    expect(saved.exercises.single.sets.where((s) => s.completed), hasLength(2));

    await tester.scrollUntilVisible(find.text('Listo'), 200);
    await settle(tester, 2);
    await tester.tap(find.text('Listo'));
    await settle(tester);
    expect(find.text('Historial'), findsWidgets);
  });

  testWidgets('a session left running is offered on the next open', (
    tester,
  ) async {
    await seedLegDay();
    await Seed(db).workout(
      Workout(
        id: 'w-running',
        name: 'Pierna',
        startedAt: DateTime.utc(2026, 10, 18, 8),
        exercises: const [WorkoutExercise(id: 'we', exerciseId: 'ex-squat')],
      ),
    );

    await pumpApp(tester);
    await settle(tester);

    expect(find.text('Tienes una sesión sin terminar'), findsOneWidget);
    // The dialog's button (the running-session bar also says it).
    await tester.tap(find.widgetWithText(FilledButton, 'Reanudar'));
    await settle(tester);

    expect(find.byType(LiveWorkoutPage), findsOneWidget);
    expect(find.text('Sentadilla'), findsOneWidget);
  });

  testWidgets('discarding asks first, then deletes the session', (
    tester,
  ) async {
    await seedLegDay();
    await pumpApp(tester);
    await tester.tap(find.text('Entrenar'));
    await settle(tester);
    await tester.tap(find.text('Entreno vacío'));
    await settle(tester);
    expect(find.byType(LiveWorkoutPage), findsOneWidget);

    await tester.tap(find.byTooltip('Más opciones'));
    await settle(tester, 3);
    await tester.tap(find.text('Descartar sesión'));
    await settle(tester, 3);
    expect(find.text('¿Descartar la sesión?'), findsOneWidget);
    await tester.tap(find.widgetWithText(FilledButton, 'Descartar sesión'));
    await settle(tester);

    expect(find.byType(LiveWorkoutPage), findsNothing);
    final running = await SyncStores(
      db,
      languageCode: () => 'es',
    ).workouts.active();
    expect(running.where((d) => d.json['finishedAt'] == null), isEmpty);
  });

  testWidgets('an exercise with a locked guide: one tap explains why', (
    tester,
  ) async {
    await seedLegDay();
    await pumpApp(
      tester,
      guides: const GuideAccess(guidesPerRoutine: 5, locked: {'ex-squat'}),
    );
    await tester.tap(find.text('Entrenar'));
    await settle(tester);
    await tester.tap(find.text('Pierna'));
    await settle(tester);

    await tester.tap(find.byTooltip('Ver guía de ejecución'));
    await settle(tester, 5);
    expect(find.text('Guía disponible con Premium'), findsOneWidget);
  });

  testWidgets('no guides: no guide button', (tester) async {
    await seedLegDay();
    await pumpApp(tester);
    await tester.tap(find.text('Entrenar'));
    await settle(tester);
    await tester.tap(find.text('Pierna'));
    await settle(tester);

    expect(find.byType(LiveWorkoutPage), findsOneWidget);
    expect(find.byTooltip('Ver guía de ejecución'), findsNothing);
  });
}
