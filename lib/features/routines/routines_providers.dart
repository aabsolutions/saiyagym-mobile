import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:saiyagym_mobile/core/sync/sync_providers.dart';
import 'package:saiyagym_mobile/features/routines/data/routines_repository_impl.dart';
import 'package:saiyagym_mobile/features/routines/domain/routine.dart';

part 'routines_providers.g.dart';

@Riverpod(keepAlive: true)
RoutinesRepository routinesRepository(Ref ref) => RoutinesRepositoryImpl(
  store: ref.watch(syncStoresProvider).routines,
  writer: ref.watch(syncWriterProvider),
);

@riverpod
Stream<List<Routine>> activeRoutines(Ref ref) =>
    ref.watch(routinesRepositoryProvider).watchActive();
