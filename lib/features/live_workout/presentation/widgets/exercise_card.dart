import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:saiyagym_mobile/core/training/training_types.dart';
import 'package:saiyagym_mobile/core/units/unit_formatter.dart';
import 'package:saiyagym_mobile/features/live_workout/domain/live_session.dart';
import 'package:saiyagym_mobile/features/workouts/domain/workout.dart';

enum SetField { weight, reps }

/// Which cell the keypad is editing.
class EditingCell {
  const EditingCell(this.exerciseRowId, this.setId, this.field);

  final String exerciseRowId;
  final String setId;
  final SetField field;

  bool matches(String exerciseRowId, String setId, SetField field) =>
      this.exerciseRowId == exerciseRowId &&
      this.setId == setId &&
      this.field == field;
}

enum ExerciseAction { notes, replace, superset, remove }

class ExerciseCard extends StatelessWidget {
  const ExerciseCard({
    required this.exercise,
    required this.name,
    required this.previous,
    required this.targets,
    required this.formatter,
    required this.editing,
    required this.editingText,
    required this.inSuperset,
    required this.onEdit,
    required this.onToggle,
    required this.onType,
    required this.onAddSet,
    required this.onRemoveSet,
    required this.onAction,
    super.key,
  });

  final WorkoutExercise exercise;
  final String name;
  final List<WorkoutSet>? previous;
  final List<SetTarget>? targets;
  final UnitFormatter formatter;
  final EditingCell? editing;

  /// What the keypad has typed for the edited cell.
  final String editingText;
  final bool inSuperset;
  final void Function(String setId, SetField field) onEdit;
  final ValueChanged<String> onToggle;
  final void Function(String setId, SetType type) onType;
  final VoidCallback onAddSet;
  final ValueChanged<String> onRemoveSet;
  final ValueChanged<ExerciseAction> onAction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    var workingIndex = 0;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: inSuperset
              ? Border(left: BorderSide(color: scheme.tertiary, width: 6))
              : null,
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 4, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (inSuperset)
                          Text(
                            context.tr('live.superset'),
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: scheme.tertiary,
                            ),
                          ),
                        Text(name, style: theme.textTheme.titleLarge),
                      ],
                    ),
                  ),
                  PopupMenuButton<ExerciseAction>(
                    tooltip: context.tr('live.exerciseMenu'),
                    onSelected: onAction,
                    itemBuilder: (_) => [
                      PopupMenuItem(
                        value: ExerciseAction.notes,
                        child: Text(context.tr('live.actions.notes')),
                      ),
                      PopupMenuItem(
                        value: ExerciseAction.replace,
                        child: Text(context.tr('live.actions.replace')),
                      ),
                      PopupMenuItem(
                        value: ExerciseAction.superset,
                        child: Text(
                          context.tr(
                            inSuperset
                                ? 'live.actions.leaveSuperset'
                                : 'live.actions.superset',
                          ),
                        ),
                      ),
                      PopupMenuItem(
                        value: ExerciseAction.remove,
                        child: Text(
                          context.tr('live.actions.remove'),
                          style: TextStyle(color: scheme.error),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              if (exercise.notes.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(right: 8, bottom: 4),
                  child: InkWell(
                    onTap: () => onAction(ExerciseAction.notes),
                    child: Text(
                      exercise.notes,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontStyle: FontStyle.italic,
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
              _HeaderRow(formatter: formatter),
              for (final (index, set) in exercise.sets.indexed)
                Dismissible(
                  key: ValueKey(set.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: scheme.errorContainer,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 24),
                    child: Icon(
                      Icons.delete_outline,
                      color: scheme.onErrorContainer,
                    ),
                  ),
                  onDismissed: (_) => onRemoveSet(set.id),
                  child: SetRow(
                    set: set,
                    label: set.type == SetType.normal
                        ? '${++workingIndex}'
                        : _typeLetter(context, set.type),
                    previous: _at(previous, index),
                    target: _at(targets, index),
                    formatter: formatter,
                    editingField:
                        editing != null &&
                            editing!.exerciseRowId == exercise.id &&
                            editing!.setId == set.id
                        ? editing!.field
                        : null,
                    editingText: editingText,
                    onEdit: (field) => onEdit(set.id, field),
                    onToggle: () => onToggle(set.id),
                    onType: (type) => onType(set.id, type),
                  ),
                ),
              TextButton.icon(
                onPressed: onAddSet,
                icon: const Icon(Icons.add),
                label: Text(context.tr('live.addSet')),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static T? _at<T>(List<T>? list, int index) =>
      list != null && index < list.length ? list[index] : null;
}

String _typeLetter(BuildContext context, SetType type) =>
    context.tr('live.setTypes.${type.name}.short');

class _HeaderRow extends StatelessWidget {
  const _HeaderRow({required this.formatter});

  final UnitFormatter formatter;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.labelMedium
        ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant);
    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 4, right: 8),
      child: Row(
        children: [
          SizedBox(
            width: 44,
            child: Text(context.tr('live.columns.set'), style: style),
          ),
          Expanded(
            flex: 3,
            child: Text(context.tr('live.columns.previous'), style: style),
          ),
          Expanded(
            flex: 2,
            child: Text(
              formatter.weightUnit,
              style: style,
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              context.tr('live.columns.reps'),
              style: style,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 56),
        ],
      ),
    );
  }
}

class SetRow extends StatelessWidget {
  const SetRow({
    required this.set,
    required this.label,
    required this.formatter,
    required this.onEdit,
    required this.onToggle,
    required this.onType,
    this.previous,
    this.target,
    this.editingField,
    this.editingText = '',
    super.key,
  });

  final WorkoutSet set;
  final String label;
  final WorkoutSet? previous;
  final SetTarget? target;
  final UnitFormatter formatter;
  final SetField? editingField;
  final String editingText;
  final ValueChanged<SetField> onEdit;
  final VoidCallback onToggle;
  final ValueChanged<SetType> onType;

  String _weight(double? kg) => kg == null
      ? ''
      : formatter.formatNumber(
          (formatter.displayWeight(kg) * 100).round() / 100,
        );

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final last = previous;
    final previousText = last?.weightKg != null && last?.reps != null
        ? '${_weight(last!.weightKg)} × ${last.reps}'
        : '—';
    final targetReps = target?.repsMin != null && target?.repsMax != null
        ? (target!.repsMin == target!.repsMax
              ? '${target!.repsMin}'
              : '${target!.repsMin}-${target!.repsMax}')
        : null;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      color: set.completed
          ? scheme.primaryContainer.withValues(alpha: 0.6)
          : Colors.transparent,
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(
            width: 44,
            child: PopupMenuButton<SetType>(
              tooltip: context.tr('live.setType'),
              initialValue: set.type,
              onSelected: onType,
              itemBuilder: (_) => [
                for (final type in SetType.values)
                  PopupMenuItem(
                    value: type,
                    child: Text(context.tr('live.setTypes.${type.name}.name')),
                  ),
              ],
              child: Center(
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: set.type == SetType.normal
                        ? null
                        : switch (set.type) {
                            SetType.warmup => scheme.tertiary,
                            SetType.failure => scheme.error,
                            _ => scheme.secondary,
                          },
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              previousText,
              style: Theme.of(context).textTheme.bodyMedium
                  ?.copyWith(color: scheme.onSurfaceVariant),
            ),
          ),
          Expanded(
            flex: 2,
            child: _Cell(
              text: editingField == SetField.weight
                  ? editingText
                  : _weight(set.weightKg),
              hint: _weight(target?.weightKg ?? last?.weightKg),
              editing: editingField == SetField.weight,
              semanticLabel: context.tr('live.columns.weight'),
              onTap: () => onEdit(SetField.weight),
            ),
          ),
          Expanded(
            flex: 2,
            child: _Cell(
              text: editingField == SetField.reps
                  ? editingText
                  : (set.reps?.toString() ?? ''),
              hint: targetReps ?? last?.reps?.toString() ?? '',
              editing: editingField == SetField.reps,
              semanticLabel: context.tr('live.columns.reps'),
              onTap: () => onEdit(SetField.reps),
            ),
          ),
          SizedBox(
            width: 56,
            child: IconButton(
              iconSize: 32,
              tooltip: context.tr(
                set.completed ? 'live.undoSet' : 'live.completeSet',
              ),
              isSelected: set.completed,
              style: IconButton.styleFrom(
                minimumSize: const Size(52, 52),
                backgroundColor: set.completed
                    ? scheme.primary
                    : scheme.surfaceContainerHighest,
                foregroundColor: set.completed
                    ? scheme.onPrimary
                    : scheme.onSurface,
              ),
              icon: const Icon(Icons.check),
              onPressed: onToggle,
            ),
          ),
        ],
      ),
    );
  }
}

class _Cell extends StatelessWidget {
  const _Cell({
    required this.text,
    required this.hint,
    required this.editing,
    required this.semanticLabel,
    required this.onTap,
  });

  final String text;
  final String hint;
  final bool editing;
  final String semanticLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final style = Theme.of(context).textTheme.titleMedium;
    return Semantics(
      button: true,
      label: semanticLabel,
      value: text.isEmpty ? hint : text,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Material(
          color: editing
              ? scheme.secondaryContainer
              : scheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(10),
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: onTap,
            child: Container(
              height: 48,
              alignment: Alignment.center,
              decoration: editing
                  ? BoxDecoration(
                      border: Border.all(color: scheme.primary, width: 2),
                      borderRadius: BorderRadius.circular(10),
                    )
                  : null,
              child: Text(
                text.isEmpty ? hint : text,
                style: style?.copyWith(
                  color: text.isEmpty ? scheme.outline : null,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
