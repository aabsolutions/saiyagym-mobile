import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saiyagym_mobile/app/app.dart';
import 'package:saiyagym_mobile/core/database/app_database.dart';
import 'package:saiyagym_mobile/core/sync/stores.dart';
import 'package:saiyagym_mobile/core/sync/sync_collection.dart';
import 'package:saiyagym_mobile/core/sync/sync_queue.dart';
import 'package:saiyagym_mobile/core/training/training_types.dart';
import 'package:saiyagym_mobile/features/auth/presentation/controllers/session_controller.dart';
import 'package:saiyagym_mobile/features/live_workout/data/device_services.dart';
import 'package:saiyagym_mobile/features/routines/domain/routine.dart';
import 'package:saiyagym_mobile/features/workouts/domain/workout.dart';

import '../helpers/fake_session.dart';
import '../helpers/fixtures.dart';
import '../helpers/pump_app.dart';
import '../helpers/seed.dart';
import '../helpers/test_infra.dart';

void main() {
  late AppDatabase db;

  setUp(() async {
    db = testDatabase();
    final seed = Seed(db);
    await seed.exercise('ex-squat', 'Sentadilla', hypertrophyTier: 'S');
    await seed.exercise(
      'ex-curl',
      'Curl de bíceps',
      muscle: 'biceps',
      hypertrophyTier: 'B',
    );
  });

  Future<void> pumpApp(WidgetTester tester) => pumpLocalized(
    tester,
    const SaiyaGymApp(),
    infra: testInfraOverrides(database: db, device: SilentDeviceServices()),
    overrides: [
      sessionControllerProvider.overrideWith(
        () => FakeSession.user(testUser()),
      ),
    ],
  );

  Future<void> settle(WidgetTester tester, [int frames = 8]) async {
    for (var i = 0; i < frames; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
  }

  Future<void> openTab(WidgetTester tester, String label) async {
    await tester.tap(
      find.descendant(
        of: find.byType(NavigationBar),
        matching: find.text(label),
      ),
    );
    await settle(tester);
  }

  Workout squatSession(String id, DateTime startedAt, double weight) => Workout(
    id: id,
    name: 'Pierna',
    startedAt: startedAt,
    finishedAt: startedAt.add(const Duration(hours: 1)),
    exercises: [
      WorkoutExercise(
        id: 'e-$id',
        exerciseId: 'ex-squat',
        sets: [
          WorkoutSet(
            id: 's-$id',
            type: SetType.normal,
            weightKg: weight,
            reps: 5,
            completed: true,
          ),
        ],
      ),
    ],
  );

  testWidgets('create a routine offline: name, exercise, save', (tester) async {
    await pumpApp(tester);
    await openTab(tester, 'Entrenar');

    await tester.tap(find.text('Nueva rutina'));
    await settle(tester);
    await tester.enterText(
      find.widgetWithText(TextField, 'Nombre de la rutina'),
      'Mi pierna',
    );
    await settle(tester, 2);
    await tester.tap(find.text('Añadir ejercicio'));
    await settle(tester);
    await tester.tap(find.text('Sentadilla').last);
    await settle(tester);
    expect(find.byTooltip('Quitar serie'), findsNWidgets(3));

    await tester.tap(find.widgetWithText(FilledButton, 'Guardar'));
    await settle(tester);

    expect(find.text('Mi pierna'), findsOneWidget, reason: 'back on Train');
    final routines = await SyncStores(
      db,
      languageCode: () => 'es',
    ).routines.active();
    expect(routines.single.json['name'], 'Mi pierna');
    expect(
      await SyncQueueDao(db).find(SyncCollection.routines, routines.single.id),
      isNotNull,
      reason: 'queued for sync',
    );
  });

  testWidgets('the Free routine limit is explained before building one', (
    tester,
  ) async {
    final seed = Seed(db);
    for (var i = 0; i < 3; i++) {
      await seed.routine(Routine(id: 'r$i', name: 'Rutina $i'));
    }
    await pumpApp(tester);
    await openTab(tester, 'Entrenar');

    await tester.tap(find.text('Nueva rutina'));
    await settle(tester);

    expect(find.text('Llegaste al límite de tu plan'), findsOneWidget);
    expect(find.text('Nombre de la rutina'), findsNothing);
  });

  testWidgets('exercises: favorite, filter, tier list, detail', (tester) async {
    await pumpApp(tester);
    await openTab(tester, 'Entrenar');
    await tester.tap(find.byTooltip('Ejercicios'));
    await settle(tester);

    expect(find.text('Sentadilla'), findsOneWidget);
    expect(find.text('Curl de bíceps'), findsOneWidget);

    await tester.tap(
      find.descendant(
        of: find.widgetWithText(ListTile, 'Curl de bíceps'),
        matching: find.byTooltip('Marcar como favorito'),
      ),
    );
    await settle(tester);
    await tester.ensureVisible(find.text('Favoritos'));
    await settle(tester, 2);
    await tester.tap(find.text('Favoritos'));
    await settle(tester);
    expect(find.text('Curl de bíceps'), findsOneWidget);
    expect(find.text('Sentadilla'), findsNothing);
    await tester.ensureVisible(find.text('Favoritos'));
    await settle(tester, 2);
    await tester.tap(find.text('Favoritos'));
    await settle(tester);

    await tester.tap(find.text('Tier list'));
    await settle(tester);
    expect(find.text('S'), findsOneWidget);
    expect(find.widgetWithText(ActionChip, 'Sentadilla'), findsOneWidget);

    await tester.tap(find.widgetWithText(ActionChip, 'Sentadilla'));
    await settle(tester);
    expect(find.text('Aún no hay récords con este ejercicio.'), findsOneWidget);
    expect(find.text('Todavía no lo has entrenado.'), findsOneWidget);
  });

  testWidgets('history: detail, calendar and delete', (tester) async {
    await Seed(db).workout(squatSession('w1', DateTime(2026, 10, 14, 18), 100));
    await pumpApp(tester);
    await openTab(tester, 'Historial');

    await tester.tap(find.text('Calendario'));
    await settle(tester);
    expect(find.textContaining('2026'), findsWidgets);
    await tester.tap(find.text('Lista'));
    await settle(tester);

    await tester.tap(find.text('Pierna'));
    await settle(tester);
    expect(find.text('Sentadilla'), findsOneWidget);
    expect(find.text('100 kg × 5'), findsOneWidget);

    await tester.tap(find.byTooltip('Borrar'));
    await settle(tester, 3);
    await tester.tap(find.widgetWithText(FilledButton, 'Borrar'));
    await settle(tester);

    expect(find.text('Todavía no hay sesiones'), findsOneWidget);
    final docs = await SyncStores(
      db,
      languageCode: () => 'es',
    ).workouts.active();
    expect(docs, isEmpty, reason: 'logically deleted');
  });

  testWidgets('today: streak, this week and the latest record', (tester) async {
    final now = DateTime.now();
    final seed = Seed(db);
    await seed.workout(
      squatSession('w1', now.subtract(const Duration(days: 7)), 100),
    );
    await seed.workout(squatSession('w2', now, 110)); // a record this week
    await pumpApp(tester);
    await settle(tester);

    expect(find.text('Esta semana'), findsOneWidget);
    expect(find.text('semanas de racha'), findsOneWidget);
    expect(find.text('2'), findsWidgets, reason: 'two weeks in a row');
    expect(find.text('Último récord'), findsOneWidget);
    expect(find.text('110 kg'), findsOneWidget);
  });
}
