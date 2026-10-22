import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:saiyagym_mobile/core/cache/json_cache.dart';
import 'package:saiyagym_mobile/core/database/database_provider.dart';
import 'package:saiyagym_mobile/core/network/api_client.dart';
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

/// Id of the user's EFFECTIVE sound (the API nulls it when deleted or the
/// plan no longer allows it).
@riverpod
String? selectedRestSoundId(Ref ref) => ref.watch(
  currentUserProvider.select((user) => user?.preferences.restSoundId),
);

/// The selected sound if it is installed on this device right now; never
/// touches the network. `null` = default sound.
@riverpod
Future<AlarmSound?> installedAlarmSound(Ref ref) => ref
    .watch(soundCacheProvider)
    .installed(ref.watch(selectedRestSoundIdProvider));

/// Choosing / clearing the rest sound (keep-alive: a download may outlive
/// the sheet that started it).
@Riverpod(keepAlive: true)
class RestSoundController extends _$RestSoundController {
  @override
  FutureOr<void> build() {}

  /// `PATCH /users/me` first (the API validates plan and existence), then
  /// the file is downloaded and installed. A failed download keeps the
  /// choice: the default sound plays until [ensureSelectedInstalled] manages.
  /// A premium sound the plan lacks is rejected by the API
  /// (PLAN_FEATURE_REQUIRED), never by this client alone.
  Future<void> select(RestSound sound) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await _save(PreferencesUpdate(restSoundId: sound.id));
      await ref.read(soundCacheProvider).ensure(sound);
      ref.invalidate(installedAlarmSoundProvider);
    });
  }

  Future<void> useDefault() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await _save(const PreferencesUpdate(resetRestSound: true));
      await ref.read(soundCacheProvider).clear();
      ref.invalidate(installedAlarmSoundProvider);
    });
  }

  /// Best-effort prefetch of the selected sound (new device, or a download
  /// that failed before). Returns the installed sound, or `null`.
  Future<AlarmSound?> ensureSelectedInstalled() async {
    final id = ref.read(currentUserProvider)?.preferences.restSoundId;
    if (id == null) return null;
    final cache = ref.read(soundCacheProvider);
    final current = await cache.installed(id);
    if (current != null) return current;
    try {
      final sounds = (await ref.read(soundRepositoryProvider).list()).data;
      final sound = sounds.where((s) => s.id == id).firstOrNull;
      if (sound == null) return null;
      final installed = await cache.ensure(sound);
      if (ref.mounted) ref.invalidate(installedAlarmSoundProvider);
      return installed;
    } on Object {
      return null;
    }
  }

  Future<void> _save(PreferencesUpdate update) async {
    final user = await ref.read(updatePreferencesUseCaseProvider)(update);
    if (ref.mounted) {
      ref.read(sessionControllerProvider.notifier).userUpdated(user);
    }
  }
}
