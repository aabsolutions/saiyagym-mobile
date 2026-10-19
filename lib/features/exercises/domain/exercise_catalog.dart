import 'package:saiyagym_mobile/core/text/search.dart';
import 'package:saiyagym_mobile/core/training/training_types.dart';
import 'package:saiyagym_mobile/features/exercises/domain/exercise.dart';

/// Every muscle / equipment value of the API (for filters and forms).
const muscles = [
  'chest',
  'lats',
  'upper_back',
  'traps',
  'front_delts',
  'side_delts',
  'rear_delts',
  'biceps',
  'triceps',
  'forearms',
  'abs',
  'obliques',
  'lower_back',
  'glutes',
  'quads',
  'hamstrings',
  'adductors',
  'abductors',
  'calves',
];
const equipments = [
  'barbell',
  'dumbbell',
  'machine',
  'cable',
  'bodyweight',
  'kettlebell',
  'band',
  'smith',
  'other',
];

class ExerciseFilter {
  const ExerciseFilter({
    this.search = '',
    this.muscle,
    this.equipment,
    this.favoritesOnly = false,
    this.customOnly = false,
  });

  final String search;
  final String? muscle;
  final String? equipment;
  final bool favoritesOnly;
  final bool customOnly;

  ExerciseFilter copyWith({
    String? search,
    String? Function()? muscle,
    String? Function()? equipment,
    bool? favoritesOnly,
    bool? customOnly,
  }) => ExerciseFilter(
    search: search ?? this.search,
    muscle: muscle == null ? this.muscle : muscle(),
    equipment: equipment == null ? this.equipment : equipment(),
    favoritesOnly: favoritesOnly ?? this.favoritesOnly,
    customOnly: customOnly ?? this.customOnly,
  );

  bool get isEmpty =>
      search.isEmpty &&
      muscle == null &&
      equipment == null &&
      !favoritesOnly &&
      !customOnly;
}

List<Exercise> filterExercises(
  List<Exercise> exercises,
  ExerciseFilter filter,
  Map<String, ExercisePref> prefs,
) {
  final matches = searchMatcher(filter.search);
  return [
    for (final exercise in exercises)
      if ((filter.muscle == null || exercise.primaryMuscle == filter.muscle) &&
          (filter.equipment == null ||
              exercise.equipment == filter.equipment) &&
          (!filter.favoritesOnly ||
              (prefs[exercise.id]?.isFavorite ?? false)) &&
          (!filter.customOnly || !exercise.isGlobal) &&
          matches(exercise.name))
        exercise,
  ];
}

enum TierSource { global, personal }

/// Tier of [exercise] for [goal]: the personal one when asked and set,
/// else the global one (same rule as the API's tier list).
Tier? tierOf(
  Exercise exercise,
  Goal goal,
  ExercisePref? pref, {
  TierSource source = TierSource.global,
}) {
  final personal = source == TierSource.personal
      ? pref?.personalTiers.of(goal)
      : null;
  return personal ?? exercise.tiers.of(goal);
}

/// Tier board: S, A, B, C columns (+ untiered), sorted by name.
Map<Tier?, List<Exercise>> tierBoard(
  List<Exercise> exercises, {
  required Goal goal,
  required Map<String, ExercisePref> prefs,
  TierSource source = TierSource.global,
  String? muscle,
}) {
  final board = <Tier?, List<Exercise>>{
    for (final tier in [...Tier.values, null]) tier: [],
  };
  for (final exercise in exercises) {
    if (muscle != null && exercise.primaryMuscle != muscle) continue;
    board[tierOf(exercise, goal, prefs[exercise.id], source: source)]!.add(
      exercise,
    );
  }
  for (final column in board.values) {
    column.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
  }
  return board;
}
