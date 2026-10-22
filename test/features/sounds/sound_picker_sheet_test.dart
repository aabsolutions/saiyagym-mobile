import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saiyagym_mobile/core/cache/json_cache.dart';
import 'package:saiyagym_mobile/features/auth/domain/entities/user.dart';
import 'package:saiyagym_mobile/features/auth/presentation/controllers/session_controller.dart';
import 'package:saiyagym_mobile/features/plans/presentation/upgrade_cta.dart';
import 'package:saiyagym_mobile/features/profile/domain/profile_repository.dart';
import 'package:saiyagym_mobile/features/profile/presentation/preferences_providers.dart';
import 'package:saiyagym_mobile/features/sounds/data/sound_preview.dart';
import 'package:saiyagym_mobile/features/sounds/domain/rest_sound.dart';
import 'package:saiyagym_mobile/features/sounds/presentation/sound_picker_sheet.dart';
import 'package:saiyagym_mobile/features/sounds/sounds_providers.dart';

import '../../helpers/fake_session.dart';
import '../../helpers/fixtures.dart';
import '../../helpers/pump_app.dart';
import '../../helpers/test_infra.dart';

const _free = RestSound(
  id: 'free-1',
  slug: 'bell',
  name: 'Campana',
  access: SoundAccess.free,
  locked: false,
  durationSec: 2,
  mp3Url: 'https://res.cloudinary.com/x/video/upload/p/k1.mp3',
  wavUrl: 'https://res.cloudinary.com/x/video/upload/af_22050/p/k1.wav',
);
const _premium = RestSound(
  id: 'prem-1',
  slug: 'gong',
  name: 'Gong',
  access: SoundAccess.premium,
  locked: true,
  durationSec: 3,
);

class _FakeProfileRepository implements ProfileRepository {
  _FakeProfileRepository(this.user);

  final User user;
  final updates = <PreferencesUpdate>[];

  @override
  Future<User> updateMe({
    ProfileUpdate? profile,
    PreferencesUpdate? preferences,
  }) async {
    if (preferences != null) updates.add(preferences);
    return user;
  }

  @override
  Future<void> recordBodyWeight(double weightKg) async {}
}

void main() {
  late _FakeProfileRepository repository;
  late SilentSoundPreview preview;

  Future<void> pumpSheet(WidgetTester tester) async {
    final user = testUser();
    repository = _FakeProfileRepository(user);
    preview = SilentSoundPreview();
    await pumpLocalized(
      tester,
      const LocalizedTestApp(home: Scaffold(body: SoundPickerSheet())),
      infra: testInfraOverrides(preview: preview),
      overrides: [
        sessionControllerProvider.overrideWith(() => FakeSession.user(user)),
        profileRepositoryProvider.overrideWithValue(repository),
        restSoundsProvider.overrideWith(
          (_) async => Cached(const [
            _free,
            _premium,
          ], fetchedAt: DateTime.utc(2026, 10, 20)),
        ),
      ],
    );
  }

  testWidgets('lists the default and the catalog; premium shows locked', (
    tester,
  ) async {
    await pumpSheet(tester);

    expect(find.text('Predeterminado'), findsOneWidget);
    expect(find.text('Campana'), findsOneWidget);
    expect(find.text('Gong'), findsOneWidget);
    expect(find.byIcon(Icons.lock_outline), findsOneWidget);
    expect(find.byType(UpgradeCta), findsNothing);
  });

  testWidgets('locked sound: shows UpgradeCta and sends no PATCH', (
    tester,
  ) async {
    await pumpSheet(tester);

    await tester.tap(find.byKey(const ValueKey('sound-prem-1')));
    await tester.pump();

    expect(find.byType(UpgradeCta), findsOneWidget);
    expect(repository.updates, isEmpty);
  });

  testWidgets('a free sound is saved through the preferences PATCH', (
    tester,
  ) async {
    await pumpSheet(tester);

    await tester.tap(find.byKey(const ValueKey('sound-free-1')));
    await tester.pump();
    await tester.pump();

    expect(repository.updates.single.restSoundId, 'free-1');
    expect(repository.updates.single.resetRestSound, isFalse);
    expect(find.byType(UpgradeCta), findsNothing);
  });

  testWidgets('default sound sends the reset flag', (tester) async {
    await pumpSheet(tester);

    await tester.tap(find.byKey(const ValueKey('sound-default')));
    await tester.pump();
    await tester.pump();

    expect(repository.updates.single.resetRestSound, isTrue);
  });

  testWidgets('preview plays the sound without selecting it', (tester) async {
    await pumpSheet(tester);

    await tester.tap(find.byIcon(Icons.play_arrow));
    await tester.pump();

    expect(preview.played, ['free-1']);
    expect(repository.updates, isEmpty);
  });
}
