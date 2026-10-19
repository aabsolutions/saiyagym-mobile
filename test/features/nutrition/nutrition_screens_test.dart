import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saiyagym_mobile/app/app.dart';
import 'package:saiyagym_mobile/core/database/app_database.dart';
import 'package:saiyagym_mobile/features/auth/presentation/controllers/session_controller.dart';
import 'package:saiyagym_mobile/features/body_metrics/domain/body_metric.dart';
import 'package:saiyagym_mobile/features/live_workout/data/device_services.dart';
import 'package:saiyagym_mobile/features/nutrition/presentation/calculator_tab.dart';

import '../../helpers/fake_http_adapter.dart';
import '../../helpers/fake_session.dart';
import '../../helpers/fake_sync_api.dart';
import '../../helpers/fixtures.dart';
import '../../helpers/pump_app.dart';
import '../../helpers/seed.dart';
import '../../helpers/test_infra.dart';

Map<String, Object?> _page(
  List<Object?> items, [
  Map<String, Object?>? extra,
]) => {
  'items': items,
  'meta': {'page': 1, 'limit': 100, 'total': items.length},
  ...?extra,
};

final Map<String, Object?> _meal = {
  'id': 'm1',
  'slug': 'oats',
  'name': 'Avena con yogur',
  'description': 'Rápido y saciante.',
  'goal': 'maintenance',
  'mealType': 'breakfast',
  'isSample': true,
  'items': [
    {
      'foodId': 'f1',
      'foodSlug': 'oats',
      'name': 'Avena',
      'grams': 60,
      'kcal': 230,
      'proteinG': 8,
      'carbsG': 40,
      'fatG': 4,
    },
  ],
  'totals': {'kcal': 380, 'proteinG': 25, 'carbsG': 50, 'fatG': 8},
};

final List<Map<String, Object?>> _foods = [
  {
    'id': 'f1',
    'slug': 'banana',
    'name': 'Plátano',
    'category': 'fruits',
    'tags': ['vegan'],
    'per100g': {'kcal': 89, 'proteinG': 1.1, 'carbsG': 23, 'fatG': 0.3},
  },
  {
    'id': 'f2',
    'slug': 'chicken-breast',
    'name': 'Pechuga de pollo',
    'category': 'meat',
    'tags': ['high-protein'],
    'per100g': {'kcal': 120, 'proteinG': 23, 'carbsG': 0, 'fatG': 2.6},
  },
];

void main() {
  late AppDatabase db;
  late FakeSyncApi api;
  var online = true;

  setUp(() async {
    db = testDatabase();
    api = FakeSyncApi();
    online = true;
    api.other = (options) {
      if (!online) {
        throw DioException(
          requestOptions: options,
          type: DioExceptionType.connectionError,
        );
      }
      return switch (options.path) {
        '/nutrition/meal-suggestions' => jsonBody(
          _page(
            [_meal],
            {'limitedByPlan': true, 'lockedCount': 29, 'disclaimer': '…'},
          ),
          200,
        ),
        '/nutrition/guidelines' => jsonBody({
          'items': [
            {
              'id': 'g1',
              'slug': 'protein',
              'title': 'Proteína diaria',
              'summary': 'Cuánta y cuándo.',
              'body': 'Primer párrafo.\n\nSegundo párrafo.',
              'goals': ['bulk', 'cut', 'maintenance'],
            },
          ],
          'disclaimer': '…',
        }, 200),
        '/nutrition/foods' => jsonBody(_page(_foods), 200),
        _ => null,
      };
    };
    await Seed(db).bodyMetric(
      BodyMetric(
        id: 'b1',
        measuredAt: DateTime.utc(2026, 10, 18),
        weightKg: 60,
      ),
    );
  });

  Future<void> settle(WidgetTester tester, [int frames = 8]) async {
    for (var i = 0; i < frames; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
  }

  Future<void> openNutrition(WidgetTester tester) async {
    await pumpLocalized(
      tester,
      const SaiyaGymApp(),
      infra: testInfraOverrides(
        api: api,
        database: db,
        device: SilentDeviceServices(),
      ),
      overrides: [
        sessionControllerProvider.overrideWith(
          () => FakeSession.user(testUser()),
        ),
      ],
    );
    await settle(tester);
    await tester.tap(find.text('Nutrición'));
    await settle(tester);
  }

  Future<void> openTab(WidgetTester tester, String label) async {
    final tab = find.descendant(
      of: find.byType(TabBar),
      matching: find.text(label),
    );
    // Scrollable tab bar: the last tabs start off-screen at 360 px.
    await tester.ensureVisible(tab);
    await settle(tester, 2);
    await tester.tap(tab);
    await settle(tester);
  }

  testWidgets('calculator: prefilled from profile + last weigh-in', (
    tester,
  ) async {
    await openNutrition(tester);

    expect(
      find.textContaining('no es consejo médico'),
      findsOneWidget,
      reason: 'the notice is always visible',
    );
    // Profile: female, 168 cm, born 1994-05-10; last weigh-in 60 kg.
    expect(find.widgetWithText(TextField, '168'), findsOneWidget);
    expect(find.widgetWithText(TextField, '60'), findsOneWidget);
    final list = find
        .descendant(
          of: find.byType(CalculatorTab),
          matching: find.byType(Scrollable),
        )
        .first;

    await tester.drag(list, const Offset(0, -600));
    await settle(tester, 2);
    // 32 years: 10·60 + 6.25·168 − 5·32 − 161 = 1329 × 1.55 (moderate).
    expect(find.text('2060 kcal'), findsOneWidget);
    expect(find.text('Calorías diarias orientativas'), findsOneWidget);

    await tester.drag(list, const Offset(0, 600));
    await settle(tester, 2);
    await tester.enterText(find.widgetWithText(TextField, '60'), '20');
    await settle(tester, 2);
    expect(find.text('Entre 35 y 250.'), findsOneWidget);
    await tester.drag(list, const Offset(0, -600));
    await settle(tester, 2);
    expect(find.textContaining('Completa sexo, edad'), findsOneWidget);
  });

  testWidgets('meals: Free sees the sample and the upgrade', (tester) async {
    await openNutrition(tester);
    await openTab(tester, 'Comidas');

    expect(find.text('Avena con yogur'), findsOneWidget);
    expect(
      find.text('29 sugerencias más disponibles con Premium.'),
      findsOneWidget,
    );
    expect(find.text('Ver planes'), findsOneWidget);
  });

  testWidgets('offline: the last copy, with its date; food search', (
    tester,
  ) async {
    await openNutrition(tester);
    await openTab(tester, 'Alimentos');
    expect(find.text('Plátano'), findsOneWidget);

    // Next open without network: same data from the local copy.
    online = false;
    await openNutrition(tester);
    await openTab(tester, 'Alimentos');
    expect(find.textContaining('Sin conexión · datos del'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'platano');
    await settle(tester, 2);
    expect(find.text('Plátano'), findsOneWidget);
    expect(find.text('Pechuga de pollo'), findsNothing);

    await openTab(tester, 'Guías');
    expect(
      find.textContaining('Sin conexión · datos del'),
      findsNothing,
      reason: 'guides were never fetched: error, not stale data',
    );
    expect(find.text('Reintentar'), findsOneWidget);
  });
}
