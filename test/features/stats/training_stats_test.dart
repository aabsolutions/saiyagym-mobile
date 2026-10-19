import 'package:flutter_test/flutter_test.dart';
import 'package:saiyagym_mobile/core/training/training_types.dart';
import 'package:saiyagym_mobile/features/stats/domain/training_stats.dart';
import 'package:saiyagym_mobile/features/workouts/domain/workout.dart';

// Same rules as the API's /stats/summary (weekly streak by local date).
// 2026-10-19 is a Monday.

void main() {
  group('weekStartOf', () {
    test('Monday weeks', () {
      expect(weekStartOf('2026-10-19', 1), '2026-10-19');
      expect(weekStartOf('2026-10-25', 1), '2026-10-19'); // Sunday
    });

    test('Sunday weeks', () {
      expect(weekStartOf('2026-10-25', 7), '2026-10-25');
      expect(weekStartOf('2026-10-24', 7), '2026-10-18'); // Saturday
    });
  });

  group('weeklyStreak', () {
    int streak(List<String> days, String today, [int first = 1]) =>
        weeklyStreak(trainedDays: days, today: today, firstDayOfWeek: first);

    test('consecutive weeks including this one', () {
      expect(
        streak(['2026-10-05', '2026-10-13', '2026-10-20'], '2026-10-21'),
        3,
      );
    });

    test('an empty current week does not break it yet', () {
      expect(streak(['2026-10-05', '2026-10-13'], '2026-10-20'), 2);
    });

    test('a missed week breaks it', () {
      expect(streak(['2026-09-28', '2026-10-13'], '2026-10-20'), 1);
      expect(streak(['2026-09-28'], '2026-10-20'), 0);
    });

    test('depends on the first day of the week', () {
      // Sunday 18 and Saturday 24 are the same Sun-week, different Mon-weeks.
      expect(streak(['2026-10-11', '2026-10-18'], '2026-10-24', 7), 2);
    });

    test('nothing trained', () => expect(streak([], '2026-10-20'), 0));
  });

  Workout workout(
    String id,
    DateTime startedAt, {
    double weight = 100,
    int reps = 5,
  }) => Workout(
    id: id,
    startedAt: startedAt,
    finishedAt: startedAt.add(const Duration(hours: 1)),
    exercises: [
      WorkoutExercise(
        id: 'e-$id',
        exerciseId: 'squat',
        sets: [
          WorkoutSet(
            id: 's-$id',
            type: SetType.normal,
            weightKg: weight,
            reps: reps,
            completed: true,
          ),
        ],
      ),
    ],
  );

  test('this week totals and streak', () {
    final history = [
      workout('w3', DateTime(2026, 10, 20, 18)),
      workout('w2', DateTime(2026, 10, 19, 18)),
      workout('w1', DateTime(2026, 10, 14, 18)),
    ];
    final summary = weeklySummary(
      history,
      now: DateTime(2026, 10, 21, 12),
      firstDayOfWeek: 1,
    );
    expect(summary.week.sessions, 2);
    expect(summary.week.volumeKg, 1000);
    expect(summary.week.workingSets, 2);
    expect(summary.week.duration, const Duration(hours: 2));
    expect(summary.streakWeeks, 2);
  });

  test('last record: the newest workout that broke one', () {
    final history = [
      workout('w3', DateTime(2026, 10, 20), weight: 90), // no record
      workout('w2', DateTime(2026, 10, 13), weight: 105), // beats 100
      workout('w1', DateTime(2026, 10, 6)),
    ];
    final last = lastRecord(history)!;
    expect(last.workout.id, 'w2');
    expect(last.records.first.record.value, 105);
    expect(
      lastRecord([history.last]),
      isNull,
      reason: 'first session = baseline',
    );
  });
}
