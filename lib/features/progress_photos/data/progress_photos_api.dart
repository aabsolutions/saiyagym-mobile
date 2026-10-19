import 'dart:io';

import 'package:dio/dio.dart';
import 'package:saiyagym_mobile/core/network/api_exception.dart';
import 'package:saiyagym_mobile/features/progress_photos/domain/progress_photo.dart';

/// `POST /media/upload-signature` answer: everything Cloudinary needs.
class UploadSignature {
  const UploadSignature({
    required this.uploadUrl,
    required this.apiKey,
    required this.signature,
    required this.params,
    required this.maxFileSizeBytes,
  });

  factory UploadSignature.fromJson(Map<String, dynamic> json) =>
      UploadSignature(
        uploadUrl: json['uploadUrl'] as String,
        apiKey: json['apiKey'] as String,
        signature: json['signature'] as String,
        params: Map<String, dynamic>.from(json['params'] as Map),
        maxFileSizeBytes: (json['maxFileSizeBytes'] as num?)?.toInt() ?? 0,
      );

  final String uploadUrl;
  final String apiKey;
  final String signature;

  /// Signed: sent to Cloudinary exactly as received.
  final Map<String, dynamic> params;
  final int maxFileSizeBytes;
}

/// Progress photos are online-only REST (Premium): the API signs, the file
/// goes straight to Cloudinary, then the API registers it.
class ProgressPhotosApi {
  ProgressPhotosApi({required this._dio, required this._upload});

  final Dio _dio;

  /// WITHOUT the app's interceptors: the JWT must never reach Cloudinary.
  final Dio _upload;

  Future<List<ProgressPhoto>> list(PhotoView view) => guardApi(() async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/progress-photos',
      queryParameters: {'view': view.name, 'page': 1, 'limit': 100},
    );
    return [
      for (final item in response.data!['items'] as List)
        ProgressPhoto.fromJson(Map<String, dynamic>.from(item as Map)),
    ];
  });

  Future<PhotoComparison> compare(PhotoView view) => guardApi(() async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/progress-photos/compare',
      queryParameters: {'view': view.name},
    );
    ProgressPhoto? photo(Object? json) => json is Map
        ? ProgressPhoto.fromJson(Map<String, dynamic>.from(json))
        : null;
    return PhotoComparison(
      before: photo(response.data!['before']),
      after: photo(response.data!['after']),
    );
  });

  Future<void> delete(String id) =>
      guardApi(() => _dio.delete<void>('/progress-photos/$id'));

  /// Valid for 1 h: asked right before each upload, never stored.
  Future<UploadSignature> signature() => guardApi(() async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/media/upload-signature',
      data: {'purpose': 'progress_photo'},
    );
    return UploadSignature.fromJson(response.data!);
  });

  Future<UploadedAsset> uploadFile(UploadSignature signature, File file) =>
      guardApi(() async {
        final form = FormData.fromMap({
          'file': await MultipartFile.fromFile(file.path),
          'api_key': signature.apiKey,
          'signature': signature.signature,
          for (final MapEntry(:key, :value) in signature.params.entries)
            key: '$value',
        });
        final response = await _upload.post<Map<String, dynamic>>(
          signature.uploadUrl,
          data: form,
        );
        final body = response.data!;
        return UploadedAsset(
          publicId: body['public_id'] as String,
          format: body['format'] as String,
          url: body['secure_url'] as String,
        );
      });

  Future<ProgressPhoto> register(PendingPhoto photo, UploadedAsset asset) =>
      guardApi(() async {
        final response = await _dio.post<Map<String, dynamic>>(
          '/progress-photos',
          data: {
            'view': photo.view.name,
            'publicId': asset.publicId,
            'format': asset.format,
            'url': asset.url,
            'takenAt': photo.takenAt.toUtc().toIso8601String(),
            if (photo.notes.isNotEmpty) 'notes': photo.notes,
          },
        );
        return ProgressPhoto.fromJson(response.data!);
      });
}
