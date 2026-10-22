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

/// Id of the user's EFFECTIVE sound for [purpose] (the API nulls it when
/// deleted or the plan no longer allows it). Keep-alive: the (keep-alive)
/// reminders depend on it.

@ProviderFor(selectedSoundId)
final selectedSoundIdProvider = SelectedSoundIdFamily._();

/// Id of the user's EFFECTIVE sound for [purpose] (the API nulls it when
/// deleted or the plan no longer allows it). Keep-alive: the (keep-alive)
/// reminders depend on it.

final class SelectedSoundIdProvider
    extends $FunctionalProvider<String?, String?, String?>
    with $Provider<String?> {
  /// Id of the user's EFFECTIVE sound for [purpose] (the API nulls it when
  /// deleted or the plan no longer allows it). Keep-alive: the (keep-alive)
  /// reminders depend on it.
  SelectedSoundIdProvider._({
    required SelectedSoundIdFamily super.from,
    required SoundPurpose super.argument,
  }) : super(
         retry: null,
         name: r'selectedSoundIdProvider',
         isAutoDispose: false,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$selectedSoundIdHash();

  @override
  String toString() {
    return r'selectedSoundIdProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<String?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String? create(Ref ref) {
    final argument = this.argument as SoundPurpose;
    return selectedSoundId(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is SelectedSoundIdProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$selectedSoundIdHash() => r'2d5fff28ca14ef2fe5cd903d0893772f2ea91b63';

/// Id of the user's EFFECTIVE sound for [purpose] (the API nulls it when
/// deleted or the plan no longer allows it). Keep-alive: the (keep-alive)
/// reminders depend on it.

final class SelectedSoundIdFamily extends $Family
    with $FunctionalFamilyOverride<String?, SoundPurpose> {
  SelectedSoundIdFamily._()
    : super(
        retry: null,
        name: r'selectedSoundIdProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  /// Id of the user's EFFECTIVE sound for [purpose] (the API nulls it when
  /// deleted or the plan no longer allows it). Keep-alive: the (keep-alive)
  /// reminders depend on it.

  SelectedSoundIdProvider call(SoundPurpose purpose) =>
      SelectedSoundIdProvider._(argument: purpose, from: this);

  @override
  String toString() => r'selectedSoundIdProvider';
}

/// The sound selected for [purpose] if it is installed on this device right
/// now; never touches the network. `null` = default sound.

@ProviderFor(installedAlarmSound)
final installedAlarmSoundProvider = InstalledAlarmSoundFamily._();

/// The sound selected for [purpose] if it is installed on this device right
/// now; never touches the network. `null` = default sound.

final class InstalledAlarmSoundProvider
    extends
        $FunctionalProvider<
          AsyncValue<AlarmSound?>,
          AlarmSound?,
          FutureOr<AlarmSound?>
        >
    with $FutureModifier<AlarmSound?>, $FutureProvider<AlarmSound?> {
  /// The sound selected for [purpose] if it is installed on this device right
  /// now; never touches the network. `null` = default sound.
  InstalledAlarmSoundProvider._({
    required InstalledAlarmSoundFamily super.from,
    required SoundPurpose super.argument,
  }) : super(
         retry: null,
         name: r'installedAlarmSoundProvider',
         isAutoDispose: false,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$installedAlarmSoundHash();

  @override
  String toString() {
    return r'installedAlarmSoundProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<AlarmSound?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<AlarmSound?> create(Ref ref) {
    final argument = this.argument as SoundPurpose;
    return installedAlarmSound(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is InstalledAlarmSoundProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$installedAlarmSoundHash() =>
    r'985fcaf6ced23fd56ce7154fa0c7031bdd26c200';

/// The sound selected for [purpose] if it is installed on this device right
/// now; never touches the network. `null` = default sound.

final class InstalledAlarmSoundFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<AlarmSound?>, SoundPurpose> {
  InstalledAlarmSoundFamily._()
    : super(
        retry: null,
        name: r'installedAlarmSoundProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  /// The sound selected for [purpose] if it is installed on this device right
  /// now; never touches the network. `null` = default sound.

  InstalledAlarmSoundProvider call(SoundPurpose purpose) =>
      InstalledAlarmSoundProvider._(argument: purpose, from: this);

  @override
  String toString() => r'installedAlarmSoundProvider';
}

/// Choosing / clearing the sound of one [purpose] (keep-alive: a download
/// may outlive the sheet that started it). Edits ONLY that purpose's
/// preference; afterwards the device keeps just the sounds some purpose
/// still needs.

@ProviderFor(SoundSelectionController)
final soundSelectionControllerProvider = SoundSelectionControllerFamily._();

/// Choosing / clearing the sound of one [purpose] (keep-alive: a download
/// may outlive the sheet that started it). Edits ONLY that purpose's
/// preference; afterwards the device keeps just the sounds some purpose
/// still needs.
final class SoundSelectionControllerProvider
    extends $AsyncNotifierProvider<SoundSelectionController, void> {
  /// Choosing / clearing the sound of one [purpose] (keep-alive: a download
  /// may outlive the sheet that started it). Edits ONLY that purpose's
  /// preference; afterwards the device keeps just the sounds some purpose
  /// still needs.
  SoundSelectionControllerProvider._({
    required SoundSelectionControllerFamily super.from,
    required SoundPurpose super.argument,
  }) : super(
         retry: null,
         name: r'soundSelectionControllerProvider',
         isAutoDispose: false,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$soundSelectionControllerHash();

  @override
  String toString() {
    return r'soundSelectionControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  SoundSelectionController create() => SoundSelectionController();

  @override
  bool operator ==(Object other) {
    return other is SoundSelectionControllerProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$soundSelectionControllerHash() =>
    r'e180b492e4cf2f3184d6abaee41e5dd1fd1cfc31';

/// Choosing / clearing the sound of one [purpose] (keep-alive: a download
/// may outlive the sheet that started it). Edits ONLY that purpose's
/// preference; afterwards the device keeps just the sounds some purpose
/// still needs.

final class SoundSelectionControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          SoundSelectionController,
          AsyncValue<void>,
          void,
          FutureOr<void>,
          SoundPurpose
        > {
  SoundSelectionControllerFamily._()
    : super(
        retry: null,
        name: r'soundSelectionControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  /// Choosing / clearing the sound of one [purpose] (keep-alive: a download
  /// may outlive the sheet that started it). Edits ONLY that purpose's
  /// preference; afterwards the device keeps just the sounds some purpose
  /// still needs.

  SoundSelectionControllerProvider call(SoundPurpose purpose) =>
      SoundSelectionControllerProvider._(argument: purpose, from: this);

  @override
  String toString() => r'soundSelectionControllerProvider';
}

/// Choosing / clearing the sound of one [purpose] (keep-alive: a download
/// may outlive the sheet that started it). Edits ONLY that purpose's
/// preference; afterwards the device keeps just the sounds some purpose
/// still needs.

abstract class _$SoundSelectionController extends $AsyncNotifier<void> {
  late final _$args = ref.$arg as SoundPurpose;
  SoundPurpose get purpose => _$args;

  FutureOr<void> build(SoundPurpose purpose);
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
    return element.handleCreate(ref, () => build(_$args));
  }
}

/// Device-wide upkeep of the installed sounds (keep-alive, no state).

@ProviderFor(soundHousekeeping)
final soundHousekeepingProvider = SoundHousekeepingProvider._();

/// Device-wide upkeep of the installed sounds (keep-alive, no state).

final class SoundHousekeepingProvider
    extends
        $FunctionalProvider<
          SoundHousekeeping,
          SoundHousekeeping,
          SoundHousekeeping
        >
    with $Provider<SoundHousekeeping> {
  /// Device-wide upkeep of the installed sounds (keep-alive, no state).
  SoundHousekeepingProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'soundHousekeepingProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$soundHousekeepingHash();

  @$internal
  @override
  $ProviderElement<SoundHousekeeping> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SoundHousekeeping create(Ref ref) {
    return soundHousekeeping(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SoundHousekeeping value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SoundHousekeeping>(value),
    );
  }
}

String _$soundHousekeepingHash() => r'307111b49ed3f2dc4bc5cb83d2d4be90dc403c8f';
