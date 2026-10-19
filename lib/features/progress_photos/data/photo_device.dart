import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

enum PhotoSource { camera, gallery }

/// Camera / gallery (the OS asks for the camera permission when the user
/// picks "camera", which is the moment it makes sense).
abstract interface class PhotoPicker {
  /// Path of the picked image, null when cancelled.
  Future<String?> pick(PhotoSource source);
}

abstract interface class ImageCompressor {
  /// Writes a smaller JPEG to [target]; false when it couldn't.
  Future<bool> compress(String source, String target);
}

class SystemPhotoPicker implements PhotoPicker {
  final _picker = ImagePicker();

  @override
  Future<String?> pick(PhotoSource source) async {
    final file = await _picker.pickImage(
      source: switch (source) {
        PhotoSource.camera => ImageSource.camera,
        PhotoSource.gallery => ImageSource.gallery,
      },
    );
    return file?.path;
  }
}

/// JPEG, short side ≤ 1280 px, no EXIF (drops GPS location, rotation is
/// applied first): a few hundred KB instead of several MB.
class JpegCompressor implements ImageCompressor {
  @override
  Future<bool> compress(String source, String target) async {
    final result = await FlutterImageCompress.compressAndGetFile(
      source,
      target,
      minWidth: 1280,
      minHeight: 1280,
      quality: 82,
    );
    return result != null;
  }
}

typedef DirectoryResolver = Future<Directory> Function();

/// Where queued photos wait (app documents: survives restarts, not backed
/// up to the gallery).
Future<Directory> pendingPhotosDirectory() async {
  final base = await getApplicationDocumentsDirectory();
  return await Directory('${base.path}${Platform.pathSeparator}pending_photos')
      .create(recursive: true);
}
