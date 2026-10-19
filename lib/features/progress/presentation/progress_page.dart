import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saiyagym_mobile/core/widgets/empty_state.dart';
import 'package:saiyagym_mobile/features/plans/domain/entitlements.dart';
import 'package:saiyagym_mobile/features/plans/plans_providers.dart';
import 'package:saiyagym_mobile/features/plans/presentation/upgrade_cta.dart';

class ProgressPage extends ConsumerWidget {
  const ProgressPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plan = ref.watch(entitlementsProvider);
    final days = plan.statsHistoryDays;

    return Scaffold(
      appBar: AppBar(title: Text(context.tr('progress.title'))),
      body: Column(
        children: [
          Expanded(
            child: EmptyState(
              icon: Icons.insights,
              title: context.tr('progress.emptyTitle'),
              message: context.tr('progress.emptyMessage'),
            ),
          ),
          // Free stats are limited server-side (statsWindow); explain it.
          if (!plan.has(PlanFeature.fullStats))
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  if (days != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Text(
                        context.tr(
                          'progress.window',
                          namedArgs: {'days': '$days'},
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  UpgradeCta.feature(PlanFeature.fullStats),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
