import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'unsynced_changes.g.dart';

/// Counts local changes not yet pushed to the API, across features.
///
/// Each feature that writes offline (workouts, body metrics, …) registers a
/// counter (its outbox). Logout asks here before wiping local data. A
/// registry instead of imports keeps core free of feature dependencies.
class UnsyncedChanges {
  final _counters = <Future<int> Function()>[];

  /// Returns the unregister callback (call it when the owner is disposed).
  void Function() register(Future<int> Function() counter) {
    _counters.add(counter);
    return () => _counters.remove(counter);
  }

  Future<int> count() async {
    var total = 0;
    for (final counter in _counters) {
      total += await counter();
    }
    return total;
  }
}

@Riverpod(keepAlive: true)
UnsyncedChanges unsyncedChanges(Ref ref) => UnsyncedChanges();
