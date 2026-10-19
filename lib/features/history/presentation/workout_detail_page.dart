import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:saiyagym_mobile/app/router/app_routes.dart';
import 'package:saiyagym_mobile/core/training/training_types.dart';
import 'package:saiyagym_mobile/features/exercises/exercises_providers.dart';
import 'package:saiyagym_mobile/features/live_workout/domain/live_session.dart';
import 'package:saiyagym_mobile/features/live_workout/presentation/widgets/live_sheets.dart';
import 'package:saiyagym_mobile/features/profile/presentation/preferences_providers.dart';
import 'package:saiyagym_mobile/features/workouts/domain/workout.dart';
import 'package:saiyagym_mobile/features/workouts/workouts_providers.dart';

/// A past session: totals, exercises and sets; edit or delete it.
class WorkoutDetailPage extends ConsumerWidget {
  const WorkoutDetailPage({required this.workoutId, super.key});

  final String workoutId;

  Future<void> _delete(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(dialogContext.tr('history.delete.title')),
        content: Text(dialogContext.tr('history.delete.message')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(dialogContext.tr('common.cancel')),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(dialogContext).colorScheme.error,
            ),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(dialogContext.tr('common.delete')),
          ),
        ],
      ),
    );
    if (!(confirmed ?? false)) return;
    // Logical delete: syncs, and the API recomputes the records.
    await ref.read(workoutsRepositoryProvider).delete(workoutId);
    if (context.mounted) context.go(AppRoutes.history);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workout =
        (ref.watch(workoutHistoryProvider).value ?? const <Workout>[])
            .where((w) => w.id == workoutId)
            .firstOrNull;
    final names = ref.watch(exerciseNamesProvider);
    final formatter = ref.unitFormatter(context);
    final theme = Theme.of(context);

    if (workout == null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: Text(context.tr('history.notFound'))),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          workout.name.isEmpty ? context.tr('history.untitled') : workout.name,
        ),
        actions: [
          IconButton(
            tooltip: context.tr('history.edit'),
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => context.go(AppRoutes.workoutEdit(workout.id)),
          ),
          IconButton(
            tooltip: context.tr('common.delete'),
            icon: const Icon(Icons.delete_outline),
            onPressed: () => unawaited(_delete(context, ref)),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            DateFormat.yMMMMEEEEd(context.locale.languageCode)
                .add_Hm()
                .format(workout.startedAt.toLocal()),
            style: theme.textTheme.bodyLarge,
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SessionStats(
                duration: workout.elapsed(
                  workout.finishedAt ?? workout.startedAt,
                ),
                volumeKg: workout.volumeKg ?? workout.liveVolumeKg,
                sets: workout.completedWorkingSets,
                formatter: formatter,
              ),
            ),
          ),
          if (workout.rating != null)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Row(
                children: [
                  for (var star = 1; star <= 5; star++)
                    Icon(
                      star <= workout.rating! ? Icons.star : Icons.star_border,
                      color: theme.colorScheme.primary,
                    ),
                ],
              ),
            ),
          if (workout.notes.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(workout.notes, style: theme.textTheme.bodyLarge),
          ],
          const SizedBox(height: 16),
          for (final exercise in workout.exercises)
            Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      names[exercise.exerciseId] ?? '',
                      style: theme.textTheme.titleMedium,
                    ),
                    if (exercise.notes.isNotEmpty)
                      Text(
                        exercise.notes,
                        style: const TextStyle(fontStyle: FontStyle.italic),
                      ),
                    const SizedBox(height: 8),
                    for (final (index, set) in exercise.sets.indexed)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 32,
                              child: Text(
                                set.type == SetType.normal
                                    ? '${index + 1}'
                                    : context.tr(
                                        'live.setTypes.${set.type.name}.short',
                                      ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                set.weightKg == null
                                    ? context.tr(
                                        'history.repsOnly',
                                        namedArgs: {
                                          'reps': '${set.reps ?? '—'}',
                                        },
                                      )
                                    : '${formatter.formatWeight(set.weightKg!)}'
                                          ' × ${set.reps ?? '—'}',
                              ),
                            ),
                            if (!set.completed)
                              Text(
                                context.tr('history.notDone'),
                                style: TextStyle(
                                  color: theme.colorScheme.outline,
                                ),
                              ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
