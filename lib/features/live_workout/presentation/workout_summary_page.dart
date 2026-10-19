import 'dart:async';
import 'dart:math' as math;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:saiyagym_mobile/app/router/app_routes.dart';
import 'package:saiyagym_mobile/core/sync/sync_providers.dart';
import 'package:saiyagym_mobile/core/units/unit_formatter.dart';
import 'package:saiyagym_mobile/core/widgets/primary_button.dart';
import 'package:saiyagym_mobile/features/exercises/exercises_providers.dart';
import 'package:saiyagym_mobile/features/live_workout/domain/live_session.dart';
import 'package:saiyagym_mobile/features/live_workout/live_workout_providers.dart';
import 'package:saiyagym_mobile/features/live_workout/presentation/live_workout_controller.dart';
import 'package:saiyagym_mobile/features/live_workout/presentation/widgets/live_sheets.dart';
import 'package:saiyagym_mobile/features/profile/presentation/preferences_providers.dart';
import 'package:saiyagym_mobile/features/records/data/records_service.dart';
import 'package:saiyagym_mobile/features/records/domain/personal_records.dart';

/// After finishing: totals, and the new records with a celebration.
/// Records are local first; once the workout syncs, the API confirms them.
class WorkoutSummaryPage extends ConsumerStatefulWidget {
  const WorkoutSummaryPage({required this.outcome, super.key});

  final FinishOutcome outcome;

  @override
  ConsumerState<WorkoutSummaryPage> createState() => _WorkoutSummaryPageState();
}

class _WorkoutSummaryPageState extends ConsumerState<WorkoutSummaryPage> {
  Map<WorkoutRecord, RecordConfirmation> _status = {};
  Map<String, String> _names = {};

  @override
  void initState() {
    super.initState();
    _status = {
      for (final record in widget.outcome.records)
        record: RecordConfirmation.pending,
    };
    unawaited(_loadNames());
    if (widget.outcome.records.isNotEmpty) unawaited(_confirm());
  }

  Future<void> _loadNames() async {
    final repository = ref.read(exercisesRepositoryProvider);
    final names = <String, String>{};
    for (final record in widget.outcome.records) {
      final exercise = await repository.find(record.exerciseId);
      if (exercise != null) names[record.exerciseId] = exercise.name;
    }
    if (mounted) setState(() => _names = names);
  }

  /// Push the workout, then ask the API who holds each record. Offline it
  /// stays "pending": the records are still saved and computed server-side
  /// on the next sync.
  Future<void> _confirm() async {
    final report = await ref.read(syncServiceProvider).sync();
    if (!report.ok || !mounted) return;
    try {
      final result = await ref
          .read(recordsConfirmerProvider)
          .confirm(widget.outcome.workout.id, widget.outcome.records);
      if (mounted) setState(() => _status = result);
    } on Object {
      // Keep "pending"; nothing is lost.
    }
  }

  @override
  Widget build(BuildContext context) {
    final workout = widget.outcome.workout;
    final records = widget.outcome.records;
    final formatter = ref.unitFormatter(context);
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            if (records.isNotEmpty)
              const _Celebration()
            else
              Icon(
                Icons.check_circle,
                size: 96,
                color: theme.colorScheme.primary,
              ),
            const SizedBox(height: 16),
            Text(
              context.tr(
                records.isEmpty ? 'summary.title' : 'summary.titleRecords',
                namedArgs: {'count': '${records.length}'},
              ),
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineMedium,
            ),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: SessionStats(
                  duration: workout.elapsed(
                    workout.finishedAt ?? workout.startedAt,
                  ),
                  volumeKg: workout.liveVolumeKg,
                  sets: workout.completedWorkingSets,
                  formatter: formatter,
                ),
              ),
            ),
            if (records.isNotEmpty) ...[
              const SizedBox(height: 24),
              Text(
                context.tr('summary.records'),
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              for (final record in records)
                Card(
                  child: ListTile(
                    leading: Icon(
                      Icons.emoji_events,
                      color: theme.colorScheme.tertiary,
                      size: 32,
                    ),
                    title: Text(_names[record.exerciseId] ?? ''),
                    subtitle: Text(
                      _describe(context, record.record, formatter),
                    ),
                    trailing: _ConfirmationIcon(status: _status[record]),
                  ),
                ),
              if (_status.values.contains(RecordConfirmation.pending))
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    context.tr('summary.pending'),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
            ],
            const SizedBox(height: 32),
            PrimaryButton(
              label: context.tr('summary.done'),
              onPressed: () => context.go(AppRoutes.history),
            ),
          ],
        ),
      ),
    );
  }

  String _describe(
    BuildContext context,
    NewRecord record,
    UnitFormatter formatter,
  ) {
    String weight(double kg) => formatter.formatWeight(kg);
    return switch (record.type) {
      RecordType.maxWeight => context.tr(
        'summary.types.maxWeight',
        namedArgs: {
          'value': weight(record.value),
          'previous': weight(record.previous),
        },
      ),
      RecordType.bestE1RM => context.tr(
        'summary.types.bestE1RM',
        namedArgs: {
          'value': weight(record.value),
          'previous': weight(record.previous),
        },
      ),
      RecordType.maxVolume => context.tr(
        'summary.types.maxVolume',
        namedArgs: {
          'value': weight(record.value),
          'previous': weight(record.previous),
        },
      ),
      RecordType.repsAtWeight => context.tr(
        'summary.types.repsAtWeight',
        namedArgs: {
          'reps': '${record.value.round()}',
          'weight': weight(record.weightKg),
          'previous': '${record.previous.round()}',
        },
      ),
    };
  }
}

class _ConfirmationIcon extends StatelessWidget {
  const _ConfirmationIcon({required this.status});

  final RecordConfirmation? status;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return switch (status) {
      RecordConfirmation.confirmed => Tooltip(
        message: context.tr('summary.confirmed'),
        child: Icon(Icons.verified, color: scheme.primary),
      ),
      RecordConfirmation.notConfirmed => Tooltip(
        message: context.tr('summary.notConfirmed'),
        child: Icon(Icons.help_outline, color: scheme.outline),
      ),
      _ => Tooltip(
        message: context.tr('summary.pendingShort'),
        child: Icon(Icons.cloud_upload_outlined, color: scheme.outline),
      ),
    };
  }
}

/// Trophy popping in with a burst of confetti (no extra package).
class _Celebration extends StatefulWidget {
  const _Celebration();

  @override
  State<_Celebration> createState() => _CelebrationState();
}

class _CelebrationState extends State<_Celebration>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1600),
  )..forward();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final colors = [
      scheme.primary,
      scheme.tertiary,
      scheme.secondary,
      scheme.error,
    ];
    return SizedBox(
      height: 160,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final t = _controller.value;
          final pop = Curves.elasticOut.transform(math.min(1, t * 1.6));
          return CustomPaint(
            painter: _ConfettiPainter(progress: t, colors: colors),
            child: Center(
              child: Transform.scale(
                scale: pop,
                child: Icon(
                  Icons.emoji_events,
                  size: 112,
                  color: scheme.tertiary,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ConfettiPainter extends CustomPainter {
  _ConfettiPainter({required this.progress, required this.colors});

  final double progress;
  final List<Color> colors;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final random = math.Random(7); // same burst every time
    final fade = (1 - progress).clamp(0.0, 1.0);
    for (var i = 0; i < 36; i++) {
      final angle = random.nextDouble() * math.pi * 2;
      final speed = 60 + random.nextDouble() * 90;
      final distance = speed * Curves.easeOut.transform(progress);
      final drop = 40 * progress * progress;
      final offset =
          center +
          Offset(math.cos(angle) * distance, math.sin(angle) * distance + drop);
      final paint = Paint()
        ..color = colors[i % colors.length].withValues(alpha: fade);
      canvas.drawRect(
        Rect.fromCenter(center: offset, width: 8, height: 5),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_ConfettiPainter old) => old.progress != progress;
}
