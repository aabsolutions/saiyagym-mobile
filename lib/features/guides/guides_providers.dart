import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:saiyagym_mobile/core/cache/json_cache.dart';
import 'package:saiyagym_mobile/core/database/database_provider.dart';
import 'package:saiyagym_mobile/core/network/api_client.dart';
import 'package:saiyagym_mobile/core/network/api_exception.dart';
import 'package:saiyagym_mobile/features/auth/presentation/controllers/session_controller.dart';
import 'package:saiyagym_mobile/features/guides/data/guide_files.dart';
import 'package:saiyagym_mobile/features/guides/data/guides_api.dart';
import 'package:saiyagym_mobile/features/guides/domain/exercise_guide.dart';
import 'package:saiyagym_mobile/features/progress_photos/progress_photos_providers.dart';
import 'package:saiyagym_mobile/features/routines/routines_providers.dart';

part 'guides_providers.g.dart';

@Riverpod(keepAlive: true)
GuidesApi guidesApi(Ref ref) {
  final language = ref.watch(requestLanguageProvider);
  return GuidesApi(
    dio: ref.watch(apiClientProvider),
    cache: JsonCache(ref.watch(appDatabaseProvider)),
    languageCode: () => language.code,
  );
}

@Riverpod(keepAlive: true)
GuideDirectory guideDirectory(Ref ref) => () async {
  final base = await getApplicationSupportDirectory();
  return await Directory('${base.path}${Platform.pathSeparator}exercise_guides')
      .create(recursive: true);
};

/// Downloads go through the plain client (no JWT to Cloudinary).
@Riverpod(keepAlive: true)
GuideFiles guideFiles(Ref ref) => GuideFiles(
  dio: ref.watch(uploadClientProvider),
  db: ref.watch(appDatabaseProvider),
  directory: ref.watch(guideDirectoryProvider),
);

/// Which guides the user may see. Starts from the stored answer (works
/// offline); [refresh] asks the API — after every sync, since the unlocks
/// follow the routines the SERVER has.
@Riverpod(keepAlive: true)
class GuidesController extends _$GuidesController {
  Future<void>? _running;
  bool _again = false;

  @override
  Future<GuideAccess> build() async {
    // Another user / logout: start over from what (still) is stored.
    ref.watch(currentUserProvider.select((user) => user?.id));
    return (await ref.read(guidesApiProvider).cached())?.data ??
        GuideAccess.empty;
  }

  /// Coalesced: a call while one runs makes it run once more afterwards.
  Future<void> refresh() {
    final running = _running;
    if (running != null) {
      _again = true;
      return running;
    }
    return _running = _loop().whenComplete(() => _running = null);
  }

  Future<void> _loop() async {
    do {
      _again = false;
      await _refreshOnce();
    } while (_again && ref.mounted);
  }

  Future<void> _refreshOnce() async {
    if (ref.read(currentUserProvider) == null) return;
    final files = ref.read(guideFilesProvider);
    // Files left by a previous user (logout wiped their marker) go first.
    await files.purgeIfWiped();
    final GuideAccess access;
    try {
      final result = await ref.read(guidesApiProvider).fetch();
      if (!ref.mounted) return;
      state = AsyncData(result.data);
      // Offline: the stored answer is shown; files stay as they are.
      if (result.fromCache) return;
      access = result.data;
    } on ApiException {
      return;
    }
    // Only what is unlocked stays on the device (admin changes, downgrade).
    await files.retain(access.sourcesOf(access.unlocked.keys));
    // Ready for the gym: the guides of the exercises in the routines.
    final routines = await ref.read(routinesRepositoryProvider).active();
    await files.prefetch(
      access.sourcesOf({
        for (final routine in routines)
          for (final exercise in routine.exercises) exercise.exerciseId,
      }),
    );
  }
}

GuideAccess _accessOf(Ref ref) =>
    ref.watch(guidesControllerProvider).value ?? GuideAccess.empty;

@riverpod
GuideStatus guideStatus(Ref ref, String exerciseId) =>
    _accessOf(ref).statusOf(exerciseId);

/// A session without a routine: besides what the routines unlock, the API
/// unlocks its first N guided exercises (`exerciseIds` comma-joined, in the
/// order they were added). Offline: the stored access only.
@riverpod
Future<GuideAccess> sessionGuides(Ref ref, String exerciseIds) async {
  final access = _accessOf(ref);
  final ids = [
    for (final id in exerciseIds.split(','))
      if (id.isNotEmpty) id,
  ].take(maxResolveIds).toList();
  if (ids.isEmpty) return access;
  try {
    return access.merge(await ref.read(guidesApiProvider).resolve(ids));
  } on ApiException {
    return access;
  }
}

/// `POST /guides/resolve` accepts at most this many ids.
const maxResolveIds = 50;

/// The local copy of a guide file, downloaded if needed (`null` = offline).
@riverpod
Future<File?> guideFile(Ref ref, GuideSource source) =>
    ref.read(guideFilesProvider).ensure(source);
