// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_channels.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(notificationChannels)
final notificationChannelsProvider = NotificationChannelsProvider._();

final class NotificationChannelsProvider
    extends
        $FunctionalProvider<
          NotificationChannels,
          NotificationChannels,
          NotificationChannels
        >
    with $Provider<NotificationChannels> {
  NotificationChannelsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'notificationChannelsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$notificationChannelsHash();

  @$internal
  @override
  $ProviderElement<NotificationChannels> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  NotificationChannels create(Ref ref) {
    return notificationChannels(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NotificationChannels value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NotificationChannels>(value),
    );
  }
}

String _$notificationChannelsHash() =>
    r'8280ae67d40bda0c8874f3ec35c535c8a36e39b1';
