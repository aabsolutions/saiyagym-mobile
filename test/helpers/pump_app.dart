import 'dart:convert';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saiyagym_mobile/core/i18n/app_locales.dart';
import 'package:saiyagym_mobile/core/theme/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Pumps [child] under the real translations (assets/i18n, Spanish).
/// [child] is either a full app or, via [LocalizedTestApp], a single page.
Future<void> pumpLocalized(
  WidgetTester tester,
  Widget child, {
  List<Override> overrides = const [],
}) async {
  // A phone, not the default 800×600 landscape test surface.
  tester.view
    ..physicalSize = const Size(1080, 2340)
    ..devicePixelRatio = 3;
  addTearDown(tester.view.reset);

  SharedPreferences.setMockInitialValues({});
  EasyLocalization.logger.enableBuildModes = [];
  await EasyLocalization.ensureInitialized();

  await tester.pumpWidget(
    EasyLocalization(
      supportedLocales: AppLocales.supported,
      path: AppLocales.path,
      fallbackLocale: AppLocales.fallback,
      startLocale: AppLocales.fallback,
      useOnlyLangCode: true,
      saveLocale: false,
      assetLoader: const _SyncFileAssetLoader(),
      // A new key per pump: a mounted ProviderScope ignores new overrides.
      child: ProviderScope(
        key: UniqueKey(),
        overrides: overrides,
        child: child,
      ),
    ),
  );
  await tester.pumpAndSettle();
}

/// Reads the real `assets/i18n/*.json` with synchronous IO. The default
/// loader does real async IO through rootBundle, which races the fake test
/// clock (the first test of a file passes, the next ones don't). Not a
/// SynchronousFuture: easy_localization feeds it to Future.wait, which then
/// completes with an empty list.
class _SyncFileAssetLoader extends AssetLoader {
  const _SyncFileAssetLoader();

  @override
  Future<Map<String, dynamic>?> load(String path, Locale locale) async =>
      jsonDecode(File('$path/${locale.languageCode}.json').readAsStringSync())
          as Map<String, dynamic>;
}

/// Minimal localized MaterialApp to test one page in isolation.
class LocalizedTestApp extends StatelessWidget {
  const LocalizedTestApp({required this.home, super.key});

  final Widget home;

  @override
  Widget build(BuildContext context) => MaterialApp(
    theme: AppTheme.light(),
    locale: context.locale,
    supportedLocales: context.supportedLocales,
    localizationsDelegates: context.localizationDelegates,
    home: home,
  );
}
