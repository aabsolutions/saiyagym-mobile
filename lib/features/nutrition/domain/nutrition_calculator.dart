// Port of the API's `nutrition/nutrition-calculator.ts` (calculateNutrition).
// MUST stay in sync: the app computes offline what `POST
// /nutrition/calculator` would answer. Orientative only — the UI always
// shows the "consult a professional" notice next to the result.

enum NutritionGoal { bulk, cut, maintenance }

enum ActivityLevel {
  sedentary(1.2),
  light(1.375),
  moderate(1.55),
  active(1.725),
  veryActive(1.9);

  ActivityLevel(this.factor);

  final double factor;
}

/// Sexes Mifflin-St Jeor defines.
enum FormulaSex { male, female }

/// Mifflin-St Jeor is validated for adults (same bounds as the API).
abstract final class CalculatorBounds {
  static const minAge = 18;
  static const maxAge = 100;
  static const minHeightCm = 120.0;
  static const maxHeightCm = 230.0;
  static const minWeightKg = 35.0;
  static const maxWeightKg = 250.0;
}

class CalculatorInput {
  const CalculatorInput({
    required this.sex,
    required this.ageYears,
    required this.heightCm,
    required this.weightKg,
    required this.activity,
    required this.goal,
  });

  final FormulaSex sex;
  final int ageYears;
  final double heightCm;
  final double weightKg;
  final ActivityLevel activity;
  final NutritionGoal goal;
}

class MacroSplit {
  const MacroSplit({
    required this.proteinG,
    required this.carbsG,
    required this.fatG,
    required this.proteinPercent,
    required this.carbsPercent,
    required this.fatPercent,
  });

  final int proteinG;
  final int carbsG;
  final int fatG;

  /// Share of the target kcal, rounded (may not add up to exactly 100).
  final int proteinPercent;
  final int carbsPercent;
  final int fatPercent;
}

class CalculatorResult {
  const CalculatorResult({
    required this.bmrKcal,
    required this.tdeeKcal,
    required this.targetKcal,
    required this.clampedToBmr,
    required this.macros,
  });

  final int bmrKcal;
  final int tdeeKcal;
  final int targetKcal;

  /// The goal's deficit went below the BMR; the target was raised to it.
  final bool clampedToBmr;
  final MacroSplit macros;
}

typedef _GoalRule = ({double kcalFactor, double proteinPerKg, double fatShare});

const Map<NutritionGoal, _GoalRule> _goalRules = {
  NutritionGoal.bulk: (kcalFactor: 1.1, proteinPerKg: 1.8, fatShare: 0.25),
  NutritionGoal.cut: (kcalFactor: 0.8, proteinPerKg: 2.2, fatShare: 0.25),
  NutritionGoal.maintenance: (kcalFactor: 1, proteinPerKg: 1.8, fatShare: 0.3),
};

/// JavaScript's Math.round (halves round up, also for negatives).
int _round(double value) => (value + 0.5).floor();

/// Mifflin-St Jeor (1990): 10·kg + 6.25·cm − 5·age + 5 (male) / − 161.
double mifflinStJeor({
  required FormulaSex sex,
  required int ageYears,
  required double heightCm,
  required double weightKg,
}) {
  final base = 10 * weightKg + 6.25 * heightCm - 5 * ageYears;
  return base + (sex == FormulaSex.male ? 5 : -161);
}

CalculatorResult calculateNutrition(CalculatorInput input) {
  final rules = _goalRules[input.goal]!;
  final bmr = mifflinStJeor(
    sex: input.sex,
    ageYears: input.ageYears,
    heightCm: input.heightCm,
    weightKg: input.weightKg,
  );
  final tdee = bmr * input.activity.factor;
  final adjusted = tdee * rules.kcalFactor;
  final clampedToBmr = adjusted < bmr;
  final targetKcal = _round(clampedToBmr ? bmr : adjusted);

  final proteinG = _round(input.weightKg * rules.proteinPerKg);
  final fatG = _round(targetKcal * rules.fatShare / 9);
  final remaining = targetKcal - proteinG * 4 - fatG * 9;
  final carbsG = _round(remaining / 4) < 0 ? 0 : _round(remaining / 4);

  int percent(int grams, int kcalPerG) =>
      _round(grams * kcalPerG / targetKcal * 100);

  return CalculatorResult(
    bmrKcal: _round(bmr),
    tdeeKcal: _round(tdee),
    targetKcal: targetKcal,
    clampedToBmr: clampedToBmr,
    macros: MacroSplit(
      proteinG: proteinG,
      carbsG: carbsG,
      fatG: fatG,
      proteinPercent: percent(proteinG, 4),
      carbsPercent: percent(carbsG, 4),
      fatPercent: percent(fatG, 9),
    ),
  );
}

/// Whole years between [birthDate] and [today] (calendar dates).
int ageInYears(DateTime birthDate, DateTime today) {
  var age = today.year - birthDate.year;
  final beforeBirthday =
      today.month < birthDate.month ||
      (today.month == birthDate.month && today.day < birthDate.day);
  if (beforeBirthday) age--;
  return age;
}
