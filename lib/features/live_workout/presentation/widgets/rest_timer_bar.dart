import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:saiyagym_mobile/features/live_workout/domain/live_session.dart';
import 'package:saiyagym_mobile/features/live_workout/presentation/widgets/ticker.dart';

/// Countdown between sets with -15 s / +15 s / skip. Driven by the stored
/// end time, so it is right after the app was in the background.
class RestTimerBar extends StatelessWidget {
  const RestTimerBar({
    required this.rest,
    required this.onAdjust,
    required this.onSkip,
    required this.onFinished,
    super.key,
  });

  final RestTimer rest;
  final ValueChanged<int> onAdjust;
  final VoidCallback onSkip;
  final VoidCallback onFinished;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: scheme.primaryContainer,
      elevation: 6,
      child: SafeArea(
        top: false,
        child: Ticker(
          builder: (context, now) {
            final remaining = rest.remaining(now);
            if (remaining == Duration.zero) {
              WidgetsBinding.instance.addPostFrameCallback((_) => onFinished());
            }
            final progress = rest.totalSeconds == 0
                ? 0.0
                : remaining.inMilliseconds / (rest.totalSeconds * 1000);
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                LinearProgressIndicator(value: progress.clamp(0, 1)),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
                  child: Row(
                    children: [
                      Icon(
                        Icons.timer_outlined,
                        color: scheme.onPrimaryContainer,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Semantics(
                          liveRegion: true,
                          label: context.tr('live.rest.label'),
                          child: Text(
                            formatDuration(remaining),
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(
                                  color: scheme.onPrimaryContainer,
                                  fontFeatures: const [
                                    FontFeature.tabularFigures(),
                                  ],
                                ),
                          ),
                        ),
                      ),
                      _RestButton(label: '-15', onTap: () => onAdjust(-15)),
                      _RestButton(label: '+15', onTap: () => onAdjust(15)),
                      TextButton(
                        onPressed: onSkip,
                        child: Text(context.tr('live.rest.skip')),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _RestButton extends StatelessWidget {
  const _RestButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 4),
    child: OutlinedButton(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(56, 48),
        padding: const EdgeInsets.symmetric(horizontal: 8),
      ),
      onPressed: onTap,
      child: Text(label),
    ),
  );
}
