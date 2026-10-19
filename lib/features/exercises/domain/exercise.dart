import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:saiyagym_mobile/core/training/training_types.dart';

part 'exercise.freezed.dart';
part 'exercise.g.dart';

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
  }) = _Exercise;

  factory Exercise.fromJson(Map<String, dynamic> json) =>
      _$ExerciseFromJson(json);
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

abstract interface class ExercisesRepository {
  /// Global catalog + custom exercises, by name. Works offline.
  Stream<List<Exercise>> watchCatalog({String? search});

  Future<Exercise?> find(String id);

  /// By exercise id.
  Stream<Map<String, ExercisePref>> watchPrefs();

  Future<void> setFavorite(String exerciseId, {required bool favorite});

  Future<void> setPersonalTier(String exerciseId, Goal goal, Tier? tier);
}
