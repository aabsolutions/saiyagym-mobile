// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'body_metrics_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(bodyMetricsRepository)
final bodyMetricsRepositoryProvider = BodyMetricsRepositoryProvider._();

final class BodyMetricsRepositoryProvider
    extends
        $FunctionalProvider<
          BodyMetricsRepository,
          BodyMetricsRepository,
          BodyMetricsRepository
        >
    with $Provider<BodyMetricsRepository> {
  BodyMetricsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'bodyMetricsRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$bodyMetricsRepositoryHash();

  @$internal
  @override
  $ProviderElement<BodyMetricsRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  BodyMetricsRepository create(Ref ref) {
    return bodyMetricsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BodyMetricsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BodyMetricsRepository>(value),
    );
  }
}

String _$bodyMetricsRepositoryHash() =>
    r'f345a92ee9c2cf7077f9bdf8ec938018323990a1';
