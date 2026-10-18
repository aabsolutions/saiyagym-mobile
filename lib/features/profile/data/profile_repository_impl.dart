import 'package:dio/dio.dart';
import 'package:saiyagym_mobile/core/network/api_exception.dart';
import 'package:saiyagym_mobile/core/units/unit_formatter.dart';
import 'package:saiyagym_mobile/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:saiyagym_mobile/features/auth/data/models/me_model.dart';
import 'package:saiyagym_mobile/features/auth/domain/entities/user.dart';
import 'package:saiyagym_mobile/features/profile/domain/profile_repository.dart';

class ProfileRemoteDataSource {
  const ProfileRemoteDataSource(this._dio);

  final Dio _dio;

  /// `PATCH /users/me` with an `UpdatePreferencesDto`.
  Future<MeModel> updatePreferences(Map<String, Object> preferences) =>
      guardApi(() async {
        final response = await _dio.patch<Map<String, dynamic>>(
          '/users/me',
          data: {'preferences': preferences},
        );
        return MeModel.fromJson(response.data!);
      });
}

class ProfileRepositoryImpl implements ProfileRepository {
  const ProfileRepositoryImpl({required this._remote, required this._local});

  final ProfileRemoteDataSource _remote;
  final AuthLocalDataSource _local;

  @override
  Future<User> updatePreferences({
    UnitSystem? units,
    ThemePreference? theme,
    String? language,
  }) async {
    final me = await _remote.updatePreferences({
      'units': ?units?.name,
      'theme': ?theme?.name,
      'language': ?language,
    });
    await _local.cacheUser(me);
    return me.toEntity();
  }
}
