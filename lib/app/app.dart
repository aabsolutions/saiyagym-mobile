import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saiyagym_mobile/app/router/app_router.dart';
import 'package:saiyagym_mobile/core/i18n/app_locales.dart';
import 'package:saiyagym_mobile/core/network/api_client.dart';
import 'package:saiyagym_mobile/core/theme/app_theme.dart';
import 'package:saiyagym_mobile/features/auth/presentation/controllers/session_controller.dart';
import 'package:saiyagym_mobile/features/profile/presentation/preferences_providers.dart';

class SaiyaGymApp extends ConsumerStatefulWidget {
  const SaiyaGymApp({super.key});

  @override
  ConsumerState<SaiyaGymApp> createState() => _SaiyaGymAppState();
}

class _SaiyaGymAppState extends ConsumerState<SaiyaGymApp> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Runs on every locale change (EasyLocalization is an inherited widget).
    ref.read(requestLanguageProvider).code = context.locale.languageCode;
  }

  @override
  Widget build(BuildContext context) {
    // The account's language wins after sign-in (set on another device).
    ref.listen(sessionControllerProvider, (_, next) {
      final language = next.value?.preferences.language;
      if (AppLocales.isSupported(language) &&
          language != context.locale.languageCode) {
        unawaited(context.setLocale(Locale(language!)));
      }
    });

    return MaterialApp.router(
      onGenerateTitle: (context) => context.tr('app.name'),
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ref.watch(themeModeProvider),
      routerConfig: ref.watch(appRouterProvider),
      locale: context.locale,
      supportedLocales: context.supportedLocales,
      localizationsDelegates: context.localizationDelegates,
    );
  }
}
