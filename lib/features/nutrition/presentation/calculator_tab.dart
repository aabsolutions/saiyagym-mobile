import 'package:clock/clock.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saiyagym_mobile/core/units/unit_formatter.dart';
import 'package:saiyagym_mobile/features/auth/domain/entities/user.dart';
import 'package:saiyagym_mobile/features/auth/presentation/controllers/session_controller.dart';
import 'package:saiyagym_mobile/features/body_metrics/domain/body_metric.dart';
import 'package:saiyagym_mobile/features/nutrition/domain/nutrition_calculator.dart';
import 'package:saiyagym_mobile/features/nutrition/nutrition_providers.dart';
import 'package:saiyagym_mobile/features/profile/presentation/preferences_providers.dart';
import 'package:saiyagym_mobile/features/progress/progress_providers.dart';

/// Orientative kcal + macros, computed on the device (port of the API's
/// calculator), prefilled from the profile and the latest weigh-in.
class CalculatorTab extends ConsumerStatefulWidget {
  const CalculatorTab({super.key});

  @override
  ConsumerState<CalculatorTab> createState() => _CalculatorTabState();
}

class _CalculatorTabState extends ConsumerState<CalculatorTab> {
  final _age = TextEditingController();
  final _height = TextEditingController();
  final _weight = TextEditingController();
  FormulaSex? _sex;
  bool _filled = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_filled) return;
    _filled = true;
    final formatter = UnitFormatter(
      ref.read(unitSystemProvider),
      locale: context.locale.languageCode,
    );
    final profile = ref.read(currentUserProvider)?.profile;
    _sex = switch (profile?.sex) {
      Sex.male => FormulaSex.male,
      Sex.female => FormulaSex.female,
      _ => null,
    };
    if (profile?.birthDate case final birth?) {
      _age.text = '${ageInYears(birth, clock.now())}';
    }
    if (profile?.heightCm case final cm?) {
      _height.text = formatter.formatNumber(formatter.displayLength(cm));
    }
    ref.listenManual(
      bodyMetricsProvider,
      (_, next) => _prefillWeight(formatter, next.value ?? const []),
      fireImmediately: true,
    );
  }

  /// The latest weigh-in arrives from Drift after the first frame.
  void _prefillWeight(UnitFormatter formatter, List<BodyMetric> metrics) {
    final kg = metrics.where((m) => m.weightKg != null).firstOrNull?.weightKg;
    if (kg == null) return;
    // Not during build: the field would rebuild mid-frame.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _weight.text.isNotEmpty) return;
      setState(
        () =>
            _weight.text = formatter.formatNumber(formatter.displayWeight(kg)),
      );
    });
  }

  @override
  void dispose() {
    _age.dispose();
    _height.dispose();
    _weight.dispose();
    super.dispose();
  }

  String? _ageError() {
    final age = int.tryParse(_age.text.trim());
    if (_age.text.trim().isEmpty) return null;
    return age == null ||
            age < CalculatorBounds.minAge ||
            age > CalculatorBounds.maxAge
        ? context.tr(
            'nutrition.calculator.range',
            namedArgs: {
              'min': '${CalculatorBounds.minAge}',
              'max': '${CalculatorBounds.maxAge}',
            },
          )
        : null;
  }

  String? _rangeError(
    UnitFormatter formatter,
    TextEditingController controller, {
    required double min,
    required double max,
    required double Function(double) toStored,
    required double Function(double) toDisplay,
  }) {
    if (controller.text.trim().isEmpty) return null;
    final value = UnitFormatter.parseNumber(controller.text);
    final stored = value == null ? null : toStored(value);
    if (stored != null && stored >= min && stored <= max) return null;
    return context.tr(
      'nutrition.calculator.range',
      namedArgs: {
        'min': formatter.formatNumber(toDisplay(min)),
        'max': formatter.formatNumber(toDisplay(max)),
      },
    );
  }

  CalculatorInput? _input(UnitFormatter formatter, CalculatorChoice choice) {
    final age = int.tryParse(_age.text.trim());
    final height = UnitFormatter.parseNumber(_height.text);
    final weight = UnitFormatter.parseNumber(_weight.text);
    final sex = _sex;
    if (sex == null || age == null || height == null || weight == null) {
      return null;
    }
    final heightCm = formatter.lengthToCm(height);
    final weightKg = formatter.weightToKg(weight);
    if (age < CalculatorBounds.minAge ||
        age > CalculatorBounds.maxAge ||
        heightCm < CalculatorBounds.minHeightCm ||
        heightCm > CalculatorBounds.maxHeightCm ||
        weightKg < CalculatorBounds.minWeightKg ||
        weightKg > CalculatorBounds.maxWeightKg) {
      return null;
    }
    return CalculatorInput(
      sex: sex,
      ageYears: age,
      heightCm: heightCm,
      weightKg: weightKg,
      activity: choice.activity,
      goal: choice.goal,
    );
  }

  @override
  Widget build(BuildContext context) {
    final formatter = ref.unitFormatter(context);
    final choice = ref.watch(calculatorChoiceControllerProvider).value;
    if (choice == null) {
      return const Center(child: CircularProgressIndicator());
    }
    final controller = ref.read(calculatorChoiceControllerProvider.notifier);
    final input = _input(formatter, choice);
    final result = input == null ? null : calculateNutrition(input);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          context.tr('nutrition.calculator.sex'),
          style: Theme.of(context).textTheme.labelLarge,
        ),
        const SizedBox(height: 6),
        SegmentedButton<FormulaSex>(
          emptySelectionAllowed: true,
          segments: [
            for (final sex in FormulaSex.values)
              ButtonSegment(
                value: sex,
                label: Text(context.tr('profile.sexes.${sex.name}')),
              ),
          ],
          selected: {?_sex},
          onSelectionChanged: (value) =>
              setState(() => _sex = value.firstOrNull),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _age,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: context.tr('nutrition.calculator.age'),
            errorText: _ageError(),
          ),
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _height,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            labelText: context.tr('nutrition.calculator.height'),
            suffixText: formatter.lengthUnit,
            errorText: _rangeError(
              formatter,
              _height,
              min: CalculatorBounds.minHeightCm,
              max: CalculatorBounds.maxHeightCm,
              toStored: formatter.lengthToCm,
              toDisplay: formatter.displayLength,
            ),
          ),
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _weight,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            labelText: context.tr('nutrition.calculator.weight'),
            suffixText: formatter.weightUnit,
            errorText: _rangeError(
              formatter,
              _weight,
              min: CalculatorBounds.minWeightKg,
              max: CalculatorBounds.maxWeightKg,
              toStored: formatter.weightToKg,
              toDisplay: formatter.displayWeight,
            ),
          ),
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<ActivityLevel>(
          initialValue: choice.activity,
          isExpanded: true,
          decoration: InputDecoration(
            labelText: context.tr('nutrition.calculator.activity'),
          ),
          items: [
            for (final level in ActivityLevel.values)
              DropdownMenuItem(
                value: level,
                child: Text(
                  context.tr('nutrition.activity.${level.name}'),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
          ],
          onChanged: (level) => level == null
              ? null
              : controller.set(
                  CalculatorChoice(goal: choice.goal, activity: level),
                ),
        ),
        const SizedBox(height: 16),
        Text(
          context.tr('nutrition.calculator.goal'),
          style: Theme.of(context).textTheme.labelLarge,
        ),
        const SizedBox(height: 6),
        GoalSelector(
          value: choice.goal,
          onChanged: (goal) => controller.set(
            CalculatorChoice(
              goal: goal ?? choice.goal,
              activity: choice.activity,
            ),
          ),
        ),
        const SizedBox(height: 20),
        if (result == null)
          Text(
            context.tr('nutrition.calculator.fillIn'),
            textAlign: TextAlign.center,
          )
        else
          _ResultCard(result: result),
      ],
    );
  }
}

/// Bulk / cut / maintenance; with [allowAll], tapping the selected one
/// clears it (null = every goal).
class GoalSelector extends StatelessWidget {
  const GoalSelector({
    required this.value,
    required this.onChanged,
    this.allowAll = false,
    super.key,
  });

  final NutritionGoal? value;
  final ValueChanged<NutritionGoal?> onChanged;
  final bool allowAll;

  @override
  Widget build(BuildContext context) => SegmentedButton<NutritionGoal>(
    emptySelectionAllowed: allowAll,
    showSelectedIcon: false,
    segments: [
      for (final goal in NutritionGoal.values)
        ButtonSegment(
          value: goal,
          label: Text(context.tr('nutrition.goals.${goal.name}')),
        ),
    ],
    selected: {?value},
    onSelectionChanged: (selection) => onChanged(selection.firstOrNull),
  );
}

class _ResultCard extends StatelessWidget {
  const _ResultCard({required this.result});

  final CalculatorResult result;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final macros = result.macros;
    Widget macro(String key, int grams, int percent) => Expanded(
      child: Column(
        children: [
          Text('$grams g', style: theme.textTheme.titleMedium),
          Text(
            '${context.tr('nutrition.macros.$key')} · $percent %',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall,
          ),
        ],
      ),
    );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Semantics(
              label: context.tr('nutrition.calculator.target'),
              child: Text(
                context.tr(
                  'nutrition.kcal',
                  namedArgs: {'value': '${result.targetKcal}'},
                ),
                style: theme.textTheme.displaySmall,
              ),
            ),
            Text(context.tr('nutrition.calculator.target')),
            const SizedBox(height: 8),
            Text(
              context.tr(
                'nutrition.calculator.bmrTdee',
                namedArgs: {
                  'bmr': '${result.bmrKcal}',
                  'tdee': '${result.tdeeKcal}',
                },
              ),
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall,
            ),
            if (result.clampedToBmr)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  context.tr('nutrition.calculator.clamped'),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: theme.colorScheme.error),
                ),
              ),
            const Divider(height: 24),
            Row(
              children: [
                macro('protein', macros.proteinG, macros.proteinPercent),
                macro('carbs', macros.carbsG, macros.carbsPercent),
                macro('fat', macros.fatG, macros.fatPercent),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
