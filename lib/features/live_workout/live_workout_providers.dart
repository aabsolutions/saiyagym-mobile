import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:saiyagym_mobile/core/database/database_provider.dart';
import 'package:saiyagym_mobile/core/network/api_client.dart';
import 'package:saiyagym_mobile/core/sync/sync_providers.dart';
import 'package:saiyagym_mobile/features/live_workout/data/device_services.dart';
import 'package:saiyagym_mobile/features/live_workout/data/start_plans.dart';
import 'package:saiyagym_mobile/features/live_workout/data/training_settings.dart';
import 'package:saiyagym_mobile/features/profile/presentation/preferences_providers.dart';
import 'package:saiyagym_mobile/features/records/data/records_service.dart';

part 'live_workout_providers.g.dart';

@Riverpod(keepAlive: true)
RestAlarm restAlarm(Ref ref) => NotificationRestAlarm();

@Riverpod(keepAlive: true)
ScreenAwake screenAwake(Ref ref) => WakelockScreenAwake();

@Riverpod(keepAlive: true)
Haptics haptics(Ref ref) => SystemHaptics();

@riverpod
TodayPlanService todayPlanService(Ref ref) => TodayPlanService(
  dio: ref.watch(apiClientProvider),
  stores: ref.watch(syncStoresProvider),
);

/// Today's program day (API, or local when offline).
@riverpod
Future<TodayPlan> todayPlan(Ref ref) =>
    ref.watch(todayPlanServiceProvider).today();

/// The "resume your session?" prompt is shown once per app run.
@Riverpod(keepAlive: true)
class ResumeOffered extends _$ResumeOffered {
  @override
  bool build() => false;

  void markOffered() => state = true;
}

@riverpod
RecordsConfirmer recordsConfirmer(Ref ref) =>
    RecordsConfirmer(ref.watch(apiClientProvider));

/// Plates and screen-on, stored on this device.
@Riverpod(keepAlive: true)
class TrainingSettingsController extends _$TrainingSettingsController {
  @override
  Future<TrainingSettings> build() =>
      TrainingSettingsStore(ref.watch(appDatabaseProvider))
          .read(ref.watch(unitSystemProvider));

  Future<void> save(TrainingSettings settings) async {
    state = AsyncData(settings);
    await TrainingSettingsStore(ref.read(appDatabaseProvider)).write(settings);
  }
}
