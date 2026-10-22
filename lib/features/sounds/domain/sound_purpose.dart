import 'package:saiyagym_mobile/features/auth/domain/entities/user.dart';

/// What a chosen sound is for. Each purpose has its own preference in
/// `PATCH /users/me` (`apiKey`); the same sound may serve several purposes.
enum SoundPurpose {
  rest('restSoundId'),
  trainingReminder('trainingReminderSoundId'),
  weighIn('weighInSoundId');

  SoundPurpose(this.apiKey);

  /// Key inside `preferences` in the API.
  final String apiKey;

  /// The EFFECTIVE sound id of this purpose (the API nulls it when deleted
  /// or the plan no longer allows it).
  String? idIn(UserPreferences preferences) => switch (this) {
    rest => preferences.restSoundId,
    trainingReminder => preferences.trainingReminderSoundId,
    weighIn => preferences.weighInSoundId,
  };
}

/// Ids of every sound some purpose still needs (what the device must keep).
Set<String> neededSoundIds(UserPreferences preferences) => {
  for (final purpose in SoundPurpose.values) ?purpose.idIn(preferences),
};
