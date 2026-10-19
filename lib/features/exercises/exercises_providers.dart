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
  );
}
