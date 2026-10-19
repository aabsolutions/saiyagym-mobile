// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'progress_photos_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Plain client for Cloudinary: no auth / language interceptors.

@ProviderFor(uploadClient)
final uploadClientProvider = UploadClientProvider._();

/// Plain client for Cloudinary: no auth / language interceptors.

final class UploadClientProvider extends $FunctionalProvider<Dio, Dio, Dio>
    with $Provider<Dio> {
  /// Plain client for Cloudinary: no auth / language interceptors.
  UploadClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'uploadClientProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$uploadClientHash();

  @$internal
  @override
  $ProviderElement<Dio> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Dio create(Ref ref) {
    return uploadClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Dio value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Dio>(value),
    );
  }
}

String _$uploadClientHash() => r'72cc4d7a28f5d444167be15ab2765fc116aa9a30';

@ProviderFor(photoPicker)
final photoPickerProvider = PhotoPickerProvider._();

final class PhotoPickerProvider
    extends $FunctionalProvider<PhotoPicker, PhotoPicker, PhotoPicker>
    with $Provider<PhotoPicker> {
  PhotoPickerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'photoPickerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$photoPickerHash();

  @$internal
  @override
  $ProviderElement<PhotoPicker> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PhotoPicker create(Ref ref) {
    return photoPicker(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PhotoPicker value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PhotoPicker>(value),
    );
  }
}

String _$photoPickerHash() => r'7f2148f1628817aaedcb83b09a14df5f4510e4a0';

@ProviderFor(imageCompressor)
final imageCompressorProvider = ImageCompressorProvider._();

final class ImageCompressorProvider
    extends
        $FunctionalProvider<ImageCompressor, ImageCompressor, ImageCompressor>
    with $Provider<ImageCompressor> {
  ImageCompressorProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'imageCompressorProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$imageCompressorHash();

  @$internal
  @override
  $ProviderElement<ImageCompressor> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ImageCompressor create(Ref ref) {
    return imageCompressor(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ImageCompressor value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ImageCompressor>(value),
    );
  }
}

String _$imageCompressorHash() => r'6ca5e3fcfd4620de1321ede3ab6b41e38afec71f';

@ProviderFor(pendingPhotosDir)
final pendingPhotosDirProvider = PendingPhotosDirProvider._();

final class PendingPhotosDirProvider
    extends
        $FunctionalProvider<
          DirectoryResolver,
          DirectoryResolver,
          DirectoryResolver
        >
    with $Provider<DirectoryResolver> {
  PendingPhotosDirProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pendingPhotosDirProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pendingPhotosDirHash();

  @$internal
  @override
  $ProviderElement<DirectoryResolver> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  DirectoryResolver create(Ref ref) {
    return pendingPhotosDir(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DirectoryResolver value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DirectoryResolver>(value),
    );
  }
}

String _$pendingPhotosDirHash() => r'e29c7944fdfb8b2c371b096bbc3dbf196f0e12cf';

@ProviderFor(progressPhotosApi)
final progressPhotosApiProvider = ProgressPhotosApiProvider._();

final class ProgressPhotosApiProvider
    extends
        $FunctionalProvider<
          ProgressPhotosApi,
          ProgressPhotosApi,
          ProgressPhotosApi
        >
    with $Provider<ProgressPhotosApi> {
  ProgressPhotosApiProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'progressPhotosApiProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$progressPhotosApiHash();

  @$internal
  @override
  $ProviderElement<ProgressPhotosApi> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ProgressPhotosApi create(Ref ref) {
    return progressPhotosApi(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ProgressPhotosApi value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ProgressPhotosApi>(value),
    );
  }
}

String _$progressPhotosApiHash() => r'2cd4ae5f8be56713123084700c76bc27fad295e6';

@ProviderFor(photoUploadQueue)
final photoUploadQueueProvider = PhotoUploadQueueProvider._();

final class PhotoUploadQueueProvider
    extends
        $FunctionalProvider<
          PhotoUploadQueue,
          PhotoUploadQueue,
          PhotoUploadQueue
        >
    with $Provider<PhotoUploadQueue> {
  PhotoUploadQueueProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'photoUploadQueueProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$photoUploadQueueHash();

  @$internal
  @override
  $ProviderElement<PhotoUploadQueue> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PhotoUploadQueue create(Ref ref) {
    return photoUploadQueue(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PhotoUploadQueue value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PhotoUploadQueue>(value),
    );
  }
}

String _$photoUploadQueueHash() => r'ae4d4be9954f8dd5041f41bfd53a75d4b1f2f164';

@ProviderFor(pendingPhotos)
final pendingPhotosProvider = PendingPhotosProvider._();

final class PendingPhotosProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<PendingPhoto>>,
          List<PendingPhoto>,
          Stream<List<PendingPhoto>>
        >
    with
        $FutureModifier<List<PendingPhoto>>,
        $StreamProvider<List<PendingPhoto>> {
  PendingPhotosProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pendingPhotosProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pendingPhotosHash();

  @$internal
  @override
  $StreamProviderElement<List<PendingPhoto>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<PendingPhoto>> create(Ref ref) {
    return pendingPhotos(ref);
  }
}

String _$pendingPhotosHash() => r'c476f761e221dbbb0b1c08a7fe3cfd2a1d4a799b';

@ProviderFor(progressPhotos)
final progressPhotosProvider = ProgressPhotosFamily._();

final class ProgressPhotosProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ProgressPhoto>>,
          List<ProgressPhoto>,
          FutureOr<List<ProgressPhoto>>
        >
    with
        $FutureModifier<List<ProgressPhoto>>,
        $FutureProvider<List<ProgressPhoto>> {
  ProgressPhotosProvider._({
    required ProgressPhotosFamily super.from,
    required PhotoView super.argument,
  }) : super(
         retry: null,
         name: r'progressPhotosProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$progressPhotosHash();

  @override
  String toString() {
    return r'progressPhotosProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<ProgressPhoto>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<ProgressPhoto>> create(Ref ref) {
    final argument = this.argument as PhotoView;
    return progressPhotos(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ProgressPhotosProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$progressPhotosHash() => r'eb890a84a38abce43563b8b102027fdaefcf7e56';

final class ProgressPhotosFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<ProgressPhoto>>, PhotoView> {
  ProgressPhotosFamily._()
    : super(
        retry: null,
        name: r'progressPhotosProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ProgressPhotosProvider call(PhotoView view) =>
      ProgressPhotosProvider._(argument: view, from: this);

  @override
  String toString() => r'progressPhotosProvider';
}

@ProviderFor(photoComparison)
final photoComparisonProvider = PhotoComparisonFamily._();

final class PhotoComparisonProvider
    extends
        $FunctionalProvider<
          AsyncValue<PhotoComparison>,
          PhotoComparison,
          FutureOr<PhotoComparison>
        >
    with $FutureModifier<PhotoComparison>, $FutureProvider<PhotoComparison> {
  PhotoComparisonProvider._({
    required PhotoComparisonFamily super.from,
    required PhotoView super.argument,
  }) : super(
         retry: null,
         name: r'photoComparisonProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$photoComparisonHash();

  @override
  String toString() {
    return r'photoComparisonProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<PhotoComparison> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<PhotoComparison> create(Ref ref) {
    final argument = this.argument as PhotoView;
    return photoComparison(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is PhotoComparisonProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$photoComparisonHash() => r'6b820e9849e26210b3505c3d8e927870fb7a403a';

final class PhotoComparisonFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<PhotoComparison>, PhotoView> {
  PhotoComparisonFamily._()
    : super(
        retry: null,
        name: r'photoComparisonProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  PhotoComparisonProvider call(PhotoView view) =>
      PhotoComparisonProvider._(argument: view, from: this);

  @override
  String toString() => r'photoComparisonProvider';
}
