import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:saiyagym_mobile/app/router/app_routes.dart';
import 'package:saiyagym_mobile/core/units/unit_formatter.dart';
import 'package:saiyagym_mobile/core/widgets/empty_state.dart';
import 'package:saiyagym_mobile/features/body_metrics/body_metrics_providers.dart';
import 'package:saiyagym_mobile/features/body_metrics/domain/body_metric.dart';
import 'package:saiyagym_mobile/features/profile/presentation/preferences_providers.dart';
import 'package:saiyagym_mobile/features/progress/progress_providers.dart';

/// Measurement history (newest first), from local data.
class BodyMetricsPage extends ConsumerWidget {
  const BodyMetricsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final metrics = ref.watch(bodyMetricsProvider).value;
    final formatter = ref.unitFormatter(context);
    final dateFormat = DateFormat.yMMMd(context.locale.toLanguageTag());

    return Scaffold(
      appBar: AppBar(title: Text(context.tr('body.title'))),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => unawaited(context.push(AppRoutes.newBodyMetric)),
        icon: const Icon(Icons.add),
        label: Text(context.tr('body.add')),
      ),
      body: switch (metrics) {
        null => const Center(child: CircularProgressIndicator()),
        [] => EmptyState(
          icon: Icons.straighten,
          title: context.tr('body.emptyTitle'),
          message: context.tr('body.emptyMessage'),
        ),
        final items => ListView.separated(
          padding: const EdgeInsets.only(bottom: 88),
          itemCount: items.length,
          separatorBuilder: (_, _) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final metric = items[index];
            return ListTile(
              title: Text(dateFormat.format(metric.measuredAt.toLocal())),
              subtitle: Text(_summary(context, formatter, metric)),
              onTap: () =>
                  unawaited(context.push(AppRoutes.bodyMetric(metric.id))),
              trailing: IconButton(
                tooltip: context.tr('common.delete'),
                icon: const Icon(Icons.delete_outline),
                onPressed: () => unawaited(_delete(context, ref, metric)),
              ),
            );
          },
        ),
      },
    );
  }

  static String _summary(
    BuildContext context,
    UnitFormatter formatter,
    BodyMetric metric,
  ) => [
    for (final measure in BodyMeasure.values)
      if (measure.of(metric) case final value?)
        _entry(context, formatter, measure, value),
  ].join(' · ');

  static String _entry(
    BuildContext context,
    UnitFormatter formatter,
    BodyMeasure measure,
    double value,
  ) {
    final shown = switch (measure.kind) {
      MeasureKind.weight => formatter.formatWeight(value),
      MeasureKind.length => formatter.formatLength(value),
      MeasureKind.percent => '${formatter.formatNumber(value)} %',
    };
    return '${context.tr('body.short.${measure.name}')} $shown';
  }

  Future<void> _delete(
    BuildContext context,
    WidgetRef ref,
    BodyMetric metric,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(context.tr('body.deleteTitle')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(context.tr('common.cancel')),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(context.tr('common.delete')),
          ),
        ],
      ),
    );
    if (confirmed ?? false) {
      await ref.read(bodyMetricsRepositoryProvider).delete(metric.id);
    }
  }
}
