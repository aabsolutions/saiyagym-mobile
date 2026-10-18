import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:saiyagym_mobile/core/network/api_client.dart';
import 'package:saiyagym_mobile/core/units/unit_formatter.dart';
import 'package:saiyagym_mobile/features/auth/auth_providers.dart';
import 'package:saiyagym_mobile/features/auth/domain/entities/user.dart';
import 'package:saiyagym_mobile/features/auth/presentation/controllers/session_controller.dart';
import 'package:saiyagym_mobile/features/profile/data/profile_repository_impl.dart';
import 'package:saiyagym_mobile/features/profile/domain/profile_repository.dart';

part 'preferences_providers.g.dart';

@riverpod
UpdatePreferencesUseCase updatePreferencesUseCase(Ref ref) =>
    UpdatePreferencesUseCase(
      ProfileRepositoryImpl(
        remote: ProfileRemoteDataSource(ref.watch(apiClientProvider)),
        local: ref.watch(authLocalDataSourceProvider),
      ),
    );

UserPreferences? _preferences(Ref ref) => ref.watch(
  sessionControllerProvider.select((session) => session.value?.preferences),
);

/// Units of the signed-in user (metric before sign-in).
@riverpod
UnitSystem unitSystem(Ref ref) => _preferences(ref)?.units ?? UnitSystem.metric;

@riverpod
ThemeMode themeMode(Ref ref) => switch (_preferences(ref)?.theme) {
  ThemePreference.light => ThemeMode.light,
  ThemePreference.dark => ThemeMode.dark,
  ThemePreference.system || null => ThemeMode.system,
};

extension UnitFormatterRef on WidgetRef {
  /// Formatter for the user's units and the current UI locale.
  UnitFormatter unitFormatter(BuildContext context) => UnitFormatter(
    watch(unitSystemProvider),
    locale: context.locale.languageCode,
  );
}

/// Saving state of a preference change.
@riverpod
class PreferencesController extends _$PreferencesController {
  @override
  FutureOr<void> build() {}

  Future<void> save({
    UnitSystem? units,
    ThemePreference? theme,
    String? language,
  }) async {
    state = const AsyncLoading();
    final result = await AsyncValue.guard(
      () => ref.read(updatePreferencesUseCaseProvider)(
        units: units,
        theme: theme,
        language: language,
      ),
    );
    if (!ref.mounted) return;
    switch (result) {
      case AsyncData(:final value):
        state = const AsyncData(null);
        ref.read(sessionControllerProvider.notifier).userUpdated(value);
      case AsyncError(:final error, :final stackTrace):
        state = AsyncError(error, stackTrace);
      case AsyncLoading():
        break;
    }
  }
}
