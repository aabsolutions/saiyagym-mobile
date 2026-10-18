import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saiyagym_mobile/app/app.dart';
import 'package:saiyagym_mobile/features/auth/domain/entities/user.dart';
import 'package:saiyagym_mobile/features/auth/presentation/controllers/session_controller.dart';

import '../helpers/fixtures.dart';
import '../helpers/pump_app.dart';

class _FakeSession extends SessionController {
  _FakeSession(this._user);

  final User? _user;

  @override
  Future<User?> build() async => _user;
}

void main() {
  Future<void> pumpApp(WidgetTester tester, {User? user}) => pumpLocalized(
    tester,
    const SaiyaGymApp(),
    overrides: [
      sessionControllerProvider.overrideWith(() => _FakeSession(user)),
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
    expect(find.text('Nada planificado para hoy'), findsOneWidget);
  });

  testWidgets('tapping a tab switches the page', (tester) async {
    await pumpApp(tester, user: testUser());

    await tester.tap(find.text('Perfil'));
    await tester.pumpAndSettle();

    expect(find.text('ana@example.com'), findsOneWidget);
    expect(find.text('Plan Free'), findsOneWidget);
  });

  testWidgets('signed out: the router sends you to login', (tester) async {
    await pumpApp(tester);

    expect(find.byType(NavigationBar), findsNothing);
    expect(find.text('Iniciar sesión'), findsOneWidget);
  });
}
