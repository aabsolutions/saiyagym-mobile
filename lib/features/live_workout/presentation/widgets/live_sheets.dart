import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saiyagym_mobile/core/units/unit_formatter.dart';
import 'package:saiyagym_mobile/core/widgets/primary_button.dart';
import 'package:saiyagym_mobile/features/exercises/domain/exercise.dart';
import 'package:saiyagym_mobile/features/exercises/exercises_providers.dart';
import 'package:saiyagym_mobile/features/live_workout/domain/live_session.dart';
import 'package:saiyagym_mobile/features/live_workout/domain/plate_calculator.dart';
import 'package:saiyagym_mobile/features/live_workout/domain/workout_editing.dart';
import 'package:saiyagym_mobile/features/live_workout/live_workout_providers.dart';
import 'package:saiyagym_mobile/features/live_workout/presentation/widgets/ticker.dart';
import 'package:saiyagym_mobile/features/workouts/domain/workout.dart';

/// Picks an exercise from the LOCAL catalog (works offline).
Future<String?> pickExercise(BuildContext context) =>
    showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => const _ExercisePicker(),
    );

class _ExercisePicker extends ConsumerStatefulWidget {
  const _ExercisePicker();

  @override
  ConsumerState<_ExercisePicker> createState() => _ExercisePickerState();
}

class _ExercisePickerState extends ConsumerState<_ExercisePicker> {
  String _search = '';

  @override
  Widget build(BuildContext context) {
    final repository = ref.watch(exercisesRepositoryProvider);
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.9,
      builder: (context, controller) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: TextField(
              autofocus: true,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: context.tr('live.picker.search'),
              ),
              onChanged: (value) => setState(() => _search = value),
            ),
          ),
          Expanded(
            child: StreamBuilder<List<Exercise>>(
              stream: repository.watchCatalog(search: _search),
              builder: (context, snapshot) {
                final items = snapshot.data ?? const <Exercise>[];
                if (snapshot.hasData && items.isEmpty) {
                  return Center(child: Text(context.tr('live.picker.empty')));
                }
                return ListView.builder(
                  controller: controller,
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final exercise = items[index];
                    return ListTile(
                      title: Text(exercise.name),
                      subtitle: Text(
                        [
                          context.tr('muscles.${exercise.primaryMuscle}'),
                          context.tr('equipment.${exercise.equipment}'),
                        ].join(' · '),
                      ),
                      onTap: () => Navigator.pop(context, exercise.id),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Which plates go on each side for a target weight.
Future<void> showPlateCalculator(BuildContext context, {double? weightKg}) =>
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => _PlateCalculator(initialKg: weightKg),
    );

class _PlateCalculator extends ConsumerStatefulWidget {
  const _PlateCalculator({this.initialKg});

  final double? initialKg;

  @override
  ConsumerState<_PlateCalculator> createState() => _PlateCalculatorState();
}

class _PlateCalculatorState extends ConsumerState<_PlateCalculator> {
  late final TextEditingController _target;

  @override
  void initState() {
    super.initState();
    _target = TextEditingController();
  }

  @override
  void dispose() {
    _target.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(trainingSettingsControllerProvider).value;
    if (settings == null) return const SizedBox(height: 200);
    final config = settings.plates;
    final unit = UnitFormatter(
      config.unit,
      locale: context.locale.languageCode,
    );
    if (_target.text.isEmpty && widget.initialKg != null) {
      _target.text = unit.formatNumber(unit.displayWeight(widget.initialKg!));
    }
    final target = UnitFormatter.parseNumber(_target.text);
    final load = target == null ? null : loadBar(target, config);
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        0,
        20,
        24 + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.tr('plates.title'),
            style: theme.textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _target,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: context.tr('plates.target'),
              suffixText: unit.weightUnit,
            ),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 16),
          Text(
            context.tr(
              'plates.bar',
              namedArgs: {
                'weight':
                    '${unit.formatNumber(config.barWeight)} ${unit.weightUnit}',
              },
            ),
          ),
          const SizedBox(height: 12),
          if (load != null) ...[
            Text(
              context.tr('plates.perSide'),
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            if (load.perSide.isEmpty)
              Text(context.tr('plates.none'))
            else
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final plate in load.perSide)
                    Chip(
                      label: Text(
                        unit.formatNumber(plate),
                        style: theme.textTheme.titleMedium,
                      ),
                    ),
                ],
              ),
            if (!load.exact) ...[
              const SizedBox(height: 12),
              Text(
                context.tr(
                  'plates.closest',
                  namedArgs: {
                    'weight': unit.formatWeight(unit.weightToKg(load.achieved)),
                  },
                ),
                style: TextStyle(color: theme.colorScheme.error),
              ),
            ],
          ],
          const SizedBox(height: 8),
          Text(
            context.tr('plates.configureHint'),
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

/// Drag to reorder the session's exercises.
Future<void> showReorderSheet(
  BuildContext context, {
  required List<WorkoutExercise> exercises,
  required Map<String, String> names,
  required void Function(int from, int to) onMove,
}) => showModalBottomSheet<void>(
  context: context,
  showDragHandle: true,
  isScrollControlled: true,
  builder: (context) {
    final order = [...exercises];
    return StatefulBuilder(
      builder: (context, setState) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              context.tr('live.reorder'),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Flexible(
              child: ReorderableListView(
                shrinkWrap: true,
                onReorderItem: (from, to) {
                  setState(() => order.insert(to, order.removeAt(from)));
                  onMove(from, to);
                },
                children: [
                  for (final exercise in order)
                    ListTile(
                      key: ValueKey(exercise.id),
                      leading: const Icon(Icons.drag_handle),
                      title: Text(names[exercise.exerciseId] ?? ''),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  },
);

/// Notes for one exercise.
Future<String?> editNotes(BuildContext context, String current) {
  final controller = TextEditingController(text: current);
  return showDialog<String>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(dialogContext.tr('live.actions.notes')),
      content: TextField(
        controller: controller,
        autofocus: true,
        maxLines: 4,
        maxLength: 500,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext),
          child: Text(dialogContext.tr('common.cancel')),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(dialogContext, controller.text.trim()),
          child: Text(dialogContext.tr('common.save')),
        ),
      ],
    ),
  ).whenComplete(controller.dispose);
}

/// Result of the finish sheet.
class FinishInput {
  const FinishInput({this.rating, this.notes = ''});

  final int? rating;
  final String notes;
}

/// Summary + rating + notes before saving.
Future<FinishInput?> showFinishSheet(
  BuildContext context, {
  required LiveSession session,
  required UnitFormatter formatter,
}) => showModalBottomSheet<FinishInput>(
  context: context,
  isScrollControlled: true,
  showDragHandle: true,
  builder: (_) => _FinishSheet(session: session, formatter: formatter),
);

class _FinishSheet extends StatefulWidget {
  const _FinishSheet({required this.session, required this.formatter});

  final LiveSession session;
  final UnitFormatter formatter;

  @override
  State<_FinishSheet> createState() => _FinishSheetState();
}

class _FinishSheetState extends State<_FinishSheet> {
  int? _rating;
  final _notes = TextEditingController();

  @override
  void dispose() {
    _notes.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final workout = widget.session.workout;
    final theme = Theme.of(context);
    final nothingDone = !workout.hasCompletedSets;
    return Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        0,
        20,
        24 + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            context.tr('live.finish.title'),
            style: theme.textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          Ticker(
            builder: (context, now) => SessionStats(
              duration: workout.elapsed(now),
              volumeKg: workout.liveVolumeKg,
              sets: workout.completedWorkingSets,
              formatter: widget.formatter,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            context.tr('live.finish.rating'),
            style: theme.textTheme.titleMedium,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var star = 1; star <= 5; star++)
                IconButton(
                  iconSize: 40,
                  tooltip: '$star',
                  onPressed: () =>
                      setState(() => _rating = _rating == star ? null : star),
                  icon: Icon(
                    (_rating ?? 0) >= star ? Icons.star : Icons.star_border,
                    color: theme.colorScheme.primary,
                  ),
                ),
            ],
          ),
          TextField(
            controller: _notes,
            maxLines: 3,
            maxLength: 1000,
            decoration: InputDecoration(
              labelText: context.tr('live.finish.notes'),
            ),
          ),
          if (!nothingDone)
            const SizedBox.shrink()
          else
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                context.tr('live.finish.nothingDone'),
                style: TextStyle(color: theme.colorScheme.error),
              ),
            ),
          PrimaryButton(
            label: context.tr('live.finish.save'),
            // An empty workout would pollute history and stats: discard it.
            onPressed: nothingDone
                ? null
                : () => Navigator.pop(
                    context,
                    FinishInput(rating: _rating, notes: _notes.text.trim()),
                  ),
          ),
        ],
      ),
    );
  }
}

/// Duration · volume · sets.
class SessionStats extends StatelessWidget {
  const SessionStats({
    required this.duration,
    required this.volumeKg,
    required this.sets,
    required this.formatter,
    super.key,
  });

  final Duration duration;
  final double volumeKg;
  final int sets;
  final UnitFormatter formatter;

  @override
  Widget build(BuildContext context) {
    Widget stat(String label, String value) => Expanded(
      child: Column(
        children: [
          Text(value, style: Theme.of(context).textTheme.titleLarge),
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
    return Row(
      children: [
        stat(context.tr('live.stats.duration'), formatDuration(duration)),
        stat(
          context.tr('live.stats.volume'),
          formatter.formatWeight(volumeKg.roundToDouble()),
        ),
        stat(context.tr('live.stats.sets'), '$sets'),
      ],
    );
  }
}
