import 'package:saiyagym_mobile/core/sync/sync_collection.dart';

/// Builds the `doc` body of a push change from a stored document.
///
/// The API validates push docs like the REST create body with
/// `forbidNonWhitelisted`, while pulled docs carry server-computed fields
/// (`volumeKg`, `workingSets`, `durationSeconds`, …). Echoing a pulled doc
/// back would be a VALIDATION_ERROR, so each collection whitelists what it
/// may send. Envelope fields (`id`, `updatedAt`, `createdAt`, `deletedAt`)
/// are added by the queue, not here.
Map<String, Object?> pushBody(
  SyncCollection collection,
  Map<String, dynamic> doc,
) => switch (collection) {
  SyncCollection.workouts => {
    ..._pick(doc, _workoutKeys),
    'exercises': [
      for (final exercise in _list(doc['exercises']))
        {
          ..._pick(exercise, _workoutExerciseKeys),
          'sets': [
            for (final set in _list(exercise['sets']))
              _pick(set, _workoutSetKeys),
          ],
        },
    ],
  },
  SyncCollection.routines => {
    ..._pick(doc, _routineKeys),
    'exercises': [
      for (final exercise in _list(doc['exercises']))
        {
          ..._pick(exercise, _routineExerciseKeys),
          // `progression: null` = no rule; the DTO wants it absent.
          if (exercise['progression'] != null)
            'progression': exercise['progression'],
          'sets': [
            for (final set in _list(exercise['sets']))
              _pick(set, _targetSetKeys),
          ],
        },
    ],
  },
  SyncCollection.bodyMetrics => _pick(doc, _bodyMetricKeys),
  SyncCollection.userExercisePrefs => _pick(doc, _prefKeys),
  SyncCollection.exercises || SyncCollection.programs => throw StateError(
    '${collection.wire} is pull-only',
  ),
};

const _workoutKeys = [
  'name',
  'routineId',
  'programId',
  'startedAt',
  'finishedAt',
  'notes',
  'rating',
];
const _workoutExerciseKeys = [
  'id',
  'exerciseId',
  'routineExerciseId',
  'groupId',
  'notes',
];
const _workoutSetKeys = [
  'id',
  'type',
  'weightKg',
  'reps',
  'completed',
  'completedAt',
];
const _routineKeys = ['name', 'notes', 'archivedAt'];
const _routineExerciseKeys = ['id', 'exerciseId', 'groupId', 'notes'];
const _targetSetKeys = [
  'type',
  'repsMin',
  'repsMax',
  'weightKg',
  'percent1RM',
  'restSeconds',
];
const _bodyMetricKeys = [
  'measuredAt',
  'weightKg',
  'bodyFatPercent',
  'waistCm',
  'chestCm',
  'hipsCm',
  'armCm',
  'thighCm',
  'calfCm',
  'neckCm',
  'notes',
];
const _prefKeys = ['exerciseId', 'isFavorite', 'personalTiers'];

Map<String, Object?> _pick(Map<String, dynamic> source, List<String> keys) => {
  for (final key in keys)
    if (source.containsKey(key)) key: source[key],
};

List<Map<String, dynamic>> _list(Object? value) => [
  if (value is List)
    for (final item in value)
      if (item is Map) Map<String, dynamic>.from(item),
];
