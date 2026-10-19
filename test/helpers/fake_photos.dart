import 'dart:io';

import 'package:saiyagym_mobile/features/progress_photos/data/photo_device.dart';

/// "Compresses" by copying (or writing placeholder bytes).
class FakeCompressor implements ImageCompressor {
  bool fail = false;
  final calls = <(String, String)>[];

  @override
  Future<bool> compress(String source, String target) async {
    calls.add((source, target));
    if (fail) return false;
    // Sync IO: real async IO never completes under the widget-test clock.
    File(target).writeAsBytesSync(List.filled(64, 7));
    return true;
  }
}

class FakePhotoPicker implements PhotoPicker {
  String? next = 'picked.jpg';
  final sources = <PhotoSource>[];

  @override
  Future<String?> pick(PhotoSource source) async {
    sources.add(source);
    return next;
  }
}

/// A fresh temp directory, deleted after the test.
Future<Directory> tempPhotosDir() => Directory.systemTemp.createTemp('photos');
