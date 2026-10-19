import 'package:dio/dio.dart';
import 'package:saiyagym_mobile/core/network/api_exception.dart';
import 'package:saiyagym_mobile/core/network/interceptors.dart';
import 'package:saiyagym_mobile/features/auth/data/models/me_model.dart';

class AuthRemoteDataSource {
  const AuthRemoteDataSource(this._dio);

  final Dio _dio;

  static final _public = Options(extra: AuthInterceptor.publicEndpoint);

  Future<AuthResponseModel> login({
    required String email,
    required String password,
  }) => guardApi(() async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/auth/login',
      data: {'email': email, 'password': password},
      options: _public,
    );
    return AuthResponseModel.fromJson(response.data!);
  });

  Future<AuthResponseModel> register({
    required String email,
    required String password,
    required String language,
    String? name,
  }) => guardApi(() async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/auth/register',
      data: {
        'email': email,
        'password': password,
        'language': language,
        'name': ?name,
      },
      options: _public,
    );
    return AuthResponseModel.fromJson(response.data!);
  });

  Future<void> logout(String refreshToken) => guardApi(
    () => _dio.post<void>(
      '/auth/logout',
      data: {'refreshToken': refreshToken},
      options: _public,
    ),
  );

  /// 202 whether or not the email exists (no account enumeration).
  Future<void> forgotPassword(String email) => guardApi(
    () => _dio.post<void>(
      '/auth/password/forgot',
      data: {'email': email},
      options: _public,
    ),
  );

  Future<void> resendVerification() =>
      guardApi(() => _dio.post<void>('/auth/verify-email/resend'));

  Future<MeModel> me() => guardApi(() async {
    final response = await _dio.get<Map<String, dynamic>>('/users/me');
    return MeModel.fromJson(response.data!);
  });
}
