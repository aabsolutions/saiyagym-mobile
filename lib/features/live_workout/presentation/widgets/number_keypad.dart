import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// In-app numeric keypad: big keys for sweaty fingers, quick ± steps
/// (2.5 kg / 1 rep) and "next field", without the system keyboard covering
/// half the workout.
class NumberKeypad extends StatelessWidget {
  const NumberKeypad({
    required this.onKey,
    required this.onBackspace,
    required this.onStep,
    required this.onNext,
    required this.onDone,
    required this.stepLabel,
    required this.decimalSeparator,
    this.allowDecimal = true,
    super.key,
  });

  final ValueChanged<String> onKey;
  final VoidCallback onBackspace;

  /// +1 / -1 step.
  final ValueChanged<int> onStep;
  final VoidCallback onNext;
  final VoidCallback onDone;

  /// e.g. `2.5` or `1`.
  final String stepLabel;
  final String decimalSeparator;
  final bool allowDecimal;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    Widget key(
      String label,
      VoidCallback? onTap, {
      Color? color,
      Widget? child,
    }) => Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Material(
          color: color ?? scheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: onTap,
            child: SizedBox(
              height: 56,
              child: Center(
                child:
                    child ??
                    Text(
                      label,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
              ),
            ),
          ),
        ),
      ),
    );
    Widget digit(String d) => key(d, () => onKey(d));
    final stepColor = scheme.secondaryContainer;

    return Material(
      elevation: 8,
      color: scheme.surfaceContainerLow,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  digit('1'),
                  digit('2'),
                  digit('3'),
                  key('-$stepLabel', () => onStep(-1), color: stepColor),
                ],
              ),
              Row(
                children: [
                  digit('4'),
                  digit('5'),
                  digit('6'),
                  key('+$stepLabel', () => onStep(1), color: stepColor),
                ],
              ),
              Row(
                children: [
                  digit('7'),
                  digit('8'),
                  digit('9'),
                  key(
                    '',
                    onBackspace,
                    child: Semantics(
                      label: context.tr('live.keypad.backspace'),
                      child: const Icon(Icons.backspace_outlined),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  key(
                    decimalSeparator,
                    allowDecimal ? () => onKey(decimalSeparator) : null,
                  ),
                  digit('0'),
                  key(
                    '',
                    onNext,
                    child: Text(
                      context.tr('live.keypad.next'),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  key(
                    '',
                    onDone,
                    color: scheme.primary,
                    child: Icon(Icons.check, color: scheme.onPrimary, size: 28),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
