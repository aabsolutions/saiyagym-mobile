import 'package:saiyagym_mobile/core/sync/synced_store.dart';

enum PhotoView { front, side, back }

/// An uploaded photo. [url] is a signed, expiring delivery URL (private
/// asset): never store it, ask the API again.
class ProgressPhoto {
  const ProgressPhoto({
    required this.id,
    required this.view,
    required this.takenAt,
    required this.url,
    this.notes = '',
  });

  factory ProgressPhoto.fromJson(Map<String, dynamic> json) => ProgressPhoto(
    id: json['id'] as String,
    view: PhotoView.values.byName(json['view'] as String),
    takenAt: parseUtc(json['takenAt']) ?? DateTime.utc(1970),
    url: json['url'] as String,
    notes: json['notes'] as String? ?? '',
  );

  final String id;
  final PhotoView view;
  final DateTime takenAt;
  final String url;
  final String notes;
}

/// Earliest and latest photo of one view.
class PhotoComparison {
  const PhotoComparison({this.before, this.after});

  final ProgressPhoto? before;

  /// Null when there is only one photo.
  final ProgressPhoto? after;
}

/// What Cloudinary returned for an upload (kept so a failed registration
/// retries without uploading the file again).
class UploadedAsset {
  const UploadedAsset({
    required this.publicId,
    required this.format,
    required this.url,
  });

  factory UploadedAsset.fromJson(Map<String, dynamic> json) => UploadedAsset(
    publicId: json['publicId'] as String,
    format: json['format'] as String,
    url: json['url'] as String,
  );

  final String publicId;
  final String format;
  final String url;

  Map<String, dynamic> toJson() => {
    'publicId': publicId,
    'format': format,
    'url': url,
  };
}

/// A photo waiting to be uploaded (compressed file on this device).
class PendingPhoto {
  const PendingPhoto({
    required this.id,
    required this.view,
    required this.takenAt,
    required this.fileName,
    this.notes = '',
    this.uploaded,
    this.error,
  });

  factory PendingPhoto.fromJson(Map<String, dynamic> json) => PendingPhoto(
    id: json['id'] as String,
    view: PhotoView.values.byName(json['view'] as String),
    takenAt: parseUtc(json['takenAt']) ?? DateTime.utc(1970),
    fileName: json['fileName'] as String,
    notes: json['notes'] as String? ?? '',
    uploaded: json['uploaded'] is Map
        ? UploadedAsset.fromJson(
            Map<String, dynamic>.from(json['uploaded'] as Map),
          )
        : null,
    error: json['error'] as String?,
  );

  final String id;
  final PhotoView view;
  final DateTime takenAt;
  final String fileName;
  final String notes;
  final UploadedAsset? uploaded;

  /// Permanent failure code (the API refused it); retried only on demand.
  final String? error;

  PendingPhoto copyWith({
    UploadedAsset? uploaded,
    String? error,
    bool clearError = false,
  }) => PendingPhoto(
    id: id,
    view: view,
    takenAt: takenAt,
    fileName: fileName,
    notes: notes,
    uploaded: uploaded ?? this.uploaded,
    error: clearError ? null : error ?? this.error,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'view': view.name,
    'takenAt': takenAt.toUtc().toIso8601String(),
    'fileName': fileName,
    'notes': notes,
    'uploaded': uploaded?.toJson(),
    'error': error,
  };
}
