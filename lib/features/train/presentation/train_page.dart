import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saiyagym_mobile/core/sync/sync_providers.dart';
import 'package:saiyagym_mobile/core/widgets/empty_state.dart';
import 'package:saiyagym_mobile/core/widgets/refreshable_list.dart';
import 'package:saiyagym_mobile/core/widgets/sync_status_button.dart';
import 'package:saiyagym_mobile/features/routines/routines_providers.dart';

/// The user's routines from the LOCAL database (works offline).
class TrainPage extends ConsumerWidget {
  const TrainPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routines = ref.watch(activeRoutinesProvider).value ?? const [];
    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('train.title')),
        actions: const [SyncStatusButton()],
      ),
      body: RefreshableList(
        onRefresh: () => ref.read(syncServiceProvider).sync(),
        empty: EmptyState(
          icon: Icons.fitness_center,
          title: context.tr('train.emptyTitle'),
          message: context.tr('train.emptyMessage'),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              context.tr('train.routines'),
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          for (final routine in routines)
            Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                leading: const Icon(Icons.list_alt),
                title: Text(routine.name),
                subtitle: Text(
                  context.tr(
                    'train.exercises',
                    namedArgs: {'count': '${routine.exercises.length}'},
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
