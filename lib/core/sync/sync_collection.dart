/// Collections of `/sync/push` and `/sync/pull` (wire names).
enum SyncCollection {
  exercises('exercises', pushable: false),
  userExercisePrefs('user_exercise_prefs', pushable: true),
  routines('routines', pushable: true),
  programs('programs', pushable: false),
  workouts('workouts', pushable: true),
  bodyMetrics('body_metrics', pushable: true);

  SyncCollection(this.wire, {required this.pushable});

  final String wire;

  /// Pull-only collections are created/edited through the REST API.
  final bool pushable;

  static SyncCollection? fromWire(String wire) {
    for (final collection in values) {
      if (collection.wire == wire) return collection;
    }
    return null;
  }
}

enum SyncOp { upsert, delete }
