// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unsynced_changes.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(unsyncedChanges)
final unsyncedChangesProvider = UnsyncedChangesProvider._();

final class UnsyncedChangesProvider
    extends
        $FunctionalProvider<UnsyncedChanges, UnsyncedChanges, UnsyncedChanges>
    with $Provider<UnsyncedChanges> {
  UnsyncedChangesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'unsyncedChangesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$unsyncedChangesHash();

  @$internal
  @override
  $ProviderElement<UnsyncedChanges> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  UnsyncedChanges create(Ref ref) {
    return unsyncedChanges(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UnsyncedChanges value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UnsyncedChanges>(value),
    );
  }
}

String _$unsyncedChangesHash() => r'b9f6b5b4a96e60a93a8d396d68844649a4e25f93';
