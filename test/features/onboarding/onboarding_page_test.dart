import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:saiyagym_mobile/core/units/unit_formatter.dart';
import 'package:saiyagym_mobile/features/auth/domain/entities/user.dart';
import 'package:saiyagym_mobile/features/auth/presentation/controllers/session_controller.dart';
import 'package:saiyagym_mobile/features/onboarding/domain/complete_onboarding.dart';
import 'package:saiyagym_mobile/features/onboarding/presentation/onboarding_controller.dart';
import 'package:saiyagym_mobile/features/onboarding/presentation/onboarding_page.dart';

import '../../helpers/fake_session.dart';
import '../../helpers/fixtures.dart';
import '../../helpers/pump_app.dart';

class _MockComplete extends Mock implements CompleteOnboardingUseCase;

void main() {
  late _MockComplete complete;

  setUpAll(
    () => registerFallbackValue(
      const OnboardingData(
        units: UnitSystem.metric,
        language: 'es',
        defaultRestSeconds: 90,
      ),
    ),
  );

  setUp(() {
    complete = _MockComplete();
    when(() => complete(any())).thenAnswer((_) async => testUser());
  });

  Future<void> pumpOnboarding(WidgetTester tester) => pumpLocalized(
    tester,
    const LocalizedTestApp(home: OnboardingPage()),
    overrides: [
      sessionControllerProvider.overrideWith(
        () => FakeSession.user(testUser(onboarded: false)),
      ),
      completeOnboardingUseCaseProvider.overrideWithValue(complete),
    ],
  );

  FilledButton primaryButton(WidgetTester tester) =>
      tester.widget<FilledButton>(find.byType(FilledButton));

  /// Scrolls the option into view first (pages scroll above the button).
  Future<void> tapVisible(WidgetTester tester, Finder finder) async {
    await tester.ensureVisible(finder);
    await tester.pumpAndSettle();
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  Future<void> next(WidgetTester tester) async {
    await tester.tap(find.byType(FilledButton));
    await tester.pumpAndSettle();
  }

  testWidgets('walks the 5 steps; level and goal are required', (tester) async {
    await pumpOnboarding(tester);
    expect(find.text('Paso 1 de 5'), findsOneWidget);

    await tapVisible(tester, find.text('lb / in'));
    await next(tester);

    // Body data: optional, shown in the chosen units.
    expect(find.text('Paso 2 de 5'), findsOneWidget);
    expect(find.text('in'), findsOneWidget);
    expect(find.text('lb'), findsOneWidget);
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Peso actual'),
      '176',
    );
    await next(tester);

    expect(find.text('Paso 3 de 5'), findsOneWidget);
    expect(primaryButton(tester).onPressed, isNull, reason: 'no level yet');
    await tapVisible(tester, find.text('Avanzado'));
    expect(primaryButton(tester).onPressed, isNotNull);
    await next(tester);

    expect(find.text('Paso 4 de 5'), findsOneWidget);
    await tapVisible(tester, find.text('Powerlifting'));
    await next(tester);

    expect(find.text('Paso 5 de 5'), findsOneWidget);
    await tapVisible(tester, find.text('3:00'));
    await tester.tap(find.text('Empezar a entrenar'));
    await tester.pumpAndSettle();

    final data =
        verify(() => complete(captureAny())).captured.single as OnboardingData;
    expect(data.units, UnitSystem.imperial);
    expect(data.level, TrainingLevel.advanced);
    expect(data.goal, TrainingGoal.powerlifting);
    expect(data.defaultRestSeconds, 180);
    // 176 lb, stored in kg.
    expect(data.weightKg, closeTo(79.83, 0.01));
    // Prefilled from the account.
    expect(data.heightCm, 168);
  });

  testWidgets('rejects an impossible height before moving on', (tester) async {
    await pumpOnboarding(tester);
    await next(tester);

    await tester.enterText(find.widgetWithText(TextFormField, 'Altura'), '900');
    await next(tester);

    expect(find.text('Paso 2 de 5'), findsOneWidget);
    expect(find.text('Debe estar entre 50 y 272'), findsOneWidget);
  });
}
