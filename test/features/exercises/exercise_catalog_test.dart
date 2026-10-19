import 'package:flutter_test/flutter_test.dart';
import 'package:saiyagym_mobile/core/training/training_types.dart';
import 'package:saiyagym_mobile/features/exercises/domain/exercise.dart';
import 'package:saiyagym_mobile/features/exercises/domain/exercise_catalog.dart';

void main() {
  const bench = Exercise(
    id: 'bench',
    name: 'Press de banca',
    primaryMuscle: 'chest',
    equipment: 'barbell',
    isGlobal: true,
    tiers: Tiers(hypertrophy: Tier.a, powerlifting: Tier.s),
  );
  const curl = Exercise(
    id: 'curl',
    name: 'Curl de bíceps',
    primaryMuscle: 'biceps',
    equipment: 'dumbbell',
    isGlobal: true,
    tiers: Tiers(hypertrophy: Tier.b, powerlifting: Tier.c),
  );
  const mine = Exercise(
    id: 'mine',
    name: 'Remo Meadows',
    primaryMuscle: 'lats',
    equipment: 'barbell',
  );
  const all = [bench, curl, mine];
  const prefs = {
    'curl': ExercisePref(
      exerciseId: 'curl',
      isFavorite: true,
      personalTiers: Tiers(hypertrophy: Tier.s),
    ),
  };

  List<String> ids(ExerciseFilter filter) =>
      filterExercises(all, filter, prefs).map((e) => e.id).toList();

  group('filters', () {
    test('search ignores accents, case and word order', () {
      expect(ids(const ExerciseFilter(search: 'biceps CURL')), ['curl']);
      expect(ids(const ExerciseFilter(search: 'banca press')), ['bench']);
    });

    test('muscle, equipment, favorites and custom combine', () {
      expect(ids(const ExerciseFilter(equipment: 'barbell')), [
        'bench',
        'mine',
      ]);
      expect(ids(const ExerciseFilter(equipment: 'barbell', muscle: 'lats')), [
        'mine',
      ]);
      expect(ids(const ExerciseFilter(favoritesOnly: true)), ['curl']);
      expect(ids(const ExerciseFilter(customOnly: true)), ['mine']);
      expect(const ExerciseFilter().isEmpty, isTrue);
    });
  });

  group('tier board', () {
    test('global tiers per goal, untiered at the end', () {
      final board = tierBoard(all, goal: Goal.powerlifting, prefs: prefs);
      expect(board[Tier.s]!.map((e) => e.id), ['bench']);
      expect(board[Tier.c]!.map((e) => e.id), ['curl']);
      expect(board[null]!.map((e) => e.id), ['mine']);
    });

    test('personal tier wins when asked; empty falls back to global', () {
      final board = tierBoard(
        all,
        goal: Goal.hypertrophy,
        prefs: prefs,
        source: TierSource.personal,
      );
      expect(board[Tier.s]!.map((e) => e.id), ['curl']);
      expect(board[Tier.a]!.map((e) => e.id), [
        'bench',
      ], reason: 'no personal tier');
    });

    test('filtered by muscle', () {
      final board = tierBoard(
        all,
        goal: Goal.hypertrophy,
        prefs: prefs,
        muscle: 'chest',
      );
      expect(board.values.expand((e) => e).map((e) => e.id), ['bench']);
    });
  });
}
