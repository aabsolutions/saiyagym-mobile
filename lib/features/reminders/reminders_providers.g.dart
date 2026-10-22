// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reminders_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(reminderScheduler)
final reminderSchedulerProvider = ReminderSchedulerProvider._();

final class ReminderSchedulerProvider
    extends
        $FunctionalProvider<
          ReminderScheduler,
          ReminderScheduler,
          ReminderScheduler
        >
    with $Provider<ReminderScheduler> {
  ReminderSchedulerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'reminderSchedulerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$reminderSchedulerHash();

  @$internal
  @override
  $ProviderElement<ReminderScheduler> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ReminderScheduler create(Ref ref) {
    return reminderScheduler(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ReminderScheduler value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ReminderScheduler>(value),
    );
  }
}

String _$reminderSchedulerHash() => r'21cb9bc0b12b885cf18cff79165cb6e791ff082a';

/// The sounds the user chose for the training and weigh-in reminders, when
/// they are installed on this device (`null` = default sound). Changes when
/// a choice changes or its download finishes.

@ProviderFor(reminderSounds)
final reminderSoundsProvider = ReminderSoundsProvider._();

/// The sounds the user chose for the training and weigh-in reminders, when
/// they are installed on this device (`null` = default sound). Changes when
/// a choice changes or its download finishes.

final class ReminderSoundsProvider
    extends
        $FunctionalProvider<
          AsyncValue<ReminderSounds>,
          ReminderSounds,
          FutureOr<ReminderSounds>
        >
    with $FutureModifier<ReminderSounds>, $FutureProvider<ReminderSounds> {
  /// The sounds the user chose for the training and weigh-in reminders, when
  /// they are installed on this device (`null` = default sound). Changes when
  /// a choice changes or its download finishes.
  ReminderSoundsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'reminderSoundsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$reminderSoundsHash();

  @$internal
  @override
  $FutureProviderElement<ReminderSounds> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<ReminderSounds> create(Ref ref) {
    return reminderSounds(ref);
  }
}

String _$reminderSoundsHash() => r'd53f2a657256ab6c2599c6fa2a04ddffb4351af1';

@ProviderFor(RemindersController)
final remindersControllerProvider = RemindersControllerProvider._();

final class RemindersControllerProvider
    extends $AsyncNotifierProvider<RemindersController, ReminderSettings> {
  RemindersControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'remindersControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$remindersControllerHash();

  @$internal
  @override
  RemindersController create() => RemindersController();
}

String _$remindersControllerHash() =>
    r'2ecb7c476b43a4f58211e2af72a6260719957a7e';

abstract class _$RemindersController extends $AsyncNotifier<ReminderSettings> {
  FutureOr<ReminderSettings> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<ReminderSettings>, ReminderSettings>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<ReminderSettings>, ReminderSettings>,
              AsyncValue<ReminderSettings>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
