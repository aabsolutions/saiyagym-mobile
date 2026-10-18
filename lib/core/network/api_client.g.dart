// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_client.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(requestLanguage)
final requestLanguageProvider = RequestLanguageProvider._();

final class RequestLanguageProvider
    extends
        $FunctionalProvider<RequestLanguage, RequestLanguage, RequestLanguage>
    with $Provider<RequestLanguage> {
  RequestLanguageProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'requestLanguageProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$requestLanguageHash();

  @$internal
  @override
  $ProviderElement<RequestLanguage> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  RequestLanguage create(Ref ref) {
    return requestLanguage(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RequestLanguage value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RequestLanguage>(value),
    );
  }
}

String _$requestLanguageHash() => r'cb5115c68029dc55cc7ec1c38d72768a807bc1c3';

@ProviderFor(sessionEvents)
final sessionEventsProvider = SessionEventsProvider._();

final class SessionEventsProvider
    extends $FunctionalProvider<SessionEvents, SessionEvents, SessionEvents>
    with $Provider<SessionEvents> {
  SessionEventsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sessionEventsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sessionEventsHash();

  @$internal
  @override
  $ProviderElement<SessionEvents> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SessionEvents create(Ref ref) {
    return sessionEvents(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SessionEvents value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SessionEvents>(value),
    );
  }
}

String _$sessionEventsHash() => r'e11d40f19d2b43c3e06c460fc54ac3882ba22132';

@ProviderFor(apiClient)
final apiClientProvider = ApiClientProvider._();

final class ApiClientProvider extends $FunctionalProvider<Dio, Dio, Dio>
    with $Provider<Dio> {
  ApiClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'apiClientProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$apiClientHash();

  @$internal
  @override
  $ProviderElement<Dio> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Dio create(Ref ref) {
    return apiClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Dio value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Dio>(value),
    );
  }
}

String _$apiClientHash() => r'94d200ece2b6775c01b4c74026fc1ef9b63420d4';
