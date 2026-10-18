// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'preferences_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(updatePreferencesUseCase)
final updatePreferencesUseCaseProvider = UpdatePreferencesUseCaseProvider._();

final class UpdatePreferencesUseCaseProvider
    extends
        $FunctionalProvider<
          UpdatePreferencesUseCase,
          UpdatePreferencesUseCase,
          UpdatePreferencesUseCase
        >
    with $Provider<UpdatePreferencesUseCase> {
  UpdatePreferencesUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'updatePreferencesUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$updatePreferencesUseCaseHash();

  @$internal
  @override
  $ProviderElement<UpdatePreferencesUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  UpdatePreferencesUseCase create(Ref ref) {
    return updatePreferencesUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UpdatePreferencesUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UpdatePreferencesUseCase>(value),
    );
  }
}

String _$updatePreferencesUseCaseHash() =>
    r'e16e0ec19715a8c082cf1e3ffbbdac9206c32fd2';

/// Units of the signed-in user (metric before sign-in).

@ProviderFor(unitSystem)
final unitSystemProvider = UnitSystemProvider._();

/// Units of the signed-in user (metric before sign-in).

final class UnitSystemProvider
    extends $FunctionalProvider<UnitSystem, UnitSystem, UnitSystem>
    with $Provider<UnitSystem> {
  /// Units of the signed-in user (metric before sign-in).
  UnitSystemProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'unitSystemProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$unitSystemHash();

  @$internal
  @override
  $ProviderElement<UnitSystem> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  UnitSystem create(Ref ref) {
    return unitSystem(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UnitSystem value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UnitSystem>(value),
    );
  }
}

String _$unitSystemHash() => r'70bef802ca95d842326169138b929dc98e08819f';

@ProviderFor(themeMode)
final themeModeProvider = ThemeModeProvider._();

final class ThemeModeProvider
    extends $FunctionalProvider<ThemeMode, ThemeMode, ThemeMode>
    with $Provider<ThemeMode> {
  ThemeModeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'themeModeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$themeModeHash();

  @$internal
  @override
  $ProviderElement<ThemeMode> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ThemeMode create(Ref ref) {
    return themeMode(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ThemeMode value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ThemeMode>(value),
    );
  }
}

String _$themeModeHash() => r'185a93e7aee3ff3bb8cf2d4b2678092adb815064';

/// Saving state of a preference change.

@ProviderFor(PreferencesController)
final preferencesControllerProvider = PreferencesControllerProvider._();

/// Saving state of a preference change.
final class PreferencesControllerProvider
    extends $AsyncNotifierProvider<PreferencesController, void> {
  /// Saving state of a preference change.
  PreferencesControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'preferencesControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$preferencesControllerHash();

  @$internal
  @override
  PreferencesController create() => PreferencesController();
}

String _$preferencesControllerHash() =>
    r'e0e6feb0b1dae78e9b60d149bd543aeffc65dc81';

/// Saving state of a preference change.

abstract class _$PreferencesController extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
