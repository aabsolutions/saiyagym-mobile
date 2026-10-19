import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:saiyagym_mobile/core/network/api_client.dart';
import 'package:saiyagym_mobile/core/sync/sync_providers.dart';
import 'package:saiyagym_mobile/features/exercises/data/exercises_repository_impl.dart';
import 'package:saiyagym_mobile/features/exercises/domain/exercise.dart';

part 'exercises_providers.g.dart';

@Riverpod(keepAlive: true)
ExercisesRepository exercisesRepository(Ref ref) {
  final language = ref.watch(requestLanguageProvider);
  return ExercisesRepositoryImpl(
    stores: ref.watch(syncStoresProvider),
    writer: ref.watch(syncWriterProvider),
    languageCode: () => language.code,
    dio: ref.watch(apiClientProvider),
  );
}

/// Every exercise (global + custom), by name. Filtering is done in Dart:
/// ~150 rows, and accent-insensitive search is easier there than in SQL.
@riverpod
Stream<List<Exercise>> exerciseCatalog(Ref ref) =>
    ref.watch(exercisesRepositoryProvider).watchCatalog();

@riverpod
Stream<Map<String, ExercisePref>> exercisePrefs(Ref ref) =>
    ref.watch(exercisesRepositoryProvider).watchPrefs();

/// Exercise names by id (sessions and routines store only the id).
@riverpod
Map<String, String> exerciseNames(Ref ref) => {
  for (final exercise
      in ref.watch(exerciseCatalogProvider).value ?? const <Exercise>[])
    exercise.id: exercise.name,
};
