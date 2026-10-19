import 'package:saiyagym_mobile/core/text/search.dart';
import 'package:saiyagym_mobile/features/nutrition/domain/nutrition_calculator.dart';

// Read models of the API's static nutrition base (admin-managed, already
// localized by Accept-Language). Small (≈80 foods, 30 meals, 10 guides):
// downloaded whole and filtered on the device, so it works offline.

class Macros {
  const Macros({
    required this.kcal,
    required this.proteinG,
    required this.carbsG,
    required this.fatG,
  });

  factory Macros.fromJson(Map<String, dynamic>? json) => Macros(
    kcal: _num(json?['kcal']),
    proteinG: _num(json?['proteinG']),
    carbsG: _num(json?['carbsG']),
    fatG: _num(json?['fatG']),
  );

  final double kcal;
  final double proteinG;
  final double carbsG;
  final double fatG;
}

class Food {
  const Food({
    required this.id,
    required this.name,
    required this.category,
    required this.tags,
    required this.per100g,
  });

  factory Food.fromJson(Map<String, dynamic> json) => Food(
    id: json['id'] as String,
    name: json['name'] as String,
    category: json['category'] as String,
    tags: [for (final t in json['tags'] as List? ?? const []) t as String],
    per100g: Macros.fromJson(_map(json['per100g'])),
  );

  final String id;
  final String name;

  /// `meat`, `fish`, … (translated by the app).
  final String category;

  /// `vegan`, `gluten-free`, … (translated by the app).
  final List<String> tags;
  final Macros per100g;
}

enum MealType {
  breakfast('breakfast'),
  lunch('lunch'),
  dinner('dinner'),
  snack('snack'),
  preWorkout('pre_workout'),
  postWorkout('post_workout');

  MealType(this.api);

  final String api;

  static MealType? fromApi(Object? value) =>
      values.where((t) => t.api == value).firstOrNull;
}

class MealItem {
  const MealItem({required this.name, required this.grams, required this.kcal});

  factory MealItem.fromJson(Map<String, dynamic> json) => MealItem(
    name: json['name'] as String,
    grams: _num(json['grams']),
    kcal: _num(json['kcal']),
  );

  final String name;
  final double grams;
  final double kcal;
}

class MealSuggestion {
  const MealSuggestion({
    required this.id,
    required this.name,
    required this.description,
    required this.goal,
    required this.mealType,
    required this.items,
    required this.totals,
  });

  factory MealSuggestion.fromJson(Map<String, dynamic> json) => MealSuggestion(
    id: json['id'] as String,
    name: json['name'] as String,
    description: json['description'] as String? ?? '',
    goal: NutritionGoal.values.byName(json['goal'] as String),
    mealType: MealType.fromApi(json['mealType']) ?? MealType.snack,
    items: [
      for (final item in json['items'] as List? ?? const [])
        MealItem.fromJson(Map<String, dynamic>.from(item as Map)),
    ],
    totals: Macros.fromJson(_map(json['totals'])),
  );

  final String id;
  final String name;
  final String description;
  final NutritionGoal goal;
  final MealType mealType;
  final List<MealItem> items;
  final Macros totals;
}

/// Suggestions the plan shows. Free gets a sample; [lockedCount] are the
/// ones Premium unlocks.
class MealSuggestions {
  const MealSuggestions({
    required this.items,
    required this.limitedByPlan,
    required this.lockedCount,
  });

  final List<MealSuggestion> items;
  final bool limitedByPlan;
  final int lockedCount;
}

class Guideline {
  const Guideline({
    required this.id,
    required this.title,
    required this.summary,
    required this.body,
    required this.goals,
  });

  factory Guideline.fromJson(Map<String, dynamic> json) => Guideline(
    id: json['id'] as String,
    title: json['title'] as String,
    summary: json['summary'] as String? ?? '',
    body: json['body'] as String? ?? '',
    goals: {
      for (final g in json['goals'] as List? ?? const [])
        NutritionGoal.values.byName(g as String),
    },
  );

  final String id;
  final String title;
  final String summary;

  /// Plain text, paragraphs separated by a blank line.
  final String body;
  final Set<NutritionGoal> goals;
}

List<Food> filterFoods(
  List<Food> foods, {
  String query = '',
  String? category,
}) {
  final matches = searchMatcher(query);
  return [
    for (final food in foods)
      if ((category == null || food.category == category) && matches(food.name))
        food,
  ];
}

List<MealSuggestion> filterMeals(
  List<MealSuggestion> meals, {
  NutritionGoal? goal,
  MealType? type,
}) => [
  for (final meal in meals)
    if ((goal == null || meal.goal == goal) &&
        (type == null || meal.mealType == type))
      meal,
];

double _num(Object? value) => (value as num?)?.toDouble() ?? 0;

Map<String, dynamic>? _map(Object? value) =>
    value is Map ? Map<String, dynamic>.from(value) : null;
