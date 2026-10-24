import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saiyagym_mobile/app/app.dart';
import 'package:saiyagym_mobile/features/auth/presentation/controllers/session_controller.dart';

import 'helpers/fake_session.dart';
import 'helpers/fixtures.dart';
import 'helpers/pump_app.dart';

/// Flutter's accessibility guidelines on the main screens: tap targets
/// (48 dp Android / 44 pt iOS), every tappable thing labeled, and text
/// contrast (WCAG AA), in light and dark.
void main() {
  Future<void> settle(WidgetTester tester, [int frames = 8]) async {
    for (var i = 0; i < frames; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
  }

  Future<void> checkGuidelines(WidgetTester tester) async {
    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
    await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
    await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
    await expectLater(tester, meetsGuideline(textContrastGuideline));
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

  for (final brightness in Brightness.values) {
    testWidgets('main screens meet the guidelines (${brightness.name})', (
      tester,
    ) async {
      tester.platformDispatcher.platformBrightnessTestValue = brightness;
      addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);
      final semantics = tester.ensureSemantics();
      await pumpLocalized(
        tester,
        const SaiyaGymApp(),
        overrides: [
          sessionControllerProvider.overrideWith(
            () => FakeSession.user(testUser()),
          ),
        ],
      );
      await settle(tester);

      await checkGuidelines(tester); // Today
      for (final tab in ['Entrenar', 'Biblioteca', 'Progreso', 'Perfil']) {
        await openTab(tester, tab);
        await checkGuidelines(tester);
      }
      // Today's shortcut opens the Library on its nutrition section.
      await openTab(tester, 'Hoy');
      await tester.tap(find.text('Nutrición'));
      await settle(tester);
      await checkGuidelines(tester);
      // History now lives inside Progress.
      await openTab(tester, 'Progreso');
      await tester.tap(find.text('Historial'));
      await settle(tester);
      await checkGuidelines(tester);

      semantics.dispose();
    });
  }
}
