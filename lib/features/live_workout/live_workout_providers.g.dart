// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'live_workout_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(restAlarm)
final restAlarmProvider = RestAlarmProvider._();

final class RestAlarmProvider
    extends $FunctionalProvider<RestAlarm, RestAlarm, RestAlarm>
    with $Provider<RestAlarm> {
  RestAlarmProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'restAlarmProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$restAlarmHash();

  @$internal
  @override
  $ProviderElement<RestAlarm> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  RestAlarm create(Ref ref) {
    return restAlarm(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RestAlarm value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RestAlarm>(value),
    );
  }
}

String _$restAlarmHash() => r'e273a5baf87d7d6ab53332bd682e22bf0b39df6a';

@ProviderFor(screenAwake)
final screenAwakeProvider = ScreenAwakeProvider._();

final class ScreenAwakeProvider
    extends $FunctionalProvider<ScreenAwake, ScreenAwake, ScreenAwake>
    with $Provider<ScreenAwake> {
  ScreenAwakeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'screenAwakeProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$screenAwakeHash();

  @$internal
  @override
  $ProviderElement<ScreenAwake> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ScreenAwake create(Ref ref) {
    return screenAwake(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ScreenAwake value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ScreenAwake>(value),
    );
  }
}

String _$screenAwakeHash() => r'6de410035ca82a46289319a78e0b4426291c7428';

@ProviderFor(haptics)
final hapticsProvider = HapticsProvider._();

final class HapticsProvider
    extends $FunctionalProvider<Haptics, Haptics, Haptics>
    with $Provider<Haptics> {
  HapticsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'hapticsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$hapticsHash();

  @$internal
  @override
  $ProviderElement<Haptics> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Haptics create(Ref ref) {
    return haptics(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Haptics value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Haptics>(value),
    );
  }
}

String _$hapticsHash() => r'59df1fe51b86d4988213f55bc674157dae779d7f';

@ProviderFor(todayPlanService)
final todayPlanServiceProvider = TodayPlanServiceProvider._();

final class TodayPlanServiceProvider
    extends
        $FunctionalProvider<
          TodayPlanService,
          TodayPlanService,
          TodayPlanService
        >
    with $Provider<TodayPlanService> {
  TodayPlanServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'todayPlanServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$todayPlanServiceHash();

  @$internal
  @override
  $ProviderElement<TodayPlanService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  TodayPlanService create(Ref ref) {
    return todayPlanService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TodayPlanService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TodayPlanService>(value),
    );
  }
}

String _$todayPlanServiceHash() => r'aa54ee652913cb9662ff8442a2209a2e83ef4590';

/// Today's program day (API, or local when offline).

@ProviderFor(todayPlan)
final todayPlanProvider = TodayPlanProvider._();

/// Today's program day (API, or local when offline).

final class TodayPlanProvider
    extends
        $FunctionalProvider<
          AsyncValue<TodayPlan>,
          TodayPlan,
          FutureOr<TodayPlan>
        >
    with $FutureModifier<TodayPlan>, $FutureProvider<TodayPlan> {
  /// Today's program day (API, or local when offline).
  TodayPlanProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'todayPlanProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$todayPlanHash();

  @$internal
  @override
  $FutureProviderElement<TodayPlan> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<TodayPlan> create(Ref ref) {
    return todayPlan(ref);
  }
}

String _$todayPlanHash() => r'87d4c1ab0ef2077a579f547b9c77492716a65046';

/// The "resume your session?" prompt is shown once per app run.

@ProviderFor(ResumeOffered)
final resumeOfferedProvider = ResumeOfferedProvider._();

/// The "resume your session?" prompt is shown once per app run.
final class ResumeOfferedProvider
    extends $NotifierProvider<ResumeOffered, bool> {
  /// The "resume your session?" prompt is shown once per app run.
  ResumeOfferedProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'resumeOfferedProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$resumeOfferedHash();

  @$internal
  @override
  ResumeOffered create() => ResumeOffered();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$resumeOfferedHash() => r'58509ca66e2d542a9d802774457d7827330bcc24';

/// The "resume your session?" prompt is shown once per app run.

abstract class _$ResumeOffered extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(recordsConfirmer)
final recordsConfirmerProvider = RecordsConfirmerProvider._();

final class RecordsConfirmerProvider
    extends
        $FunctionalProvider<
          RecordsConfirmer,
          RecordsConfirmer,
          RecordsConfirmer
        >
    with $Provider<RecordsConfirmer> {
  RecordsConfirmerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'recordsConfirmerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$recordsConfirmerHash();

  @$internal
  @override
  $ProviderElement<RecordsConfirmer> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  RecordsConfirmer create(Ref ref) {
    return recordsConfirmer(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RecordsConfirmer value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RecordsConfirmer>(value),
    );
  }
}

String _$recordsConfirmerHash() => r'1b1459a1b5c0f091a95bf85d9bd5c0533c21a688';

/// Plates and screen-on, stored on this device.

@ProviderFor(TrainingSettingsController)
final trainingSettingsControllerProvider =
    TrainingSettingsControllerProvider._();

/// Plates and screen-on, stored on this device.
final class TrainingSettingsControllerProvider
    extends
        $AsyncNotifierProvider<TrainingSettingsController, TrainingSettings> {
  /// Plates and screen-on, stored on this device.
  TrainingSettingsControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'trainingSettingsControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$trainingSettingsControllerHash();

  @$internal
  @override
  TrainingSettingsController create() => TrainingSettingsController();
}

String _$trainingSettingsControllerHash() =>
    r'9c82d7a12de4013dfdd60c22a58a041a2dba1384';

/// Plates and screen-on, stored on this device.

abstract class _$TrainingSettingsController
    extends $AsyncNotifier<TrainingSettings> {
  FutureOr<TrainingSettings> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<TrainingSettings>, TrainingSettings>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<TrainingSettings>, TrainingSettings>,
              AsyncValue<TrainingSettings>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
