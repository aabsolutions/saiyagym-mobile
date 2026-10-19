import 'package:flutter_test/flutter_test.dart';
import 'package:saiyagym_mobile/core/training/training_types.dart';
import 'package:saiyagym_mobile/features/records/domain/personal_records.dart';

// Same cases as the API's `personal-records.calc.spec.ts`: the app's local
// celebration must match what the server computes on sync.

RecordSet s(double? weightKg, int? reps, [SetType type = SetType.normal]) =>
    _set(weightKg, reps, type);

RecordSet unfinished(double weightKg, int reps) =>
    _set(weightKg, reps, SetType.normal, completed: false);

RecordSet _set(
  double? weightKg,
  int? reps,
  SetType type, {
  bool completed = true,
}) =>
    RecordSet(type: type, weightKg: weightKg, reps: reps, completed: completed);

RecordSession session(String id, int day, List<RecordSet> sets) =>
    RecordSession(
      workoutId: id,
      startedAt: DateTime.utc(2024, 1, day),
      sets: sets,
    );

List<RecordSession> without(List<RecordSession> sessions, String id) =>
    sessions.where((x) => x.workoutId != id).toList();

void main() {
  group('computeRecords', () {
    test('every record type, ignoring warmups and unfinished sets', () {
      final records = computeRecords([
        session('w1', 1, [
          s(140, 3, SetType.warmup),
          s(100, 5),
          s(100, 5),
          s(80, 10),
          unfinished(150, 1),
        ]),
      ]);
      expect(records.maxWeight!.value, 100);
      expect(records.maxWeight!.reps, 5);
      expect(records.bestE1RM!.value, 116.7); // 100×(1+5/30)
      expect(records.maxVolume!.value, 100 * 5 * 2 + 80 * 10);
      expect(records.repsAtWeight.map((r) => [r.weightKg, r.value]), [
        [80, 10],
        [100, 5],
      ]);
    });

    test('dropsets and failure sets count (working sets)', () {
      final records = computeRecords([
        session('w1', 1, [
          s(60, 20, SetType.failure),
          s(50, 15, SetType.dropset),
        ]),
      ]);
      expect(records.maxWeight!.value, 60);
      expect(records.maxVolume!.value, 60 * 20 + 50 * 15);
    });

    test('e1RM only uses 1–12 reps', () {
      final records = computeRecords([
        session('w1', 1, [s(100, 15), s(90, 3)]),
      ]);
      expect(records.bestE1RM!.value, 99); // 90×1.1
      expect(records.bestE1RM!.weightKg, 90);
      expect(records.maxWeight!.value, 100);
    });

    test('a tie keeps the earliest holder', () {
      final records = computeRecords([
        session('later', 5, [s(100, 5)]),
        session('first', 1, [s(100, 5)]),
      ]);
      expect(records.maxWeight!.workoutId, 'first');
    });

    test('ignores unloaded sets; empty without data', () {
      final records = computeRecords([
        session('w1', 1, [s(null, 12), s(0, 10)]),
      ]);
      expect(records.maxWeight, isNull);
      expect(records.bestE1RM, isNull);
      expect(records.maxVolume, isNull);
      expect(records.repsAtWeight, isEmpty);
    });
  });

  group('newRecordsFor', () {
    final history = [
      session('w1', 1, [s(100, 5), s(100, 5)]),
      session('w2', 8, [s(100, 6), s(90, 8)]),
    ];

    test('the first session of an exercise is the baseline', () {
      final first = [
        session('w0', 1, [s(100, 5)]),
      ];
      expect(
        newRecordsFor(computeRecords([]), computeRecords(first), 'w0'),
        isEmpty,
      );
    });

    test('detects every record broken, with the previous value', () {
      final all = [
        ...history,
        session('w3', 15, [s(105, 5), s(100, 7), s(90, 8)]),
      ];
      final found = newRecordsFor(
        computeRecords(without(all, 'w3')),
        computeRecords(all),
        'w3',
      );
      expect(
        found.map((r) => (r.type, r.value, r.previous, r.weightKg, r.reps)),
        [
          (RecordType.maxWeight, 105, 100, 105, 5),
          (RecordType.bestE1RM, 123.3, 120, 100, 7),
          (RecordType.maxVolume, 105 * 5 + 700 + 720, 1320, 0, 0),
          (RecordType.repsAtWeight, 7, 6, 100, 7),
        ],
      );
    });

    test('matching is not breaking; a first-time weight is not a rep PR', () {
      final all = [
        ...history,
        session('w3', 15, [s(100, 6), s(95, 3)]),
      ];
      expect(
        newRecordsFor(
          computeRecords(without(all, 'w3')),
          computeRecords(all),
          'w3',
        ),
        isEmpty,
      );
    });

    test('editing the holder compares against the runner-up', () {
      final edited = [
        history[0],
        session('w2', 8, [s(102.5, 6), s(90, 8)]),
      ];
      final found = newRecordsFor(
        computeRecords(without(edited, 'w2')),
        computeRecords(edited),
        'w2',
      );
      final maxWeight = found.firstWhere((r) => r.type == RecordType.maxWeight);
      expect((maxWeight.value, maxWeight.previous), (102.5, 100));
      final e1rm = found.firstWhere((r) => r.type == RecordType.bestE1RM);
      expect((e1rm.value, e1rm.previous), (123, 116.7));
    });

    test('deleting the holder falls back to the runner-up', () {
      expect(computeRecords(history).bestE1RM!.workoutId, 'w2');
      final afterDelete = computeRecords(without(history, 'w2'));
      expect(afterDelete.bestE1RM!.value, 116.7);
      expect(afterDelete.repsAtWeight.map((r) => r.weightKg), [100]);
    });
  });

  test('epley1RM: 1 rep is the weight; outside 1–12 or unloaded → null', () {
    expect(epley1RM(100, 1), 100);
    expect(epley1RM(100, 10), closeTo(133.33, 0.01));
    expect(epley1RM(100, 13), isNull);
    expect(epley1RM(100, 0), isNull);
    expect(epley1RM(0, 5), isNull);
    expect(epley1RM(null, 5), isNull);
  });
}
