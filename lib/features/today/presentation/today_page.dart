import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saiyagym_mobile/core/widgets/primary_button.dart';
import 'package:saiyagym_mobile/core/widgets/sync_status_button.dart';
import 'package:saiyagym_mobile/features/exercises/exercises_providers.dart';
import 'package:saiyagym_mobile/features/live_workout/data/start_plans.dart';
import 'package:saiyagym_mobile/features/live_workout/domain/live_session.dart';
import 'package:saiyagym_mobile/features/live_workout/live_workout_providers.dart';
import 'package:saiyagym_mobile/features/live_workout/presentation/live_workout_controller.dart';
import 'package:saiyagym_mobile/features/live_workout/presentation/start_session.dart';
import 'package:saiyagym_mobile/features/profile/presentation/preferences_providers.dart';
import 'package:saiyagym_mobile/features/records/domain/personal_records.dart';
import 'package:saiyagym_mobile/features/stats/stats_providers.dart';

/// Today's program day (with its target weights), or an empty session.
class TodayPage extends ConsumerWidget {
  const TodayPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final today = ref.watch(todayPlanProvider);
    final running = ref.watch(liveWorkoutControllerProvider) != null;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('today.title')),
        actions: const [SyncStatusButton()],
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(todayPlanProvider.future),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          children: [
            switch (today) {
              AsyncData(:final value) => _TodayCard(
                plan: value,
                running: running,
              ),
              AsyncError() => _InfoCard(
                icon: Icons.event_busy,
                title: context.tr('today.noProgramTitle'),
                message: context.tr('today.noProgramMessage'),
              ),
              _ => const Padding(
                padding: EdgeInsets.all(32),
                child: Center(child: CircularProgressIndicator()),
              ),
            },
            const SizedBox(height: 16),
            const _WeekCard(),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              icon: const Icon(Icons.add),
              label: Text(context.tr('today.emptyWorkout')),
              onPressed: () =>
                  startSession(context, ref, const StartPlan.empty()),
            ),
            const SizedBox(height: 8),
            Text(
              context.tr('today.emptyWorkoutHint'),
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TodayCard extends ConsumerWidget {
  const _TodayCard({required this.plan, required this.running});

  final TodayPlan plan;
  final bool running;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return switch (plan) {
      ProgramTrainingDay(
        :final programName,
        :final plan,
        :final week,
        :final isDeloadWeek,
        :final dayLabel,
        :final offline,
      ) =>
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.tr(
                    'today.programWeek',
                    namedArgs: {'program': programName, 'week': '$week'},
                  ),
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                const SizedBox(height: 4),
                Text(
                  dayLabel ?? plan.name,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                if (dayLabel != null) Text(plan.name),
                const SizedBox(height: 8),
                Text(
                  context.tr(
                    'today.exercises',
                    namedArgs: {'count': '${plan.exercises.length}'},
                  ),
                ),
                if (isDeloadWeek)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Chip(label: Text(context.tr('today.deload'))),
                  ),
                if (offline)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      context.tr('today.offlineTargets'),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                const SizedBox(height: 16),
                PrimaryButton(
                  label: context.tr(running ? 'live.resume' : 'today.start'),
                  onPressed: () => startSession(context, ref, plan),
                ),
              ],
            ),
          ),
        ),
      ProgramRestDay(:final programName) => _InfoCard(
        icon: Icons.bedtime_outlined,
        title: context.tr('today.restTitle'),
        message: context.tr(
          'today.restMessage',
          namedArgs: {'program': programName},
        ),
      ),
      ProgramNotRunning(:final programName, :final startsInDays) => _InfoCard(
        icon: Icons.event_outlined,
        title: programName,
        message: startsInDays == null
            ? context.tr('today.programFinished')
            : context.tr(
                'today.programStarts',
                namedArgs: {'days': '$startsInDays'},
              ),
      ),
      NoActiveProgram() => _InfoCard(
        icon: Icons.event_busy,
        title: context.tr('today.noProgramTitle'),
        message: context.tr('today.noProgramMessage'),
      ),
    };
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.icon,
    required this.title,
    required this.message,
  });

  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) => Card(
    child: ListTile(
      contentPadding: const EdgeInsets.all(20),
      leading: Icon(icon, size: 36),
      title: Text(title),
      subtitle: Text(message),
    ),
  );
}

/// Weekly streak, this week's totals and the latest record (local data).
class _WeekCard extends ConsumerWidget {
  const _WeekCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(todayStatsProvider).value;
    if (stats == null) return const SizedBox.shrink();
    final formatter = ref.unitFormatter(context);
    final theme = Theme.of(context);
    final week = stats.summary.week;
    final last = stats.lastRecord;
    final names = ref.watch(exerciseNamesProvider);

    Widget stat(IconData icon, String value, String label) => Expanded(
      child: Column(
        children: [
          Icon(icon, color: theme.colorScheme.primary),
          const SizedBox(height: 4),
          Text(value, style: theme.textTheme.titleLarge),
          Text(
            label,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium,
          ),
        ],
      ),
    );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.tr('today.week.title'),
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                stat(
                  Icons.local_fire_department,
                  '${stats.summary.streakWeeks}',
                  context.tr('today.week.streak'),
                ),
                stat(
                  Icons.event_available,
                  '${week.sessions}',
                  context.tr('today.week.sessions'),
                ),
                stat(
                  Icons.fitness_center,
                  formatter.formatWeight(week.volumeKg.roundToDouble()),
                  context.tr('live.stats.volume'),
                ),
              ],
            ),
            if (last != null) ...[
              const Divider(height: 32),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(
                  Icons.emoji_events,
                  color: theme.colorScheme.tertiary,
                  size: 32,
                ),
                title: Text(context.tr('today.week.lastRecord')),
                subtitle: Text(
                  [
                    names[last.records.first.exerciseId] ?? '',
                    DateFormat.MMMd(context.locale.languageCode)
                        .format(last.workout.startedAt.toLocal()),
                  ].where((s) => s.isNotEmpty).join(' · '),
                ),
                trailing: Text(
                  last.records.first.record.type == RecordType.repsAtWeight
                      ? context.tr(
                          'history.repsOnly',
                          namedArgs: {
                            'reps':
                                '${last.records.first.record.value.round()}',
                          },
                        )
                      : formatter.formatWeight(last.records.first.record.value),
                  style: theme.textTheme.titleMedium,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
