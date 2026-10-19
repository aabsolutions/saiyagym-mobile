import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:saiyagym_mobile/app/router/app_routes.dart';
import 'package:saiyagym_mobile/features/live_workout/domain/live_session.dart';
import 'package:saiyagym_mobile/features/live_workout/live_workout_providers.dart';
import 'package:saiyagym_mobile/features/live_workout/presentation/live_workout_controller.dart';
import 'package:saiyagym_mobile/features/live_workout/presentation/widgets/ticker.dart';

/// Starts [plan] (or resumes the running session) and opens the screen.
Future<void> startSession(
  BuildContext context,
  WidgetRef ref,
  StartPlan plan,
) async {
  final controller = ref.read(liveWorkoutControllerProvider.notifier);
  final running = ref.read(liveWorkoutControllerProvider);
  if (running != null) {
    // Already training: don't silently start another one.
    final open = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(dialogContext.tr('live.alreadyRunning.title')),
        content: Text(dialogContext.tr('live.alreadyRunning.message')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(dialogContext.tr('common.cancel')),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(dialogContext.tr('live.resume')),
          ),
        ],
      ),
    );
    if ((open ?? false) && context.mounted) {
      unawaited(context.push(AppRoutes.workout));
    }
    return;
  }
  await controller.start(plan);
  if (context.mounted) await context.push(AppRoutes.workout);
}

/// "Session in progress · 12:34 · Back" above the tabs.
class ActiveSessionBar extends ConsumerWidget {
  const ActiveSessionBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(liveWorkoutControllerProvider);
    if (session == null) return const SizedBox.shrink();
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: scheme.primary,
      child: InkWell(
        onTap: () => context.push(AppRoutes.workout),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Icon(Icons.fitness_center, color: scheme.onPrimary),
              const SizedBox(width: 12),
              Expanded(
                child: Ticker(
                  builder: (context, now) => Text(
                    context.tr(
                      'live.activeBar',
                      namedArgs: {
                        'time': formatDuration(session.workout.elapsed(now)),
                      },
                    ),
                    style: Theme.of(context).textTheme.titleSmall
                        ?.copyWith(color: scheme.onPrimary),
                  ),
                ),
              ),
              Text(
                context.tr('live.resume'),
                style: TextStyle(
                  color: scheme.onPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Icon(Icons.chevron_right, color: scheme.onPrimary),
            ],
          ),
        ),
      ),
    );
  }
}

/// On app open: a session left running (app killed, phone rebooted) is
/// offered to resume or discard.
class ResumeSessionGate extends ConsumerStatefulWidget {
  const ResumeSessionGate({required this.child, super.key});

  final Widget child;

  @override
  ConsumerState<ResumeSessionGate> createState() => _ResumeSessionGateState();
}

class _ResumeSessionGateState extends ConsumerState<ResumeSessionGate> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || ref.read(resumeOfferedProvider)) return;
      ref.read(resumeOfferedProvider.notifier).markOffered();
      unawaited(_check());
    });
  }

  Future<void> _check() async {
    final controller = ref.read(liveWorkoutControllerProvider.notifier);
    final session = await controller.restore();
    if (session == null || !mounted) return;
    final resume = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        icon: const Icon(Icons.restore),
        title: Text(dialogContext.tr('live.resumePrompt.title')),
        content: Text(
          dialogContext.tr(
            'live.resumePrompt.message',
            namedArgs: {
              'time': DateFormat.Hm(dialogContext.locale.languageCode)
                  .format(session.workout.startedAt.toLocal()),
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(dialogContext.tr('live.discard.action')),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(dialogContext.tr('live.resume')),
          ),
        ],
      ),
    );
    if (!mounted) return;
    if (resume ?? true) {
      await context.push(AppRoutes.workout);
    } else {
      await controller.discard();
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
