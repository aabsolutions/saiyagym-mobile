import 'package:saiyagym_mobile/core/units/unit_formatter.dart';
import 'package:saiyagym_mobile/features/auth/domain/entities/user.dart';

abstract interface class ProfileRepository {
  /// Partial update: only non-null fields change. Returns the updated user.
  Future<User> updatePreferences({
    UnitSystem? units,
    ThemePreference? theme,
    String? language,
  });
}

class UpdatePreferencesUseCase {
  const UpdatePreferencesUseCase(this._repository);

  final ProfileRepository _repository;

  Future<User> call({
    UnitSystem? units,
    ThemePreference? theme,
    String? language,
  }) => _repository.updatePreferences(
    units: units,
    theme: theme,
    language: language,
  );
}
