import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saiyagym_mobile/core/units/unit_formatter.dart';
import 'package:saiyagym_mobile/core/widgets/async_body.dart';
import 'package:saiyagym_mobile/core/widgets/empty_state.dart';
import 'package:saiyagym_mobile/features/exercises/exercises_providers.dart';
import 'package:saiyagym_mobile/features/profile/presentation/preferences_providers.dart';
import 'package:saiyagym_mobile/features/progress/progress_providers.dart';
import 'package:saiyagym_mobile/features/records/domain/personal_records.dart';

/// Personal records of every trained exercise, by name.
class RecordsPage extends ConsumerWidget {
  const RecordsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = ref.watch(personalRecordsProvider);
    final records = value.value;
    final names = ref.watch(exerciseNamesProvider);
    final formatter = ref.unitFormatter(context);
    final entries =
        [
          for (final MapEntry(key: id, value: record)
              in (records ?? const <String, ExerciseRecords>{}).entries)
            if (record.maxWeight != null) (id: id, records: record),
        ]..sort(
          (a, b) => (names[a.id] ?? a.id).toLowerCase().compareTo(
            (names[b.id] ?? b.id).toLowerCase(),
          ),
        );

    return Scaffold(
      appBar: AppBar(title: Text(context.tr('records.title'))),
      body: records == null
          ? AsyncBody(
              value: value,
              onRetry: () => ref.invalidate(personalRecordsProvider),
              builder: (_) => const SizedBox.shrink(),
            )
          : entries.isEmpty
          ? EmptyState(
              icon: Icons.emoji_events_outlined,
              title: context.tr('records.emptyTitle'),
              message: context.tr('records.emptyMessage'),
            )
          : ListView.builder(
              itemCount: entries.length,
              itemBuilder: (context, index) => _ExerciseRecordsTile(
                name: names[entries[index].id] ?? '…',
                records: entries[index].records,
                formatter: formatter,
              ),
            ),
    );
  }
}

class _ExerciseRecordsTile extends StatelessWidget {
  const _ExerciseRecordsTile({
    required this.name,
    required this.records,
    required this.formatter,
  });

  final String name;
  final ExerciseRecords records;
  final UnitFormatter formatter;

  @override
  Widget build(BuildContext context) {
    final best = records.maxWeight!;
    return ExpansionTile(
      leading: Icon(
        Icons.emoji_events_outlined,
        color: Theme.of(context).colorScheme.tertiary,
      ),
      title: Text(name),
      subtitle: Text('${formatter.formatWeight(best.value)} × ${best.reps}'),
      children: [
        if (records.bestE1RM case final e1rm?)
          _row(
            context,
            'exercises.records.bestE1RM',
            formatter.formatWeight(e1rm.value),
          ),
        if (records.maxVolume case final volume?)
          _row(
            context,
            'exercises.records.maxVolume',
            formatter.formatWeight(volume.value),
          ),
        if (records.repsAtWeight.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final entry in records.repsAtWeight.reversed.take(8))
                  Chip(
                    label: Text(
                      context.tr(
                        'records.repsAt',
                        namedArgs: {
                          'reps': '${entry.reps}',
                          'weight': formatter.formatWeight(entry.weightKg),
                        },
                      ),
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _row(BuildContext context, String label, String value) => ListTile(
    dense: true,
    title: Text(context.tr(label)),
    trailing: Text(value, style: Theme.of(context).textTheme.titleSmall),
  );
}
