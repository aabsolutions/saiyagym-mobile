import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saiyagym_mobile/core/units/unit_formatter.dart';
import 'package:saiyagym_mobile/features/live_workout/domain/plate_calculator.dart';
import 'package:saiyagym_mobile/features/live_workout/live_workout_providers.dart';

/// Profile → Training: bar, available plates, keep screen on.
class TrainingSettingsSection extends ConsumerWidget {
  const TrainingSettingsSection({super.key});

  /// Plates a gym may have, per unit.
  static const List<double> _kgPlates = [
    50,
    25,
    20,
    15,
    10,
    5,
    2.5,
    2,
    1.25,
    1,
    0.5,
  ];
  static const List<double> _lbPlates = [100, 55, 45, 35, 25, 10, 5, 2.5];
  static const List<double> _kgBars = [20, 15, 10, 25];
  static const List<double> _lbBars = [45, 35, 15, 55];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(trainingSettingsControllerProvider).value;
    if (settings == null) return const SizedBox.shrink();
    final controller = ref.read(trainingSettingsControllerProvider.notifier);
    final config = settings.plates;
    final imperial = config.unit == UnitSystem.imperial;
    final unit = UnitFormatter(
      config.unit,
      locale: context.locale.languageCode,
    );
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 24, bottom: 12),
          child: Text(
            context.tr('profile.training'),
            style: theme.textTheme.titleMedium,
          ),
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(context.tr('live.keepScreenOn')),
          subtitle: Text(context.tr('profile.keepScreenOnHint')),
          value: settings.keepScreenOn,
          onChanged: (value) =>
              controller.save(settings.copyWith(keepScreenOn: value)),
        ),
        const SizedBox(height: 8),
        Text(context.tr('plates.barLabel'), style: theme.textTheme.bodyLarge),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final bar in imperial ? _lbBars : _kgBars)
              ChoiceChip(
                label: Text('${unit.formatNumber(bar)} ${unit.weightUnit}'),
                selected: config.barWeight == bar,
                onSelected: (_) => controller.save(
                  settings.copyWith(plates: config.copyWith(barWeight: bar)),
                ),
              ),
          ],
        ),
        const SizedBox(height: 16),
        Text(context.tr('plates.available'), style: theme.textTheme.bodyLarge),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final plate in imperial ? _lbPlates : _kgPlates)
              FilterChip(
                label: Text(unit.formatNumber(plate)),
                selected: config.plates.contains(plate),
                onSelected: (selected) {
                  final plates = [...config.plates];
                  selected ? plates.add(plate) : plates.remove(plate);
                  if (plates.isEmpty) return; // keep at least one
                  unawaited(
                    controller.save(
                      settings.copyWith(
                        plates: config.copyWith(plates: plates),
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
        TextButton(
          onPressed: () => controller.save(
            settings.copyWith(plates: PlateConfig.defaults(config.unit)),
          ),
          child: Text(context.tr('plates.reset')),
        ),
      ],
    );
  }
}
