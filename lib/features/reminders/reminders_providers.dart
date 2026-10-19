import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:saiyagym_mobile/core/database/database_provider.dart';
import 'package:saiyagym_mobile/core/time/local_timezone.dart';
import 'package:saiyagym_mobile/features/reminders/data/reminder_scheduler.dart';
import 'package:saiyagym_mobile/features/reminders/domain/reminder_settings.dart';

part 'reminders_providers.g.dart';

@Riverpod(keepAlive: true)
ReminderScheduler reminderScheduler(Ref ref) => LocalReminderScheduler(
  timezone: () => ref.read(localTimezoneProvider.future),
);

@Riverpod(keepAlive: true)
class RemindersController extends _$RemindersController {
  @override
  Future<ReminderSettings> build() =>
      ReminderSettingsStore(ref.watch(appDatabaseProvider)).read();

  /// Saves and reschedules. Turning a reminder ON asks for the
  /// notification permission first; false = refused (nothing changes).
  Future<bool> save(ReminderSettings next, ReminderTexts texts) async {
    final current = await future;
    final turningOn =
        (next.trainingEnabled && !current.trainingEnabled) ||
        (next.weighInEnabled && !current.weighInEnabled);
    final scheduler = ref.read(reminderSchedulerProvider);
    if (turningOn && !await scheduler.requestPermission()) return false;
    state = AsyncData(next);
    await ReminderSettingsStore(ref.read(appDatabaseProvider)).write(next);
    await scheduler.apply(next, texts);
    return true;
  }

  /// Nothing may stay scheduled once the settings are gone (logout wipes
  /// the local data).
  Future<void> cancelIfWiped() async {
    final store = ReminderSettingsStore(ref.read(appDatabaseProvider));
    if (await store.exists()) return;
    state = const AsyncData(ReminderSettings());
    await ref.read(reminderSchedulerProvider).cancelAll();
  }

  Future<void> markWeighInOffered() async {
    final next = (await future).copyWith(weighInOffered: true);
    state = AsyncData(next);
    await ReminderSettingsStore(ref.read(appDatabaseProvider)).write(next);
  }
}
