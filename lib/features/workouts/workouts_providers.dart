import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:saiyagym_mobile/core/sync/sync_providers.dart';
import 'package:saiyagym_mobile/features/workouts/data/workouts_repository_impl.dart';
import 'package:saiyagym_mobile/features/workouts/domain/workout.dart';

part 'workouts_providers.g.dart';

@Riverpod(keepAlive: true)
WorkoutsRepository workoutsRepository(Ref ref) => WorkoutsRepositoryImpl(
  store: ref.watch(syncStoresProvider).workouts,
  writer: ref.watch(syncWriterProvider),
);

@riverpod
FinishWorkoutUseCase finishWorkoutUseCase(Ref ref) => FinishWorkoutUseCase(
  ref.watch(workoutsRepositoryProvider),
  ref.watch(syncSchedulerProvider),
);

@riverpod
Stream<List<Workout>> workoutHistory(Ref ref) =>
    ref.watch(workoutsRepositoryProvider).watchHistory();
