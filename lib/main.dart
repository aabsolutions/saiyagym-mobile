import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saiyagym_mobile/app/app.dart';
import 'package:saiyagym_mobile/core/config/app_config.dart';
import 'package:saiyagym_mobile/core/i18n/app_locales.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  final config = AppConfig.resolve(
    flavorName: appFlavor ?? const String.fromEnvironment('FLAVOR'),
  );

  runApp(
    EasyLocalization(
      supportedLocales: AppLocales.supported,
      path: AppLocales.path,
      fallbackLocale: AppLocales.fallback,
      useOnlyLangCode: true,
      child: ProviderScope(
        overrides: [appConfigProvider.overrideWithValue(config)],
        child: const SaiyaGymApp(),
      ),
    ),
  );
}
