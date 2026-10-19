import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saiyagym_mobile/core/feedback/haptics.dart';
import 'package:saiyagym_mobile/core/training/training_types.dart';
import 'package:saiyagym_mobile/core/units/unit_formatter.dart';
import 'package:saiyagym_mobile/features/exercises/domain/exercise.dart';
import 'package:saiyagym_mobile/features/exercises/exercises_providers.dart';
import 'package:saiyagym_mobile/features/exercises/presentation/exercises_page.dart';
import 'package:saiyagym_mobile/features/profile/presentation/preferences_providers.dart';
import 'package:saiyagym_mobile/features/records/data/records_service.dart';
import 'package:saiyagym_mobile/features/records/domain/personal_records.dart';
import 'package:saiyagym_mobile/features/workouts/domain/workout.dart';
import 'package:saiyagym_mobile/features/workouts/workouts_providers.dart';

/// One exercise: tiers (global + mine), favorite, records and history —
/// all computed from local data.
class ExerciseDetailPage extends ConsumerWidget {
  const ExerciseDetailPage({required this.exerciseId, super.key});

  final String exerciseId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final exercise =
        (ref.watch(exerciseCatalogProvider).value ?? const <Exercise>[])
            .where((e) => e.id == exerciseId)
            .firstOrNull;
    final pref =
        (ref.watch(exercisePrefsProvider).value ?? const {})[exerciseId];
    final history =
        (ref.watch(workoutHistoryProvider).value ?? const <Workout>[])
            .where((w) => w.exercises.any((e) => e.exerciseId == exerciseId))
            .toList();
    final formatter = ref.unitFormatter(context);
    final repository = ref.read(exercisesRepositoryProvider);
    final theme = Theme.of(context);

    if (exercise == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    final favorite = pref?.isFavorite ?? false;
    final records = computeRecords([
      for (final workout in history) recordSessionOf(workout, exerciseId),
    ]);

    return Scaffold(
      appBar: AppBar(
        title: Text(exercise.name),
        actions: [
          IconButton(
            tooltip: context.tr(
              favorite ? 'exercises.unfavorite' : 'exercises.favorite',
            ),
            icon: Icon(favorite ? Icons.star : Icons.star_border),
            onPressed: () {
              unawaited(confirmHaptic());
              unawaited(
                repository.setFavorite(exerciseId, favorite: !favorite),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              Chip(
                label: Text(context.tr('muscles.${exercise.primaryMuscle}')),
              ),
              Chip(label: Text(context.tr('equipment.${exercise.equipment}'))),
              if (exercise.mechanic != null)
                Chip(
                  label: Text(
                    context.tr('exercises.mechanics.${exercise.mechanic}'),
                  ),
                ),
              if (!exercise.isGlobal)
                Chip(label: Text(context.tr('exercises.customTag'))),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            context.tr('exercises.tiers.title'),
            style: theme.textTheme.titleMedium,
          ),
          for (final goal in Goal.values)
            _TierRow(
              goal: goal,
              global: exercise.tiers.of(goal),
              personal: pref?.personalTiers.of(goal),
              onPersonal: (tier) =>
                  unawaited(repository.setPersonalTier(exerciseId, goal, tier)),
            ),
          const SizedBox(height: 16),
          Text(
            context.tr('summary.records'),
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          if (records.maxWeight == null)
            Text(context.tr('exercises.noRecords'))
          else
            Card(
              child: Column(
                children: [
                  _RecordTile(
                    label: context.tr('exercises.records.maxWeight'),
                    value:
                        '${formatter.formatWeight(records.maxWeight!.value)} '
                        '× ${records.maxWeight!.reps}',
                  ),
                  if (records.bestE1RM != null)
                    _RecordTile(
                      label: context.tr('exercises.records.bestE1RM'),
                      value: formatter.formatWeight(records.bestE1RM!.value),
                    ),
                  if (records.maxVolume != null)
                    _RecordTile(
                      label: context.tr('exercises.records.maxVolume'),
                      value: formatter.formatWeight(records.maxVolume!.value),
                    ),
                ],
              ),
            ),
          const SizedBox(height: 16),
          Text(
            context.tr('exercises.history'),
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          if (history.isEmpty) Text(context.tr('exercises.noHistory')),
          for (final workout in history.take(30))
            _HistoryTile(
              workout: workout,
              exerciseId: exerciseId,
              formatter: formatter,
            ),
        ],
      ),
    );
  }
}

class _TierRow extends StatelessWidget {
  const _TierRow({
    required this.goal,
    required this.global,
    required this.personal,
    required this.onPersonal,
  });

  final Goal goal;
  final Tier? global;
  final Tier? personal;
  final ValueChanged<Tier?> onPersonal;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.tr(
              'exercises.tiers.forGoal',
              namedArgs: {
                'goal': context.tr('profile.goals.${goal.name}.title'),
                'tier': global == null ? '–' : tierLabel(global!),
              },
            ),
          ),
          const SizedBox(height: 6),
          // Personal tier: empty = use the global one.
          SegmentedButton<Tier?>(
            emptySelectionAllowed: true,
            showSelectedIcon: false,
            segments: [
              for (final tier in Tier.values)
                ButtonSegment(value: tier, label: Text(tierLabel(tier))),
            ],
            selected: {?personal},
            onSelectionChanged: (value) => onPersonal(value.firstOrNull),
          ),
        ],
      ),
    );
  }
}

class _RecordTile extends StatelessWidget {
  const _RecordTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => ListTile(
    leading: Icon(
      Icons.emoji_events_outlined,
      color: Theme.of(context).colorScheme.tertiary,
    ),
    title: Text(label),
    trailing: Text(value, style: Theme.of(context).textTheme.titleMedium),
  );
}

class _HistoryTile extends StatelessWidget {
  const _HistoryTile({
    required this.workout,
    required this.exerciseId,
    required this.formatter,
  });

  final Workout workout;
  final String exerciseId;
  final UnitFormatter formatter;

  @override
  Widget build(BuildContext context) {
    String weight(double kg) =>
        formatter.formatNumber(formatter.displayWeight(kg));
    final sets = [
      for (final e in workout.exercises)
        if (e.exerciseId == exerciseId)
          for (final s in e.sets)
            if (s.completed && s.weightKg != null && s.reps != null)
              '${weight(s.weightKg!)}×${s.reps}',
    ];
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        DateFormat.yMMMEd(context.locale.languageCode)
            .format(workout.startedAt.toLocal()),
      ),
      subtitle: Text(
        sets.isEmpty ? '—' : '${sets.join('  ')} ${formatter.weightUnit}',
      ),
    );
  }
}
