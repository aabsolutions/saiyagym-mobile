// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'programs_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(programsRepository)
final programsRepositoryProvider = ProgramsRepositoryProvider._();

final class ProgramsRepositoryProvider
    extends
        $FunctionalProvider<
          ProgramsRepository,
          ProgramsRepository,
          ProgramsRepository
        >
    with $Provider<ProgramsRepository> {
  ProgramsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'programsRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$programsRepositoryHash();

  @$internal
  @override
  $ProviderElement<ProgramsRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ProgramsRepository create(Ref ref) {
    return programsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ProgramsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ProgramsRepository>(value),
    );
  }
}

String _$programsRepositoryHash() =>
    r'65dfc51b6978629a32d8d00af7f9e4179a2de334';
