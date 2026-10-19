import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:saiyagym_mobile/core/units/unit_formatter.dart';
import 'package:saiyagym_mobile/features/auth/domain/entities/user.dart';

// Inputs shared by onboarding and "edit profile". All values in and out are
// in storage units (kg / cm); conversion happens only for display.

/// One big tappable card per option (easy to hit with tired hands).
class OptionCards<T> extends StatelessWidget {
  const OptionCards({
    required this.options,
    required this.selected,
    required this.onSelected,
    required this.title,
    this.description,
    super.key,
  });

  final List<T> options;
  final T? selected;
  final ValueChanged<T> onSelected;
  final String Function(T option) title;
  final String Function(T option)? description;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        for (final option in options)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Semantics(
              selected: option == selected,
              button: true,
              child: Card(
                color: option == selected
                    ? scheme.primaryContainer
                    : scheme.surfaceContainerLow,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(
                    color: option == selected
                        ? scheme.primary
                        : Colors.transparent,
                    width: 2,
                  ),
                ),
                clipBehavior: Clip.antiAlias,
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  title: Text(title(option)),
                  subtitle: description == null
                      ? null
                      : Text(description!(option)),
                  trailing: Icon(
                    option == selected
                        ? Icons.check_circle
                        : Icons.circle_outlined,
                    color: option == selected ? scheme.primary : scheme.outline,
                  ),
                  onTap: () => onSelected(option),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class LevelSelector extends StatelessWidget {
  const LevelSelector({
    required this.selected,
    required this.onSelected,
    super.key,
  });

  final TrainingLevel? selected;
  final ValueChanged<TrainingLevel> onSelected;

  @override
  Widget build(BuildContext context) => OptionCards(
    options: TrainingLevel.values,
    selected: selected,
    onSelected: onSelected,
    title: (level) => context.tr('profile.levels.${level.name}.title'),
    description: (level) =>
        context.tr('profile.levels.${level.name}.description'),
  );
}

class GoalSelector extends StatelessWidget {
  const GoalSelector({
    required this.selected,
    required this.onSelected,
    super.key,
  });

  final TrainingGoal? selected;
  final ValueChanged<TrainingGoal> onSelected;

  @override
  Widget build(BuildContext context) => OptionCards(
    options: TrainingGoal.values,
    selected: selected,
    onSelected: onSelected,
    title: (goal) => context.tr('profile.goals.${goal.name}.title'),
    description: (goal) => context.tr('profile.goals.${goal.name}.description'),
  );
}

class SexSelector extends StatelessWidget {
  const SexSelector({
    required this.selected,
    required this.onSelected,
    super.key,
  });

  final Sex? selected;
  final ValueChanged<Sex> onSelected;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: double.infinity,
    child: SegmentedButton<Sex>(
      emptySelectionAllowed: true,
      segments: [
        for (final sex in Sex.values)
          ButtonSegment(
            value: sex,
            label: Text(context.tr('profile.sexes.${sex.name}')),
          ),
      ],
      selected: {?selected},
      onSelectionChanged: (value) {
        if (value.isNotEmpty) onSelected(value.single);
      },
    ),
  );
}

class BirthDateField extends StatelessWidget {
  const BirthDateField({
    required this.value,
    required this.onChanged,
    super.key,
  });

  final DateTime? value;
  final ValueChanged<DateTime> onChanged;

  // Same bounds a gym app reasonably needs; the API only checks the format.
  static const _minAgeYears = 12;

  Future<void> _pick(BuildContext context) async {
    final now = DateTime.now();
    final last = DateTime(now.year - _minAgeYears, now.month, now.day);
    final picked = await showDatePicker(
      context: context,
      initialDate: value ?? DateTime(now.year - 30),
      firstDate: DateTime(1900),
      lastDate: last,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      initialDatePickerMode: DatePickerMode.year,
    );
    if (picked != null) onChanged(picked);
  }

  @override
  Widget build(BuildContext context) {
    final date = value;
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () => _pick(context),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: context.tr('profile.birthDate'),
          prefixIcon: const Icon(Icons.cake_outlined),
          suffixIcon: const Icon(Icons.edit_calendar),
        ),
        isEmpty: date == null,
        child: date == null
            ? null
            : Text(DateFormat.yMMMd(context.locale.languageCode).format(date)),
      ),
    );
  }
}

enum MeasurementKind { weight, length }

/// Numeric input in the user's units; reports the value in kg / cm.
///
/// Rebuild it with a new key when the unit system changes, so the text is
/// re-rendered in the new unit.
class MeasurementField extends StatefulWidget {
  const MeasurementField({
    required this.kind,
    required this.label,
    required this.formatter,
    required this.min,
    required this.max,
    required this.onChanged,
    this.initialValue,
    this.icon,
    super.key,
  });

  final MeasurementKind kind;
  final String label;
  final UnitFormatter formatter;

  /// Bounds in storage units (kg / cm).
  final double min;
  final double max;

  /// Storage units; `null` = empty.
  final double? initialValue;
  final ValueChanged<double?> onChanged;
  final IconData? icon;

  @override
  State<MeasurementField> createState() => _MeasurementFieldState();
}

class _MeasurementFieldState extends State<MeasurementField> {
  late final TextEditingController _controller;

  UnitFormatter get _units => widget.formatter;
  bool get _isWeight => widget.kind == MeasurementKind.weight;

  double _toDisplay(double base) =>
      _isWeight ? _units.displayWeight(base) : _units.displayLength(base);
  double _toBase(double display) =>
      _isWeight ? _units.weightToKg(display) : _units.lengthToCm(display);

  @override
  void initState() {
    super.initState();
    final initial = widget.initialValue;
    _controller = TextEditingController(
      text: initial == null
          ? ''
          : _units.formatNumber((_toDisplay(initial) * 10).round() / 10),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double? _parse(String text) {
    final display = UnitFormatter.parseNumber(text);
    return display == null ? null : _toBase(display);
  }

  String? _validate(String? text) {
    if (text == null || text.trim().isEmpty) return null; // optional
    final base = _parse(text);
    if (base == null) return context.tr('validation.number');
    if (base < widget.min || base > widget.max) {
      return context.tr(
        'validation.range',
        namedArgs: {
          'min': _units.formatNumber(_toDisplay(widget.min).ceilToDouble()),
          'max': _units.formatNumber(_toDisplay(widget.max).floorToDouble()),
        },
      );
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      textInputAction: TextInputAction.next,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: _validate,
      onChanged: (text) {
        final base = _parse(text);
        widget.onChanged(
          base != null && base >= widget.min && base <= widget.max
              ? base
              : null,
        );
      },
      decoration: InputDecoration(
        labelText: widget.label,
        prefixIcon: widget.icon == null ? null : Icon(widget.icon),
        suffixText: _isWeight ? _units.weightUnit : _units.lengthUnit,
      ),
    );
  }
}

/// Default rest between sets.
class RestSelector extends StatelessWidget {
  const RestSelector({
    required this.seconds,
    required this.onSelected,
    super.key,
  });

  static const options = [60, 90, 120, 150, 180, 240, 300];

  final int seconds;
  final ValueChanged<int> onSelected;

  /// `1:30` — universal, no translation needed.
  static String format(int seconds) =>
      '${seconds ~/ 60}:${(seconds % 60).toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        for (final option in {...options, seconds}.toList()..sort())
          ChoiceChip(
            label: Text(format(option)),
            labelStyle: Theme.of(context).textTheme.titleMedium,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            selected: option == seconds,
            onSelected: (_) => onSelected(option),
          ),
      ],
    );
  }
}

/// Stored ranges (same as `UpdateProfileDto.heightCm`).
abstract final class BodyLimits {
  static const minHeightCm = 50.0;
  static const maxHeightCm = 272.0;
  static const minWeightKg = 20.0;
  static const maxWeightKg = 400.0;
}
