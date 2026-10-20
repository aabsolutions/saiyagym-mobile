import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:saiyagym_mobile/app/router/app_routes.dart';
import 'package:saiyagym_mobile/core/i18n/app_locales.dart';
import 'package:saiyagym_mobile/core/widgets/app_logo.dart';

/// First screen when signed out.
class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  static const List<(IconData, String)> _highlights = [
    (Icons.touch_app_outlined, 'welcome.highlights.log'),
    (Icons.cloud_off_outlined, 'welcome.highlights.offline'),
    (Icons.insights_outlined, 'welcome.highlights.progress'),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                const Align(
                  alignment: Alignment.centerRight,
                  child: _LanguageButton(),
                ),
                const SizedBox(height: 8),
                const Center(child: AppLogo()),
                const SizedBox(height: 24),
                Text(
                  context.tr('app.name'),
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  context.tr('welcome.tagline'),
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 32),
                for (final (icon, key) in _highlights)
                  ListTile(
                    leading: Icon(icon, color: scheme.primary, size: 28),
                    title: Text(context.tr(key)),
                  ),
              ],
            ),
          ),
        ),
      ),
      // Always on screen, whatever the phone size or text scale.
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FilledButton(
                onPressed: () => context.go(AppRoutes.register),
                child: Text(context.tr('welcome.createAccount')),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () => context.go(AppRoutes.login),
                child: Text(context.tr('welcome.haveAccount')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LanguageButton extends StatelessWidget {
  const _LanguageButton();

  @override
  Widget build(BuildContext context) {
    final current = context.locale.languageCode;
    return PopupMenuButton<AppLanguage>(
      tooltip: context.tr('profile.language'),
      initialValue: AppLocales.languages
          .where((language) => language.code == current)
          .firstOrNull,
      onSelected: (language) => context.setLocale(language.locale),
      itemBuilder: (_) => [
        for (final language in AppLocales.languages)
          PopupMenuItem(value: language, child: Text(language.nativeName)),
      ],
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.language),
            const SizedBox(width: 8),
            Text(current.toUpperCase()),
          ],
        ),
      ),
    );
  }
}
