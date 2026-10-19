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

String _$reminderSchedulerHash() => r'd9b7daac8b42435862688dd5d37e58ca5896aee0';

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
    r'e0825c53f76b6b17e3a24978ae82af7e1f3dfbc2';

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
