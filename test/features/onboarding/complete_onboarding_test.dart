import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:saiyagym_mobile/core/network/api_exception.dart';
import 'package:saiyagym_mobile/core/units/unit_formatter.dart';
import 'package:saiyagym_mobile/features/auth/domain/entities/user.dart';
import 'package:saiyagym_mobile/features/onboarding/domain/complete_onboarding.dart';
import 'package:saiyagym_mobile/features/profile/domain/profile_repository.dart';

import '../../helpers/fixtures.dart';

class _MockProfile extends Mock implements ProfileRepository;

void main() {
  late _MockProfile profile;
  late CompleteOnboardingUseCase complete;

  const data = OnboardingData(
    units: UnitSystem.imperial,
    language: 'en',
    defaultRestSeconds: 150,
    heightCm: 180,
    weightKg: 82.5,
    level: TrainingLevel.beginner,
    goal: TrainingGoal.hypertrophy,
  );

  setUp(() {
    profile = _MockProfile();
    complete = CompleteOnboardingUseCase(profile);
    when(
      () => profile.updateMe(
        profile: any(named: 'profile'),
        preferences: any(named: 'preferences'),
      ),
    ).thenAnswer((_) async => testUser());
    when(() => profile.recordBodyWeight(any())).thenAnswer((_) async {});
  });

  test('saves profile + preferences in one PATCH, then the weight', () async {
    await complete(data);

    final captured = verify(
      () => profile.updateMe(
        profile: captureAny(named: 'profile'),
        preferences: captureAny(named: 'preferences'),
      ),
    ).captured;
    final saved = captured[0] as ProfileUpdate;
    final preferences = captured[1] as PreferencesUpdate;
    expect(saved.level, TrainingLevel.beginner);
    expect(saved.goal, TrainingGoal.hypertrophy);
    expect(saved.heightCm, 180);
    expect(preferences.units, UnitSystem.imperial);
    expect(preferences.language, 'en');
    expect(preferences.defaultRestSeconds, 150);
    verify(() => profile.recordBodyWeight(82.5)).called(1);
  });

  test('a failed weigh-in does not block onboarding', () async {
    when(() => profile.recordBodyWeight(any()))
        .thenThrow(const ApiException(code: ApiException.networkError));

    expect(await complete(data), testUser());
  });

  test('no weight → no body metric', () async {
    await complete(data.copyWith(weightKg: null));

    verifyNever(() => profile.recordBodyWeight(any()));
  });

  test('level and goal are mandatory', () {
    expect(() => complete(data.copyWith(goal: null)), throwsArgumentError);
  });
}
