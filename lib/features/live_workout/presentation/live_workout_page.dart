import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:saiyagym_mobile/app/router/app_routes.dart';
import 'package:saiyagym_mobile/core/units/unit_formatter.dart';
import 'package:saiyagym_mobile/features/guides/domain/exercise_guide.dart';
import 'package:saiyagym_mobile/features/guides/guides_providers.dart';
import 'package:saiyagym_mobile/features/guides/presentation/guide_view.dart';
import 'package:saiyagym_mobile/features/live_workout/data/device_services.dart';
import 'package:saiyagym_mobile/features/live_workout/domain/live_session.dart';
import 'package:saiyagym_mobile/features/live_workout/domain/workout_editing.dart';
import 'package:saiyagym_mobile/features/live_workout/live_workout_providers.dart';
import 'package:saiyagym_mobile/features/live_workout/presentation/live_workout_controller.dart';
import 'package:saiyagym_mobile/features/live_workout/presentation/widgets/exercise_card.dart';
import 'package:saiyagym_mobile/features/live_workout/presentation/widgets/live_sheets.dart';
import 'package:saiyagym_mobile/features/live_workout/presentation/widgets/number_keypad.dart';
import 'package:saiyagym_mobile/features/live_workout/presentation/widgets/rest_timer_bar.dart';
import 'package:saiyagym_mobile/features/live_workout/presentation/widgets/ticker.dart';
import 'package:saiyagym_mobile/features/profile/presentation/preferences_providers.dart';
import 'package:saiyagym_mobile/features/sounds/domain/sound_purpose.dart';
import 'package:saiyagym_mobile/features/sounds/sounds_providers.dart';
import 'package:saiyagym_mobile/features/workouts/domain/workout.dart';

class LiveWorkoutPage extends ConsumerStatefulWidget {
  const LiveWorkoutPage({super.key});

  @override
  ConsumerState<LiveWorkoutPage> createState() => _LiveWorkoutPageState();
}

class _LiveWorkoutPageState extends ConsumerState<LiveWorkoutPage> {
  // Kept for dispose(), where `ref` is no longer usable.
  late final ScreenAwake _screen;
  EditingCell? _editing;
  String _buffer = '';

  /// The first key replaces the prefilled value (like selecting it).
  bool _fresh = true;

  @override
  void initState() {
    super.initState();
    _screen = ref.read(screenAwakeProvider);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref.read(liveWorkoutControllerProvider.notifier).alarmTitle = context.tr(
        'live.rest.notification',
      );
      unawaited(_prepareAlarm(context.tr('live.rest.channel')));
      unawaited(_applyScreenOn());
    });
  }

  /// Prepares the rest alarm with the installed custom sound (offline-safe).
  /// If the selected sound isn't installed yet (new device, failed download),
  /// it is fetched in the background and the alarm re-prepared once it is.
  Future<void> _prepareAlarm(String channelName) async {
    final alarm = ref.read(restAlarmProvider);
    final sounds = ref.read(
      soundSelectionControllerProvider(SoundPurpose.rest).notifier,
    );
    final installed = await ref.read(
      installedAlarmSoundProvider(SoundPurpose.rest).future,
    );
    if (!mounted) return;
    await alarm.prepare(channelName: channelName, sound: installed);
    if (!mounted ||
        installed != null ||
        ref.read(selectedSoundIdProvider(SoundPurpose.rest)) == null) {
      return;
    }
    final fetched = await sounds.ensureSelectedInstalled();
    if (fetched != null && mounted) {
      await alarm.prepare(channelName: channelName, sound: fetched);
    }
  }

  Future<void> _applyScreenOn() async {
    final settings = await ref.read(trainingSettingsControllerProvider.future);
    if (mounted) {
      await _screen.set(enabled: settings.keepScreenOn);
    }
  }

  @override
  void dispose() {
    unawaited(_screen.set(enabled: false));
    super.dispose();
  }

  LiveWorkoutController get _controller =>
      ref.read(liveWorkoutControllerProvider.notifier);

  // ===== keypad =====

  void _startEditing(
    LiveSession session,
    String exerciseRowId,
    String setId,
    SetField field,
  ) {
    final formatter = ref.read(unitSystemProvider);
    final set = session.workout
        .exerciseRow(exerciseRowId)
        ?.sets
        .where((s) => s.id == setId)
        .firstOrNull;
    if (set == null) return;
    final units = UnitFormatter(formatter, locale: context.locale.languageCode);
    setState(() {
      _editing = EditingCell(exerciseRowId, setId, field);
      _fresh = true;
      _buffer = switch (field) {
        SetField.weight =>
          set.weightKg == null
              ? ''
              : units.formatNumber(
                  (units.displayWeight(set.weightKg!) * 100).round() / 100,
                ),
        SetField.reps => set.reps?.toString() ?? '',
      };
    });
  }

  Future<void> _commit(String text) async {
    final editing = _editing;
    if (editing == null) return;
    setState(() => _buffer = text);
    final value = UnitFormatter.parseNumber(text);
    final units = UnitFormatter(
      ref.read(unitSystemProvider),
      locale: context.locale.languageCode,
    );
    await _controller.updateSet(
      editing.exerciseRowId,
      editing.setId,
      weightKg: editing.field == SetField.weight
          ? () => value == null ? null : units.weightToKg(value)
          : null,
      reps: editing.field == SetField.reps ? () => value?.round() : null,
    );
  }

  void _key(String key) {
    final separator = _decimalSeparator;
    if (key == separator && !_fresh && _buffer.contains(separator)) return;
    final next = _fresh ? (key == separator ? '0$key' : key) : '$_buffer$key';
    _fresh = false;
    unawaited(_commit(next));
  }

  void _backspace() {
    _fresh = false;
    if (_buffer.isEmpty) return;
    unawaited(_commit(_buffer.substring(0, _buffer.length - 1)));
  }

  void _step(int direction) {
    final editing = _editing;
    if (editing == null) return;
    final current = UnitFormatter.parseNumber(_buffer) ?? 0;
    final imperial = ref.read(unitSystemProvider) == UnitSystem.imperial;
    final step = editing.field == SetField.reps ? 1.0 : (imperial ? 5.0 : 2.5);
    final next = (current + step * direction).clamp(0, 9999).toDouble();
    _fresh = false;
    final units = UnitFormatter(
      ref.read(unitSystemProvider),
      locale: context.locale.languageCode,
    );
    unawaited(
      _commit(
        editing.field == SetField.reps
            ? '${next.round()}'
            : units.formatNumber(next),
      ),
    );
  }

  /// Weight → reps of the same set → weight of the next set.
  void _next(LiveSession session) {
    final editing = _editing;
    if (editing == null) return;
    if (editing.field == SetField.weight) {
      _startEditing(
        session,
        editing.exerciseRowId,
        editing.setId,
        SetField.reps,
      );
      return;
    }
    final exercise = session.workout.exerciseRow(editing.exerciseRowId);
    final sets = exercise?.sets ?? const [];
    final index = sets.indexWhere((s) => s.id == editing.setId);
    if (index >= 0 && index + 1 < sets.length) {
      _startEditing(
        session,
        editing.exerciseRowId,
        sets[index + 1].id,
        SetField.weight,
      );
    } else {
      setState(() => _editing = null);
    }
  }

  String get _decimalSeparator =>
      NumberFormat.decimalPattern(context.locale.languageCode)
          .symbols
          .DECIMAL_SEP;

  // ===== actions =====

  Future<void> _onAction(
    LiveSession session,
    String exerciseRowId,
    ExerciseAction action,
  ) async {
    switch (action) {
      case ExerciseAction.notes:
        final current = session.workout.exerciseRow(exerciseRowId)?.notes ?? '';
        final notes = await editNotes(context, current);
        if (notes != null) await _controller.setNotes(exerciseRowId, notes);
      case ExerciseAction.replace:
        final exerciseId = await pickExercise(context);
        if (exerciseId != null) {
          await _controller.replaceExercise(exerciseRowId, exerciseId);
        }
      case ExerciseAction.superset:
        await _controller.toggleSuperset(exerciseRowId);
      case ExerciseAction.remove:
        final confirmed = await _confirm(
          title: context.tr('live.removeExercise.title'),
          message: context.tr('live.removeExercise.message'),
          action: context.tr('live.actions.remove'),
        );
        if (confirmed) await _controller.removeExercise(exerciseRowId);
    }
  }

  Future<bool> _confirm({
    required String title,
    required String message,
    required String action,
  }) async =>
      await showDialog<bool>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: Text(title),
          content: Text(message),
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
              child: Text(action),
            ),
          ],
        ),
      ) ??
      false;

  Future<void> _discard() async {
    final confirmed = await _confirm(
      title: context.tr('live.discard.title'),
      message: context.tr('live.discard.message'),
      action: context.tr('live.discard.action'),
    );
    if (!confirmed) return;
    await _controller.discard();
    if (mounted) context.go(AppRoutes.train);
  }

  Future<void> _finish(LiveSession session, UnitFormatter formatter) async {
    setState(() => _editing = null);
    final input = await showFinishSheet(
      context,
      session: session,
      formatter: formatter,
    );
    if (input == null || !mounted) return;
    final outcome = await _controller.finish(
      rating: input.rating,
      notes: input.notes,
    );
    if (outcome == null || !mounted) return;
    context.go(AppRoutes.workoutSummary, extra: outcome);
  }

  /// From a routine (or a program day): what the routines unlock. Without
  /// one, the API also unlocks the session's first N guided exercises.
  GuideAccess _guidesFor(Workout workout) {
    final stored =
        ref.watch(guidesControllerProvider).value ?? GuideAccess.empty;
    if (workout.routineId != null) return stored;
    final ids = {for (final e in workout.exercises) e.exerciseId}.join(',');
    return ref.watch(sessionGuidesProvider(ids)).value ?? stored;
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(liveWorkoutControllerProvider);
    if (session == null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: Text(context.tr('live.noSession'))),
      );
    }
    final workout = session.workout;
    final formatter = ref.unitFormatter(context);
    final rest = session.meta.rest;
    final editing = _editing;
    final imperial = formatter.system == UnitSystem.imperial;
    final guides = _guidesFor(workout);

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Ticker(
          builder: (context, now) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                formatDuration(workout.elapsed(now)),
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
              Text(
                context.tr(
                  'live.header',
                  namedArgs: {
                    'volume': formatter.formatWeight(
                      workout.liveVolumeKg.roundToDouble(),
                    ),
                    'sets': '${workout.completedWorkingSets}',
                  },
                ),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            tooltip: context.tr('plates.title'),
            icon: const Icon(Icons.calculate_outlined),
            onPressed: () => showPlateCalculator(context),
          ),
          PopupMenuButton<String>(
            tooltip: context.tr('live.menu'),
            onSelected: (value) async {
              switch (value) {
                case 'reorder':
                  await showReorderSheet(
                    context,
                    exercises: workout.exercises,
                    names: session.names,
                    onMove: (from, to) =>
                        unawaited(_controller.moveExercise(from, to)),
                  );
                case 'screen':
                  final settings = await ref.read(
                    trainingSettingsControllerProvider.future,
                  );
                  final next = settings.copyWith(
                    keepScreenOn: !settings.keepScreenOn,
                  );
                  await ref
                      .read(trainingSettingsControllerProvider.notifier)
                      .save(next);
                  await ref
                      .read(screenAwakeProvider)
                      .set(enabled: next.keepScreenOn);
                case 'discard':
                  await _discard();
              }
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                value: 'reorder',
                child: Text(context.tr('live.reorder')),
              ),
              CheckedPopupMenuItem(
                value: 'screen',
                checked:
                    ref
                        .watch(trainingSettingsControllerProvider)
                        .value
                        ?.keepScreenOn ??
                    true,
                child: Text(context.tr('live.keepScreenOn')),
              ),
              PopupMenuItem(
                value: 'discard',
                child: Text(
                  context.tr('live.discard.action'),
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilledButton(
              style: FilledButton.styleFrom(minimumSize: const Size(0, 44)),
              onPressed: () => _finish(session, formatter),
              child: Text(context.tr('live.finish.action')),
            ),
          ),
        ],
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => setState(() => _editing = null),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 120),
          children: [
            if (workout.exercises.isEmpty)
              Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  context.tr('live.empty'),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            for (final exercise in workout.exercises)
              ExerciseCard(
                key: ValueKey(exercise.id),
                exercise: exercise,
                name: session.names[exercise.exerciseId] ?? '',
                previous: session.previous[exercise.exerciseId],
                targets: session.meta.targets[exercise.id],
                formatter: formatter,
                editing: editing,
                editingText: _buffer,
                inSuperset: exercise.groupId != null,
                onEdit: (setId, field) =>
                    _startEditing(session, exercise.id, setId, field),
                onToggle: (setId) {
                  setState(() => _editing = null);
                  unawaited(_controller.toggleSet(exercise.id, setId));
                },
                onType: (setId, type) => unawaited(
                  _controller.updateSet(exercise.id, setId, type: type),
                ),
                onAddSet: () => unawaited(_controller.addSet(exercise.id)),
                onRemoveSet: (setId) =>
                    unawaited(_controller.removeSet(exercise.id, setId)),
                onAction: (action) => _onAction(session, exercise.id, action),
                guide: guides.statusOf(exercise.exerciseId),
                onGuide: () => unawaited(
                  showGuideSheet(
                    context,
                    exerciseName: session.names[exercise.exerciseId] ?? '',
                    status: guides.statusOf(exercise.exerciseId),
                  ),
                ),
              ),
            OutlinedButton.icon(
              icon: const Icon(Icons.add),
              label: Text(context.tr('live.addExercise')),
              onPressed: () async {
                final exerciseId = await pickExercise(context);
                if (exerciseId != null) {
                  await _controller.addExercise(exerciseId);
                }
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (rest != null)
            RestTimerBar(
              rest: rest,
              onAdjust: (seconds) => unawaited(_controller.adjustRest(seconds)),
              onSkip: () => unawaited(_controller.skipRest()),
              onFinished: () => unawaited(_controller.restFinished()),
            ),
          if (editing != null)
            NumberKeypad(
              stepLabel: editing.field == SetField.reps
                  ? '1'
                  : (imperial ? '5' : formatter.formatNumber(2.5)),
              decimalSeparator: _decimalSeparator,
              allowDecimal: editing.field == SetField.weight,
              onKey: _key,
              onBackspace: _backspace,
              onStep: _step,
              onNext: () => _next(session),
              onDone: () => setState(() => _editing = null),
            ),
        ],
      ),
    );
  }
}
