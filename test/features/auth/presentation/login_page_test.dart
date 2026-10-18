import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:saiyagym_mobile/core/network/api_exception.dart';
import 'package:saiyagym_mobile/features/auth/auth_providers.dart';
import 'package:saiyagym_mobile/features/auth/domain/usecases/auth_use_cases.dart';
import 'package:saiyagym_mobile/features/auth/presentation/pages/login_page.dart';

import '../../../helpers/pump_app.dart';

class _MockLogin extends Mock implements LoginUseCase;

void main() {
  late _MockLogin login;

  setUp(() => login = _MockLogin());

  Future<void> pumpLogin(WidgetTester tester) => pumpLocalized(
    tester,
    const LocalizedTestApp(home: LoginPage()),
    overrides: [loginUseCaseProvider.overrideWithValue(login)],
  );

  Finder field(String label) => find.widgetWithText(TextFormField, label);

  testWidgets('validates before calling the API', (tester) async {
    await pumpLogin(tester);

    await tester.tap(find.widgetWithText(FilledButton, 'Entrar'));
    await tester.pumpAndSettle();
    expect(find.text('Este campo es obligatorio'), findsNWidgets(2));

    await tester.enterText(field('Email'), 'not-an-email');
    await tester.tap(find.widgetWithText(FilledButton, 'Entrar'));
    await tester.pumpAndSettle();
    expect(find.text('Introduce un email válido'), findsOneWidget);

    verifyZeroInteractions(login);
  });

  testWidgets('shows the translated error when the API is unreachable', (
    tester,
  ) async {
    when(
      () => login(
        email: any(named: 'email'),
        password: any(named: 'password'),
      ),
    ).thenThrow(const ApiException(code: ApiException.networkError));
    await pumpLogin(tester);

    await tester.enterText(field('Email'), 'ana@example.com');
    await tester.enterText(field('Contraseña'), 'secret-password');
    await tester.tap(find.widgetWithText(FilledButton, 'Entrar'));
    await tester.pumpAndSettle();

    verify(() => login(email: 'ana@example.com', password: 'secret-password'))
        .called(1);
    expect(
      find.text('Sin conexión. Revisa tu internet e inténtalo de nuevo.'),
      findsOneWidget,
    );
  });
}
