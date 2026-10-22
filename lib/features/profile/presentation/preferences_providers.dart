import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:saiyagym_mobile/core/network/api_client.dart';
import 'package:saiyagym_mobile/core/state/submission.dart';
import 'package:saiyagym_mobile/core/units/unit_formatter.dart';
import 'package:saiyagym_mobile/features/auth/auth_providers.dart';
import 'package:saiyagym_mobile/features/auth/domain/entities/user.dart';
import 'package:saiyagym_mobile/features/auth/presentation/controllers/session_controller.dart';
import 'package:saiyagym_mobile/features/profile/data/profile_repository_impl.dart';
import 'package:saiyagym_mobile/features/profile/domain/profile_repository.dart';

part 'preferences_providers.g.dart';

// Keep-alive (stateless): RestSoundController, kept alive, saves through it.
@Riverpod(keepAlive: true)
ProfileRepository profileRepository(Ref ref) => ProfileRepositoryImpl(
  remote: ProfileRemoteDataSource(ref.watch(apiClientProvider)),
  local: ref.watch(authLocalDataSourceProvider),
);

@Riverpod(keepAlive: true)
UpdatePreferencesUseCase updatePreferencesUseCase(Ref ref) =>
    UpdatePreferencesUseCase(ref.watch(profileRepositoryProvider));

@riverpod
UpdateProfileUseCase updateProfileUseCase(Ref ref) =>
    UpdateProfileUseCase(ref.watch(profileRepositoryProvider));

/// Units of the signed-in user (metric before sign-in).
@Riverpod(keepAlive: true)
UnitSystem unitSystem(Ref ref) => ref.watch(
  currentUserProvider.select((u) => u?.preferences.units ?? UnitSystem.metric),
);

@riverpod
ThemeMode themeMode(Ref ref) => switch (ref.watch(
  currentUserProvider.select((u) => u?.preferences.theme),
)) {
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

/// Saving state of profile / preference changes.
@riverpod
class ProfileSaveController extends _$ProfileSaveController {
  @override
  FutureOr<void> build() {}

  Future<void> savePreferences(PreferencesUpdate preferences) =>
      _save(() => ref.read(updatePreferencesUseCaseProvider)(preferences));

  Future<void> saveProfile(ProfileUpdate profile) =>
      _save(() => ref.read(updateProfileUseCaseProvider)(profile));

  Future<void> _save(Future<User> Function() action) async {
    state = const AsyncLoading();
    final result = await AsyncValue.guard(action);
    if (!ref.mounted) return;
    state = submissionOf(result);
    if (result case AsyncData(:final value)) {
      ref.read(sessionControllerProvider.notifier).userUpdated(value);
    }
  }
}
