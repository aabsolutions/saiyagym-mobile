// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercises_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(exercisesRepository)
final exercisesRepositoryProvider = ExercisesRepositoryProvider._();

final class ExercisesRepositoryProvider
    extends
        $FunctionalProvider<
          ExercisesRepository,
          ExercisesRepository,
          ExercisesRepository
        >
    with $Provider<ExercisesRepository> {
  ExercisesRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'exercisesRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$exercisesRepositoryHash();

  @$internal
  @override
  $ProviderElement<ExercisesRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ExercisesRepository create(Ref ref) {
    return exercisesRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ExercisesRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ExercisesRepository>(value),
    );
  }
}

String _$exercisesRepositoryHash() =>
    r'45d9673d70a7deb6548dc3ce1b4982089897171c';

/// Every exercise (global + custom), by name. Filtering is done in Dart:
/// ~150 rows, and accent-insensitive search is easier there than in SQL.

@ProviderFor(exerciseCatalog)
final exerciseCatalogProvider = ExerciseCatalogProvider._();

/// Every exercise (global + custom), by name. Filtering is done in Dart:
/// ~150 rows, and accent-insensitive search is easier there than in SQL.

final class ExerciseCatalogProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Exercise>>,
          List<Exercise>,
          Stream<List<Exercise>>
        >
    with $FutureModifier<List<Exercise>>, $StreamProvider<List<Exercise>> {
  /// Every exercise (global + custom), by name. Filtering is done in Dart:
  /// ~150 rows, and accent-insensitive search is easier there than in SQL.
  ExerciseCatalogProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'exerciseCatalogProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$exerciseCatalogHash();

  @$internal
  @override
  $StreamProviderElement<List<Exercise>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Exercise>> create(Ref ref) {
    return exerciseCatalog(ref);
  }
}

String _$exerciseCatalogHash() => r'7257cec0b845f2b406665e878beb64fd4506c3a3';

@ProviderFor(exercisePrefs)
final exercisePrefsProvider = ExercisePrefsProvider._();

final class ExercisePrefsProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<String, ExercisePref>>,
          Map<String, ExercisePref>,
          Stream<Map<String, ExercisePref>>
        >
    with
        $FutureModifier<Map<String, ExercisePref>>,
        $StreamProvider<Map<String, ExercisePref>> {
  ExercisePrefsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'exercisePrefsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$exercisePrefsHash();

  @$internal
  @override
  $StreamProviderElement<Map<String, ExercisePref>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<Map<String, ExercisePref>> create(Ref ref) {
    return exercisePrefs(ref);
  }
}

String _$exercisePrefsHash() => r'd73711d8f00efe0e81a0162b9da4733fd35ee287';

/// Exercise names by id (sessions and routines store only the id).

@ProviderFor(exerciseNames)
final exerciseNamesProvider = ExerciseNamesProvider._();

/// Exercise names by id (sessions and routines store only the id).

final class ExerciseNamesProvider
    extends
        $FunctionalProvider<
          Map<String, String>,
          Map<String, String>,
          Map<String, String>
        >
    with $Provider<Map<String, String>> {
  /// Exercise names by id (sessions and routines store only the id).
  ExerciseNamesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'exerciseNamesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$exerciseNamesHash();

  @$internal
  @override
  $ProviderElement<Map<String, String>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  Map<String, String> create(Ref ref) {
    return exerciseNames(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<String, String> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<String, String>>(value),
    );
  }
}

String _$exerciseNamesHash() => r'27a6433afd600f0430c812477ee6fcc67294b4fd';
