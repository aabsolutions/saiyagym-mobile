import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saiyagym_mobile/core/database/app_database.dart';
import 'package:saiyagym_mobile/core/network/api_client.dart';
import 'package:saiyagym_mobile/core/units/unit_formatter.dart';
import 'package:saiyagym_mobile/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:saiyagym_mobile/features/auth/domain/entities/user.dart';
import 'package:saiyagym_mobile/features/profile/data/profile_repository_impl.dart';
import 'package:saiyagym_mobile/features/profile/domain/profile_repository.dart';
import 'package:uuid/uuid.dart';

import '../../helpers/fake_http_adapter.dart';
import '../../helpers/fixtures.dart';
import '../../helpers/in_memory_token_storage.dart';

void main() {
  late AppDatabase database;
  late FakeHttpAdapter api;
  late ProfileRepositoryImpl repository;

  setUp(() {
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
    database = AppDatabase(NativeDatabase.memory());
    api = FakeHttpAdapter((options) async {
      if (options.path == '/users/me') return jsonBody(meJson(), 200);
      return jsonBody(null, 201);
    });
    final dio = buildApiClient(
      baseUrl: 'https://api.test/api/v1',
      storage: InMemoryTokenStorage(),
      languageCode: () => 'es',
      onSessionExpired: () {},
      adapter: api,
    );
    repository = ProfileRepositoryImpl(
      remote: ProfileRemoteDataSource(dio),
      local: AuthLocalDataSource(database),
    );
  });

  tearDown(() => database.close());

  test(
    'PATCH /users/me sends only what changed, dates as YYYY-MM-DD',
    () async {
      await repository.updateMe(
        profile: ProfileUpdate(
          birthDate: DateTime(1994, 5, 9),
          level: TrainingLevel.advanced,
        ),
        preferences: const PreferencesUpdate(units: UnitSystem.imperial),
      );

      final request = api.requests.single;
      expect(request.method, 'PATCH');
      expect(request.data, {
        'profile': {'birthDate': '1994-05-09', 'level': 'advanced'},
        'preferences': {'units': 'imperial'},
      });
    },
  );

  test('the updated user is cached for offline starts', () async {
    await repository.updateMe(
      preferences: const PreferencesUpdate(defaultRestSeconds: 180),
    );

    expect(await AuthLocalDataSource(database).readUser(), meModel());
  });

  test('a weigh-in gets a client UUID (idempotent retries)', () async {
    await repository.recordBodyWeight(80);

    final body = api.requests.single.data as Map<String, dynamic>;
    expect(api.requests.single.path, '/body-metrics');
    expect(body['weightKg'], 80);
    expect(Uuid.isValidUUID(fromString: body['id'] as String), isTrue);
    expect(DateTime.parse(body['measuredAt'] as String).isUtc, isTrue);
  });
}
