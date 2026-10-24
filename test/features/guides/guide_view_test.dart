import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saiyagym_mobile/features/guides/domain/exercise_guide.dart';
import 'package:saiyagym_mobile/features/guides/guides_providers.dart';
import 'package:saiyagym_mobile/features/guides/presentation/guide_view.dart';

import '../../helpers/pump_app.dart';
import 'exercise_guide_test.dart' show guideJson;

void main() {
  final guides = [
    ExerciseGuide.fromJson(guideJson('g1', kind: 'animation')),
    ExerciseGuide.fromJson(guideJson('g2')),
  ];

  Future<void> pump(WidgetTester tester, GuideStatus status) => pumpLocalized(
    tester,
    LocalizedTestApp(
      home: Scaffold(
        body: SingleChildScrollView(child: GuideSection(status: status)),
      ),
    ),
    overrides: [
      // Not downloaded and offline (no real IO / image decoding in tests).
      for (final guide in guides)
        guideFileProvider(guide.source).overrideWith((ref) async => null),
    ],
  );

  testWidgets('no guide: nothing', (tester) async {
    await pump(tester, const NoGuide());
    expect(find.byType(Card), findsNothing);
    expect(find.byType(PageView), findsNothing);
  });

  testWidgets('locked: explains it and offers the upgrade', (tester) async {
    await pump(tester, const GuideLocked());
    expect(find.text('Guía disponible con Premium'), findsOneWidget);
    expect(find.byIcon(Icons.workspace_premium), findsOneWidget);
    expect(find.byType(PageView), findsNothing);
  });

  testWidgets('unlocked: swipeable files with their caption', (tester) async {
    await pump(tester, GuideUnlocked(guides));
    expect(find.byType(PageView), findsOneWidget);
    expect(find.text('Baja controlado'), findsOneWidget);
    // Not downloaded and no network: says so instead of a blank box.
    expect(
      find.text('Conéctate a internet para descargar esta guía.'),
      findsOneWidget,
    );

    await tester.fling(find.byType(PageView), const Offset(-600, 0), 1000);
    await tester.pumpAndSettle();
    // The second guide has no caption.
    expect(find.text('Baja controlado'), findsNothing);
  });

  testWidgets('accessible: each file has a label', (tester) async {
    final handle = tester.ensureSemantics();
    await pump(tester, GuideUnlocked(guides));
    expect(find.bySemanticsLabel(RegExp('Guía 1 de 2')), findsOneWidget);
    handle.dispose();
  });
}
