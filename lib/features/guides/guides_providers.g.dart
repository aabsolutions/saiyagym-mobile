// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'guides_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(guidesApi)
final guidesApiProvider = GuidesApiProvider._();

final class GuidesApiProvider
    extends $FunctionalProvider<GuidesApi, GuidesApi, GuidesApi>
    with $Provider<GuidesApi> {
  GuidesApiProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'guidesApiProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$guidesApiHash();

  @$internal
  @override
  $ProviderElement<GuidesApi> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GuidesApi create(Ref ref) {
    return guidesApi(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GuidesApi value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GuidesApi>(value),
    );
  }
}

String _$guidesApiHash() => r'51621c7a74fc4b69c474daaaac6c779b21eb4331';

@ProviderFor(guideDirectory)
final guideDirectoryProvider = GuideDirectoryProvider._();

final class GuideDirectoryProvider
    extends $FunctionalProvider<GuideDirectory, GuideDirectory, GuideDirectory>
    with $Provider<GuideDirectory> {
  GuideDirectoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'guideDirectoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$guideDirectoryHash();

  @$internal
  @override
  $ProviderElement<GuideDirectory> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GuideDirectory create(Ref ref) {
    return guideDirectory(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GuideDirectory value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GuideDirectory>(value),
    );
  }
}

String _$guideDirectoryHash() => r'5c93b299c22172d1b677bee5161bfbdf41ed029a';

/// Downloads go through the plain client (no JWT to Cloudinary).

@ProviderFor(guideFiles)
final guideFilesProvider = GuideFilesProvider._();

/// Downloads go through the plain client (no JWT to Cloudinary).

final class GuideFilesProvider
    extends $FunctionalProvider<GuideFiles, GuideFiles, GuideFiles>
    with $Provider<GuideFiles> {
  /// Downloads go through the plain client (no JWT to Cloudinary).
  GuideFilesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'guideFilesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$guideFilesHash();

  @$internal
  @override
  $ProviderElement<GuideFiles> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GuideFiles create(Ref ref) {
    return guideFiles(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GuideFiles value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GuideFiles>(value),
    );
  }
}

String _$guideFilesHash() => r'311c8c4e195aaa09fc6cbed4b590d41fdcd9527a';

/// Which guides the user may see. Starts from the stored answer (works
/// offline); [refresh] asks the API — after every sync, since the unlocks
/// follow the routines the SERVER has.

@ProviderFor(GuidesController)
final guidesControllerProvider = GuidesControllerProvider._();

/// Which guides the user may see. Starts from the stored answer (works
/// offline); [refresh] asks the API — after every sync, since the unlocks
/// follow the routines the SERVER has.
final class GuidesControllerProvider
    extends $AsyncNotifierProvider<GuidesController, GuideAccess> {
  /// Which guides the user may see. Starts from the stored answer (works
  /// offline); [refresh] asks the API — after every sync, since the unlocks
  /// follow the routines the SERVER has.
  GuidesControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'guidesControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$guidesControllerHash();

  @$internal
  @override
  GuidesController create() => GuidesController();
}

String _$guidesControllerHash() => r'2ba80f19b42b4b13cf65c1f32c0cfab4246f4861';

/// Which guides the user may see. Starts from the stored answer (works
/// offline); [refresh] asks the API — after every sync, since the unlocks
/// follow the routines the SERVER has.

abstract class _$GuidesController extends $AsyncNotifier<GuideAccess> {
  FutureOr<GuideAccess> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<GuideAccess>, GuideAccess>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<GuideAccess>, GuideAccess>,
              AsyncValue<GuideAccess>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(guideStatus)
final guideStatusProvider = GuideStatusFamily._();

final class GuideStatusProvider
    extends $FunctionalProvider<GuideStatus, GuideStatus, GuideStatus>
    with $Provider<GuideStatus> {
  GuideStatusProvider._({
    required GuideStatusFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'guideStatusProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$guideStatusHash();

  @override
  String toString() {
    return r'guideStatusProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<GuideStatus> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GuideStatus create(Ref ref) {
    final argument = this.argument as String;
    return guideStatus(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GuideStatus value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GuideStatus>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is GuideStatusProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$guideStatusHash() => r'096f295f8242e245611e03d471a34c55cbd15a9c';

final class GuideStatusFamily extends $Family
    with $FunctionalFamilyOverride<GuideStatus, String> {
  GuideStatusFamily._()
    : super(
        retry: null,
        name: r'guideStatusProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  GuideStatusProvider call(String exerciseId) =>
      GuideStatusProvider._(argument: exerciseId, from: this);

  @override
  String toString() => r'guideStatusProvider';
}

/// A session without a routine: besides what the routines unlock, the API
/// unlocks its first N guided exercises (`exerciseIds` comma-joined, in the
/// order they were added). Offline: the stored access only.

@ProviderFor(sessionGuides)
final sessionGuidesProvider = SessionGuidesFamily._();

/// A session without a routine: besides what the routines unlock, the API
/// unlocks its first N guided exercises (`exerciseIds` comma-joined, in the
/// order they were added). Offline: the stored access only.

final class SessionGuidesProvider
    extends
        $FunctionalProvider<
          AsyncValue<GuideAccess>,
          GuideAccess,
          FutureOr<GuideAccess>
        >
    with $FutureModifier<GuideAccess>, $FutureProvider<GuideAccess> {
  /// A session without a routine: besides what the routines unlock, the API
  /// unlocks its first N guided exercises (`exerciseIds` comma-joined, in the
  /// order they were added). Offline: the stored access only.
  SessionGuidesProvider._({
    required SessionGuidesFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'sessionGuidesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$sessionGuidesHash();

  @override
  String toString() {
    return r'sessionGuidesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<GuideAccess> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<GuideAccess> create(Ref ref) {
    final argument = this.argument as String;
    return sessionGuides(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is SessionGuidesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$sessionGuidesHash() => r'470396493f938d59e8f6d1e961dfb364a60a770d';

/// A session without a routine: besides what the routines unlock, the API
/// unlocks its first N guided exercises (`exerciseIds` comma-joined, in the
/// order they were added). Offline: the stored access only.

final class SessionGuidesFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<GuideAccess>, String> {
  SessionGuidesFamily._()
    : super(
        retry: null,
        name: r'sessionGuidesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// A session without a routine: besides what the routines unlock, the API
  /// unlocks its first N guided exercises (`exerciseIds` comma-joined, in the
  /// order they were added). Offline: the stored access only.

  SessionGuidesProvider call(String exerciseIds) =>
      SessionGuidesProvider._(argument: exerciseIds, from: this);

  @override
  String toString() => r'sessionGuidesProvider';
}

/// The local copy of a guide file, downloaded if needed (`null` = offline).

@ProviderFor(guideFile)
final guideFileProvider = GuideFileFamily._();

/// The local copy of a guide file, downloaded if needed (`null` = offline).

final class GuideFileProvider
    extends $FunctionalProvider<AsyncValue<File?>, File?, FutureOr<File?>>
    with $FutureModifier<File?>, $FutureProvider<File?> {
  /// The local copy of a guide file, downloaded if needed (`null` = offline).
  GuideFileProvider._({
    required GuideFileFamily super.from,
    required GuideSource super.argument,
  }) : super(
         retry: null,
         name: r'guideFileProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$guideFileHash();

  @override
  String toString() {
    return r'guideFileProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<File?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<File?> create(Ref ref) {
    final argument = this.argument as GuideSource;
    return guideFile(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is GuideFileProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$guideFileHash() => r'16b4d70ed174dff019d4f75887e6c134b5c1379a';

/// The local copy of a guide file, downloaded if needed (`null` = offline).

final class GuideFileFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<File?>, GuideSource> {
  GuideFileFamily._()
    : super(
        retry: null,
        name: r'guideFileProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// The local copy of a guide file, downloaded if needed (`null` = offline).

  GuideFileProvider call(GuideSource source) =>
      GuideFileProvider._(argument: source, from: this);

  @override
  String toString() => r'guideFileProvider';
}
