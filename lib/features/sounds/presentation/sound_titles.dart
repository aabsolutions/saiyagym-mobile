import 'package:saiyagym_mobile/features/sounds/domain/sound_purpose.dart';

/// i18n keys (title, subtitle) of the picker / selector of [purpose].
(String, String) soundTitleKeys(SoundPurpose purpose) => switch (purpose) {
  SoundPurpose.rest => ('sounds.title', 'sounds.subtitle'),
  SoundPurpose.trainingReminder => (
    'sounds.trainingTitle',
    'sounds.trainingSubtitle',
  ),
  SoundPurpose.weighIn => ('sounds.weighInTitle', 'sounds.weighInSubtitle'),
};
