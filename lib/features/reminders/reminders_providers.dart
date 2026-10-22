import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:saiyagym_mobile/core/database/database_provider.dart';
import 'package:saiyagym_mobile/core/notifications/notification_channels.dart';
import 'package:saiyagym_mobile/core/time/local_timezone.dart';
import 'package:saiyagym_mobile/features/reminders/data/reminder_scheduler.dart';
import 'package:saiyagym_mobile/features/reminders/domain/reminder_settings.dart';
import 'package:saiyagym_mobile/features/sounds/domain/sound_purpose.dart';
import 'package:saiyagym_mobile/features/sounds/sounds_providers.dart';

part 'reminders_providers.g.dart';

@Riverpod(keepAlive: true)
ReminderScheduler reminderScheduler(Ref ref) => LocalReminderScheduler(
  timezone: () => ref.read(localTimezoneProvider.future),
  platform: ref.watch(alarmSoundPlatformProvider),
  channels: ref.watch(notificationChannelsProvider),
);

/// The sounds the user chose for the training and weigh-in reminders, when
/// they are installed on this device (`null` = default sound). Changes when
/// a choice changes or its download finishes.
@Riverpod(keepAlive: true)
Future<ReminderSounds> reminderSounds(Ref ref) async {
  final training = ref.watch(
    installedAlarmSoundProvider(SoundPurpose.trainingReminder).future,
  );
  final weighIn = ref.watch(
    installedAlarmSoundProvider(SoundPurpose.weighIn).future,
  );
  return ReminderSounds(training: await training, weighIn: await weighIn);
}

@Riverpod(keepAlive: true)
class RemindersController extends _$RemindersController {
  /// Signature of the sounds the schedule was last built with; `null` until
  /// the first apply of this run, so the first value at app start reapplies
  /// once (R4-S5: a sound lost / downgraded while the app was closed).
  String? _lastApplied;
  Future<void> _queue = Future.value();

  @override
  Future<ReminderSettings> build() =>
      ReminderSettingsStore(ref.watch(appDatabaseProvider)).read();

  /// The sounds the reminders use changed (a choice, a finished download, a
  /// sound lost while the app was closed): reapply the schedule. Driven by
  /// the always-listened `SyncCoordinator`: a `ref.listen` inside this
  /// notifier would be paused while nobody watches it. Same sounds as the
  /// last apply = nothing to do, so a reapply never retriggers itself.
  Future<void> soundsChanged(ReminderSounds sounds) async {
    if (sounds.signature == _lastApplied) return;
    await reapply();
  }

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
    final db = ref.read(appDatabaseProvider);
    await ReminderSettingsStore(db).write(next);
    // Cached so a later sound change can reapply without a BuildContext.
    await ReminderTextsStore(db).write(texts);
    await reapply();
    return true;
  }

  /// Schedules the stored settings again with the stored texts and the
  /// current sounds. Without cached texts (never saved) there is nothing to
  /// schedule: only stale sound channels are pruned. Serialized.
  Future<void> reapply() {
    final run = _queue.then((_) => _reapply());
    _queue = run.catchError((Object _) {});
    return run;
  }

  Future<void> _reapply() async {
    final db = ref.read(appDatabaseProvider);
    final scheduler = ref.read(reminderSchedulerProvider);
    final sounds = await _currentSounds();
    _lastApplied = sounds.signature;
    final texts = await ReminderTextsStore(db).read();
    if (texts == null) {
      await scheduler.pruneChannels(sounds: sounds);
      return;
    }
    await scheduler.apply(
      await ReminderSettingsStore(db).read(),
      texts,
      sounds: sounds,
    );
  }

  /// A failing lookup must never block a reminder: default sound then.
  Future<ReminderSounds> _currentSounds() async {
    try {
      return await ref.read(reminderSoundsProvider.future);
    } on Object {
      return const ReminderSounds();
    }
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
