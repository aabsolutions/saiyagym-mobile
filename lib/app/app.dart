import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saiyagym_mobile/app/router/app_router.dart';
import 'package:saiyagym_mobile/app/sync/sync_coordinator.dart';
import 'package:saiyagym_mobile/core/i18n/app_locales.dart';
import 'package:saiyagym_mobile/core/network/api_client.dart';
import 'package:saiyagym_mobile/core/theme/app_theme.dart';
import 'package:saiyagym_mobile/core/widgets/server_waking_banner.dart';
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
    final language = ref.read(requestLanguageProvider);
    final code = context.locale.languageCode;
    if (language.code == code) return;
    language.code = code;
    // The offline catalog is stored per language.
    ref.read(syncCoordinatorProvider.notifier).languageChanged();
  }

  @override
  Widget build(BuildContext context) {
    // The account's language wins after sign-in (set on another device).
    ref.listen(sessionControllerProvider, (_, next) {
      final language = next.value?.user.preferences.language;
      if (AppLocales.isSupported(language) &&
          language != context.locale.languageCode) {
        unawaited(context.setLocale(Locale(language!)));
      }
    });

    // Starts/stops sync with the session and owns its triggers.
    ref.watch(syncCoordinatorProvider);

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
      builder: (context, child) => ServerWakingBanner(
        slow: ref.watch(slowRequestMonitorProvider),
        child: child ?? const SizedBox.shrink(),
      ),
    );
  }
}
