import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:saiyagym_mobile/core/database/app_database.dart';
import 'package:saiyagym_mobile/core/network/api_exception.dart';
import 'package:saiyagym_mobile/core/storage/token_storage.dart';
import 'package:saiyagym_mobile/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:saiyagym_mobile/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:saiyagym_mobile/features/auth/data/models/me_model.dart';
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

  void loginReturns(MeModel user) =>
      when(
        () => remote.login(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer(
        (_) async => AuthResponseModel(
          tokens: const AuthTokens(accessToken: 'a2', refreshToken: 'r2'),
          user: user,
        ),
      );

  group('restoreSession', () {
    test('without tokens is signed out and never calls the API', () async {
      await storage.clear();

      expect(await repository.restoreSession(), isNull);
      verifyNever(() => remote.me());
    });

    test('online: fetches /users/me and caches it', () async {
      when(() => remote.me()).thenAnswer((_) async => meModel());

      final session = await repository.restoreSession();

      expect(session?.user, testUser());
      expect(session?.isOffline, isFalse);
      expect(await local.readUser(), meModel());
    });

    test('offline: opens with the last user, flagged offline', () async {
      await local.cacheUser(meModel(email: 'cached@example.com'));
      when(() => remote.me())
          .thenThrow(const ApiException(code: ApiException.networkError));

      final session = await repository.restoreSession();

      expect(session?.user.email, 'cached@example.com');
      expect(session?.isOffline, isTrue);
      expect(await storage.read(), isNotNull);
    });

    test('offline without a local copy cannot open', () async {
      when(() => remote.me())
          .thenThrow(const ApiException(code: ApiException.networkError));

      await expectLater(
        repository.restoreSession(),
        throwsA(isA<ApiException>()),
      );
    });

    test('unauthorized: drops the tokens but keeps local data', () async {
      await local.cacheUser(meModel());
      when(() => remote.me()).thenThrow(
        const ApiException(code: ApiException.unauthorized, statusCode: 401),
      );

      expect(await repository.restoreSession(), isNull);
      expect(await storage.read(), isNull);
      expect(await local.readUser(), meModel());
    });
  });

  group('login', () {
    test('the same user keeps the local data', () async {
      await local.cacheUser(meModel());
      await database.writeMeta('sync.cursor', 'c1');
      loginReturns(meModel());

      await repository.login(email: 'ana@example.com', password: 'x');

      expect(await database.readMeta('sync.cursor'), 'c1');
      expect((await storage.read())!.refreshToken, 'r2');
    });

    test("another user never sees the previous user's data", () async {
      await local.cacheUser(meModel());
      await database.writeMeta('sync.cursor', 'c1');
      loginReturns(meModel(id: 'user-2', email: 'leo@example.com'));

      final user = await repository.login(
        email: 'leo@example.com',
        password: 'x',
      );

      expect(user.id, 'user-2');
      expect(await database.readMeta('sync.cursor'), isNull);
      expect((await local.readUser())?.id, 'user-2');
    });
  });

  test('logout offline still signs out and wipes local data', () async {
    await local.cacheUser(meModel());
    await database.writeMeta('sync.cursor', 'c1');
    when(() => remote.logout(any()))
        .thenThrow(const ApiException(code: ApiException.networkError));

    await repository.logout();

    verify(() => remote.logout('r')).called(1);
    expect(await storage.read(), isNull);
    expect(await local.readUser(), isNull);
    expect(await database.readMeta('sync.cursor'), isNull);
  });

  test('refreshUser updates the local copy', () async {
    when(() => remote.me())
        .thenAnswer((_) async => meModel(emailVerified: false));
    await repository.refreshUser();
    when(() => remote.me()).thenAnswer((_) async => meModel());

    final user = await repository.refreshUser();

    expect(user.emailVerified, isTrue);
    expect((await local.readUser())?.emailVerified, isTrue);
  });
}
