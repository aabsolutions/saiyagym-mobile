import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:saiyagym_mobile/app/router/app_routes.dart';
import 'package:saiyagym_mobile/core/widgets/cached_view.dart';
import 'package:saiyagym_mobile/core/widgets/sync_status_button.dart';
import 'package:saiyagym_mobile/features/body_metrics/domain/body_metric.dart';
import 'package:saiyagym_mobile/features/body_metrics/presentation/quick_weight_sheet.dart';
import 'package:saiyagym_mobile/features/exercises/exercises_providers.dart';
import 'package:saiyagym_mobile/features/plans/domain/entitlements.dart';
import 'package:saiyagym_mobile/features/plans/plans_providers.dart';
import 'package:saiyagym_mobile/features/plans/presentation/upgrade_cta.dart';
import 'package:saiyagym_mobile/features/profile/presentation/preferences_providers.dart';
import 'package:saiyagym_mobile/features/progress/domain/progress_stats.dart';
import 'package:saiyagym_mobile/features/progress/presentation/widgets/progress_charts.dart';
import 'package:saiyagym_mobile/features/progress/progress_providers.dart';
import 'package:saiyagym_mobile/features/reminders/presentation/weigh_in_prompt.dart';

/// Charts (API stats with a local copy; body weight from local data),
/// records, measurements and photos.
class ProgressPage extends ConsumerWidget {
  const ProgressPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plan = ref.watch(entitlementsProvider);
    final days = plan.statsHistoryDays;

    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('progress.title')),
        actions: const [SyncStatusButton()],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref
            ..invalidate(exerciseProgressProvider)
            ..invalidate(muscleVolumeProvider)
            ..invalidate(powerliftingTotalProvider);
          try {
            await ref.read(muscleVolumeProvider.future);
          } on Object {
            // Each card shows its own error.
          }
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const _BodyWeightCard(),
            const _ExerciseProgressCard(),
            const _MuscleVolumeCard(),
            const _PowerliftingCard(),
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.emoji_events_outlined),
                    title: Text(context.tr('records.title')),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => unawaited(context.push(AppRoutes.records)),
                  ),
                  ListTile(
                    leading: const Icon(Icons.straighten),
                    title: Text(context.tr('body.title')),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => unawaited(context.push(AppRoutes.bodyMetrics)),
                  ),
                  ListTile(
                    leading: const Icon(Icons.photo_camera_outlined),
                    title: Text(context.tr('photos.title')),
                    trailing: plan.has(PlanFeature.progressPhotos)
                        ? const Icon(Icons.chevron_right)
                        : const Icon(Icons.workspace_premium_outlined),
                    onTap: () =>
                        unawaited(context.push(AppRoutes.progressPhotos)),
                  ),
                ],
              ),
            ),
            // Free stats are limited server-side (statsWindow); explain it.
            if (!plan.has(PlanFeature.fullStats)) ...[
              const SizedBox(height: 16),
              if (days != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    context.tr('progress.window', namedArgs: {'days': '$days'}),
                    textAlign: TextAlign.center,
                  ),
                ),
              UpgradeCta.feature(PlanFeature.fullStats),
            ],
          ],
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.child, this.action});

  final String title;
  final Widget child;
  final Widget? action;

  @override
  Widget build(BuildContext context) => Card(
    margin: const EdgeInsets.only(bottom: 16),
    child: Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              ?action,
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    ),
  );
}

class _BodyWeightCard extends ConsumerWidget {
  const _BodyWeightCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formatter = ref.unitFormatter(context);
    final weights = [
      for (final metric
          in (ref.watch(bodyMetricsProvider).value ?? const <BodyMetric>[]))
        if (metric.weightKg case final kg?)
          ChartPoint(metric.measuredAt, formatter.displayWeight(kg)),
    ].reversed.toList();
    final latest = weights.lastOrNull;

    return _SectionCard(
      title: context.tr('progress.bodyWeight'),
      action: latest == null
          ? null
          : Text(
              '${formatter.formatNumber(latest.value)} ${formatter.weightUnit}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TrendChart(
            points: weights,
            format: (v) =>
                '${formatter.formatNumber(v)} ${formatter.weightUnit}',
            emptyText: context.tr('progress.noWeight'),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: FilledButton.tonalIcon(
                  icon: const Icon(Icons.monitor_weight_outlined),
                  label: Text(context.tr('body.quick')),
                  onPressed: () async {
                    final saved = await showQuickWeightSheet(
                      context,
                      lastKg: latest == null
                          ? null
                          : formatter.weightToKg(latest.value),
                    );
                    // Right after weighing in: the moment to offer a
                    // weekly reminder (and its permission).
                    if (saved && context.mounted) {
                      await offerWeighInReminder(context, ref);
                    }
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton(
                  onPressed: () =>
                      unawaited(context.push(AppRoutes.newBodyMetric)),
                  child: Text(
                    context.tr('body.full'),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

enum _ExerciseMetric { maxWeight, e1rm }

class _ExerciseProgressCard extends ConsumerStatefulWidget {
  const _ExerciseProgressCard();

  @override
  ConsumerState<_ExerciseProgressCard> createState() =>
      _ExerciseProgressCardState();
}

class _ExerciseProgressCardState extends ConsumerState<_ExerciseProgressCard> {
  String? _exerciseId;
  _ExerciseMetric _metric = _ExerciseMetric.maxWeight;

  @override
  Widget build(BuildContext context) {
    final trained = ref.watch(trainedExercisesProvider).value ?? const [];
    final names = ref.watch(exerciseNamesProvider);
    final formatter = ref.unitFormatter(context);
    final selected = trained.contains(_exerciseId)
        ? _exerciseId
        : trained.firstOrNull;

    return _SectionCard(
      title: context.tr('progress.exercise'),
      child: selected == null
          ? Text(context.tr('progress.noTraining'))
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                DropdownButton<String>(
                  isExpanded: true,
                  value: selected,
                  items: [
                    for (final id in trained)
                      DropdownMenuItem(
                        value: id,
                        child: Text(
                          names[id] ?? '…',
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                  ],
                  onChanged: (id) => setState(() => _exerciseId = id),
                ),
                const SizedBox(height: 8),
                SegmentedButton<_ExerciseMetric>(
                  showSelectedIcon: false,
                  segments: [
                    ButtonSegment(
                      value: _ExerciseMetric.maxWeight,
                      label: Text(context.tr('progress.maxWeight')),
                    ),
                    ButtonSegment(
                      value: _ExerciseMetric.e1rm,
                      label: Text(context.tr('progress.e1rm')),
                    ),
                  ],
                  selected: {_metric},
                  onSelectionChanged: (value) =>
                      setState(() => _metric = value.single),
                ),
                const SizedBox(height: 12),
                CachedView(
                  value: ref.watch(exerciseProgressProvider(selected)),
                  onRetry: () =>
                      ref.invalidate(exerciseProgressProvider(selected)),
                  builder: (data) => TrendChart(
                    points: [
                      for (final point in data.points)
                        if (switch (_metric) {
                              _ExerciseMetric.maxWeight => point.maxWeightKg,
                              _ExerciseMetric.e1rm => point.bestE1RM,
                            }
                            case final kg? when kg > 0)
                          ChartPoint(
                            localDay(point.date),
                            formatter.displayWeight(kg),
                          ),
                    ],
                    format: (v) =>
                        '${formatter.formatNumber(v)} ${formatter.weightUnit}',
                  ),
                ),
              ],
            ),
    );
  }
}

class _MuscleVolumeCard extends ConsumerStatefulWidget {
  const _MuscleVolumeCard();

  @override
  ConsumerState<_MuscleVolumeCard> createState() => _MuscleVolumeCardState();
}

class _MuscleVolumeCardState extends ConsumerState<_MuscleVolumeCard> {
  static const _weeksShown = 12;
  String? _muscle;
  bool _sets = true;

  @override
  Widget build(BuildContext context) {
    final formatter = ref.unitFormatter(context);
    return _SectionCard(
      title: context.tr('progress.muscleVolume'),
      child: CachedView(
        value: ref.watch(muscleVolumeProvider),
        onRetry: () => ref.invalidate(muscleVolumeProvider),
        builder: (data) {
          final muscles = data.muscles;
          if (muscles.isEmpty) return Text(context.tr('progress.noTraining'));
          final muscle = muscles.contains(_muscle) ? _muscle! : muscles.first;
          final weeks = data.weeks;
          final series = data.seriesOf(muscle);
          final from = weeks.length > _weeksShown
              ? weeks.length - _weeksShown
              : 0;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SegmentedButton<bool>(
                showSelectedIcon: false,
                style: const ButtonStyle(visualDensity: VisualDensity.compact),
                segments: [
                  ButtonSegment(
                    value: true,
                    label: Text(context.tr('progress.sets')),
                  ),
                  ButtonSegment(
                    value: false,
                    label: Text(context.tr('progress.volume')),
                  ),
                ],
                selected: {_sets},
                onSelectionChanged: (value) =>
                    setState(() => _sets = value.single),
              ),
              const SizedBox(height: 8),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for (final m in muscles)
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(context.tr('muscles.$m')),
                          selected: m == muscle,
                          onSelected: (_) => setState(() => _muscle = m),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              WeeklyBarChart(
                weeks: [for (final w in weeks.sublist(from)) localDay(w)],
                values: [
                  for (final row in series.sublist(from))
                    if (_sets)
                      (row?.sets ?? 0).toDouble()
                    else
                      formatter.displayWeight(row?.volumeKg ?? 0),
                ],
                format: (v) => _sets
                    ? context.tr(
                        'progress.setsValue',
                        namedArgs: {'count': formatter.formatNumber(v)},
                      )
                    : '${formatter.formatNumber(v)} ${formatter.weightUnit}',
              ),
            ],
          );
        },
      ),
    );
  }
}

class _PowerliftingCard extends ConsumerStatefulWidget {
  const _PowerliftingCard();

  @override
  ConsumerState<_PowerliftingCard> createState() => _PowerliftingCardState();
}

class _PowerliftingCardState extends ConsumerState<_PowerliftingCard> {
  PowerliftingMetric _metric = PowerliftingMetric.e1rm;

  @override
  Widget build(BuildContext context) {
    final formatter = ref.unitFormatter(context);
    String weight(double v) =>
        '${formatter.formatNumber(v)} ${formatter.weightUnit}';

    return _SectionCard(
      title: context.tr('progress.powerlifting'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SegmentedButton<PowerliftingMetric>(
            showSelectedIcon: false,
            segments: [
              ButtonSegment(
                value: PowerliftingMetric.e1rm,
                label: Text(context.tr('progress.e1rm')),
              ),
              ButtonSegment(
                value: PowerliftingMetric.maxWeight,
                label: Text(context.tr('progress.maxWeight')),
              ),
            ],
            selected: {_metric},
            onSelectionChanged: (value) =>
                setState(() => _metric = value.single),
          ),
          const SizedBox(height: 12),
          CachedView(
            value: ref.watch(powerliftingTotalProvider(_metric)),
            onRetry: () => ref.invalidate(powerliftingTotalProvider(_metric)),
            builder: (data) {
              final points = [
                for (final p in data.points)
                  if (p.total case final total?)
                    ChartPoint(
                      localDay(p.weekStart),
                      formatter.displayWeight(total),
                    ),
              ];
              final last = data.points.lastOrNull;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (data.bestTotal case final best?)
                    Text(
                      context.tr(
                        'progress.bestTotal',
                        namedArgs: {'total': formatter.formatWeight(best)},
                      ),
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  TrendChart(
                    points: points,
                    format: weight,
                    emptyText: context.tr('progress.noTotal'),
                  ),
                  if (last != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Wrap(
                        spacing: 8,
                        children: [
                          for (final (key, kg) in [
                            ('squat', last.squat),
                            ('bench', last.bench),
                            ('deadlift', last.deadlift),
                          ])
                            Chip(
                              label: Text(
                                context.tr(
                                  'progress.liftValue',
                                  namedArgs: {
                                    'lift': context.tr('progress.lifts.$key'),
                                    'value': kg == null
                                        ? '–'
                                        : formatter.formatWeight(kg),
                                  },
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
