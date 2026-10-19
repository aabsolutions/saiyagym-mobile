import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saiyagym_mobile/core/network/api_exception.dart';

void main() {
  final request = RequestOptions(path: '/routines');

  DioException badResponse(int status, Object? body) => DioException(
    requestOptions: request,
    type: DioExceptionType.badResponse,
    response: Response(requestOptions: request, statusCode: status, data: body),
  );

  group('ApiException.fromDio', () {
    test('keeps the API code, message and details', () {
      final error = ApiException.fromDio(
        badResponse(403, {
          'statusCode': 403,
          'code': 'PLAN_LIMIT_REACHED',
          'message': 'Límite de rutinas alcanzado',
          'details': {'limit': 3},
        }),
      );

      expect(error.code, 'PLAN_LIMIT_REACHED');
      expect(error.message, 'Límite de rutinas alcanzado');
      expect(error.statusCode, 403);
      expect(error.details, {'limit': 3});
    });

    test('falls back to a code per status when the body has none', () {
      expect(ApiException.fromDio(badResponse(401, null)).code, 'UNAUTHORIZED');
      expect(
        ApiException.fromDio(badResponse(429, 'x')).code,
        'TOO_MANY_REQUESTS',
      );
      expect(
        ApiException.fromDio(badResponse(502, null)).code,
        'INTERNAL_ERROR',
      );
    });

    test('no response → client-side connectivity codes', () {
      ApiException of(DioExceptionType type, [Object? cause]) =>
          ApiException.fromDio(
            DioException(requestOptions: request, type: type, error: cause),
          );

      expect(of(DioExceptionType.connectionError).code, 'NETWORK_ERROR');
      expect(of(DioExceptionType.receiveTimeout).code, 'TIMEOUT');
      expect(of(DioExceptionType.connectionTimeout).isConnectivity, isTrue);
      expect(
        of(DioExceptionType.unknown, const SocketException('down')).code,
        'NETWORK_ERROR',
      );
      expect(of(DioExceptionType.unknown).code, 'UNKNOWN_ERROR');
    });

    test('TLS failures → secure-connection code (e.g. wrong device clock)', () {
      ApiException of(DioExceptionType type, [Object? cause]) =>
          ApiException.fromDio(
            DioException(requestOptions: request, type: type, error: cause),
          );

      expect(
        of(
          DioExceptionType.unknown,
          const HandshakeException('certificate is not yet valid'),
        ).code,
        ApiException.secureConnection,
      );
      expect(
        of(DioExceptionType.badCertificate).code,
        ApiException.secureConnection,
      );
      expect(
        of(
          DioExceptionType.unknown,
          const HandshakeException('x'),
        ).isConnectivity,
        isFalse,
        reason: 'retrying will not fix the clock',
      );
    });

    test('returns an already mapped exception untouched', () {
      const mapped = ApiException(code: 'ROUTINE_NOT_FOUND', statusCode: 404);

      final error = ApiException.fromDio(
        DioException(requestOptions: request, error: mapped),
      );

      expect(identical(error, mapped), isTrue);
    });
  });
}
