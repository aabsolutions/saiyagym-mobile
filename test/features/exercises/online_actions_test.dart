import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saiyagym_mobile/core/database/app_database.dart';
import 'package:saiyagym_mobile/core/network/api_client.dart';
import 'package:saiyagym_mobile/core/network/api_exception.dart';
import 'package:saiyagym_mobile/core/storage/token_storage.dart';
import 'package:saiyagym_mobile/core/sync/stores.dart';
import 'package:saiyagym_mobile/core/sync/sync_queue.dart';
import 'package:saiyagym_mobile/core/sync/sync_writer.dart';
import 'package:saiyagym_mobile/features/exercises/data/exercises_repository_impl.dart';
import 'package:saiyagym_mobile/features/exercises/domain/exercise.dart';
import 'package:saiyagym_mobile/features/programs/data/programs_repository_impl.dart';
import 'package:saiyagym_mobile/features/programs/domain/program.dart';

import '../../helpers/fake_http_adapter.dart';
import '../../helpers/in_memory_token_storage.dart';
import '../../helpers/test_infra.dart';

void main() {
  late AppDatabase db;
  late SyncStores stores;
  late FakeHttpAdapter api;
  late Dio dio;
  late ResponseBody Function(RequestOptions options) respond;

  setUp(() {
    respond = (_) => jsonBody(null, 200);
    db = testDatabase();
    stores = SyncStores(db, languageCode: () => 'es');
    api = FakeHttpAdapter((options) async => respond(options));
    dio = buildApiClient(
      baseUrl: 'https://api.test',
      storage: InMemoryTokenStorage(
        const AuthTokens(accessToken: 'a', refreshToken: 'r'),
      ),
      languageCode: () => 'es',
      onSessionExpired: () {},
      adapter: api,
    );
  });

  group('custom exercise', () {
    ExercisesRepositoryImpl repository() => ExercisesRepositoryImpl(
      stores: stores,
      writer: SyncWriter(db, SyncQueueDao(db)),
      languageCode: () => 'es',
      dio: dio,
    );

    const draft = CustomExerciseDraft(
      name: '  Remo Meadows ',
      primaryMuscle: 'lats',
      equipment: 'barbell',
      mechanic: 'compound',
    );

    test('is created through the API and usable right away', () async {
      respond = (options) => jsonBody({
        'id': 'ex-new',
        'name': 'Remo Meadows',
        'primaryMuscle': 'lats',
        'equipment': 'barbell',
        'mechanic': 'compound',
        'isGlobal': false,
        'isCustom': true,
      }, 201);

      final exercise = await repository().createCustom(draft);

      expect(api.requests.single.path, '/exercises');
      expect((api.requests.single.data as Map)['name'], 'Remo Meadows');
      expect(exercise.name, 'Remo Meadows');
      expect(await repository().find('ex-new'), isNotNull);
      // Version 0: the pulled raw document will replace it.
      final stored = await stores.exercises.find('ex-new');
      expect(
        stored!.updatedAt,
        DateTime.fromMillisecondsSinceEpoch(0, isUtc: true),
      );
    });

    test('the plan limit comes back as an upgrade reason', () async {
      respond = (_) => jsonBody({
        'statusCode': 403,
        'code': 'PLAN_LIMIT_REACHED',
        'message': 'Límite',
        'details': {'resource': 'customExercises', 'limit': 10},
      }, 403);

      await expectLater(
        repository().createCustom(draft),
        throwsA(
          isA<ApiException>().having(
            (e) => e.code,
            'code',
            'PLAN_LIMIT_REACHED',
          ),
        ),
      );
      expect(await stores.exercises.active(), isEmpty);
    });
  });

  test('activating a program stores the returned program', () async {
    respond = (options) => jsonBody({
      'id': 'p1',
      'name': 'Bloque',
      'status': 'active',
      'startDate': '2026-10-19',
      'durationWeeks': 4,
      'weeks': <Object>[],
      'updatedAt': '2026-10-19T10:00:00.000Z',
    }, 200);
    final repository = ProgramsRepositoryImpl(stores.programs, dio);

    final program = await repository.activate('p1', startDate: '2026-10-19');

    expect(api.requests.single.path, '/programs/p1/activate');
    expect(api.requests.single.data, {'startDate': '2026-10-19'});
    expect(program.status, ProgramStatus.active);
    expect(
      (await repository.watchAll().first).single.status,
      ProgramStatus.active,
    );
  });
}
