import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:saiyagym_mobile/core/database/database_provider.dart';
import 'package:saiyagym_mobile/core/network/api_client.dart';
import 'package:saiyagym_mobile/core/storage/token_storage.dart';
import 'package:saiyagym_mobile/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:saiyagym_mobile/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:saiyagym_mobile/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:saiyagym_mobile/features/auth/domain/repositories/auth_repository.dart';
import 'package:saiyagym_mobile/features/auth/domain/usecases/auth_use_cases.dart';

part 'auth_providers.g.dart';

// Composition root of the feature: the only place that knows which
// implementation backs each port.

@Riverpod(keepAlive: true)
AuthLocalDataSource authLocalDataSource(Ref ref) =>
    AuthLocalDataSource(ref.watch(appDatabaseProvider));

@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) => AuthRepositoryImpl(
  remote: AuthRemoteDataSource(ref.watch(apiClientProvider)),
  local: ref.watch(authLocalDataSourceProvider),
  tokens: ref.watch(tokenStorageProvider),
);

@riverpod
LoginUseCase loginUseCase(Ref ref) =>
    LoginUseCase(ref.watch(authRepositoryProvider));

@riverpod
RegisterUseCase registerUseCase(Ref ref) =>
    RegisterUseCase(ref.watch(authRepositoryProvider));

@riverpod
RequestPasswordResetUseCase requestPasswordResetUseCase(Ref ref) =>
    RequestPasswordResetUseCase(ref.watch(authRepositoryProvider));

@Riverpod(keepAlive: true)
RestoreSessionUseCase restoreSessionUseCase(Ref ref) =>
    RestoreSessionUseCase(ref.watch(authRepositoryProvider));

@Riverpod(keepAlive: true)
LogoutUseCase logoutUseCase(Ref ref) =>
    LogoutUseCase(ref.watch(authRepositoryProvider));
