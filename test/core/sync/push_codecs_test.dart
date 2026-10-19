import 'package:flutter_test/flutter_test.dart';
import 'package:saiyagym_mobile/core/sync/push_codecs.dart';
import 'package:saiyagym_mobile/core/sync/sync_collection.dart';

void main() {
  test('workouts: server-computed and envelope fields never go back', () {
    final body = pushBody(SyncCollection.workouts, {
      'id': 'w-1',
      'updatedAt': 'x',
      'createdAt': 'x',
      'deletedAt': null,
      'name': 'Pierna',
      'startedAt': '2026-10-18T09:00:00.000Z',
      'volumeKg': 500,
      'workingSets': 3,
      'durationSeconds': 3600,
      'exercises': [
        {
          'id': 'we-1',
          'exerciseId': 'ex-1',
          'volumeKg': 500,
          'sets': [
            {'id': 's-1', 'type': 'normal', 'reps': 5, 'extra': true},
          ],
        },
      ],
    });

    expect(body, {
      'name': 'Pierna',
      'startedAt': '2026-10-18T09:00:00.000Z',
      'exercises': [
        {
          'id': 'we-1',
          'exerciseId': 'ex-1',
          'sets': [
            {'id': 's-1', 'type': 'normal', 'reps': 5},
          ],
        },
      ],
    });
  });

  test('routines: a null progression rule is omitted, a real one kept', () {
    final body = pushBody(SyncCollection.routines, {
      'name': 'Torso',
      'archivedAt': null,
      'exercises': [
        {
          'id': 'slot-1',
          'exerciseId': 'ex-1',
          'progression': null,
          'sets': [
            {'type': 'normal', 'repsMin': 6, 'repsMax': 8, 'restSeconds': 120},
          ],
        },
        {
          'id': 'slot-2',
          'exerciseId': 'ex-2',
          'progression': {'type': 'double_progression', 'incrementKg': 2.5},
          'sets': <Object>[],
        },
      ],
    });

    final exercises = body['exercises']! as List;
    expect((exercises[0] as Map).containsKey('progression'), isFalse);
    expect((exercises[1] as Map)['progression'], {
      'type': 'double_progression',
      'incrementKg': 2.5,
    });
    expect(body['archivedAt'], isNull);
  });

  test('prefs and body metrics keep only their fields', () {
    expect(
      pushBody(SyncCollection.userExercisePrefs, {
        'id': 'p',
        'exerciseId': 'ex-1',
        'isFavorite': true,
        'personalTiers': {'hypertrophy': 'A', 'powerlifting': null},
      }),
      {
        'exerciseId': 'ex-1',
        'isFavorite': true,
        'personalTiers': {'hypertrophy': 'A', 'powerlifting': null},
      },
    );
    expect(
      pushBody(SyncCollection.bodyMetrics, {
        'id': 'm',
        'measuredAt': '2026-10-18T09:00:00.000Z',
        'weightKg': 80,
        'userId': 'someone',
      }),
      {'measuredAt': '2026-10-18T09:00:00.000Z', 'weightKg': 80},
    );
  });

  test('pull-only collections cannot be pushed', () {
    expect(() => pushBody(SyncCollection.programs, const {}), throwsStateError);
    expect(
      () => pushBody(SyncCollection.exercises, const {}),
      throwsStateError,
    );
  });
}
