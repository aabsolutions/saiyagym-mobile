import 'package:saiyagym_mobile/features/sounds/data/alarm_sound_platform.dart';
import 'package:saiyagym_mobile/features/sounds/domain/alarm_sound.dart';

/// In-memory [AlarmSoundPlatform]: records calls, availability is settable.
class FakeAlarmSoundPlatform implements AlarmSoundPlatform {
  /// What `install` returns (`null` = the OS refused).
  String? installUri = 'content://media/external/audio/media/42';

  /// Answer of `isAvailable`.
  bool available = true;

  final installed = <String>[];
  final removed = <String>[];
  final previews = <String>[];
  int stops = 0;
  int removeAllCalls = 0;

  @override
  Future<String?> install({
    required String path,
    required String assetKey,
  }) async {
    installed.add(assetKey);
    return installUri;
  }

  @override
  Future<void> remove(String androidUri) async => removed.add(androidUri);

  @override
  Future<int> removeAll() async {
    removeAllCalls++;
    return 0;
  }

  @override
  Future<bool> isAvailable(AlarmSound sound) async => available;

  @override
  Future<void> preview(String path) async => previews.add(path);

  @override
  Future<void> stopPreview() async => stops++;
}
