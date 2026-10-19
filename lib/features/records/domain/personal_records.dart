import 'package:saiyagym_mobile/core/training/training_types.dart';

// Port of the API's `records/personal-records.calc.ts`. MUST stay in sync:
// the app celebrates locally right after a workout and the API confirms the
// same records once the workout syncs. Same rules:
// - only completed WORKING sets with weight > 0 and reps > 0 count;
// - computed from scratch over every finished session (edits stay correct);
// - ties keep the earliest achievement (matching ≠ breaking);
// - the first session of an exercise, and the first time a weight is
//   lifted, are baselines (no "new record").

/// SPEC: Epley, valid for 1–12 reps only.
const e1rmMinReps = 1;
const e1rmMaxReps = 12;

double? epley1RM(double? weightKg, int reps) {
  if (weightKg == null || weightKg <= 0) return null;
  if (reps < e1rmMinReps || reps > e1rmMaxReps) return null;
  return reps == 1 ? weightKg : weightKg * (1 + reps / 30);
}

enum RecordType { maxWeight, bestE1RM, maxVolume, repsAtWeight }

class RecordSet {
  const RecordSet({
    required this.type,
    required this.completed,
    this.weightKg,
    this.reps,
  });

  final SetType type;
  final double? weightKg;
  final int? reps;
  final bool completed;

  bool get qualifies =>
      completed &&
      type.countsForVolume &&
      (weightKg ?? 0) > 0 &&
      (reps ?? 0) > 0;
}

/// One exercise in one finished workout.
class RecordSession {
  const RecordSession({
    required this.workoutId,
    required this.startedAt,
    required this.sets,
  });

  final String workoutId;
  final DateTime startedAt;
  final List<RecordSet> sets;
}

class RecordEntry {
  const RecordEntry({
    required this.value,
    required this.weightKg,
    required this.reps,
    required this.workoutId,
  });

  final double value;
  final double weightKg;
  final int reps;
  final String workoutId;
}

class ExerciseRecords {
  ExerciseRecords({
    this.maxWeight,
    this.bestE1RM,
    this.maxVolume,
    List<RecordEntry>? repsAtWeight,
  }) : repsAtWeight = repsAtWeight ?? [];

  RecordEntry? maxWeight;
  RecordEntry? bestE1RM;
  RecordEntry? maxVolume;

  /// Ascending by weight; `value` = reps.
  List<RecordEntry> repsAtWeight;
}

class NewRecord {
  const NewRecord({
    required this.type,
    required this.value,
    required this.previous,
    required this.weightKg,
    required this.reps,
  });

  final RecordType type;
  final double value;
  final double previous;
  final double weightKg;
  final int reps;
}

double _round(double value, [int decimals = 2]) {
  final factor = _pow10(decimals);
  return (value * factor).round() / factor;
}

double _pow10(int n) {
  var result = 1.0;
  for (var i = 0; i < n; i++) {
    result *= 10;
  }
  return result;
}

ExerciseRecords computeRecords(List<RecordSession> sessions) {
  final ordered = [...sessions]
    ..sort((a, b) {
      final byTime = a.startedAt.compareTo(b.startedAt);
      return byTime != 0 ? byTime : a.workoutId.compareTo(b.workoutId);
    });
  final records = ExerciseRecords();
  final byWeight = <double, RecordEntry>{};
  bool beats(RecordEntry? current, double value) =>
      current == null || value > current.value;

  for (final session in ordered) {
    var volume = 0.0;
    for (final set in session.sets) {
      if (!set.qualifies) continue;
      final weight = set.weightKg!;
      final reps = set.reps!;
      RecordEntry entry(double value) => RecordEntry(
        value: value,
        weightKg: weight,
        reps: reps,
        workoutId: session.workoutId,
      );

      volume += weight * reps;
      if (beats(records.maxWeight, weight)) records.maxWeight = entry(weight);

      final e1rm = epley1RM(weight, reps);
      if (e1rm != null && beats(records.bestE1RM, _round(e1rm, 1))) {
        records.bestE1RM = entry(_round(e1rm, 1));
      }

      if (beats(byWeight[weight], reps.toDouble())) {
        byWeight[weight] = entry(reps.toDouble());
      }
    }
    if (volume > 0 && beats(records.maxVolume, _round(volume))) {
      records.maxVolume = RecordEntry(
        value: _round(volume),
        weightKg: 0,
        reps: 0,
        workoutId: session.workoutId,
      );
    }
  }
  records.repsAtWeight = byWeight.values.toList()
    ..sort((a, b) => a.weightKg.compareTo(b.weightKg));
  return records;
}

/// Records [workoutId] broke. [others] = records WITHOUT this workout.
List<NewRecord> newRecordsFor(
  ExerciseRecords others,
  ExerciseRecords after,
  String workoutId,
) {
  final found = <NewRecord>[];
  void check(RecordType type, RecordEntry? previous, RecordEntry? next) {
    if (previous != null &&
        next != null &&
        next.workoutId == workoutId &&
        next.value > previous.value) {
      found.add(
        NewRecord(
          type: type,
          value: next.value,
          previous: previous.value,
          weightKg: next.weightKg,
          reps: next.reps,
        ),
      );
    }
  }

  check(RecordType.maxWeight, others.maxWeight, after.maxWeight);
  check(RecordType.bestE1RM, others.bestE1RM, after.bestE1RM);
  check(RecordType.maxVolume, others.maxVolume, after.maxVolume);
  final previousAtWeight = {
    for (final entry in others.repsAtWeight) entry.weightKg: entry,
  };
  for (final entry in after.repsAtWeight) {
    check(RecordType.repsAtWeight, previousAtWeight[entry.weightKg], entry);
  }
  return found;
}

/// New records of [current] for one exercise, against its [history]
/// (other finished sessions of the same exercise).
List<NewRecord> detectNewRecords({
  required RecordSession current,
  required List<RecordSession> history,
}) {
  final others = history
      .where((s) => s.workoutId != current.workoutId)
      .toList();
  return newRecordsFor(
    computeRecords(others),
    computeRecords([...others, current]),
    current.workoutId,
  );
}
