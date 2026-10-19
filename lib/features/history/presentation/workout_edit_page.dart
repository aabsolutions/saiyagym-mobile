import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:saiyagym_mobile/core/training/training_types.dart';
import 'package:saiyagym_mobile/core/units/unit_formatter.dart';
import 'package:saiyagym_mobile/core/widgets/primary_button.dart';
import 'package:saiyagym_mobile/features/exercises/exercises_providers.dart';
import 'package:saiyagym_mobile/features/live_workout/domain/workout_editing.dart';
import 'package:saiyagym_mobile/features/profile/presentation/preferences_providers.dart';
import 'package:saiyagym_mobile/features/workouts/domain/workout.dart';
import 'package:saiyagym_mobile/features/workouts/workouts_providers.dart';
import 'package:uuid/uuid.dart';

/// Fix a past session (typo in a weight, forgotten set, rating). Saved
/// locally and synced; the API recomputes the records.
class WorkoutEditPage extends ConsumerStatefulWidget {
  const WorkoutEditPage({required this.workoutId, super.key});

  final String workoutId;

  @override
  ConsumerState<WorkoutEditPage> createState() => _WorkoutEditPageState();
}

class _WorkoutEditPageState extends ConsumerState<WorkoutEditPage> {
  static const _uuid = Uuid();
  Workout? _workout;
  final _notes = TextEditingController();
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    unawaited(_load());
  }

  Future<void> _load() async {
    final workout = await ref
        .read(workoutsRepositoryProvider)
        .find(widget.workoutId);
    if (!mounted) return;
    setState(() {
      _workout = workout;
      _notes.text = workout?.notes ?? '';
    });
  }

  @override
  void dispose() {
    _notes.dispose();
    super.dispose();
  }

  void _edit(Workout Function(Workout w) change) =>
      setState(() => _workout = change(_workout!));

  Future<void> _save() async {
    setState(() => _saving = true);
    await ref
        .read(workoutsRepositoryProvider)
        .save(_workout!.copyWith(notes: _notes.text.trim()));
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final workout = _workout;
    final names = ref.watch(exerciseNamesProvider);
    final formatter = ref.unitFormatter(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(context.tr('history.edit'))),
      body: workout == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                for (final exercise in workout.exercises)
                  Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(12, 12, 4, 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            names[exercise.exerciseId] ?? '',
                            style: theme.textTheme.titleMedium,
                          ),
                          for (final set in exercise.sets)
                            _EditableSetRow(
                              key: ValueKey(set.id),
                              set: set,
                              formatter: formatter,
                              onChanged: ({weightKg, reps, type, completed}) =>
                                  _edit((w) {
                                    var next = w.updateSet(
                                      exercise.id,
                                      set.id,
                                      weightKg: weightKg,
                                      reps: reps,
                                      type: type,
                                    );
                                    if (completed != null &&
                                        completed != set.completed) {
                                      next = next.toggleSet(
                                        exercise.id,
                                        set.id,
                                        set.completedAt ?? w.startedAt,
                                      );
                                    }
                                    return next;
                                  }),
                              onRemove: () => _edit(
                                (w) => w.removeSet(exercise.id, set.id),
                              ),
                            ),
                          TextButton.icon(
                            onPressed: () =>
                                _edit((w) => w.addSet(exercise.id, _uuid.v4())),
                            icon: const Icon(Icons.add),
                            label: Text(context.tr('live.addSet')),
                          ),
                        ],
                      ),
                    ),
                  ),
                Text(
                  context.tr('live.finish.rating'),
                  style: theme.textTheme.titleMedium,
                ),
                Row(
                  children: [
                    for (var star = 1; star <= 5; star++)
                      IconButton(
                        iconSize: 36,
                        tooltip: '$star',
                        onPressed: () => _edit(
                          (w) => w.copyWith(
                            rating: w.rating == star ? null : star,
                          ),
                        ),
                        icon: Icon(
                          (workout.rating ?? 0) >= star
                              ? Icons.star
                              : Icons.star_border,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                  ],
                ),
                TextField(
                  controller: _notes,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: context.tr('live.finish.notes'),
                  ),
                ),
                const SizedBox(height: 24),
                PrimaryButton(
                  label: context.tr('common.save'),
                  isLoading: _saving,
                  onPressed: _save,
                ),
              ],
            ),
    );
  }
}

typedef _SetChange = void Function({
  double? Function()? weightKg,
  int? Function()? reps,
  SetType? type,
  bool? completed,
});

class _EditableSetRow extends StatefulWidget {
  const _EditableSetRow({
    required this.set,
    required this.formatter,
    required this.onChanged,
    required this.onRemove,
    super.key,
  });

  final WorkoutSet set;
  final UnitFormatter formatter;
  final _SetChange onChanged;
  final VoidCallback onRemove;

  @override
  State<_EditableSetRow> createState() => _EditableSetRowState();
}

class _EditableSetRowState extends State<_EditableSetRow> {
  late final TextEditingController _weight;
  late final TextEditingController _reps;

  @override
  void initState() {
    super.initState();
    final kg = widget.set.weightKg;
    _weight = TextEditingController(
      text: kg == null
          ? ''
          : widget.formatter.formatNumber(
              (widget.formatter.displayWeight(kg) * 100).round() / 100,
            ),
    );
    _reps = TextEditingController(text: widget.set.reps?.toString() ?? '');
  }

  @override
  void dispose() {
    _weight.dispose();
    _reps.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final set = widget.set;
    return Row(
      children: [
        DropdownButton<SetType>(
          value: set.type,
          underline: const SizedBox.shrink(),
          items: [
            for (final type in SetType.values)
              DropdownMenuItem(
                value: type,
                child: Text(context.tr('live.setTypes.${type.name}.short')),
              ),
          ],
          onChanged: (type) => widget.onChanged(type: type),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: TextField(
            controller: _weight,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              isDense: true,
              suffixText: widget.formatter.weightUnit,
            ),
            onChanged: (text) {
              final display = UnitFormatter.parseNumber(text);
              widget.onChanged(
                weightKg: () => display == null
                    ? null
                    : widget.formatter.weightToKg(display),
              );
            },
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: TextField(
            controller: _reps,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              isDense: true,
              suffixText: context.tr('live.columns.reps'),
            ),
            onChanged: (text) =>
                widget.onChanged(reps: () => int.tryParse(text)),
          ),
        ),
        Checkbox(
          value: set.completed,
          semanticLabel: context.tr('live.completeSet'),
          onChanged: (value) => widget.onChanged(completed: value),
        ),
        IconButton(
          tooltip: context.tr('routines.removeSet'),
          icon: const Icon(Icons.remove_circle_outline),
          onPressed: widget.onRemove,
        ),
      ],
    );
  }
}
