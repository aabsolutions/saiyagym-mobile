import 'dart:async';
import 'dart:convert';

import 'package:clock/clock.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:saiyagym_mobile/core/database/database_provider.dart';
import 'package:saiyagym_mobile/core/training/training_types.dart';
import 'package:saiyagym_mobile/features/auth/presentation/controllers/session_controller.dart';
import 'package:saiyagym_mobile/features/exercises/exercises_providers.dart';
import 'package:saiyagym_mobile/features/live_workout/domain/live_session.dart';
import 'package:saiyagym_mobile/features/live_workout/domain/workout_editing.dart';
import 'package:saiyagym_mobile/features/live_workout/live_workout_providers.dart';
import 'package:saiyagym_mobile/features/records/data/records_service.dart';
import 'package:saiyagym_mobile/features/workouts/domain/workout.dart';
import 'package:saiyagym_mobile/features/workouts/workouts_providers.dart';
import 'package:uuid/uuid.dart';

part 'live_workout_controller.g.dart';

/// What finishing returns to the summary screen.
class FinishOutcome {
  const FinishOutcome({required this.workout, required this.records});

  final Workout workout;

  /// Detected locally; the API confirms them once synced.
  final List<WorkoutRecord> records;
}

/// The session being logged (`null` = none). Every change is written to
/// Drift right away: killing the app loses nothing.
@Riverpod(keepAlive: true)
class LiveWorkoutController extends _$LiveWorkoutController {
  static const metaKey = 'live.meta';
  static const _uuid = Uuid();

  Future<void> _writes = Future.value();
  String _alarmTitle = '';

  @override
  LiveSession? build() => null;

  // ===== lifecycle =====

  /// Picks up a session left in progress (app killed, phone rebooted).
  Future<LiveSession?> restore() async {
    if (state != null) return state;
    final workout = await ref.read(workoutsRepositoryProvider).inProgress();
    if (workout == null) return null;
    final raw = await ref.read(appDatabaseProvider).readMeta(metaKey);
    var meta = LiveMeta(workoutId: workout.id);
    if (raw != null) {
      try {
        final stored = LiveMeta.fromJson(
          jsonDecode(raw) as Map<String, dynamic>,
        );
        if (stored.workoutId == workout.id) meta = stored;
      } on Object {
        // Unreadable meta: the workout itself is intact.
      }
    }
    // A rest that ended while we were away is over.
    final rest = meta.rest;
    if (rest != null && !rest.endsAt.isAfter(_now())) {
      meta = meta.copyWith(rest: null);
    }
    final session = await _withLookups(
      LiveSession(workout: workout, meta: meta),
    );
    if (!ref.mounted) return null;
    state = session;
    return session;
  }

  Future<LiveSession> start(StartPlan plan) async {
    final current = state ?? await restore();
    if (current != null) return current; // one session at a time

    final exerciseIds = {for (final e in plan.exercises) e.exerciseId};
    final previous = await _previous(exerciseIds);
    final workout = buildWorkout(
      id: _uuid.v4(),
      plan: plan,
      startedAt: _now(),
      previous: previous,
      newId: _uuid.v4,
    );
    final meta = LiveMeta(
      workoutId: workout.id,
      targets: {
        for (final (index, exercise) in workout.exercises.indexed)
          exercise.id: plan.exercises[index].sets,
      },
      restSeconds: {
        for (final (index, exercise) in workout.exercises.indexed)
          exercise.id: ?plan.exercises[index].sets.firstOrNull?.restSeconds,
      },
    );
    final session = LiveSession(
      workout: workout,
      meta: meta,
      previous: previous,
      names: await _names(exerciseIds),
    );
    await _persist(session);
    return session;
  }

  /// Rest notifications are shown by the OS: texts come from the UI.
  // ignore: avoid_setters_without_getters, write-only by design.
  set alarmTitle(String title) => _alarmTitle = title;

  // ===== sets =====

  Future<void> toggleSet(String exerciseRowId, String setId) async {
    final session = state;
    if (session == null) return;
    final now = _now();
    final workout = session.workout.toggleSet(exerciseRowId, setId, now);
    final set = workout
        .exerciseRow(exerciseRowId)
        ?.sets
        .where((s) => s.id == setId)
        .firstOrNull;
    var meta = session.meta;
    if (set != null && set.completed) {
      unawaited(ref.read(hapticsProvider).setDone());
      if (_restsAfter(workout, exerciseRowId)) {
        final seconds = _restFor(session, exerciseRowId, setId);
        meta = meta.copyWith(
          rest: RestTimer(
            endsAt: now.add(Duration(seconds: seconds)),
            totalSeconds: seconds,
            setId: setId,
          ),
        );
        unawaited(_scheduleAlarm(meta.rest!));
      }
    }
    await _persist(session.copyWith(workout: workout, meta: meta));
  }

  Future<void> updateSet(
    String exerciseRowId,
    String setId, {
    double? Function()? weightKg,
    int? Function()? reps,
    SetType? type,
  }) => _edit(
    (workout) => workout.updateSet(
      exerciseRowId,
      setId,
      weightKg: weightKg,
      reps: reps,
      type: type,
    ),
  );

  Future<void> addSet(String exerciseRowId) =>
      _edit((workout) => workout.addSet(exerciseRowId, _uuid.v4()));

  Future<void> removeSet(String exerciseRowId, String setId) =>
      _edit((workout) => workout.removeSet(exerciseRowId, setId));

  // ===== exercises =====

  Future<void> addExercise(String exerciseId) async {
    final session = state;
    if (session == null) return;
    final previous = await _previous({exerciseId});
    final last = previous[exerciseId];
    final row = WorkoutExercise(
      id: _uuid.v4(),
      exerciseId: exerciseId,
      // Same shape as last time, else one set to start with.
      sets: [
        if (last == null || last.isEmpty)
          prefilledSet(id: _uuid.v4())
        else
          for (final set in last) prefilledSet(id: _uuid.v4(), last: set),
      ],
    );
    await _persist(
      session.copyWith(
        workout: session.workout.addExercise(row),
        previous: {...session.previous, ...previous},
        names: {
          ...session.names,
          ...await _names({exerciseId}),
        },
      ),
    );
  }

  Future<void> removeExercise(String exerciseRowId) =>
      _edit((workout) => workout.removeExercise(exerciseRowId));

  Future<void> moveExercise(int from, int to) =>
      _edit((workout) => workout.moveExercise(from, to));

  Future<void> replaceExercise(String exerciseRowId, String exerciseId) async {
    final session = state;
    if (session == null) return;
    await _persist(
      session.copyWith(
        workout: session.workout.replaceExercise(exerciseRowId, exerciseId),
        previous: {
          ...session.previous,
          ...await _previous({exerciseId}),
        },
        names: {
          ...session.names,
          ...await _names({exerciseId}),
        },
      ),
    );
  }

  Future<void> toggleSuperset(String exerciseRowId) => _edit(
    (workout) => workout.toggleSupersetWithNext(exerciseRowId, _uuid.v4()),
  );

  Future<void> setNotes(String exerciseRowId, String notes) =>
      _edit((workout) => workout.setExerciseNotes(exerciseRowId, notes));

  // ===== rest timer =====

  Future<void> adjustRest(int seconds) async {
    final session = state;
    final rest = session?.meta.rest;
    if (session == null || rest == null) return;
    final endsAt = rest.endsAt.add(Duration(seconds: seconds));
    if (!endsAt.isAfter(_now())) return await skipRest();
    final next = rest.copyWith(
      endsAt: endsAt,
      totalSeconds: (rest.totalSeconds + seconds).clamp(1, 3600),
    );
    unawaited(_scheduleAlarm(next));
    await _persist(session.copyWith(meta: session.meta.copyWith(rest: next)));
  }

  Future<void> skipRest() async {
    final session = state;
    if (session == null || session.meta.rest == null) return;
    unawaited(ref.read(restAlarmProvider).cancel());
    await _persist(session.copyWith(meta: session.meta.copyWith(rest: null)));
  }

  /// The countdown reached zero with the app open: buzz and clear. The
  /// scheduled notification covers the app being in the background.
  Future<void> restFinished() async {
    final session = state;
    if (session == null || session.meta.rest == null) return;
    unawaited(ref.read(hapticsProvider).restDone());
    await _persist(session.copyWith(meta: session.meta.copyWith(rest: null)));
  }

  // ===== end =====

  Future<FinishOutcome?> finish({int? rating, String notes = ''}) async {
    final session = state;
    if (session == null) return null;
    await _writes;
    final done = session.workout.onlyCompleted().copyWith(
      rating: rating,
      notes: notes,
      finishedAt: _now(),
    );
    final history = await ref.read(workoutsRepositoryProvider).finished();
    final records = detectWorkoutRecords(done, history);
    final saved = await ref.read(finishWorkoutUseCaseProvider)(done);
    await _clear();
    return FinishOutcome(workout: saved, records: records);
  }

  /// Deletes the session (logically: if it already synced while in
  /// progress, the deletion syncs too).
  Future<void> discard() async {
    final session = state;
    if (session == null) return;
    await _writes;
    await ref.read(workoutsRepositoryProvider).delete(session.workout.id);
    await _clear();
  }

  // ===== internals =====

  DateTime _now() => DateTime.fromMillisecondsSinceEpoch(
    clock.now().millisecondsSinceEpoch,
    isUtc: true,
  );

  Future<void> _edit(Workout Function(Workout workout) change) async {
    final session = state;
    if (session == null) return;
    await _persist(session.copyWith(workout: change(session.workout)));
  }

  /// State first (instant UI), then Drift — chained so writes land in order.
  Future<void> _persist(LiveSession session) {
    state = session;
    final db = ref.read(appDatabaseProvider);
    final workouts = ref.read(workoutsRepositoryProvider);
    return _writes = _writes.then((_) async {
      await workouts.save(session.workout);
      await db.writeMeta(metaKey, jsonEncode(session.meta.toJson()));
    });
  }

  Future<void> _clear() async {
    unawaited(ref.read(restAlarmProvider).cancel());
    await ref.read(appDatabaseProvider).deleteMeta(metaKey);
    state = null;
  }

  /// In a superset the rest comes after its LAST exercise.
  static bool _restsAfter(Workout workout, String exerciseRowId) {
    final index = workout.exercises.indexWhere((e) => e.id == exerciseRowId);
    if (index < 0) return false;
    final group = workout.exercises[index].groupId;
    if (group == null) return true;
    return index + 1 >= workout.exercises.length ||
        workout.exercises[index + 1].groupId != group;
  }

  int _restFor(LiveSession session, String exerciseRowId, String setId) {
    final exercise = session.workout.exerciseRow(exerciseRowId);
    final index = exercise?.sets.indexWhere((s) => s.id == setId) ?? -1;
    final targets = session.meta.targets[exerciseRowId];
    final target = targets != null && index >= 0 && index < targets.length
        ? targets[index].restSeconds
        : null;
    return target ??
        session.meta.restSeconds[exerciseRowId] ??
        ref.read(currentUserProvider)?.preferences.defaultRestSeconds ??
        90;
  }

  Future<void> _scheduleAlarm(RestTimer rest) =>
      ref.read(restAlarmProvider).schedule(rest.endsAt, title: _alarmTitle);

  Future<Map<String, List<WorkoutSet>>> _previous(Set<String> ids) async {
    final repository = ref.read(workoutsRepositoryProvider);
    return {for (final id in ids) id: ?await repository.lastPerformance(id)};
  }

  Future<Map<String, String>> _names(Set<String> ids) async {
    final repository = ref.read(exercisesRepositoryProvider);
    return {
      for (final id in ids)
        if (await repository.find(id) case final exercise?) id: exercise.name,
    };
  }

  Future<LiveSession> _withLookups(LiveSession session) async {
    final ids = {for (final e in session.workout.exercises) e.exerciseId};
    return session.copyWith(
      previous: await _previous(ids),
      names: await _names(ids),
    );
  }
}
