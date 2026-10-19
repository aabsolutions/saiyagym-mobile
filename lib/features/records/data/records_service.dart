import 'package:dio/dio.dart';
import 'package:saiyagym_mobile/core/network/api_exception.dart';
import 'package:saiyagym_mobile/features/records/domain/personal_records.dart';
import 'package:saiyagym_mobile/features/workouts/domain/workout.dart';

/// A record broken in a workout, for one exercise.
class WorkoutRecord {
  const WorkoutRecord({required this.exerciseId, required this.record});

  final String exerciseId;
  final NewRecord record;
}

enum RecordConfirmation { pending, confirmed, notConfirmed }

RecordSession _sessionOf(Workout workout, String exerciseId) => RecordSession(
  workoutId: workout.id,
  startedAt: workout.startedAt,
  sets: [
    for (final exercise in workout.exercises)
      if (exercise.exerciseId == exerciseId)
        for (final set in exercise.sets)
          RecordSet(
            type: set.type,
            completed: set.completed,
            weightKg: set.weightKg,
            reps: set.reps,
          ),
  ],
);

/// Records [workout] broke against the user's local history — the same
/// computation the API runs when the workout syncs.
List<WorkoutRecord> detectWorkoutRecords(
  Workout workout,
  List<Workout> history,
) {
  final exerciseIds = {for (final e in workout.exercises) e.exerciseId};
  return [
    for (final exerciseId in exerciseIds)
      for (final record in detectNewRecords(
        current: _sessionOf(workout, exerciseId),
        history: [
          for (final past in history)
            if (past.id != workout.id &&
                !past.inProgress &&
                past.exercises.any((e) => e.exerciseId == exerciseId))
              _sessionOf(past, exerciseId),
        ],
      ))
        WorkoutRecord(exerciseId: exerciseId, record: record),
  ];
}

/// Asks the API who holds each record now (`GET /exercises/:id/records`).
/// Confirmed when the holder is the workout itself: the server agrees.
class RecordsConfirmer {
  RecordsConfirmer(this._dio);

  final Dio _dio;

  Future<Map<WorkoutRecord, RecordConfirmation>> confirm(
    String workoutId,
    List<WorkoutRecord> records,
  ) async {
    final result = <WorkoutRecord, RecordConfirmation>{};
    final byExercise = <String, Map<String, dynamic>>{};
    for (final record in records) {
      final server = byExercise[record.exerciseId] ??= await guardApi(() async {
        final response = await _dio.get<Map<String, dynamic>>(
          '/exercises/${record.exerciseId}/records',
        );
        return response.data!;
      });
      result[record] = _holds(server, record.record, workoutId)
          ? RecordConfirmation.confirmed
          : RecordConfirmation.notConfirmed;
    }
    return result;
  }

  static bool _holds(
    Map<String, dynamic> server,
    NewRecord record,
    String workoutId,
  ) {
    bool held(Object? entry) => entry is Map && entry['workoutId'] == workoutId;
    return switch (record.type) {
      RecordType.maxWeight => held(server['maxWeight']),
      RecordType.bestE1RM => held(server['bestE1RM']),
      RecordType.maxVolume => held(server['maxVolume']),
      RecordType.repsAtWeight =>
        (server['repsAtWeight'] as List? ?? const []).any(
          (entry) =>
              entry is Map &&
              (entry['weightKg'] as num?)?.toDouble() == record.weightKg &&
              held(entry),
        ),
    };
  }
}
