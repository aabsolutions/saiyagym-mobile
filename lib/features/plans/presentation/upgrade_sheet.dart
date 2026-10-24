import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saiyagym_mobile/core/widgets/error_banner.dart';
import 'package:saiyagym_mobile/features/auth/presentation/controllers/session_controller.dart';
import 'package:saiyagym_mobile/features/plans/domain/entitlements.dart';
import 'package:saiyagym_mobile/features/plans/domain/plan.dart';
import 'package:saiyagym_mobile/features/plans/plans_providers.dart';

Future<void> showUpgradeSheet(BuildContext context) => showModalBottomSheet(
  context: context,
  isScrollControlled: true,
  showDragHandle: true,
  builder: (_) => const UpgradeSheet(),
);

/// Plan comparison. No payment gateway yet: an admin assigns plans, so the
/// sheet says so instead of a buy button (see `PaymentProvider`).
class UpgradeSheet extends ConsumerWidget {
  const UpgradeSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plans = ref.watch(availablePlansProvider);
    final currentCode = ref.watch(
      currentUserProvider.select((user) => user?.plan.code),
    );
    final payments = ref.watch(paymentProviderProvider);
    final theme = Theme.of(context);

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.75,
      maxChildSize: 0.95,
      builder: (context, scrollController) => ListView(
        controller: scrollController,
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
        children: [
          Text(
            context.tr('plans.sheet.title'),
            style: theme.textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          ...switch (plans) {
            AsyncData(:final value) => [
              for (final plan in value) ...[
                _PlanCard(plan: plan, isCurrent: plan.code == currentCode),
                const SizedBox(height: 12),
              ],
            ],
            AsyncError(:final error) => [ErrorBanner(error: error)],
            _ => [
              const Padding(
                padding: EdgeInsets.all(32),
                child: Center(child: CircularProgressIndicator()),
              ),
            ],
          },
          const SizedBox(height: 8),
          if (!payments.canPurchase)
            Text(
              context.tr('plans.sheet.manual'),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
        ],
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  const _PlanCard({required this.plan, required this.isCurrent});

  final Plan plan;
  final bool isCurrent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final entitlements = plan.entitlements;
    String limitText(PlanLimit limit) {
      final max = entitlements.limitOf(limit);
      return context.tr(
        max == null ? 'plans.sheet.unlimited' : 'plans.sheet.upTo',
        namedArgs: {
          'resource': context.tr('plans.limits.${limit.name}'),
          'max': '${max ?? ''}',
        },
      );
    }

    return Card(
      shape: isCurrent
          ? RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: theme.colorScheme.primary, width: 2),
            )
          : null,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(plan.name, style: theme.textTheme.titleLarge),
                ),
                if (isCurrent)
                  Chip(label: Text(context.tr('plans.sheet.current'))),
              ],
            ),
            if (plan.description.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(plan.description, style: theme.textTheme.bodyMedium),
            ],
            const SizedBox(height: 12),
            for (final limit in PlanLimit.values)
              _Benefit(text: limitText(limit), included: true),
            _Benefit(
              text: entitlements.statsHistoryDays == null
                  ? context.tr('plans.sheet.statsFull')
                  : context.tr(
                      'plans.sheet.statsDays',
                      namedArgs: {'days': '${entitlements.statsHistoryDays}'},
                    ),
              included: true,
            ),
            _Benefit(
              text: entitlements.guidesPerRoutine == null
                  ? context.tr('plans.sheet.guidesAll')
                  : context.tr(
                      'plans.sheet.guidesPerRoutine',
                      namedArgs: {'max': '${entitlements.guidesPerRoutine}'},
                    ),
              included: entitlements.guidesPerRoutine != 0,
            ),
            for (final feature in PlanFeature.values)
              _Benefit(
                text: context.tr('plans.features.${feature.name}'),
                included: entitlements.has(feature),
              ),
          ],
        ),
      ),
    );
  }
}

class _Benefit extends StatelessWidget {
  const _Benefit({required this.text, required this.included});

  final String text;
  final bool included;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            included ? Icons.check_circle : Icons.remove_circle_outline,
            color: included ? scheme.primary : scheme.outline,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: included ? null : scheme.outline),
            ),
          ),
        ],
      ),
    );
  }
}
