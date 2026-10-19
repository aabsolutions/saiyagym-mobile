import 'package:clock/clock.dart';
import 'package:dio/dio.dart';
import 'package:saiyagym_mobile/core/network/api_exception.dart';
import 'package:saiyagym_mobile/core/sync/stores.dart';
import 'package:saiyagym_mobile/features/live_workout/domain/live_session.dart';
import 'package:saiyagym_mobile/features/programs/domain/program_schedule.dart';
import 'package:saiyagym_mobile/features/routines/domain/routine.dart';

StartPlan planFromRoutine(Routine routine, {String? programId}) => StartPlan(
  name: routine.name,
  routineId: routine.id,
  programId: programId,
  exercises: [
    for (final exercise in routine.exercises)
      PlannedExercise(
        exerciseId: exercise.exerciseId,
        routineExerciseId: exercise.id,
        groupId: exercise.groupId,
        notes: exercise.notes,
        sets: [
          for (final set in exercise.sets)
            SetTarget(
              type: set.type,
              repsMin: set.repsMin,
              repsMax: set.repsMax,
              weightKg: set.weightKg,
              restSeconds: set.restSeconds,
            ),
        ],
      ),
  ],
);

/// What today's active program asks for.
sealed class TodayPlan {
  const TodayPlan();
}

final class NoActiveProgram extends TodayPlan {
  const NoActiveProgram();
}

final class ProgramRestDay extends TodayPlan {
  const ProgramRestDay({required this.programName, this.week});
  final String programName;
  final int? week;
}

final class ProgramNotRunning extends TodayPlan {
  const ProgramNotRunning({required this.programName, this.startsInDays});
  final String programName;

  /// `null` = finished.
  final int? startsInDays;
}

final class ProgramTrainingDay extends TodayPlan {
  const ProgramTrainingDay({
    required this.programName,
    required this.plan,
    required this.week,
    required this.isDeloadWeek,
    required this.offline,
    this.dayLabel,
  });

  final String programName;
  final StartPlan plan;
  final int week;
  final bool isDeloadWeek;
  final String? dayLabel;

  /// Built from local data: static routine weights, without the API's
  /// automatic progression.
  final bool offline;
}

/// Today's program day: from the API when reachable (targets include the
/// automatic progression), else computed locally from the synced program
/// and routine (same calendar rules as the API).
class TodayPlanService {
  TodayPlanService({required this._dio, required this._stores});

  final Dio _dio;
  final SyncStores _stores;

  Future<TodayPlan> today() async {
    final date = localDate(clock.now());
    try {
      return await _fromApi(date);
    } on ApiException catch (error) {
      if (!error.isConnectivity && !error.isServerError) {
        if (error.code == 'NO_ACTIVE_PROGRAM') return const NoActiveProgram();
        rethrow;
      }
      return await _fromLocal(date);
    }
  }

  Future<TodayPlan> _fromApi(String date) => guardApi(() async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/programs/active/today',
      queryParameters: {'date': date},
    );
    final body = response.data!;
    final programName = body['programName'] as String? ?? '';
    final week = (body['week'] as num?)?.toInt();
    switch (body['status']) {
      case 'training':
        final routine = body['routine'];
        if (routine is! Map) {
          return ProgramRestDay(programName: programName, week: week);
        }
        return ProgramTrainingDay(
          programName: programName,
          week: week ?? 1,
          isDeloadWeek: body['isDeloadWeek'] as bool? ?? false,
          dayLabel: body['dayLabel'] as String?,
          offline: false,
          plan: _planFromToday(
            Map<String, dynamic>.from(routine),
            programId: body['programId'] as String?,
          ),
        );
      case 'not_started':
        return ProgramNotRunning(
          programName: programName,
          startsInDays: (body['startsInDays'] as num?)?.toInt(),
        );
      case 'finished':
        return ProgramNotRunning(programName: programName);
      default:
        return ProgramRestDay(programName: programName, week: week);
    }
  });

  /// `TodayRoutineDto` → plan (weights already progressed by the API).
  StartPlan _planFromToday(Map<String, dynamic> routine, {String? programId}) =>
      StartPlan(
        name: routine['name'] as String? ?? '',
        routineId: routine['id'] as String?,
        programId: programId,
        exercises: [
          for (final raw in routine['exercises'] as List? ?? const [])
            _plannedExercise(Map<String, dynamic>.from(raw as Map)),
        ],
      );

  static PlannedExercise _plannedExercise(Map<String, dynamic> exercise) =>
      PlannedExercise(
        exerciseId: exercise['exerciseId'] as String,
        routineExerciseId: exercise['id'] as String?,
        groupId: exercise['groupId'] as String?,
        notes: exercise['notes'] as String? ?? '',
        sets: [
          for (final set in exercise['sets'] as List? ?? const [])
            SetTarget.fromJson(Map<String, dynamic>.from(set as Map)),
        ],
      );

  Future<TodayPlan> _fromLocal(String date) async {
    final programs = await _stores.programs.active();
    final active = programs
        .where((doc) => doc.json['status'] == 'active')
        .firstOrNull;
    if (active == null) return const NoActiveProgram();
    final programName = active.json['name'] as String? ?? '';
    final input = scheduleInputFrom(active.json);
    if (input == null) return ProgramNotRunning(programName: programName);

    switch (scheduleFor(input, date)) {
      case NotStarted(:final startsInDays):
        return ProgramNotRunning(
          programName: programName,
          startsInDays: startsInDays,
        );
      case Finished():
        return ProgramNotRunning(programName: programName);
      case RestDay(:final week):
        return ProgramRestDay(programName: programName, week: week);
      case TrainingDay(:final week, :final isDeloadWeek, :final day):
        final routine = await _stores.routines.find(day.routineId);
        if (routine == null || routine.isDeleted) {
          return ProgramRestDay(programName: programName, week: week);
        }
        return ProgramTrainingDay(
          programName: programName,
          week: week,
          isDeloadWeek: isDeloadWeek,
          dayLabel: day.label,
          offline: true,
          plan: planFromRoutine(
            Routine.fromJson(routine.json),
            programId: active.id,
          ),
        );
    }
  }
}
