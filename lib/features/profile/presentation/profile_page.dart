import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:saiyagym_mobile/app/router/app_routes.dart';
import 'package:saiyagym_mobile/core/i18n/app_locales.dart';
import 'package:saiyagym_mobile/core/sync/unsynced_changes.dart';
import 'package:saiyagym_mobile/core/units/unit_formatter.dart';
import 'package:saiyagym_mobile/core/widgets/error_banner.dart';
import 'package:saiyagym_mobile/core/widgets/sync_status_button.dart';
import 'package:saiyagym_mobile/features/auth/domain/entities/user.dart';
import 'package:saiyagym_mobile/features/auth/presentation/controllers/session_controller.dart';
import 'package:saiyagym_mobile/features/live_workout/presentation/widgets/training_settings_section.dart';
import 'package:saiyagym_mobile/features/plans/domain/entitlements.dart';
import 'package:saiyagym_mobile/features/plans/plans_providers.dart';
import 'package:saiyagym_mobile/features/plans/presentation/upgrade_cta.dart';
import 'package:saiyagym_mobile/features/profile/domain/profile_repository.dart';
import 'package:saiyagym_mobile/features/profile/presentation/preferences_providers.dart';
import 'package:saiyagym_mobile/features/profile/presentation/widgets/profile_fields.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    if (user == null) return const SizedBox.shrink();

    ref.listen(profileSaveControllerProvider, (_, next) {
      if (next case AsyncError(:final error)) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(errorText(context, error))));
      }
    });
    final saving = ref.watch(profileSaveControllerProvider).isLoading;
    final save = ref.read(profileSaveControllerProvider.notifier);
    final premium = ref.watch(
      entitlementsProvider.select((plan) => plan.has(PlanFeature.fullStats)),
    );
    final formatter = ref.unitFormatter(context);
    final preferences = user.preferences;

    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('profile.title')),
        actions: const [SyncStatusButton()],
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
          if (!premium) ...[
            const SizedBox(height: 12),
            UpgradeCta.feature(PlanFeature.fullStats, compact: true),
          ],
          _SectionTitle(context.tr('profile.data')),
          Card(
            child: Column(
              children: [
                _InfoTile(
                  icon: Icons.signal_cellular_alt,
                  label: context.tr('profile.level'),
                  value: _name(
                    context,
                    'profile.levels',
                    user.profile.level?.name,
                    suffix: '.title',
                  ),
                ),
                _InfoTile(
                  icon: Icons.flag_outlined,
                  label: context.tr('profile.goal'),
                  value: _name(
                    context,
                    'profile.goals',
                    user.profile.goal?.name,
                    suffix: '.title',
                  ),
                ),
                _InfoTile(
                  icon: Icons.height,
                  label: context.tr('profile.height'),
                  value: user.profile.heightCm == null
                      ? null
                      : formatter.formatLength(user.profile.heightCm!),
                ),
                _InfoTile(
                  icon: Icons.cake_outlined,
                  label: context.tr('profile.birthDate'),
                  value: user.profile.birthDate == null
                      ? null
                      : DateFormat.yMMMd(context.locale.languageCode)
                            .format(user.profile.birthDate!),
                ),
                ListTile(
                  leading: const Icon(Icons.edit_outlined),
                  title: Text(context.tr('profile.edit.title')),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.go(AppRoutes.editProfile),
                ),
              ],
            ),
          ),
          _SectionTitle(context.tr('profile.units')),
          SegmentedButton<UnitSystem>(
            segments: [
              for (final units in UnitSystem.values)
                ButtonSegment(
                  value: units,
                  label: Text(context.tr('profile.unitSystems.${units.name}')),
                ),
            ],
            selected: {preferences.units},
            onSelectionChanged: saving
                ? null
                : (value) => save.savePreferences(
                    PreferencesUpdate(units: value.single),
                  ),
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
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          _SectionTitle(context.tr('profile.theme')),
          SegmentedButton<ThemePreference>(
            segments: [
              for (final option in ThemePreference.values)
                ButtonSegment(
                  value: option,
                  label: Text(context.tr('profile.themes.${option.name}')),
                ),
            ],
            selected: {preferences.theme},
            onSelectionChanged: saving
                ? null
                : (value) => save.savePreferences(
                    PreferencesUpdate(theme: value.single),
                  ),
          ),
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
              await save.savePreferences(PreferencesUpdate(language: code));
            },
          ),
          _SectionTitle(context.tr('profile.rest')),
          RestSelector(
            seconds: preferences.defaultRestSeconds,
            onSelected: (seconds) {
              if (saving) return;
              unawaited(
                save.savePreferences(
                  PreferencesUpdate(defaultRestSeconds: seconds),
                ),
              );
            },
          ),
          const TrainingSettingsSection(),
          const SizedBox(height: 40),
          const _LogoutButton(),
        ],
      ),
    );
  }

  static String? _name(
    BuildContext context,
    String prefix,
    String? value, {
    String suffix = '',
  }) => value == null ? null : context.tr('$prefix.$value$suffix');
}

class _LogoutButton extends ConsumerWidget {
  const _LogoutButton();

  Future<void> _logout(BuildContext context, WidgetRef ref) async {
    final pending = await ref.read(unsyncedChangesProvider).count();
    if (!context.mounted) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => LogoutDialog(unsyncedChanges: pending),
    );
    if (confirmed ?? false) {
      await ref.read(sessionControllerProvider.notifier).logout();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    return OutlinedButton.icon(
      style: OutlinedButton.styleFrom(
        foregroundColor: scheme.error,
        side: BorderSide(color: scheme.error),
      ),
      icon: const Icon(Icons.logout),
      label: Text(context.tr('profile.logout')),
      onPressed: () => _logout(context, ref),
    );
  }
}

/// Logout wipes this device's data: say so, louder when work would be lost.
class LogoutDialog extends StatelessWidget {
  const LogoutDialog({required this.unsyncedChanges, super.key});

  final int unsyncedChanges;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final risky = unsyncedChanges > 0;
    return AlertDialog(
      icon: risky ? Icon(Icons.warning_amber, color: scheme.error) : null,
      title: Text(context.tr('profile.logoutConfirm.title')),
      content: Text(
        risky
            ? context.tr(
                'profile.logoutConfirm.unsynced',
                namedArgs: {'count': '$unsyncedChanges'},
              )
            : context.tr('profile.logoutConfirm.message'),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(context.tr('common.cancel')),
        ),
        FilledButton(
          style: risky
              ? FilledButton.styleFrom(
                  backgroundColor: scheme.error,
                  foregroundColor: scheme.onError,
                )
              : null,
          onPressed: () => Navigator.pop(context, true),
          child: Text(
            context.tr(
              risky ? 'profile.logoutConfirm.discard' : 'profile.logout',
            ),
          ),
        ),
      ],
    );
  }
}

class _UserCard extends StatelessWidget {
  const _UserCard({required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final name = user.profile.name;
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

class _InfoTile extends StatelessWidget {
  const _InfoTile({required this.icon, required this.label, this.value});

  final IconData icon;
  final String label;
  final String? value;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      trailing: Text(
        value ?? context.tr('profile.notSet'),
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          color: value == null ? Theme.of(context).colorScheme.outline : null,
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
      padding: const EdgeInsets.only(top: 24, bottom: 12),
      child: Text(text, style: Theme.of(context).textTheme.titleMedium),
    );
  }
}
