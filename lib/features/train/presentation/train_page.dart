import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:saiyagym_mobile/app/router/app_routes.dart';
import 'package:saiyagym_mobile/core/sync/sync_providers.dart';
import 'package:saiyagym_mobile/core/widgets/refreshable_list.dart';
import 'package:saiyagym_mobile/core/widgets/sync_status_button.dart';
import 'package:saiyagym_mobile/features/live_workout/data/start_plans.dart';
import 'package:saiyagym_mobile/features/live_workout/domain/live_session.dart';
import 'package:saiyagym_mobile/features/live_workout/presentation/start_session.dart';
import 'package:saiyagym_mobile/features/plans/domain/entitlements.dart';
import 'package:saiyagym_mobile/features/plans/plans_providers.dart';
import 'package:saiyagym_mobile/features/plans/presentation/upgrade_cta.dart';
import 'package:saiyagym_mobile/features/programs/domain/program.dart';
import 'package:saiyagym_mobile/features/programs/programs_providers.dart';
import 'package:saiyagym_mobile/features/routines/routines_providers.dart';

/// Programs (view / activate), routines (start / edit) and the exercise
/// catalog. Everything from the LOCAL database.
class TrainPage extends ConsumerWidget {
  const TrainPage({super.key});

  /// The API enforces the routine limit on sync; checking here avoids
  /// building a routine that will be rejected.
  void _newRoutine(BuildContext context, WidgetRef ref, int current) {
    final plan = ref.read(entitlementsProvider);
    if (!plan.canAdd(PlanLimit.routines, current: current)) {
      unawaited(
        showModalBottomSheet<void>(
          context: context,
          showDragHandle: true,
          builder: (_) => Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            child: UpgradeCta.limit(
              PlanLimit.routines,
              max: plan.limitOf(PlanLimit.routines),
            ),
          ),
        ),
      );
      return;
    }
    context.go(AppRoutes.newRoutine);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routines = ref.watch(activeRoutinesProvider).value ?? const [];
    final programs = ref.watch(programsProvider).value ?? const <Program>[];
    final theme = Theme.of(context);

    Widget header(String title, {Widget? action}) => Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: Row(
        children: [
          Expanded(child: Text(title, style: theme.textTheme.titleMedium)),
          ?action,
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('train.title')),
        actions: [
          IconButton(
            tooltip: context.tr('exercises.title'),
            icon: const Icon(Icons.menu_book_outlined),
            onPressed: () => context.go(AppRoutes.exercises),
          ),
          const SyncStatusButton(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: Text(context.tr('today.emptyWorkout')),
        onPressed: () => startSession(context, ref, const StartPlan.empty()),
      ),
      body: RefreshableList(
        onRefresh: () => ref.read(syncServiceProvider).sync(),
        empty: const SizedBox.shrink(),
        children: [
          if (programs.isNotEmpty) ...[
            header(context.tr('programs.title')),
            for (final program in programs)
              Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: Icon(
                    program.status == ProgramStatus.active
                        ? Icons.play_circle
                        : Icons.calendar_month_outlined,
                    color: program.status == ProgramStatus.active
                        ? theme.colorScheme.primary
                        : null,
                  ),
                  title: Text(program.name),
                  subtitle: Text(
                    context.tr('programs.status.${program.status.name}'),
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.go(AppRoutes.program(program.id)),
                ),
              ),
            const SizedBox(height: 8),
          ],
          header(
            context.tr('train.routines'),
            action: TextButton.icon(
              icon: const Icon(Icons.add),
              label: Text(context.tr('routines.new')),
              onPressed: () => _newRoutine(context, ref, routines.length),
            ),
          ),
          if (routines.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Text(
                context.tr('routines.empty'),
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge,
              ),
            ),
          for (final routine in routines)
            Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                contentPadding: const EdgeInsets.only(left: 20, right: 4),
                leading: const Icon(Icons.play_arrow),
                title: Text(routine.name),
                subtitle: Text(
                  context.tr(
                    'train.exercises',
                    namedArgs: {'count': '${routine.exercises.length}'},
                  ),
                ),
                trailing: IconButton(
                  tooltip: context.tr('routines.edit'),
                  icon: const Icon(Icons.edit_outlined),
                  onPressed: () => context.go(AppRoutes.routine(routine.id)),
                ),
                onTap: () =>
                    startSession(context, ref, planFromRoutine(routine)),
              ),
            ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}
