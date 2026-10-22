import 'package:saiyagym_mobile/core/cache/json_cache.dart';
import 'package:saiyagym_mobile/features/sounds/domain/rest_sound.dart';

abstract interface class SoundRepository {
  /// The catalog in admin order. Offline: the last copy, with its date.
  Future<Cached<List<RestSound>>> list();
}
