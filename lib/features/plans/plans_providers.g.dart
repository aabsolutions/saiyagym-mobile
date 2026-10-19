// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plans_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Entitlements of the signed-in user's effective plan
/// ([Entitlements.none] when signed out).

@ProviderFor(entitlements)
final entitlementsProvider = EntitlementsProvider._();

/// Entitlements of the signed-in user's effective plan
/// ([Entitlements.none] when signed out).

final class EntitlementsProvider
    extends $FunctionalProvider<Entitlements, Entitlements, Entitlements>
    with $Provider<Entitlements> {
  /// Entitlements of the signed-in user's effective plan
  /// ([Entitlements.none] when signed out).
  EntitlementsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'entitlementsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$entitlementsHash();

  @$internal
  @override
  $ProviderElement<Entitlements> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Entitlements create(Ref ref) {
    return entitlements(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Entitlements value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Entitlements>(value),
    );
  }
}

String _$entitlementsHash() => r'844700d1ce90e02776396dc0a490019c2c9bbaba';

/// Public plan catalog (`GET /plans`) for the upgrade sheet.

@ProviderFor(availablePlans)
final availablePlansProvider = AvailablePlansProvider._();

/// Public plan catalog (`GET /plans`) for the upgrade sheet.

final class AvailablePlansProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Plan>>,
          List<Plan>,
          FutureOr<List<Plan>>
        >
    with $FutureModifier<List<Plan>>, $FutureProvider<List<Plan>> {
  /// Public plan catalog (`GET /plans`) for the upgrade sheet.
  AvailablePlansProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'availablePlansProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$availablePlansHash();

  @$internal
  @override
  $FutureProviderElement<List<Plan>> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<Plan>> create(Ref ref) {
    return availablePlans(ref);
  }
}

String _$availablePlansHash() => r'9e047957b9ddb17e859163813512c0fa2c7dc372';

@ProviderFor(paymentProvider)
final paymentProviderProvider = PaymentProviderProvider._();

final class PaymentProviderProvider
    extends
        $FunctionalProvider<PaymentProvider, PaymentProvider, PaymentProvider>
    with $Provider<PaymentProvider> {
  PaymentProviderProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'paymentProviderProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$paymentProviderHash();

  @$internal
  @override
  $ProviderElement<PaymentProvider> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PaymentProvider create(Ref ref) {
    return paymentProvider(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PaymentProvider value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PaymentProvider>(value),
    );
  }
}

String _$paymentProviderHash() => r'4a3bce5917b312f90d5719984ff77eddfce80c77';
