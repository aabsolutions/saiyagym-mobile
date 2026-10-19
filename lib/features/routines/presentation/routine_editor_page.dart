import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:saiyagym_mobile/core/feedback/haptics.dart';
import 'package:saiyagym_mobile/core/training/training_types.dart';
import 'package:saiyagym_mobile/core/units/unit_formatter.dart';
import 'package:saiyagym_mobile/core/widgets/primary_button.dart';
import 'package:saiyagym_mobile/features/exercises/exercises_providers.dart';
import 'package:saiyagym_mobile/features/live_workout/presentation/widgets/live_sheets.dart';
import 'package:saiyagym_mobile/features/profile/presentation/preferences_providers.dart';
import 'package:saiyagym_mobile/features/routines/domain/routine.dart';
import 'package:saiyagym_mobile/features/routines/domain/routine_editing.dart';
import 'package:saiyagym_mobile/features/routines/routines_providers.dart';
import 'package:uuid/uuid.dart';

/// Simplified routine editor: name, exercises (add / reorder / remove) and
/// their target sets. Saved locally and synced (works offline). Progression
/// rules and programs are edited on the web.
class RoutineEditorPage extends ConsumerStatefulWidget {
  const RoutineEditorPage({this.routineId, super.key});

  /// `null` = new routine.
  final String? routineId;

  @override
  ConsumerState<RoutineEditorPage> createState() => _RoutineEditorPageState();
}

class _RoutineEditorPageState extends ConsumerState<RoutineEditorPage> {
  static const _uuid = Uuid();
  final _name = TextEditingController();
  Routine? _routine;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    unawaited(_load());
  }

  Future<void> _load() async {
    final id = widget.routineId;
    final routine = id == null
        ? Routine(id: _uuid.v4(), name: '')
        : await ref.read(routinesRepositoryProvider).find(id);
    if (!mounted) return;
    setState(() {
      _routine = routine;
      _name.text = routine?.name ?? '';
    });
  }

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  void _edit(Routine Function(Routine routine) change) =>
      setState(() => _routine = change(_routine!));

  Future<void> _addExercise() async {
    final exerciseId = await pickExercise(context);
    if (exerciseId != null) {
      _edit((r) => r.addExercise(exerciseId, slotId: _uuid.v4()));
    }
  }

  Future<void> _save() async {
    final routine = _routine!.copyWith(name: _name.text.trim());
    if (!routine.isValid) return;
    setState(() => _saving = true);
    await ref.read(routinesRepositoryProvider).save(routine);
    unawaited(confirmHaptic());
    if (mounted) context.pop();
  }

  Future<void> _delete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(dialogContext.tr('routines.delete.title')),
        content: Text(dialogContext.tr('routines.delete.message')),
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
    await ref.read(routinesRepositoryProvider).delete(_routine!.id);
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final routine = _routine;
    final names = ref.watch(exerciseNamesProvider);
    final formatter = ref.unitFormatter(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.tr(
            widget.routineId == null ? 'routines.new' : 'routines.edit',
          ),
        ),
        actions: [
          if (widget.routineId != null)
            IconButton(
              tooltip: context.tr('common.delete'),
              icon: const Icon(Icons.delete_outline),
              onPressed: routine == null ? null : _delete,
            ),
        ],
      ),
      body: routine == null
          ? const Center(child: CircularProgressIndicator())
          : ReorderableListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
              header: Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: TextField(
                  controller: _name,
                  maxLength: 80,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    labelText: context.tr('routines.name'),
                    counterText: '',
                  ),
                  onChanged: (_) => setState(() {}),
                ),
              ),
              footer: OutlinedButton.icon(
                icon: const Icon(Icons.add),
                label: Text(context.tr('live.addExercise')),
                onPressed: _addExercise,
              ),
              onReorderItem: (from, to) =>
                  _edit((r) => r.moveExercise(from, to)),
              children: [
                for (final (index, exercise) in routine.exercises.indexed)
                  _RoutineExerciseCard(
                    key: ValueKey(exercise.id),
                    index: index,
                    exercise: exercise,
                    name: names[exercise.exerciseId] ?? '',
                    formatter: formatter,
                    onChanged: (setIndex, set) =>
                        _edit((r) => r.updateSet(exercise.id, setIndex, set)),
                    onAddSet: () => _edit((r) => r.addSet(exercise.id)),
                    onRemoveSet: (setIndex) =>
                        _edit((r) => r.removeSet(exercise.id, setIndex)),
                    onRemove: () => _edit((r) => r.removeExercise(exercise.id)),
                  ),
              ],
            ),
      bottomNavigationBar: routine == null
          ? null
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: PrimaryButton(
                  label: context.tr('common.save'),
                  isLoading: _saving,
                  onPressed:
                      _name.text.trim().isEmpty || routine.exercises.isEmpty
                      ? null
                      : _save,
                ),
              ),
            ),
    );
  }
}

class _RoutineExerciseCard extends StatelessWidget {
  const _RoutineExerciseCard({
    required this.index,
    required this.exercise,
    required this.name,
    required this.formatter,
    required this.onChanged,
    required this.onAddSet,
    required this.onRemoveSet,
    required this.onRemove,
    super.key,
  });

  final int index;
  final RoutineExercise exercise;
  final String name;
  final UnitFormatter formatter;
  final void Function(int index, TargetSet set) onChanged;
  final VoidCallback onAddSet;
  final ValueChanged<int> onRemoveSet;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 4, 4, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ReorderableDragStartListener(
                  index: index,
                  child: const Padding(
                    padding: EdgeInsets.all(8),
                    child: Icon(Icons.drag_handle),
                  ),
                ),
                Expanded(child: Text(name, style: theme.textTheme.titleMedium)),
                IconButton(
                  tooltip: context.tr('live.actions.remove'),
                  icon: const Icon(Icons.close),
                  onPressed: onRemove,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Row(
                children: [
                  for (final (flex, key) in const [
                    (2, 'routines.columns.type'),
                    (3, 'routines.columns.reps'),
                    (3, 'routines.columns.weight'),
                    (2, 'routines.columns.rest'),
                  ])
                    Expanded(
                      flex: flex,
                      child: Text(
                        key == 'routines.columns.weight'
                            ? formatter.weightUnit
                            : context.tr(key),
                        style: theme.textTheme.labelMedium,
                      ),
                    ),
                  const SizedBox(width: 40),
                ],
              ),
            ),
            for (final (setIndex, set) in exercise.sets.indexed)
              _TargetSetRow(
                key: ValueKey(
                  '${exercise.id}-$setIndex-${exercise.sets.length}',
                ),
                set: set,
                formatter: formatter,
                onChanged: (next) => onChanged(setIndex, next),
                onRemove: () => onRemoveSet(setIndex),
              ),
            TextButton.icon(
              onPressed: onAddSet,
              icon: const Icon(Icons.add),
              label: Text(context.tr('live.addSet')),
            ),
          ],
        ),
      ),
    );
  }
}

class _TargetSetRow extends StatelessWidget {
  const _TargetSetRow({
    required this.set,
    required this.formatter,
    required this.onChanged,
    required this.onRemove,
    super.key,
  });

  final TargetSet set;
  final UnitFormatter formatter;
  final ValueChanged<TargetSet> onChanged;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final weight = set.weightKg;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: DropdownButton<SetType>(
              value: set.type,
              isExpanded: true,
              underline: const SizedBox.shrink(),
              items: [
                for (final type in SetType.values)
                  DropdownMenuItem(
                    value: type,
                    child: Text(context.tr('live.setTypes.${type.name}.short')),
                  ),
              ],
              onChanged: (type) =>
                  onChanged(set.copyWith(type: type ?? set.type)),
            ),
          ),
          Expanded(
            flex: 3,
            child: Row(
              children: [
                Expanded(
                  child: _NumberField(
                    value: '${set.repsMin}',
                    label: context.tr('routines.repsMin'),
                    onChanged: (v) => onChanged(
                      set.copyWith(repsMin: int.tryParse(v) ?? set.repsMin),
                    ),
                  ),
                ),
                const Text('–'),
                Expanded(
                  child: _NumberField(
                    value: '${set.repsMax}',
                    label: context.tr('routines.repsMax'),
                    onChanged: (v) => onChanged(
                      set.copyWith(repsMax: int.tryParse(v) ?? set.repsMax),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: _NumberField(
              value: weight == null
                  ? ''
                  : formatter.formatNumber(
                      (formatter.displayWeight(weight) * 100).round() / 100,
                    ),
              label: formatter.weightUnit,
              decimal: true,
              onChanged: (v) {
                final display = UnitFormatter.parseNumber(v);
                onChanged(
                  set.copyWith(
                    weightKg: display == null
                        ? null
                        : formatter.weightToKg(display),
                  ),
                );
              },
            ),
          ),
          Expanded(
            flex: 2,
            child: _NumberField(
              value: '${set.restSeconds}',
              label: context.tr('routines.columns.rest'),
              onChanged: (v) => onChanged(
                set.copyWith(restSeconds: int.tryParse(v) ?? set.restSeconds),
              ),
            ),
          ),
          SizedBox(
            width: 40,
            child: IconButton(
              tooltip: context.tr('routines.removeSet'),
              icon: const Icon(Icons.remove_circle_outline),
              onPressed: onRemove,
            ),
          ),
        ],
      ),
    );
  }
}

/// Small numeric input that keeps its own text while typing.
class _NumberField extends StatefulWidget {
  const _NumberField({
    required this.value,
    required this.label,
    required this.onChanged,
    this.decimal = false,
  });

  final String value;
  final String label;
  final ValueChanged<String> onChanged;
  final bool decimal;

  @override
  State<_NumberField> createState() => _NumberFieldState();
}

class _NumberFieldState extends State<_NumberField> {
  late final TextEditingController _controller = TextEditingController(
    text: widget.value,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 2),
    child: Semantics(
      label: widget.label,
      child: TextField(
        controller: _controller,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.numberWithOptions(decimal: widget.decimal),
        decoration: const InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 4),
        ),
        onChanged: widget.onChanged,
      ),
    ),
  );
}
