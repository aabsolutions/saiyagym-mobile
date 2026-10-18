import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saiyagym_mobile/core/i18n/app_locales.dart';
import 'package:saiyagym_mobile/core/units/unit_formatter.dart';
import 'package:saiyagym_mobile/core/widgets/error_banner.dart';
import 'package:saiyagym_mobile/features/auth/domain/entities/user.dart';
import 'package:saiyagym_mobile/features/auth/presentation/controllers/session_controller.dart';
import 'package:saiyagym_mobile/features/profile/presentation/preferences_providers.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(sessionControllerProvider).value;
    if (user == null) return const SizedBox.shrink();

    ref.listen(preferencesControllerProvider, (_, next) {
      if (next case AsyncError(:final error)) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(errorText(context, error))));
      }
    });
    final saving = ref.watch(preferencesControllerProvider).isLoading;
    final preferences = ref.read(preferencesControllerProvider.notifier);
    final formatter = ref.unitFormatter(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('profile.title')),
        bottom: saving
            ? const PreferredSize(
                preferredSize: Size.fromHeight(4),
                child: LinearProgressIndicator(),
              )
            : null,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _UserCard(user: user),
          const SizedBox(height: 24),
          _SectionTitle(context.tr('profile.units')),
          SegmentedButton<UnitSystem>(
            segments: [
              ButtonSegment(
                value: UnitSystem.metric,
                label: Text(context.tr('profile.metric')),
              ),
              ButtonSegment(
                value: UnitSystem.imperial,
                label: Text(context.tr('profile.imperial')),
              ),
            ],
            selected: {user.preferences.units},
            onSelectionChanged: saving
                ? null
                : (value) => preferences.save(units: value.single),
          ),
          const SizedBox(height: 8),
          Text(
            context.tr(
              'profile.unitsExample',
              namedArgs: {
                'weight': formatter.formatWeight(100),
                'length': formatter.formatLength(180),
              },
            ),
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),
          _SectionTitle(context.tr('profile.theme')),
          SegmentedButton<ThemePreference>(
            segments: [
              for (final option in ThemePreference.values)
                ButtonSegment(
                  value: option,
                  label: Text(context.tr('profile.themes.${option.name}')),
                ),
            ],
            selected: {user.preferences.theme},
            onSelectionChanged: saving
                ? null
                : (value) => preferences.save(theme: value.single),
          ),
          const SizedBox(height: 24),
          _SectionTitle(context.tr('profile.language')),
          DropdownMenu<String>(
            expandedInsets: EdgeInsets.zero,
            enabled: !saving,
            initialSelection: context.locale.languageCode,
            dropdownMenuEntries: [
              for (final language in AppLocales.languages)
                DropdownMenuEntry(
                  value: language.code,
                  label: language.nativeName,
                ),
            ],
            onSelected: (code) async {
              if (code == null || code == context.locale.languageCode) return;
              // UI switches immediately; the API keeps it for other devices.
              await context.setLocale(Locale(code));
              await preferences.save(language: code);
            },
          ),
          const SizedBox(height: 40),
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              foregroundColor: theme.colorScheme.error,
              side: BorderSide(color: theme.colorScheme.error),
            ),
            icon: const Icon(Icons.logout),
            label: Text(context.tr('profile.logout')),
            onPressed: () => _confirmLogout(context, ref),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmLogout(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(dialogContext.tr('profile.logoutConfirm.title')),
        content: Text(dialogContext.tr('profile.logoutConfirm.message')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(dialogContext.tr('common.cancel')),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(dialogContext.tr('profile.logout')),
          ),
        ],
      ),
    );
    if (confirmed ?? false) {
      await ref.read(sessionControllerProvider.notifier).logout();
    }
  }
}

class _UserCard extends StatelessWidget {
  const _UserCard({required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final name = user.name;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: theme.colorScheme.primaryContainer,
              child: Icon(
                Icons.person,
                size: 32,
                color: theme.colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (name != null && name.isNotEmpty)
                    Text(name, style: theme.textTheme.titleMedium),
                  Text(user.email, style: theme.textTheme.bodyMedium),
                  const SizedBox(height: 8),
                  Chip(
                    avatar: const Icon(Icons.workspace_premium, size: 18),
                    label: Text(
                      context.tr(
                        'profile.plan',
                        namedArgs: {'plan': user.plan.name},
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(text, style: Theme.of(context).textTheme.titleMedium),
    );
  }
}
