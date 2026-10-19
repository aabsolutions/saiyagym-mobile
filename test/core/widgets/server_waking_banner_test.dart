import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saiyagym_mobile/core/widgets/server_waking_banner.dart';

import '../../helpers/pump_app.dart';

void main() {
  testWidgets('shows the notice only while a request is slow', (tester) async {
    final slow = ValueNotifier(false);
    addTearDown(slow.dispose);
    await pumpLocalized(
      tester,
      LocalizedTestApp(
        home: ServerWakingBanner(slow: slow, child: const Text('app')),
      ),
    );

    expect(find.text('Despertando el servidor…'), findsNothing);
    expect(find.text('app'), findsOneWidget);

    slow.value = true;
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('Despertando el servidor…'), findsOneWidget);
    expect(find.text('app'), findsOneWidget);

    slow.value = false;
    await tester.pumpAndSettle();
    expect(find.text('Despertando el servidor…'), findsNothing);
  });
}
