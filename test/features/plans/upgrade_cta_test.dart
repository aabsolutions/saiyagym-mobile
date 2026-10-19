import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saiyagym_mobile/features/auth/presentation/controllers/session_controller.dart';
import 'package:saiyagym_mobile/features/plans/data/plan_models.dart';
import 'package:saiyagym_mobile/features/plans/domain/entitlements.dart';
import 'package:saiyagym_mobile/features/plans/plans_providers.dart';
import 'package:saiyagym_mobile/features/plans/presentation/upgrade_cta.dart';

import '../../helpers/fake_session.dart';
import '../../helpers/fixtures.dart';
import '../../helpers/pump_app.dart';

void main() {
  final plans = [
    PublicPlanModel.fromJson(const {
      'id': 'p1',
      'code': 'free',
      'name': 'Free',
      'description': 'Para empezar',
      'isDefault': true,
      'entitlements': freeEntitlementsJson,
    }).toEntity(),
    PublicPlanModel.fromJson(const {
      'id': 'p2',
      'code': 'premium',
      'name': 'Premium',
      'description': 'Sin límites',
      'isDefault': false,
      'entitlements': premiumEntitlementsJson,
    }).toEntity(),
  ];

  Future<void> pump(
    WidgetTester tester,
    Widget child, {
    bool premium = false,
  }) => pumpLocalized(
    tester,
    LocalizedTestApp(home: Scaffold(body: child)),
    overrides: [
      sessionControllerProvider.overrideWith(
        () => FakeSession.user(testUser(premium: premium)),
      ),
      availablePlansProvider.overrideWith((_) async => plans),
    ],
  );

  testWidgets('limit reached: explains it and opens the plans', (tester) async {
    await pump(tester, UpgradeCta.limit(PlanLimit.routines, max: 3));

    expect(find.text('Llegaste al límite de tu plan'), findsOneWidget);
    expect(
      find.text('Tu plan permite hasta 3 rutinas propias.'),
      findsOneWidget,
    );

    await tester.tap(find.text('Ver planes'));
    await tester.pumpAndSettle();

    expect(find.text('Tu plan'), findsOneWidget); // marks Free
    expect(find.text('Hasta 3 rutinas propias'), findsOneWidget);

    final premium = find.text('Sin límite de rutinas propias');
    await tester.scrollUntilVisible(
      premium,
      300,
      scrollable: find.byType(Scrollable).last,
    );
    expect(premium, findsOneWidget);
    expect(find.text('Premium'), findsOneWidget);
    final manual = find.textContaining('lo gestiona el administrador');
    await tester.scrollUntilVisible(
      manual,
      300,
      scrollable: find.byType(Scrollable).last,
    );
    expect(manual, findsOneWidget);
  });

  testWidgets('PlanGate: CTA on Free, content on Premium', (tester) async {
    const gate = PlanGate(
      feature: PlanFeature.progressPhotos,
      child: Text('photos'),
    );

    await pump(tester, gate);
    expect(find.text('photos'), findsNothing);
    expect(
      find.text('Fotos de progreso es parte del plan Premium.'),
      findsOneWidget,
    );

    await pump(tester, gate, premium: true);
    expect(find.text('photos'), findsOneWidget);
  });
}
