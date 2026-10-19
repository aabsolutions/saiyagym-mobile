import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saiyagym_mobile/features/plans/domain/entitlements.dart';
import 'package:saiyagym_mobile/features/plans/plans_providers.dart';
import 'package:saiyagym_mobile/features/plans/presentation/upgrade_sheet.dart';

/// Explains what the plan blocks and offers the upgrade.
///
/// Use it where a feature is off (`UpgradeCta.feature`), when a limit is
/// reached (`UpgradeCta.limit`), or straight from an API rejection
/// (`UpgradeReason.fromError`). Hiding UI is cosmetic: the API decides.
class UpgradeCta extends StatelessWidget {
  const UpgradeCta({required this.reason, this.compact = false, super.key});

  UpgradeCta.feature(PlanFeature feature, {bool compact = false, Key? key})
    : this(reason: FeatureRequired(feature), compact: compact, key: key);

  UpgradeCta.limit(PlanLimit limit, {int? max, bool compact = false, Key? key})
    : this(
        reason: LimitReached(limit, max: max),
        compact: compact,
        key: key,
      );

  final UpgradeReason reason;

  /// One-line banner instead of a card.
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final (title, message) = switch (reason) {
      FeatureRequired(:final feature) => (
        context.tr('plans.cta.featureTitle'),
        context.tr(
          'plans.cta.featureMessage',
          namedArgs: {'feature': context.tr('plans.features.${feature.name}')},
        ),
      ),
      LimitReached(:final limit, :final max) => (
        context.tr('plans.cta.limitTitle'),
        context.tr(
          max == null ? 'plans.cta.limitMessage' : 'plans.cta.limitMessageMax',
          namedArgs: {
            'resource': context.tr('plans.limits.${limit.name}'),
            'max': '${max ?? ''}',
          },
        ),
      ),
    };
    final button = FilledButton.tonalIcon(
      icon: const Icon(Icons.workspace_premium),
      label: Text(context.tr('plans.cta.action')),
      onPressed: () => showUpgradeSheet(context),
    );

    if (compact) {
      return ListTile(
        leading: Icon(Icons.lock_outline, color: scheme.primary),
        title: Text(title),
        subtitle: Text(message),
        trailing: IconButton(
          tooltip: context.tr('plans.cta.action'),
          icon: const Icon(Icons.chevron_right),
          onPressed: () => showUpgradeSheet(context),
        ),
        onTap: () => showUpgradeSheet(context),
      );
    }

    return Card(
      color: scheme.secondaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.lock_outline, color: scheme.onSecondaryContainer),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: scheme.onSecondaryContainer,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: scheme.onSecondaryContainer,
              ),
            ),
            const SizedBox(height: 16),
            button,
          ],
        ),
      ),
    );
  }
}

/// Shows [child] when the plan has [feature]; the CTA otherwise.
class PlanGate extends ConsumerWidget {
  const PlanGate({required this.feature, required this.child, super.key});

  final PlanFeature feature;
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allowed = ref.watch(
      entitlementsProvider.select((plan) => plan.has(feature)),
    );
    return allowed ? child : UpgradeCta.feature(feature);
  }
}
