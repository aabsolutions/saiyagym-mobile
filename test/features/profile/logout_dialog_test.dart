import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saiyagym_mobile/features/profile/presentation/profile_page.dart';

import '../../helpers/pump_app.dart';

void main() {
  testWidgets('nothing pending: plain confirmation', (tester) async {
    await pumpLocalized(
      tester,
      const LocalizedTestApp(home: LogoutDialog(unsyncedChanges: 0)),
    );

    expect(find.textContaining('Se borrarán los datos'), findsOneWidget);
    expect(find.widgetWithText(FilledButton, 'Cerrar sesión'), findsOneWidget);
  });

  testWidgets('unsynced changes: says they will be lost', (tester) async {
    await pumpLocalized(
      tester,
      const LocalizedTestApp(home: LogoutDialog(unsyncedChanges: 3)),
    );

    expect(
      find.textContaining('Tienes 3 cambios sin sincronizar'),
      findsOneWidget,
    );
    expect(
      find.widgetWithText(FilledButton, 'Cerrar y perder cambios'),
      findsOneWidget,
    );
    expect(find.byIcon(Icons.warning_amber), findsOneWidget);
  });
}
