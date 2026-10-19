import 'package:flutter_test/flutter_test.dart';
import 'package:saiyagym_mobile/features/programs/domain/program_schedule.dart';

// Same cases as the API's `program-schedule.spec.ts` (offline "today" must
// pick the same routine the server would). 2024-01-01 is a Monday.

const program = ScheduleInput(
  startDate: '2024-01-01',
  durationWeeks: 2,
  deloadWeeks: [2],
  weeks: [
    [
      ScheduleDay(weekday: 1, routineId: 'A', label: 'Upper'),
      ScheduleDay(weekday: 4, routineId: 'B', label: 'Lower'),
    ],
    [ScheduleDay(weekday: 2, routineId: 'C')],
  ],
);

void main() {
  test('before the start date', () {
    final result = scheduleFor(program, '2023-12-30');
    expect(result, isA<NotStarted>());
    expect((result as NotStarted).startsInDays, 2);
  });

  test('training day in week 1, by weekday', () {
    final result = scheduleFor(program, '2024-01-04') as TrainingDay;
    expect(result.week, 1);
    expect(result.isDeloadWeek, isFalse);
    expect(result.day.routineId, 'B');
    expect(result.day.label, 'Lower');
  });

  test('rest day when nothing is scheduled that weekday', () {
    final result = scheduleFor(program, '2024-01-03') as RestDay;
    expect((result.week, result.isDeloadWeek), (1, false));
  });

  test('week 2 uses its own days and flags the deload week', () {
    final training = scheduleFor(program, '2024-01-09') as TrainingDay;
    expect(
      (training.week, training.isDeloadWeek, training.day.routineId),
      (2, true, 'C'),
    );
    final rest = scheduleFor(program, '2024-01-08') as RestDay;
    expect((rest.week, rest.isDeloadWeek), (2, true));
  });

  test('weeks count from the start date, whatever weekday it is', () {
    const midweek = ScheduleInput(
      startDate: '2024-01-03',
      durationWeeks: 2,
      weeks: [[], []],
    );
    expect((scheduleFor(midweek, '2024-01-09') as RestDay).week, 1); // day 6
    expect((scheduleFor(midweek, '2024-01-10') as RestDay).week, 2); // day 7
  });

  test('finished after the last week', () {
    expect(scheduleFor(program, '2024-01-15'), isA<Finished>());
  });

  test('reads a pulled program document', () {
    final input = scheduleInputFrom({
      'startDate': '2024-01-01',
      'durationWeeks': 4,
      'weeks': [
        {
          'days': [
            {'weekday': 1, 'routineId': 'A', 'label': null},
          ],
        },
      ],
      'deload': {
        'mode': 'weight',
        'weeks': [4],
        'percent': 10,
      },
    })!;
    expect(input.durationWeeks, 4);
    expect(input.deloadWeeks, [4]);
    expect(input.weeks.single.single.routineId, 'A');
    expect(scheduleInputFrom({'name': 'draft without start'}), isNull);
  });
}
