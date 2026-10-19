// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'live_workout_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The session being logged (`null` = none). Every change is written to
/// Drift right away: killing the app loses nothing.

@ProviderFor(LiveWorkoutController)
final liveWorkoutControllerProvider = LiveWorkoutControllerProvider._();

/// The session being logged (`null` = none). Every change is written to
/// Drift right away: killing the app loses nothing.
final class LiveWorkoutControllerProvider
    extends $NotifierProvider<LiveWorkoutController, LiveSession?> {
  /// The session being logged (`null` = none). Every change is written to
  /// Drift right away: killing the app loses nothing.
  LiveWorkoutControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'liveWorkoutControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$liveWorkoutControllerHash();

  @$internal
  @override
  LiveWorkoutController create() => LiveWorkoutController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LiveSession? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LiveSession?>(value),
    );
  }
}

String _$liveWorkoutControllerHash() =>
    r'ae7b47f9f359f96ff7e06036f6b7d4848e545f10';

/// The session being logged (`null` = none). Every change is written to
/// Drift right away: killing the app loses nothing.

abstract class _$LiveWorkoutController extends $Notifier<LiveSession?> {
  LiveSession? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<LiveSession?, LiveSession?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<LiveSession?, LiveSession?>,
              LiveSession?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
