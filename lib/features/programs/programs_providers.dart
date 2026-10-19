import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:saiyagym_mobile/core/sync/sync_providers.dart';
import 'package:saiyagym_mobile/features/programs/data/programs_repository_impl.dart';
import 'package:saiyagym_mobile/features/programs/domain/program.dart';

part 'programs_providers.g.dart';

@Riverpod(keepAlive: true)
ProgramsRepository programsRepository(Ref ref) =>
    ProgramsRepositoryImpl(ref.watch(syncStoresProvider).programs);
