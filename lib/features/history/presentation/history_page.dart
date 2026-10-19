import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saiyagym_mobile/core/sync/sync_providers.dart';
import 'package:saiyagym_mobile/core/widgets/empty_state.dart';
import 'package:saiyagym_mobile/core/widgets/refreshable_list.dart';
import 'package:saiyagym_mobile/core/widgets/sync_status_button.dart';
import 'package:saiyagym_mobile/features/profile/presentation/preferences_providers.dart';
import 'package:saiyagym_mobile/features/workouts/domain/workout.dart';
import 'package:saiyagym_mobile/features/workouts/workouts_providers.dart';

/// Finished workouts from the LOCAL database (works offline).
class HistoryPage extends ConsumerWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workouts = ref.watch(workoutHistoryProvider).value ?? const [];
    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('history.title')),
        actions: const [SyncStatusButton()],
      ),
      body: RefreshableList(
        onRefresh: () => ref.read(syncServiceProvider).sync(),
        empty: EmptyState(
          icon: Icons.history,
          title: context.tr('history.emptyTitle'),
          message: context.tr('history.emptyMessage'),
        ),
        children: [
          for (final workout in workouts) _WorkoutTile(workout: workout),
        ],
      ),
    );
  }
}

class _WorkoutTile extends ConsumerWidget {
  const _WorkoutTile({required this.workout});

  final Workout workout;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formatter = ref.unitFormatter(context);
    final sets = workout.exercises.fold<int>(
      0,
      (total, exercise) =>
          total + exercise.sets.where((set) => set.completed).length,
    );
    final volume = workout.volumeKg;
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        title: Text(
          workout.name.isEmpty ? context.tr('history.untitled') : workout.name,
        ),
        subtitle: Text(
          [
            DateFormat.yMMMEd(context.locale.languageCode)
                .format(workout.startedAt.toLocal()),
            context.tr('history.sets', namedArgs: {'count': '$sets'}),
            if (volume != null) formatter.formatWeight(volume),
          ].join(' · '),
        ),
      ),
    );
  }
}
