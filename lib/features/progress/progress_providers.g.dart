// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'progress_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(progressStatsRepository)
final progressStatsRepositoryProvider = ProgressStatsRepositoryProvider._();

final class ProgressStatsRepositoryProvider
    extends
        $FunctionalProvider<
          ProgressStatsRepository,
          ProgressStatsRepository,
          ProgressStatsRepository
        >
    with $Provider<ProgressStatsRepository> {
  ProgressStatsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'progressStatsRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$progressStatsRepositoryHash();

  @$internal
  @override
  $ProviderElement<ProgressStatsRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ProgressStatsRepository create(Ref ref) {
    return progressStatsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ProgressStatsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ProgressStatsRepository>(value),
    );
  }
}

String _$progressStatsRepositoryHash() =>
    r'8d10fecbb4c1b620c025c4b9a500af462a8a1e1f';

@ProviderFor(exerciseProgress)
final exerciseProgressProvider = ExerciseProgressFamily._();

final class ExerciseProgressProvider
    extends
        $FunctionalProvider<
          AsyncValue<Cached<ExerciseProgress>>,
          Cached<ExerciseProgress>,
          FutureOr<Cached<ExerciseProgress>>
        >
    with
        $FutureModifier<Cached<ExerciseProgress>>,
        $FutureProvider<Cached<ExerciseProgress>> {
  ExerciseProgressProvider._({
    required ExerciseProgressFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'exerciseProgressProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$exerciseProgressHash();

  @override
  String toString() {
    return r'exerciseProgressProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Cached<ExerciseProgress>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Cached<ExerciseProgress>> create(Ref ref) {
    final argument = this.argument as String;
    return exerciseProgress(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ExerciseProgressProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$exerciseProgressHash() => r'34f4faeb4600a641c26aed24f64c71d63e055f80';

final class ExerciseProgressFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Cached<ExerciseProgress>>, String> {
  ExerciseProgressFamily._()
    : super(
        retry: null,
        name: r'exerciseProgressProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ExerciseProgressProvider call(String exerciseId) =>
      ExerciseProgressProvider._(argument: exerciseId, from: this);

  @override
  String toString() => r'exerciseProgressProvider';
}

@ProviderFor(muscleVolume)
final muscleVolumeProvider = MuscleVolumeProvider._();

final class MuscleVolumeProvider
    extends
        $FunctionalProvider<
          AsyncValue<Cached<MuscleVolume>>,
          Cached<MuscleVolume>,
          FutureOr<Cached<MuscleVolume>>
        >
    with
        $FutureModifier<Cached<MuscleVolume>>,
        $FutureProvider<Cached<MuscleVolume>> {
  MuscleVolumeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'muscleVolumeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$muscleVolumeHash();

  @$internal
  @override
  $FutureProviderElement<Cached<MuscleVolume>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Cached<MuscleVolume>> create(Ref ref) {
    return muscleVolume(ref);
  }
}

String _$muscleVolumeHash() => r'252f3b9087948ff731b1faefc319f897b1defeee';

@ProviderFor(powerliftingTotal)
final powerliftingTotalProvider = PowerliftingTotalFamily._();

final class PowerliftingTotalProvider
    extends
        $FunctionalProvider<
          AsyncValue<Cached<PowerliftingTotal>>,
          Cached<PowerliftingTotal>,
          FutureOr<Cached<PowerliftingTotal>>
        >
    with
        $FutureModifier<Cached<PowerliftingTotal>>,
        $FutureProvider<Cached<PowerliftingTotal>> {
  PowerliftingTotalProvider._({
    required PowerliftingTotalFamily super.from,
    required PowerliftingMetric super.argument,
  }) : super(
         retry: null,
         name: r'powerliftingTotalProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$powerliftingTotalHash();

  @override
  String toString() {
    return r'powerliftingTotalProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Cached<PowerliftingTotal>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Cached<PowerliftingTotal>> create(Ref ref) {
    final argument = this.argument as PowerliftingMetric;
    return powerliftingTotal(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is PowerliftingTotalProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$powerliftingTotalHash() => r'3353d5df5d3e393da22bd00e7b4b0c45e06289a5';

final class PowerliftingTotalFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<Cached<PowerliftingTotal>>,
          PowerliftingMetric
        > {
  PowerliftingTotalFamily._()
    : super(
        retry: null,
        name: r'powerliftingTotalProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  PowerliftingTotalProvider call(PowerliftingMetric metric) =>
      PowerliftingTotalProvider._(argument: metric, from: this);

  @override
  String toString() => r'powerliftingTotalProvider';
}

/// Exercises the user has trained, most recent first (chart picker).

@ProviderFor(trainedExercises)
final trainedExercisesProvider = TrainedExercisesProvider._();

/// Exercises the user has trained, most recent first (chart picker).

final class TrainedExercisesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<String>>,
          List<String>,
          FutureOr<List<String>>
        >
    with $FutureModifier<List<String>>, $FutureProvider<List<String>> {
  /// Exercises the user has trained, most recent first (chart picker).
  TrainedExercisesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'trainedExercisesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$trainedExercisesHash();

  @$internal
  @override
  $FutureProviderElement<List<String>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<String>> create(Ref ref) {
    return trainedExercises(ref);
  }
}

String _$trainedExercisesHash() => r'eec87f93e01cb388fd81a2b3b35382eb888922a7';

/// Personal records per exercise, from local history (works offline and
/// includes sessions not synced yet; same rules as the API).

@ProviderFor(personalRecords)
final personalRecordsProvider = PersonalRecordsProvider._();

/// Personal records per exercise, from local history (works offline and
/// includes sessions not synced yet; same rules as the API).

final class PersonalRecordsProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<String, ExerciseRecords>>,
          Map<String, ExerciseRecords>,
          FutureOr<Map<String, ExerciseRecords>>
        >
    with
        $FutureModifier<Map<String, ExerciseRecords>>,
        $FutureProvider<Map<String, ExerciseRecords>> {
  /// Personal records per exercise, from local history (works offline and
  /// includes sessions not synced yet; same rules as the API).
  PersonalRecordsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'personalRecordsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$personalRecordsHash();

  @$internal
  @override
  $FutureProviderElement<Map<String, ExerciseRecords>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Map<String, ExerciseRecords>> create(Ref ref) {
    return personalRecords(ref);
  }
}

String _$personalRecordsHash() => r'a2947774be43a10c771752ae0a718709423eddba';

/// Newest first. Local, so unsynced entries show up right away.

@ProviderFor(bodyMetrics)
final bodyMetricsProvider = BodyMetricsProvider._();

/// Newest first. Local, so unsynced entries show up right away.

final class BodyMetricsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<BodyMetric>>,
          List<BodyMetric>,
          Stream<List<BodyMetric>>
        >
    with $FutureModifier<List<BodyMetric>>, $StreamProvider<List<BodyMetric>> {
  /// Newest first. Local, so unsynced entries show up right away.
  BodyMetricsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'bodyMetricsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$bodyMetricsHash();

  @$internal
  @override
  $StreamProviderElement<List<BodyMetric>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<BodyMetric>> create(Ref ref) {
    return bodyMetrics(ref);
  }
}

String _$bodyMetricsHash() => r'2c219358b74e729758977d5889e73f56f5c7869a';
