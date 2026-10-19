import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saiyagym_mobile/app/app.dart';
import 'package:saiyagym_mobile/features/auth/domain/entities/user.dart';
import 'package:saiyagym_mobile/features/auth/presentation/controllers/session_controller.dart';

import '../helpers/fake_session.dart';
import '../helpers/fixtures.dart';
import '../helpers/pump_app.dart';

void main() {
  Future<void> pumpApp(
    WidgetTester tester, {
    User? user,
    bool offline = false,
  }) => pumpLocalized(
    tester,
    const SaiyaGymApp(),
    overrides: [
      sessionControllerProvider.overrideWith(
        () => FakeSession.user(user, offline: offline),
      ),
    ],
  );

  testWidgets('signed in: lands on Today with the 5 bottom tabs', (
    tester,
  ) async {
    await pumpApp(tester, user: testUser());

    final navigation = find.byType(NavigationBar);
    expect(navigation, findsOneWidget);
    for (final label in [
      'Hoy',
      'Entrenar',
      'Historial',
      'Progreso',
      'Perfil',
    ]) {
      expect(
        find.descendant(of: navigation, matching: find.text(label)),
        findsOneWidget,
        reason: label,
      );
    }
    // No program reachable in tests: the empty-workout option is there.
    expect(find.text('Sin programa activo'), findsOneWidget);
    expect(find.text('Entreno vacío'), findsOneWidget);
  });

  testWidgets('tapping a tab switches the page', (tester) async {
    await pumpApp(tester, user: testUser());

    await tester.tap(find.text('Perfil'));
    await tester.pumpAndSettle();

    expect(find.text('ana@example.com'), findsOneWidget);
    expect(find.text('Plan Free'), findsOneWidget);
  });

  testWidgets('signed out: starts on the welcome screen', (tester) async {
    await pumpApp(tester);

    expect(find.byType(NavigationBar), findsNothing);
    expect(find.text('Crear cuenta'), findsOneWidget);
    expect(find.text('Ya tengo cuenta'), findsOneWidget);
  });

  testWidgets('without level and goal: onboarding first', (tester) async {
    await pumpApp(tester, user: testUser(onboarded: false));

    expect(find.byType(NavigationBar), findsNothing);
    expect(find.text('Paso 1 de 5'), findsOneWidget);
  });

  testWidgets('offline session: opens and says so', (tester) async {
    await pumpApp(tester, user: testUser(), offline: true);

    expect(find.byType(NavigationBar), findsOneWidget);
    expect(
      find.textContaining('Sin conexión: estás usando los datos guardados'),
      findsOneWidget,
    );
    expect(find.text('Reintentar'), findsOneWidget);
  });

  testWidgets('unverified email: banner with resend, dismissible', (
    tester,
  ) async {
    await pumpApp(tester, user: testUser(emailVerified: false));

    expect(find.textContaining('Confirma tu email'), findsOneWidget);
    expect(find.text('Reenviar'), findsOneWidget);

    await tester.tap(find.byTooltip('Cerrar'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Confirma tu email'), findsNothing);
  });
}
