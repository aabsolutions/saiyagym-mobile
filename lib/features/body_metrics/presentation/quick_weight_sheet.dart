import 'dart:async';

import 'package:clock/clock.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saiyagym_mobile/core/feedback/haptics.dart';
import 'package:saiyagym_mobile/core/units/unit_formatter.dart';
import 'package:saiyagym_mobile/core/widgets/primary_button.dart';
import 'package:saiyagym_mobile/features/body_metrics/body_metrics_providers.dart';
import 'package:saiyagym_mobile/features/body_metrics/domain/body_metric.dart';
import 'package:saiyagym_mobile/features/profile/presentation/preferences_providers.dart';
import 'package:uuid/uuid.dart';

/// Today's weight in one field (works offline: local row + sync queue).
/// Returns true when saved.
Future<bool> showQuickWeightSheet(BuildContext context, {double? lastKg}) =>
    showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => _QuickWeightSheet(lastKg: lastKg),
    ).then((saved) => saved ?? false);

class _QuickWeightSheet extends ConsumerStatefulWidget {
  const _QuickWeightSheet({this.lastKg});

  final double? lastKg;

  @override
  ConsumerState<_QuickWeightSheet> createState() => _QuickWeightSheetState();
}

class _QuickWeightSheetState extends ConsumerState<_QuickWeightSheet> {
  static const _uuid = Uuid();
  final _controller = TextEditingController();
  String? _error;
  bool _saving = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _save(UnitFormatter formatter) async {
    final value = UnitFormatter.parseNumber(_controller.text);
    final kg = value == null ? null : formatter.weightToKg(value);
    if (kg == null || !BodyMeasure.weightKg.accepts(kg)) {
      setState(() => _error = context.tr('body.invalid'));
      return;
    }
    setState(() => _saving = true);
    await ref
        .read(bodyMetricsRepositoryProvider)
        .save(
          BodyMetric(
            id: _uuid.v4(),
            measuredAt: clock.now().toUtc(),
            weightKg: kg,
          ),
        );
    unawaited(confirmHaptic());
    if (mounted) Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final formatter = ref.unitFormatter(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(
        16,
        0,
        16,
        16 + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            context.tr('body.quickTitle'),
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _controller,
            autofocus: true,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: context.tr('body.measures.weightKg'),
              suffixText: formatter.weightUnit,
              // The last weight as a hint: most days it barely changes.
              hintText: widget.lastKg == null
                  ? null
                  : formatter.formatNumber(
                      formatter.displayWeight(widget.lastKg!),
                    ),
              errorText: _error,
            ),
            onSubmitted: (_) => _save(formatter),
          ),
          const SizedBox(height: 16),
          PrimaryButton(
            label: context.tr('common.save'),
            isLoading: _saving,
            onPressed: () => _save(formatter),
          ),
        ],
      ),
    );
  }
}
