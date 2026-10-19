import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:saiyagym_mobile/features/auth/auth_providers.dart';
import 'package:saiyagym_mobile/features/auth/domain/usecases/auth_use_cases.dart';
import 'package:saiyagym_mobile/features/auth/presentation/pages/forgot_password_page.dart';

import '../../../helpers/pump_app.dart';

class _MockReset extends Mock implements RequestPasswordResetUseCase;

void main() {
  testWidgets('sends the email and explains what happens next', (tester) async {
    final reset = _MockReset();
    when(() => reset(any())).thenAnswer((_) async {});
    await pumpLocalized(
      tester,
      const LocalizedTestApp(home: ForgotPasswordPage()),
      overrides: [requestPasswordResetUseCaseProvider.overrideWithValue(reset)],
    );

    await tester.enterText(find.byType(TextFormField), 'ana@example.com');
    await tester.tap(find.text('Enviar enlace'));
    await tester.pumpAndSettle();

    verify(() => reset('ana@example.com')).called(1);
    expect(find.textContaining('te llegará un enlace'), findsOneWidget);
    expect(find.text('Volver a iniciar sesión'), findsOneWidget);
    expect(find.byType(TextFormField), findsNothing);
  });
}
