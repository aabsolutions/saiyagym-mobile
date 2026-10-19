import 'dart:io';

import 'package:dio/dio.dart';

/// Every failure that leaves the data layer.
///
/// Branch on [code] — the API's stable code (`ROUTINE_LIMIT_REACHED`, …) or
/// one of the client-side codes below — never on [message], which is only
/// display text (already localized by the API via `Accept-Language`).
class ApiException implements Exception {
  const ApiException({
    required this.code,
    this.message,
    this.statusCode,
    this.details,
  });

  /// Maps the API error body `{ statusCode, code, message, details? }`, or
  /// the transport failure when there is no response.
  factory ApiException.fromDio(DioException error) {
    if (error.error case final ApiException mapped) return mapped;

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.transformTimeout:
        return const ApiException(code: timeout);
      case DioExceptionType.connectionError:
        return const ApiException(code: networkError);
      case DioExceptionType.cancel:
        return const ApiException(code: cancelled);
      case DioExceptionType.badResponse:
        return ApiException._fromResponse(error.response);
      case DioExceptionType.badCertificate:
        return const ApiException(code: secureConnection);
      case DioExceptionType.unknown:
        return switch (error.error) {
          SocketException() => const ApiException(code: networkError),
          // Usually a wrong device clock ("certificate is not yet valid").
          HandshakeException() => const ApiException(code: secureConnection),
          _ => const ApiException(code: unknown),
        };
    }
  }

  factory ApiException._fromResponse(Response<dynamic>? response) {
    final status = response?.statusCode;
    final body = response?.data;
    if (body is Map && body['code'] is String) {
      return ApiException(
        code: body['code'] as String,
        message: body['message'] is String ? body['message'] as String : null,
        statusCode: status,
        details: body['details'],
      );
    }
    return ApiException(code: _codeForStatus(status), statusCode: status);
  }

  // Same fallbacks as the API's exception filter.
  static String _codeForStatus(int? status) => switch (status) {
    400 => 'BAD_REQUEST',
    401 => unauthorized,
    403 => 'FORBIDDEN',
    404 => 'NOT_FOUND',
    409 => 'CONFLICT',
    413 => 'PAYLOAD_TOO_LARGE',
    429 => 'TOO_MANY_REQUESTS',
    503 => 'SERVICE_UNAVAILABLE',
    _ => (status ?? 0) >= 500 ? 'INTERNAL_ERROR' : unknown,
  };

  // Client-side codes (no response from the API).
  static const networkError = 'NETWORK_ERROR';
  static const timeout = 'TIMEOUT';
  static const cancelled = 'CANCELLED';
  static const unknown = 'UNKNOWN_ERROR';

  /// TLS failed (wrong date/time on the device, or a network intercepting
  /// HTTPS).
  static const secureConnection = 'SECURE_CONNECTION_FAILED';

  static const unauthorized = 'UNAUTHORIZED';

  final String code;
  final String? message;
  final int? statusCode;
  final Object? details;

  /// The API was not reached: keep local state, retry later.
  bool get isConnectivity => code == networkError || code == timeout;

  bool get isServerError => (statusCode ?? 0) >= 500;

  @override
  String toString() => 'ApiException($code, status: $statusCode)';
}

/// Runs a request and rethrows transport errors as [ApiException], so the
/// domain never sees Dio types.
Future<T> guardApi<T>(Future<T> Function() request) async {
  try {
    return await request();
  } on DioException catch (error) {
    throw ApiException.fromDio(error);
  }
}
