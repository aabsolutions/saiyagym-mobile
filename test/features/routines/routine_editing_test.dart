import 'package:flutter_test/flutter_test.dart';
import 'package:saiyagym_mobile/core/training/training_types.dart';
import 'package:saiyagym_mobile/features/history/domain/month_grid.dart';
import 'package:saiyagym_mobile/features/routines/domain/routine.dart';
import 'package:saiyagym_mobile/features/routines/domain/routine_editing.dart';

void main() {
  group('routine editing', () {
    const empty = Routine(id: 'r', name: 'Torso');

    test('a new exercise gets 3 working sets of 8–12', () {
      final routine = empty.addExercise('bench', slotId: 's1');
      final sets = routine.exercises.single.sets;
      expect(sets, hasLength(3));
      expect(sets.every((s) => s.repsMin == 8 && s.repsMax == 12), isTrue);
      expect(routine.isValid, isTrue);
      expect(empty.isValid, isFalse, reason: 'no exercises');
    });

    test('sets: add copies the last (warmups become working), remove', () {
      var routine = empty.addExercise('bench', slotId: 's1');
      routine = routine.updateSet(
        's1',
        2,
        const TargetSet(
          type: SetType.warmup,
          repsMin: 5,
          repsMax: 5,
          weightKg: 60,
        ),
      );
      routine = routine.addSet('s1');
      final added = routine.exercises.single.sets.last;
      expect(
        (added.type, added.repsMin, added.weightKg),
        (SetType.normal, 5, 60),
      );

      routine = routine.removeSet('s1', 0);
      expect(routine.exercises.single.sets, hasLength(3));
    });

    test('updates are kept valid for the API', () {
      final routine = empty
          .addExercise('bench', slotId: 's1')
          .updateSet(
            's1',
            0,
            const TargetSet(
              type: SetType.normal,
              repsMin: 0,
              repsMax: -3,
              weightKg: 80,
              percent1RM: 75,
              restSeconds: 5000,
            ),
          );
      final set = routine.exercises.single.sets.first;
      expect((set.repsMin, set.repsMax), (1, 1));
      expect(set.percent1RM, isNull, reason: 'weight and %1RM are exclusive');
      expect(set.restSeconds, 1800);
    });

    test('reorder and remove', () {
      var routine = empty
          .addExercise('a', slotId: '1')
          .addExercise('b', slotId: '2')
          .addExercise('c', slotId: '3');
      routine = routine.moveExercise(2, 0);
      expect(routine.exercises.map((e) => e.exerciseId), ['c', 'a', 'b']);
      routine = routine.removeExercise('1');
      expect(routine.exercises.map((e) => e.exerciseId), ['c', 'b']);
    });
  });

  group('month grid', () {
    test('October 2026, weeks from Monday', () {
      final cells = monthGrid(2026, 10, firstDayOfWeek: 1);
      // Oct 1st 2026 is a Thursday → 3 blanks.
      expect(cells.take(3), [null, null, null]);
      expect(cells[3], DateTime(2026, 10));
      expect(cells.whereType<DateTime>(), hasLength(31));
      expect(cells.length % 7, 0);
    });

    test('weeks from Sunday', () {
      final cells = monthGrid(2026, 10, firstDayOfWeek: 7);
      expect(cells.indexOf(DateTime(2026, 10)), 4);
      expect(weekdayOrder(7), [7, 1, 2, 3, 4, 5, 6]);
      expect(weekdayOrder(1), [1, 2, 3, 4, 5, 6, 7]);
    });
  });
}
