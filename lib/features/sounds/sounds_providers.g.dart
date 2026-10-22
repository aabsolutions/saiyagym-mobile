// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sounds_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(alarmSoundPlatform)
final alarmSoundPlatformProvider = AlarmSoundPlatformProvider._();

final class AlarmSoundPlatformProvider
    extends
        $FunctionalProvider<
          AlarmSoundPlatform,
          AlarmSoundPlatform,
          AlarmSoundPlatform
        >
    with $Provider<AlarmSoundPlatform> {
  AlarmSoundPlatformProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'alarmSoundPlatformProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$alarmSoundPlatformHash();

  @$internal
  @override
  $ProviderElement<AlarmSoundPlatform> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AlarmSoundPlatform create(Ref ref) {
    return alarmSoundPlatform(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AlarmSoundPlatform value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AlarmSoundPlatform>(value),
    );
  }
}

String _$alarmSoundPlatformHash() =>
    r'd7aed46b9641dbc05ab4dd95ae4c8d86060356b0';

@ProviderFor(soundTarget)
final soundTargetProvider = SoundTargetProvider._();

final class SoundTargetProvider
    extends $FunctionalProvider<SoundTarget, SoundTarget, SoundTarget>
    with $Provider<SoundTarget> {
  SoundTargetProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'soundTargetProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$soundTargetHash();

  @$internal
  @override
  $ProviderElement<SoundTarget> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SoundTarget create(Ref ref) {
    return soundTarget(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SoundTarget value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SoundTarget>(value),
    );
  }
}

String _$soundTargetHash() => r'86eb559e42277a37ad1a5c3047bb38b5d21d67cb';

/// Android: app support files. iOS: `Library/Sounds`, the only place a
/// notification sound is looked up by file name.

@ProviderFor(soundDirectory)
final soundDirectoryProvider = SoundDirectoryProvider._();

/// Android: app support files. iOS: `Library/Sounds`, the only place a
/// notification sound is looked up by file name.

final class SoundDirectoryProvider
    extends $FunctionalProvider<SoundDirectory, SoundDirectory, SoundDirectory>
    with $Provider<SoundDirectory> {
  /// Android: app support files. iOS: `Library/Sounds`, the only place a
  /// notification sound is looked up by file name.
  SoundDirectoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'soundDirectoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$soundDirectoryHash();

  @$internal
  @override
  $ProviderElement<SoundDirectory> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SoundDirectory create(Ref ref) {
    return soundDirectory(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SoundDirectory value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SoundDirectory>(value),
    );
  }
}

String _$soundDirectoryHash() => r'27d8adb90bceaa3e68f56e2a58f9d1faa55e2006';

@ProviderFor(soundRepository)
final soundRepositoryProvider = SoundRepositoryProvider._();

final class SoundRepositoryProvider
    extends
        $FunctionalProvider<SoundRepository, SoundRepository, SoundRepository>
    with $Provider<SoundRepository> {
  SoundRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'soundRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$soundRepositoryHash();

  @$internal
  @override
  $ProviderElement<SoundRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SoundRepository create(Ref ref) {
    return soundRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SoundRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SoundRepository>(value),
    );
  }
}

String _$soundRepositoryHash() => r'78d1ef334b447c08a82358e4d3e5986c59207cad';

/// Downloads go through the plain client (no JWT to Cloudinary).

@ProviderFor(soundCache)
final soundCacheProvider = SoundCacheProvider._();

/// Downloads go through the plain client (no JWT to Cloudinary).

final class SoundCacheProvider
    extends $FunctionalProvider<SoundCache, SoundCache, SoundCache>
    with $Provider<SoundCache> {
  /// Downloads go through the plain client (no JWT to Cloudinary).
  SoundCacheProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'soundCacheProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$soundCacheHash();

  @$internal
  @override
  $ProviderElement<SoundCache> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SoundCache create(Ref ref) {
    return soundCache(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SoundCache value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SoundCache>(value),
    );
  }
}

String _$soundCacheHash() => r'4b03891d6a76f2242fdd12adbd8859ca522e863a';

@ProviderFor(soundPreview)
final soundPreviewProvider = SoundPreviewProvider._();

final class SoundPreviewProvider
    extends $FunctionalProvider<SoundPreview, SoundPreview, SoundPreview>
    with $Provider<SoundPreview> {
  SoundPreviewProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'soundPreviewProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$soundPreviewHash();

  @$internal
  @override
  $ProviderElement<SoundPreview> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SoundPreview create(Ref ref) {
    return soundPreview(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SoundPreview value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SoundPreview>(value),
    );
  }
}

String _$soundPreviewHash() => r'7e13f50ca9bf7e12667d9ba1495d1f7802bb96b9';

/// The catalog (cached for offline display).

@ProviderFor(restSounds)
final restSoundsProvider = RestSoundsProvider._();

/// The catalog (cached for offline display).

final class RestSoundsProvider
    extends
        $FunctionalProvider<
          AsyncValue<Cached<List<RestSound>>>,
          Cached<List<RestSound>>,
          FutureOr<Cached<List<RestSound>>>
        >
    with
        $FutureModifier<Cached<List<RestSound>>>,
        $FutureProvider<Cached<List<RestSound>>> {
  /// The catalog (cached for offline display).
  RestSoundsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'restSoundsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$restSoundsHash();

  @$internal
  @override
  $FutureProviderElement<Cached<List<RestSound>>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Cached<List<RestSound>>> create(Ref ref) {
    return restSounds(ref);
  }
}

String _$restSoundsHash() => r'43b3ed229fd9ce035344859d249c0ef332a3a295';

/// Id of the user's EFFECTIVE sound (the API nulls it when deleted or the
/// plan no longer allows it).

@ProviderFor(selectedRestSoundId)
final selectedRestSoundIdProvider = SelectedRestSoundIdProvider._();

/// Id of the user's EFFECTIVE sound (the API nulls it when deleted or the
/// plan no longer allows it).

final class SelectedRestSoundIdProvider
    extends $FunctionalProvider<String?, String?, String?>
    with $Provider<String?> {
  /// Id of the user's EFFECTIVE sound (the API nulls it when deleted or the
  /// plan no longer allows it).
  SelectedRestSoundIdProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedRestSoundIdProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedRestSoundIdHash();

  @$internal
  @override
  $ProviderElement<String?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String? create(Ref ref) {
    return selectedRestSoundId(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$selectedRestSoundIdHash() =>
    r'aa6dab7eaa85e1946717b034708822ae9e30d8ba';

/// The selected sound if it is installed on this device right now; never
/// touches the network. `null` = default sound.

@ProviderFor(installedAlarmSound)
final installedAlarmSoundProvider = InstalledAlarmSoundProvider._();

/// The selected sound if it is installed on this device right now; never
/// touches the network. `null` = default sound.

final class InstalledAlarmSoundProvider
    extends
        $FunctionalProvider<
          AsyncValue<AlarmSound?>,
          AlarmSound?,
          FutureOr<AlarmSound?>
        >
    with $FutureModifier<AlarmSound?>, $FutureProvider<AlarmSound?> {
  /// The selected sound if it is installed on this device right now; never
  /// touches the network. `null` = default sound.
  InstalledAlarmSoundProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'installedAlarmSoundProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$installedAlarmSoundHash();

  @$internal
  @override
  $FutureProviderElement<AlarmSound?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<AlarmSound?> create(Ref ref) {
    return installedAlarmSound(ref);
  }
}

String _$installedAlarmSoundHash() =>
    r'1c0d15facac0e4188619309ceeacc77a637e193f';

/// Choosing / clearing the rest sound (keep-alive: a download may outlive
/// the sheet that started it).

@ProviderFor(RestSoundController)
final restSoundControllerProvider = RestSoundControllerProvider._();

/// Choosing / clearing the rest sound (keep-alive: a download may outlive
/// the sheet that started it).
final class RestSoundControllerProvider
    extends $AsyncNotifierProvider<RestSoundController, void> {
  /// Choosing / clearing the rest sound (keep-alive: a download may outlive
  /// the sheet that started it).
  RestSoundControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'restSoundControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$restSoundControllerHash();

  @$internal
  @override
  RestSoundController create() => RestSoundController();
}

String _$restSoundControllerHash() =>
    r'448426721b77f5e36f90f5a1944a65c9137cbf27';

/// Choosing / clearing the rest sound (keep-alive: a download may outlive
/// the sheet that started it).

abstract class _$RestSoundController extends $AsyncNotifier<void> {
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
