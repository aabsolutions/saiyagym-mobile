// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'routines_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(routinesRepository)
final routinesRepositoryProvider = RoutinesRepositoryProvider._();

final class RoutinesRepositoryProvider
    extends
        $FunctionalProvider<
          RoutinesRepository,
          RoutinesRepository,
          RoutinesRepository
        >
    with $Provider<RoutinesRepository> {
  RoutinesRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'routinesRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$routinesRepositoryHash();

  @$internal
  @override
  $ProviderElement<RoutinesRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  RoutinesRepository create(Ref ref) {
    return routinesRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RoutinesRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RoutinesRepository>(value),
    );
  }
}

String _$routinesRepositoryHash() =>
    r'1660383b06bae58c52d3dc203d74820280306a92';

@ProviderFor(activeRoutines)
final activeRoutinesProvider = ActiveRoutinesProvider._();

final class ActiveRoutinesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Routine>>,
          List<Routine>,
          Stream<List<Routine>>
        >
    with $FutureModifier<List<Routine>>, $StreamProvider<List<Routine>> {
  ActiveRoutinesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activeRoutinesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activeRoutinesHash();

  @$internal
  @override
  $StreamProviderElement<List<Routine>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Routine>> create(Ref ref) {
    return activeRoutines(ref);
  }
}

String _$activeRoutinesHash() => r'8a1838e8cba14a94569e3d1d307ebc6abec15f98';
