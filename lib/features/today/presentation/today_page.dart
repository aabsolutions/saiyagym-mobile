import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saiyagym_mobile/core/widgets/primary_button.dart';
import 'package:saiyagym_mobile/core/widgets/sync_status_button.dart';
import 'package:saiyagym_mobile/features/live_workout/data/start_plans.dart';
import 'package:saiyagym_mobile/features/live_workout/domain/live_session.dart';
import 'package:saiyagym_mobile/features/live_workout/live_workout_providers.dart';
import 'package:saiyagym_mobile/features/live_workout/presentation/live_workout_controller.dart';
import 'package:saiyagym_mobile/features/live_workout/presentation/start_session.dart';

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
