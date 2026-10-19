import 'package:flutter_test/flutter_test.dart';
import 'package:saiyagym_mobile/features/nutrition/domain/nutrition_calculator.dart';

// Mirrors the API's nutrition-calculator.spec.ts: same inputs, same numbers.

const _male = CalculatorInput(
  sex: FormulaSex.male,
  ageYears: 30,
  heightCm: 180,
  weightKg: 80,
  activity: ActivityLevel.moderate,
  goal: NutritionGoal.maintenance,
);

CalculatorInput _with({NutritionGoal? goal, ActivityLevel? activity}) =>
    CalculatorInput(
      sex: _male.sex,
      ageYears: _male.ageYears,
      heightCm: _male.heightCm,
      weightKg: _male.weightKg,
      activity: activity ?? _male.activity,
      goal: goal ?? _male.goal,
    );

void main() {
  group('mifflinStJeor', () {
    test('male: 10·kg + 6.25·cm − 5·age + 5', () {
      expect(
        mifflinStJeor(
          sex: FormulaSex.male,
          ageYears: 30,
          heightCm: 180,
          weightKg: 80,
        ),
        1780,
      );
    });

    test('female: same base − 161', () {
      expect(
        mifflinStJeor(
          sex: FormulaSex.female,
          ageYears: 25,
          heightCm: 165,
          weightKg: 60,
        ),
        1345.25,
      );
    });
  });

  group('calculateNutrition', () {
    test('maintenance: TDEE = BMR × factor, 1.8 g/kg, 30 % fat', () {
      final result = calculateNutrition(_male);
      expect(result.bmrKcal, 1780);
      expect(result.tdeeKcal, 2759);
      expect(result.targetKcal, 2759);
      expect(result.clampedToBmr, isFalse);
      final m = result.macros;
      expect([m.proteinG, m.fatG, m.carbsG], [144, 92, 339]);
      expect([m.proteinPercent, m.carbsPercent, m.fatPercent], [21, 49, 30]);
    });

    test('bulk: +10 % kcal, 25 % fat', () {
      final result = calculateNutrition(_with(goal: NutritionGoal.bulk));
      expect(result.targetKcal, 3035);
      final m = result.macros;
      expect([m.proteinG, m.fatG, m.carbsG], [144, 84, 426]);
    });

    test('cut: −20 % kcal and 2.2 g/kg protein', () {
      final result = calculateNutrition(_with(goal: NutritionGoal.cut));
      expect(result.targetKcal, 2207);
      final m = result.macros;
      expect([m.proteinG, m.fatG, m.carbsG], [176, 61, 239]);
      expect(result.clampedToBmr, isFalse);
    });

    test('macro grams add up to the target (± rounding)', () {
      for (final goal in NutritionGoal.values) {
        final result = calculateNutrition(_with(goal: goal));
        final m = result.macros;
        final kcal = m.proteinG * 4 + m.carbsG * 4 + m.fatG * 9;
        expect((kcal - result.targetKcal).abs(), lessThanOrEqualTo(10));
      }
    });

    test('each activity level multiplies the BMR', () {
      const factors = {
        ActivityLevel.sedentary: 1.2,
        ActivityLevel.light: 1.375,
        ActivityLevel.moderate: 1.55,
        ActivityLevel.active: 1.725,
        ActivityLevel.veryActive: 1.9,
      };
      factors.forEach((level, factor) {
        expect(
          calculateNutrition(_with(activity: level)).tdeeKcal,
          (1780 * factor).round(),
        );
      });
    });

    test('never targets below the BMR', () {
      final result = calculateNutrition(
        const CalculatorInput(
          sex: FormulaSex.female,
          ageYears: 25,
          heightCm: 165,
          weightKg: 60,
          activity: ActivityLevel.sedentary,
          goal: NutritionGoal.cut,
        ),
      );
      expect(result.clampedToBmr, isTrue);
      expect(result.targetKcal, 1345);
      expect(result.bmrKcal, 1345);
    });

    test('carbs never go negative', () {
      final result = calculateNutrition(
        const CalculatorInput(
          sex: FormulaSex.female,
          ageYears: 100,
          heightCm: 120,
          weightKg: 250,
          activity: ActivityLevel.sedentary,
          goal: NutritionGoal.cut,
        ),
      );
      expect(result.macros.carbsG, greaterThanOrEqualTo(0));
    });
  });

  test('ageInYears counts whole years, birthday included', () {
    final birth = DateTime(2000, 6, 15);
    expect(ageInYears(birth, DateTime(2026, 6, 14)), 25);
    expect(ageInYears(birth, DateTime(2026, 6, 15)), 26);
    expect(ageInYears(birth, DateTime(2026, 12)), 26);
  });
}
