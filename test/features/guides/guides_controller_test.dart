import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saiyagym_mobile/core/cache/json_cache.dart';
import 'package:saiyagym_mobile/core/network/api_exception.dart';
import 'package:saiyagym_mobile/features/auth/presentation/controllers/session_controller.dart';
import 'package:saiyagym_mobile/features/guides/data/guide_files.dart';
import 'package:saiyagym_mobile/features/guides/data/guides_api.dart';
import 'package:saiyagym_mobile/features/guides/domain/exercise_guide.dart';
import 'package:saiyagym_mobile/features/guides/guides_providers.dart';
import 'package:saiyagym_mobile/features/routines/domain/routine.dart';
import 'package:saiyagym_mobile/features/routines/routines_providers.dart';

import '../../helpers/fixtures.dart';
import 'exercise_guide_test.dart' show guideJson;

class _FakeApi implements GuidesApi {
  GuideAccess? stored;
  GuideAccess remote = GuideAccess.empty;
  bool online = true;
  int fetches = 0;
  final resolved = <List<String>>[];

  @override
  Future<Cached<GuideAccess>?> cached() async =>
      stored == null ? null : Cached(stored!, fetchedAt: DateTime.utc(2026));

  @override
  Future<Cached<GuideAccess>> fetch() async {
    fetches++;
    if (!online) {
      const error = ApiException(code: ApiException.networkError);
      if (stored == null) throw error;
      return Cached(stored!, fetchedAt: DateTime.utc(2026), error: error);
    }
    stored = remote;
    return Cached(remote, fetchedAt: DateTime.utc(2026));
  }

  @override
  Future<GuideAccess> resolve(List<String> exerciseIds) async {
    resolved.add(exerciseIds);
    if (!online) throw const ApiException(code: ApiException.networkError);
    return GuideAccess.fromJson({
      'items': [
        {
          'exerciseId': exerciseIds.first,
          'guides': [guideJson('s1')],
        },
      ],
    });
  }
}

class _FakeFiles implements GuideFiles {
  final log = <String>[];
  List<String> retained = [];
  List<String> prefetched = [];

  @override
  Future<void> purgeIfWiped() async => log.add('purge');

  @override
  Future<void> retain(Iterable<GuideSource> sources) async {
    log.add('retain');
    retained = [for (final s in sources) s.id];
  }

  @override
  Future<void> prefetch(Iterable<GuideSource> sources) async {
    log.add('prefetch');
    prefetched = [for (final s in sources) s.id];
  }

  @override
  Future<File?> ensure(GuideSource source) async => null;

  @override
  Future<File?> local(GuideSource source) async => null;
}

class _FakeRoutines implements RoutinesRepository {
  List<Routine> routines = [];

  @override
  Future<List<Routine>> active() async => routines;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

GuideAccess _access(
  Map<String, List<String>> unlocked, {
  List<String> locked = const [],
}) => GuideAccess.fromJson({
  'guidesPerRoutine': 5,
  'items': [
    for (final MapEntry(:key, :value) in unlocked.entries)
      {
        'exerciseId': key,
        'guides': [for (final id in value) guideJson(id)],
      },
  ],
  'lockedExerciseIds': locked,
});

void main() {
  late _FakeApi api;
  late _FakeFiles files;
  late _FakeRoutines routines;
  late ProviderContainer container;

  setUp(() {
    api = _FakeApi();
    files = _FakeFiles();
    routines = _FakeRoutines();
    container = ProviderContainer(
      overrides: [
        guidesApiProvider.overrideWithValue(api),
        guideFilesProvider.overrideWithValue(files),
        routinesRepositoryProvider.overrideWithValue(routines),
        currentUserProvider.overrideWithValue(testUser()),
      ],
    );
    addTearDown(container.dispose);
  });

  GuidesController controller() =>
      container.read(guidesControllerProvider.notifier);

  test('starts from the stored answer, without the network', () async {
    api.stored = _access({
      'squat': ['g1'],
    });
    final access = await container.read(guidesControllerProvider.future);
    expect(access.statusOf('squat'), isA<GuideUnlocked>());
    expect(api.fetches, 0);
  });

  test(
    'refresh: purge, keep only unlocked files, prefetch the routines',
    () async {
      api.remote = _access(
        {
          'squat': ['g1', 'g2'],
          'bench': ['g3'],
        },
        locked: ['row'],
      );
      routines.routines = [
        const Routine(
          id: 'r1',
          name: 'Legs',
          exercises: [RoutineExercise(id: 's1', exerciseId: 'squat')],
        ),
      ];
      await container.read(guidesControllerProvider.future);

      await controller().refresh();

      expect(files.log, ['purge', 'retain', 'prefetch']);
      expect(files.retained, ['g1', 'g2', 'g3']);
      // Premium-sized catalogs aren't downloaded whole: only what is planned.
      expect(files.prefetched, ['g1', 'g2']);
      final access = container.read(guidesControllerProvider).value!;
      expect(access.statusOf('row'), isA<GuideLocked>());
    },
  );

  test('offline: shows the stored answer and leaves the files alone', () async {
    api
      ..stored = _access({
        'squat': ['g1'],
      })
      ..online = false;
    await container.read(guidesControllerProvider.future);

    await controller().refresh();

    expect(files.log, ['purge']);
    expect(
      container.read(guidesControllerProvider).value!.statusOf('squat'),
      isA<GuideUnlocked>(),
    );
  });

  test('calls while refreshing coalesce into one more run', () async {
    await container.read(guidesControllerProvider.future);
    await Future.wait([
      controller().refresh(),
      controller().refresh(),
      controller().refresh(),
    ]);
    expect(api.fetches, 2);
  });

  test(
    'session without a routine: resolve, or the stored access offline',
    () async {
      api.stored = _access({}, locked: ['curl']);
      await container.read(guidesControllerProvider.future);

      final session = await container.read(
        sessionGuidesProvider('curl,row').future,
      );
      expect(api.resolved.single, ['curl', 'row']);
      expect(session.statusOf('curl'), isA<GuideUnlocked>());

      api.online = false;
      final offline = await container.read(
        sessionGuidesProvider('curl').future,
      );
      expect(offline.statusOf('curl'), isA<GuideLocked>());
    },
  );
}
