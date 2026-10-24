// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_coordinator.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(backgroundSyncScheduler)
final backgroundSyncSchedulerProvider = BackgroundSyncSchedulerProvider._();

final class BackgroundSyncSchedulerProvider
    extends
        $FunctionalProvider<
          BackgroundSyncScheduler,
          BackgroundSyncScheduler,
          BackgroundSyncScheduler
        >
    with $Provider<BackgroundSyncScheduler> {
  BackgroundSyncSchedulerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'backgroundSyncSchedulerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$backgroundSyncSchedulerHash();

  @$internal
  @override
  $ProviderElement<BackgroundSyncScheduler> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  BackgroundSyncScheduler create(Ref ref) {
    return backgroundSyncScheduler(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BackgroundSyncScheduler value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BackgroundSyncScheduler>(value),
    );
  }
}

String _$backgroundSyncSchedulerHash() =>
    r'bc1a1aebc222575232c7f9a8b69eb5c0b929477b';

/// Decides WHEN to sync (the service decides how):
/// sign-in / app open, network back, app resumed or sent to background,
/// language change (catalog), periodic background work. Also uploads
/// queued progress photos (sign-in, network back). Local edits and
/// finished workouts request it themselves.

@ProviderFor(SyncCoordinator)
final syncCoordinatorProvider = SyncCoordinatorProvider._();

/// Decides WHEN to sync (the service decides how):
/// sign-in / app open, network back, app resumed or sent to background,
/// language change (catalog), periodic background work. Also uploads
/// queued progress photos (sign-in, network back). Local edits and
/// finished workouts request it themselves.
final class SyncCoordinatorProvider
    extends $NotifierProvider<SyncCoordinator, void> {
  /// Decides WHEN to sync (the service decides how):
  /// sign-in / app open, network back, app resumed or sent to background,
  /// language change (catalog), periodic background work. Also uploads
  /// queued progress photos (sign-in, network back). Local edits and
  /// finished workouts request it themselves.
  SyncCoordinatorProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'syncCoordinatorProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$syncCoordinatorHash();

  @$internal
  @override
  SyncCoordinator create() => SyncCoordinator();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$syncCoordinatorHash() => r'ccd42d12587fd34aaaeee78f6816a4ed81ce5fd8';

/// Decides WHEN to sync (the service decides how):
/// sign-in / app open, network back, app resumed or sent to background,
/// language change (catalog), periodic background work. Also uploads
/// queued progress photos (sign-in, network back). Local edits and
/// finished workouts request it themselves.

abstract class _$SyncCoordinator extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
