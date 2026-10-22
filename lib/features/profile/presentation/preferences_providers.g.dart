// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'preferences_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(profileRepository)
final profileRepositoryProvider = ProfileRepositoryProvider._();

final class ProfileRepositoryProvider
    extends
        $FunctionalProvider<
          ProfileRepository,
          ProfileRepository,
          ProfileRepository
        >
    with $Provider<ProfileRepository> {
  ProfileRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'profileRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$profileRepositoryHash();

  @$internal
  @override
  $ProviderElement<ProfileRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ProfileRepository create(Ref ref) {
    return profileRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ProfileRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ProfileRepository>(value),
    );
  }
}

String _$profileRepositoryHash() => r'535b0ab1bf90e39aad98a413ebceb05b1eeb76aa';

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
        isAutoDispose: false,
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
    r'813109678de55f993df603cfc7f19961a1922b65';

@ProviderFor(updateProfileUseCase)
final updateProfileUseCaseProvider = UpdateProfileUseCaseProvider._();

final class UpdateProfileUseCaseProvider
    extends
        $FunctionalProvider<
          UpdateProfileUseCase,
          UpdateProfileUseCase,
          UpdateProfileUseCase
        >
    with $Provider<UpdateProfileUseCase> {
  UpdateProfileUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'updateProfileUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$updateProfileUseCaseHash();

  @$internal
  @override
  $ProviderElement<UpdateProfileUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  UpdateProfileUseCase create(Ref ref) {
    return updateProfileUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UpdateProfileUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UpdateProfileUseCase>(value),
    );
  }
}

String _$updateProfileUseCaseHash() =>
    r'1d9baca8efbdc0053489383ccfa1d0a2bc62a446';

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
        isAutoDispose: false,
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

String _$unitSystemHash() => r'd01f7c8363cd7af401fd15d1156f8abeab3761a8';

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

String _$themeModeHash() => r'5ab9069f901b52c4ae0f665262e85576e6d80b45';

/// Saving state of profile / preference changes.

@ProviderFor(ProfileSaveController)
final profileSaveControllerProvider = ProfileSaveControllerProvider._();

/// Saving state of profile / preference changes.
final class ProfileSaveControllerProvider
    extends $AsyncNotifierProvider<ProfileSaveController, void> {
  /// Saving state of profile / preference changes.
  ProfileSaveControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'profileSaveControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$profileSaveControllerHash();

  @$internal
  @override
  ProfileSaveController create() => ProfileSaveController();
}

String _$profileSaveControllerHash() =>
    r'8ef52e3fe4f6bb3fc0ce905e38e458ad944af294';

/// Saving state of profile / preference changes.

abstract class _$ProfileSaveController extends $AsyncNotifier<void> {
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
