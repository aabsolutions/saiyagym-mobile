// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workouts_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(workoutsRepository)
final workoutsRepositoryProvider = WorkoutsRepositoryProvider._();

final class WorkoutsRepositoryProvider
    extends
        $FunctionalProvider<
          WorkoutsRepository,
          WorkoutsRepository,
          WorkoutsRepository
        >
    with $Provider<WorkoutsRepository> {
  WorkoutsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'workoutsRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$workoutsRepositoryHash();

  @$internal
  @override
  $ProviderElement<WorkoutsRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  WorkoutsRepository create(Ref ref) {
    return workoutsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WorkoutsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WorkoutsRepository>(value),
    );
  }
}

String _$workoutsRepositoryHash() =>
    r'd547c9573ca3f70332b5c9fed28c7d2780c03570';

@ProviderFor(finishWorkoutUseCase)
final finishWorkoutUseCaseProvider = FinishWorkoutUseCaseProvider._();

final class FinishWorkoutUseCaseProvider
    extends
        $FunctionalProvider<
          FinishWorkoutUseCase,
          FinishWorkoutUseCase,
          FinishWorkoutUseCase
        >
    with $Provider<FinishWorkoutUseCase> {
  FinishWorkoutUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'finishWorkoutUseCaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$finishWorkoutUseCaseHash();

  @$internal
  @override
  $ProviderElement<FinishWorkoutUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  FinishWorkoutUseCase create(Ref ref) {
    return finishWorkoutUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FinishWorkoutUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FinishWorkoutUseCase>(value),
    );
  }
}

String _$finishWorkoutUseCaseHash() =>
    r'a4a3e6cb65d68a2bde9a7eb9a61f3030b202997a';

@ProviderFor(workoutHistory)
final workoutHistoryProvider = WorkoutHistoryProvider._();

final class WorkoutHistoryProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Workout>>,
          List<Workout>,
          Stream<List<Workout>>
        >
    with $FutureModifier<List<Workout>>, $StreamProvider<List<Workout>> {
  WorkoutHistoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'workoutHistoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$workoutHistoryHash();

  @$internal
  @override
  $StreamProviderElement<List<Workout>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Workout>> create(Ref ref) {
    return workoutHistory(ref);
  }
}

String _$workoutHistoryHash() => r'0248b83aa9a4ca6060f414525c73cbc543e09cb0';
