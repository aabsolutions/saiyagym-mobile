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
    r'1c8f05ea070860d9320b0b87b7029612d8b434fc';
