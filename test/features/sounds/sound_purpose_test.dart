import 'package:flutter_test/flutter_test.dart';
import 'package:saiyagym_mobile/features/auth/domain/entities/user.dart';
import 'package:saiyagym_mobile/features/sounds/domain/sound_purpose.dart';

void main() {
  const preferences = UserPreferences(
    restSoundId: 'a',
    trainingReminderSoundId: 'b',
    weighInSoundId: 'a',
  );

  test('idIn reads the preference of each purpose', () {
    expect(SoundPurpose.rest.idIn(preferences), 'a');
    expect(SoundPurpose.trainingReminder.idIn(preferences), 'b');
    expect(SoundPurpose.weighIn.idIn(preferences), 'a');
    expect(SoundPurpose.weighIn.idIn(const UserPreferences()), isNull);
  });

  test('apiKey matches the API preference names', () {
    expect(SoundPurpose.values.map((p) => p.apiKey), [
      'restSoundId',
      'trainingReminderSoundId',
      'weighInSoundId',
    ]);
  });

  test('neededSoundIds dedupes and skips nulls', () {
    expect(neededSoundIds(preferences), {'a', 'b'});
    expect(neededSoundIds(const UserPreferences()), isEmpty);
  });
}
