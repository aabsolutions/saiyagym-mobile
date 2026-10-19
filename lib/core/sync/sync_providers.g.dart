// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(syncStores)
final syncStoresProvider = SyncStoresProvider._();

final class SyncStoresProvider
    extends $FunctionalProvider<SyncStores, SyncStores, SyncStores>
    with $Provider<SyncStores> {
  SyncStoresProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'syncStoresProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$syncStoresHash();

  @$internal
  @override
  $ProviderElement<SyncStores> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SyncStores create(Ref ref) {
    return syncStores(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SyncStores value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SyncStores>(value),
    );
  }
}

String _$syncStoresHash() => r'f8ea14a37aac28a2d3da628460003c10ce70dc6a';

@ProviderFor(syncQueue)
final syncQueueProvider = SyncQueueProvider._();

final class SyncQueueProvider
    extends $FunctionalProvider<SyncQueueDao, SyncQueueDao, SyncQueueDao>
    with $Provider<SyncQueueDao> {
  SyncQueueProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'syncQueueProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$syncQueueHash();

  @$internal
  @override
  $ProviderElement<SyncQueueDao> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SyncQueueDao create(Ref ref) {
    return syncQueue(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SyncQueueDao value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SyncQueueDao>(value),
    );
  }
}

String _$syncQueueHash() => r'52e2b1d67b5cf4c3db0a3e4bf1b4dd24c5368930';

@ProviderFor(syncService)
final syncServiceProvider = SyncServiceProvider._();

final class SyncServiceProvider
    extends $FunctionalProvider<SyncService, SyncService, SyncService>
    with $Provider<SyncService> {
  SyncServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'syncServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$syncServiceHash();

  @$internal
  @override
  $ProviderElement<SyncService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SyncService create(Ref ref) {
    return syncService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SyncService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SyncService>(value),
    );
  }
}

String _$syncServiceHash() => r'3f0352c89620d0f272e03b8b49dbbb597aef684b';

/// Writer for repositories: every local edit schedules a (debounced) sync.

@ProviderFor(syncWriter)
final syncWriterProvider = SyncWriterProvider._();

/// Writer for repositories: every local edit schedules a (debounced) sync.

final class SyncWriterProvider
    extends $FunctionalProvider<SyncWriter, SyncWriter, SyncWriter>
    with $Provider<SyncWriter> {
  /// Writer for repositories: every local edit schedules a (debounced) sync.
  SyncWriterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'syncWriterProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$syncWriterHash();

  @$internal
  @override
  $ProviderElement<SyncWriter> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SyncWriter create(Ref ref) {
    return syncWriter(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SyncWriter value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SyncWriter>(value),
    );
  }
}

String _$syncWriterHash() => r'5c3b908d2a0c0bc9ba93e828236afa96bd6ab5ac';

/// Changes the API rejected permanently (for the sync sheet).

@ProviderFor(failedChanges)
final failedChangesProvider = FailedChangesProvider._();

/// Changes the API rejected permanently (for the sync sheet).

final class FailedChangesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<FailedChange>>,
          List<FailedChange>,
          Stream<List<FailedChange>>
        >
    with
        $FutureModifier<List<FailedChange>>,
        $StreamProvider<List<FailedChange>> {
  /// Changes the API rejected permanently (for the sync sheet).
  FailedChangesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'failedChangesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$failedChangesHash();

  @$internal
  @override
  $StreamProviderElement<List<FailedChange>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<FailedChange>> create(Ref ref) {
    return failedChanges(ref);
  }
}

String _$failedChangesHash() => r'b1451f4b934a107c7eba715bde9b7f82bccb0814';

@ProviderFor(syncScheduler)
final syncSchedulerProvider = SyncSchedulerProvider._();

final class SyncSchedulerProvider
    extends $FunctionalProvider<SyncScheduler, SyncScheduler, SyncScheduler>
    with $Provider<SyncScheduler> {
  SyncSchedulerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'syncSchedulerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$syncSchedulerHash();

  @$internal
  @override
  $ProviderElement<SyncScheduler> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SyncScheduler create(Ref ref) {
    return syncScheduler(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SyncScheduler value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SyncScheduler>(value),
    );
  }
}

String _$syncSchedulerHash() => r'180da224ceb2ed440757ea13f7092714fe2c4451';

@ProviderFor(connectivityMonitor)
final connectivityMonitorProvider = ConnectivityMonitorProvider._();

final class ConnectivityMonitorProvider
    extends
        $FunctionalProvider<
          ConnectivityMonitor,
          ConnectivityMonitor,
          ConnectivityMonitor
        >
    with $Provider<ConnectivityMonitor> {
  ConnectivityMonitorProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'connectivityMonitorProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$connectivityMonitorHash();

  @$internal
  @override
  $ProviderElement<ConnectivityMonitor> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ConnectivityMonitor create(Ref ref) {
    return connectivityMonitor(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ConnectivityMonitor value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ConnectivityMonitor>(value),
    );
  }
}

String _$connectivityMonitorHash() =>
    r'5854d168aaf3f18152cc54f5dce7ec006b2dcb89';

/// Live sync state for the UI.

@ProviderFor(SyncStatus)
final syncStatusProvider = SyncStatusProvider._();

/// Live sync state for the UI.
final class SyncStatusProvider
    extends $NotifierProvider<SyncStatus, SyncState> {
  /// Live sync state for the UI.
  SyncStatusProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'syncStatusProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$syncStatusHash();

  @$internal
  @override
  SyncStatus create() => SyncStatus();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SyncState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SyncState>(value),
    );
  }
}

String _$syncStatusHash() => r'7071cfbc0806abb871ee3bdf051dbe61151dcc07';

/// Live sync state for the UI.

abstract class _$SyncStatus extends $Notifier<SyncState> {
  SyncState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<SyncState, SyncState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SyncState, SyncState>,
              SyncState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
