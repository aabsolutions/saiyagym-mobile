import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:saiyagym_mobile/core/training/training_types.dart';

part 'exercise.freezed.dart';
part 'exercise.g.dart';

final _bullet = RegExp(r'^(?:\d+[.)]|[-•*])\s+');

// Entities mirror the API documents on purpose: the sync wire format IS
// the domain shape here, so they carry their own JSON mapping. What may be
// SENT back is decided by the sync codecs, not by these classes.

@freezed
abstract class Tiers with _$Tiers {
  const factory Tiers({
    @JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue)
    Tier? hypertrophy,
    @JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue)
    Tier? powerlifting,
  }) = _Tiers;

  const Tiers._();

  factory Tiers.fromJson(Map<String, dynamic> json) => _$TiersFromJson(json);

  Tier? of(Goal goal) => switch (goal) {
    Goal.hypertrophy => hypertrophy,
    Goal.powerlifting => powerlifting,
  };
}

@freezed
abstract class Exercise with _$Exercise {
  const factory Exercise({
    required String id,

    /// In the UI language.
    required String name,
    required String primaryMuscle,
    required String equipment,
    @Default([]) List<String> secondaryMuscles,
    String? mechanic,
    String? category,
    String? slug,
    String? imageUrl,
    @Default([]) List<String> tags,
    @Default(Tiers()) Tiers tiers,
    @Default(false) bool isGlobal,
    @Default(false) bool isCustom,

    /// In the UI language; '' when there is none.
    @Default('') String description,

    /// Execution steps, one per line, in the UI language.
    @Default('') String instructions,
  }) = _Exercise;

  const Exercise._();

  factory Exercise.fromJson(Map<String, dynamic> json) =>
      _$ExerciseFromJson(json);

  /// The instructions as steps; a hand-typed "1." or "-" is dropped (the UI
  /// numbers them).
  List<String> get steps => [
    for (final line in instructions.split('\n'))
      if (line.trim().replaceFirst(_bullet, '') case final step
          when step.isNotEmpty)
        step,
  ];
}

/// Favorite + personal tier per goal (`null` = use the global tier).
@freezed
abstract class ExercisePref with _$ExercisePref {
  const factory ExercisePref({
    required String exerciseId,
    @Default(false) bool isFavorite,
    @Default(Tiers()) Tiers personalTiers,
  }) = _ExercisePref;

  factory ExercisePref.fromJson(Map<String, dynamic> json) =>
      _$ExercisePrefFromJson(json);
}

/// Fields of `CreateCustomExerciseDto` the mobile form fills.
class CustomExerciseDraft {
  const CustomExerciseDraft({
    required this.name,
    required this.primaryMuscle,
    required this.equipment,
    required this.mechanic,
    this.category = 'strength',
    this.secondaryMuscles = const [],
  });

  final String name;
  final String primaryMuscle;
  final String equipment;

  /// `compound` | `isolation`.
  final String mechanic;
  final String category;
  final List<String> secondaryMuscles;

  Map<String, Object> toJson() => {
    'name': name.trim(),
    'primaryMuscle': primaryMuscle,
    'equipment': equipment,
    'mechanic': mechanic,
    'category': category,
    'secondaryMuscles': secondaryMuscles,
  };
}

abstract interface class ExercisesRepository {
  /// Global catalog + custom exercises, by name. Works offline.
  Stream<List<Exercise>> watchCatalog({String? search});

  Future<Exercise?> find(String id);

  /// By exercise id.
  Stream<Map<String, ExercisePref>> watchPrefs();

  Future<void> setFavorite(String exerciseId, {required bool favorite});

  Future<void> setPersonalTier(String exerciseId, Goal goal, Tier? tier);

  /// Online only (`POST /exercises`): custom exercises are created through
  /// the API (they count toward the plan limit) and then pulled. Stored
  /// locally right away so it can be used immediately.
  Future<Exercise> createCustom(CustomExerciseDraft draft);
}
