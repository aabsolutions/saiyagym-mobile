import 'package:dio/dio.dart';
import 'package:saiyagym_mobile/core/network/api_exception.dart';
import 'package:saiyagym_mobile/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:saiyagym_mobile/features/auth/data/models/me_model.dart';
import 'package:saiyagym_mobile/features/auth/domain/entities/user.dart';
import 'package:saiyagym_mobile/features/profile/domain/profile_repository.dart';
import 'package:uuid/uuid.dart';

class ProfileRemoteDataSource {
  const ProfileRemoteDataSource(this._dio);

  final Dio _dio;

  /// `PATCH /users/me` with an `UpdateMeDto`.
  Future<MeModel> updateMe(Map<String, Object?> body) => guardApi(() async {
    final response = await _dio.patch<Map<String, dynamic>>(
      '/users/me',
      data: body,
    );
    return MeModel.fromJson(response.data!);
  });

  /// `POST /body-metrics`. The client id makes a retried create idempotent.
  Future<void> createBodyMetric({
    required String id,
    required DateTime measuredAt,
    required double weightKg,
  }) => guardApi(
    () => _dio.post<void>(
      '/body-metrics',
      data: {
        'id': id,
        'measuredAt': measuredAt.toUtc().toIso8601String(),
        'weightKg': weightKg,
      },
    ),
  );
}

class ProfileRepositoryImpl implements ProfileRepository {
  const ProfileRepositoryImpl({
    required this._remote,
    required this._local,
    this._uuid = const Uuid(),
  });

  final ProfileRemoteDataSource _remote;
  final AuthLocalDataSource _local;
  final Uuid _uuid;

  @override
  Future<User> updateMe({
    ProfileUpdate? profile,
    PreferencesUpdate? preferences,
  }) async {
    final me = await _remote.updateMe({
      if (profile != null) 'profile': _profileJson(profile),
      if (preferences != null) 'preferences': _preferencesJson(preferences),
    });
    await _local.cacheUser(me);
    return me.toEntity();
  }

  @override
  Future<void> recordBodyWeight(double weightKg) => _remote.createBodyMetric(
    id: _uuid.v4(),
    measuredAt: DateTime.now(),
    weightKg: weightKg,
  );

  static Map<String, Object> _profileJson(ProfileUpdate profile) => {
    'name': ?profile.name,
    // `UpdateProfileDto.birthDate` is a plain date (YYYY-MM-DD).
    if (profile.birthDate case final date?) 'birthDate': _isoDate(date),
    'sex': ?profile.sex?.name,
    'heightCm': ?profile.heightCm,
    'level': ?profile.level?.name,
    'goal': ?profile.goal?.name,
  };

  static Map<String, Object?> _preferencesJson(PreferencesUpdate preferences) =>
      {
        'units': ?preferences.units?.name,
        'theme': ?preferences.theme?.name,
        'language': ?preferences.language,
        'defaultRestSeconds': ?preferences.defaultRestSeconds,
        // `null` is a real value here: it clears the choice (default sound).
        if (preferences.resetRestSound)
          'restSoundId': null
        else
          'restSoundId': ?preferences.restSoundId,
      };

  static String _isoDate(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-'
      '${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';
}
