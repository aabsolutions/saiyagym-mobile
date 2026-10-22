import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:saiyagym_mobile/core/cache/json_cache.dart';
import 'package:saiyagym_mobile/core/database/database_provider.dart';
import 'package:saiyagym_mobile/core/network/api_client.dart';
import 'package:saiyagym_mobile/core/notifications/notification_channels.dart';
import 'package:saiyagym_mobile/features/auth/domain/entities/user.dart';
import 'package:saiyagym_mobile/features/auth/presentation/controllers/session_controller.dart';
import 'package:saiyagym_mobile/features/profile/domain/profile_repository.dart';
import 'package:saiyagym_mobile/features/profile/presentation/preferences_providers.dart';
import 'package:saiyagym_mobile/features/progress_photos/progress_photos_providers.dart';
import 'package:saiyagym_mobile/features/sounds/data/alarm_sound_platform.dart';
import 'package:saiyagym_mobile/features/sounds/data/sound_cache.dart';
import 'package:saiyagym_mobile/features/sounds/data/sound_preview.dart';
import 'package:saiyagym_mobile/features/sounds/data/sounds_api.dart';
import 'package:saiyagym_mobile/features/sounds/domain/alarm_sound.dart';
import 'package:saiyagym_mobile/features/sounds/domain/rest_sound.dart';
import 'package:saiyagym_mobile/features/sounds/domain/sound_purpose.dart';
import 'package:saiyagym_mobile/features/sounds/domain/sound_repository.dart';

part 'sounds_providers.g.dart';

@Riverpod(keepAlive: true)
AlarmSoundPlatform alarmSoundPlatform(Ref ref) =>
    MethodChannelAlarmSoundPlatform();

@Riverpod(keepAlive: true)
SoundTarget soundTarget(Ref ref) => SoundTarget.current;

/// Android: app support files. iOS: `Library/Sounds`, the only place a
/// notification sound is looked up by file name.
@Riverpod(keepAlive: true)
SoundDirectory soundDirectory(Ref ref) {
  final target = ref.watch(soundTargetProvider);
  return () async {
    final base = target == SoundTarget.ios
        ? await getLibraryDirectory()
        : await getApplicationSupportDirectory();
    final name = target == SoundTarget.ios ? 'Sounds' : 'rest_sounds';
    return await Directory('${base.path}${Platform.pathSeparator}$name')
        .create(recursive: true);
  };
}

@Riverpod(keepAlive: true)
SoundRepository soundRepository(Ref ref) {
  final language = ref.watch(requestLanguageProvider);
  return SoundsApi(
    dio: ref.watch(apiClientProvider),
    cache: JsonCache(ref.watch(appDatabaseProvider)),
    languageCode: () => language.code,
  );
}

/// Downloads go through the plain client (no JWT to Cloudinary).
@Riverpod(keepAlive: true)
SoundCache soundCache(Ref ref) => SoundCache(
  dio: ref.watch(uploadClientProvider),
  db: ref.watch(appDatabaseProvider),
  platform: ref.watch(alarmSoundPlatformProvider),
  target: ref.watch(soundTargetProvider),
  directory: ref.watch(soundDirectoryProvider),
);

@Riverpod(keepAlive: true)
SoundPreview soundPreview(Ref ref) {
  final preview = PlatformSoundPreview(
    cache: ref.watch(soundCacheProvider),
    platform: ref.watch(alarmSoundPlatformProvider),
  );
  ref.onDispose(preview.stop);
  return preview;
}

/// The catalog (cached for offline display).
@riverpod
Future<Cached<List<RestSound>>> restSounds(Ref ref) =>
    ref.watch(soundRepositoryProvider).list();

/// Id of the user's EFFECTIVE sound for [purpose] (the API nulls it when
/// deleted or the plan no longer allows it). Keep-alive: the (keep-alive)
/// reminders depend on it.
@Riverpod(keepAlive: true)
String? selectedSoundId(Ref ref, SoundPurpose purpose) => ref.watch(
  currentUserProvider.select(
    (user) => user == null ? null : purpose.idIn(user.preferences),
  ),
);

/// The sound selected for [purpose] if it is installed on this device right
/// now; never touches the network. `null` = default sound.
@Riverpod(keepAlive: true)
Future<AlarmSound?> installedAlarmSound(Ref ref, SoundPurpose purpose) => ref
    .watch(soundCacheProvider)
    .installed(ref.watch(selectedSoundIdProvider(purpose)));

/// Choosing / clearing the sound of one [purpose] (keep-alive: a download
/// may outlive the sheet that started it). Edits ONLY that purpose's
/// preference; afterwards the device keeps just the sounds some purpose
/// still needs.
@Riverpod(keepAlive: true)
class SoundSelectionController extends _$SoundSelectionController {
  @override
  FutureOr<void> build(SoundPurpose purpose) {}

  /// `PATCH /users/me` first (the API validates plan and existence), then
  /// the file is downloaded and installed. A failed download keeps the
  /// choice: the default sound plays until [ensureSelectedInstalled] manages.
  /// A premium sound the plan lacks is rejected by the API
  /// (PLAN_FEATURE_REQUIRED), never by this client alone.
  Future<void> select(RestSound sound) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final user = await _save(
        PreferencesUpdate(soundIds: {purpose.apiKey: sound.id}),
      );
      final cache = ref.read(soundCacheProvider);
      await cache.ensure(sound);
      await cache.retain(neededSoundIds(user.preferences));
      if (ref.mounted) ref.invalidate(installedAlarmSoundProvider(purpose));
    });
  }

  Future<void> useDefault() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final user = await _save(
        PreferencesUpdate(soundIds: {purpose.apiKey: null}),
      );
      await ref
          .read(soundCacheProvider)
          .retain(neededSoundIds(user.preferences));
      if (ref.mounted) ref.invalidate(installedAlarmSoundProvider(purpose));
    });
  }

  /// Best-effort prefetch of the selected sound (new device, or a download
  /// that failed before). Returns the installed sound, or `null`.
  Future<AlarmSound?> ensureSelectedInstalled() async {
    final user = ref.read(currentUserProvider);
    final id = user == null ? null : purpose.idIn(user.preferences);
    if (id == null) return null;
    final cache = ref.read(soundCacheProvider);
    final current = await cache.installed(id);
    if (current != null) return current;
    try {
      final sounds = (await ref.read(soundRepositoryProvider).list()).data;
      final sound = sounds.where((s) => s.id == id).firstOrNull;
      if (sound == null) return null;
      final installed = await cache.ensure(sound);
      if (ref.mounted) ref.invalidate(installedAlarmSoundProvider(purpose));
      return installed;
    } on Object {
      return null;
    }
  }

  Future<User> _save(PreferencesUpdate update) async {
    final user = await ref.read(updatePreferencesUseCaseProvider)(update);
    if (ref.mounted) {
      ref.read(sessionControllerProvider.notifier).userUpdated(user);
    }
    return user;
  }
}

/// Device-wide upkeep of the installed sounds (keep-alive, no state).
@Riverpod(keepAlive: true)
SoundHousekeeping soundHousekeeping(Ref ref) => SoundHousekeeping(ref);

class SoundHousekeeping {
  SoundHousekeeping(this._ref);

  final Ref _ref;

  /// Channel prefixes of the sound channels this app creates; the default
  /// ones (`rest_timer`, `reminders`) don't match and stay.
  static const _channelPrefixes = [
    'rest_timer_',
    'reminder_training_',
    'reminder_weighin_',
  ];

  /// Logout / another user signing in wiped `app_meta`: with no record of
  /// installed sounds nothing on the device is valid, so purge it all (OS
  /// copies, downloaded files and the sound channels). A record present
  /// (including an empty one) means the data was not wiped (e.g. an expired
  /// session): keep everything.
  Future<void> purgeIfWiped() async {
    final cache = _ref.read(soundCacheProvider);
    if (await cache.hasRecord()) return;
    await cache.purgeAll();
    final channels = _ref.read(notificationChannelsProvider);
    final existing = await channels.ids();
    for (final prefix in _channelPrefixes) {
      for (final id in staleChannels(existing, prefix: prefix, keep: '')) {
        await channels.delete(id);
      }
    }
  }

  /// Drops installed sounds no purpose selects any more (e.g. the API nulled
  /// a deleted sound, or the plan was downgraded).
  Future<void> retainSelected() async {
    final user = _ref.read(currentUserProvider);
    if (user == null) return;
    await _ref
        .read(soundCacheProvider)
        .retain(neededSoundIds(user.preferences));
  }

  /// Best-effort install of the sounds the reminders use (new device).
  Future<void> prefetch() async {
    for (final purpose in const [
      SoundPurpose.trainingReminder,
      SoundPurpose.weighIn,
    ]) {
      await _ref
          .read(soundSelectionControllerProvider(purpose).notifier)
          .ensureSelectedInstalled();
    }
  }
}
