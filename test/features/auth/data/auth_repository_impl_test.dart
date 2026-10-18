import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:saiyagym_mobile/core/database/app_database.dart';
import 'package:saiyagym_mobile/core/network/api_exception.dart';
import 'package:saiyagym_mobile/core/storage/token_storage.dart';
import 'package:saiyagym_mobile/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:saiyagym_mobile/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:saiyagym_mobile/features/auth/data/repositories/auth_repository_impl.dart';

import '../../../helpers/fixtures.dart';
import '../../../helpers/in_memory_token_storage.dart';

class _MockRemote extends Mock implements AuthRemoteDataSource;

void main() {
  const tokens = AuthTokens(accessToken: 'a', refreshToken: 'r');

  late AppDatabase database;
  late AuthLocalDataSource local;
  late _MockRemote remote;
  late InMemoryTokenStorage storage;
  late AuthRepositoryImpl repository;

  setUp(() {
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
    database = AppDatabase(NativeDatabase.memory());
    local = AuthLocalDataSource(database);
    remote = _MockRemote();
    storage = InMemoryTokenStorage(tokens);
    repository = AuthRepositoryImpl(
      remote: remote,
      local: local,
      tokens: storage,
    );
  });

  tearDown(() => database.close());

  group('restoreSession', () {
    test('without tokens is signed out and never calls the API', () async {
      await storage.clear();

      expect(await repository.restoreSession(), isNull);
      verifyNever(() => remote.me());
    });

    test('online: fetches /users/me and caches it', () async {
      when(() => remote.me()).thenAnswer((_) async => meModel());

      final user = await repository.restoreSession();

      expect(user, testUser());
      expect(await local.readUser(), meModel());
    });

    test('offline: opens with the cached user', () async {
      await local.cacheUser(meModel(email: 'cached@example.com'));
      when(() => remote.me())
          .thenThrow(const ApiException(code: ApiException.networkError));

      final user = await repository.restoreSession();

      expect(user?.email, 'cached@example.com');
      expect(await storage.read(), isNotNull);
    });

    test('unauthorized: clears the whole local session', () async {
      await local.cacheUser(meModel());
      when(() => remote.me()).thenThrow(
        const ApiException(code: ApiException.unauthorized, statusCode: 401),
      );

      expect(await repository.restoreSession(), isNull);
      expect(await storage.read(), isNull);
      expect(await local.readUser(), isNull);
    });
  });

  test('logout offline still signs out locally', () async {
    await local.cacheUser(meModel());
    when(() => remote.logout(any()))
        .thenThrow(const ApiException(code: ApiException.networkError));

    await repository.logout();

    verify(() => remote.logout('r')).called(1);
    expect(await storage.read(), isNull);
    expect(await local.readUser(), isNull);
  });
}
