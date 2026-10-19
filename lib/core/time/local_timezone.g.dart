// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_timezone.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The device's IANA timezone (`Europe/Madrid`), for the API's `tz`
/// parameter and local reminders. `UTC` when the platform can't tell.

@ProviderFor(localTimezone)
final localTimezoneProvider = LocalTimezoneProvider._();

/// The device's IANA timezone (`Europe/Madrid`), for the API's `tz`
/// parameter and local reminders. `UTC` when the platform can't tell.

final class LocalTimezoneProvider
    extends $FunctionalProvider<AsyncValue<String>, String, FutureOr<String>>
    with $FutureModifier<String>, $FutureProvider<String> {
  /// The device's IANA timezone (`Europe/Madrid`), for the API's `tz`
  /// parameter and local reminders. `UTC` when the platform can't tell.
  LocalTimezoneProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'localTimezoneProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$localTimezoneHash();

  @$internal
  @override
  $FutureProviderElement<String> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<String> create(Ref ref) {
    return localTimezone(ref);
  }
}

String _$localTimezoneHash() => r'56070959e9c0f6537380a9f26be32df397922d2e';
