import 'dart:convert';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:saiyagym_mobile/core/cache/json_cache.dart';
import 'package:saiyagym_mobile/core/database/database_provider.dart';
import 'package:saiyagym_mobile/core/network/api_client.dart';
import 'package:saiyagym_mobile/features/nutrition/data/nutrition_repository.dart';
import 'package:saiyagym_mobile/features/nutrition/domain/nutrition_calculator.dart';
import 'package:saiyagym_mobile/features/nutrition/domain/nutrition_catalog.dart';

part 'nutrition_providers.g.dart';

@Riverpod(keepAlive: true)
NutritionRepository nutritionRepository(Ref ref) {
  final language = ref.watch(requestLanguageProvider);
  return NutritionRepository(
    dio: ref.watch(apiClientProvider),
    cache: JsonCache(ref.watch(appDatabaseProvider)),
    languageCode: () => language.code,
  );
}

@riverpod
Future<Cached<List<Food>>> foods(Ref ref) =>
    ref.watch(nutritionRepositoryProvider).foods();

@riverpod
Future<Cached<MealSuggestions>> mealSuggestions(Ref ref) =>
    ref.watch(nutritionRepositoryProvider).meals();

@riverpod
Future<Cached<List<Guideline>>> guidelines(Ref ref) =>
    ref.watch(nutritionRepositoryProvider).guidelines();

/// Goal + activity last used in the calculator (this device).
class CalculatorChoice {
  const CalculatorChoice({required this.goal, required this.activity});

  final NutritionGoal goal;
  final ActivityLevel activity;
}

@Riverpod(keepAlive: true)
class CalculatorChoiceController extends _$CalculatorChoiceController {
  static const key = 'nutrition.calculator';

  @override
  Future<CalculatorChoice> build() async {
    final raw = await ref.watch(appDatabaseProvider).readMeta(key);
    final json = raw == null
        ? const <String, dynamic>{}
        : jsonDecode(raw) as Map<String, dynamic>;
    return CalculatorChoice(
      goal:
          NutritionGoal.values.asNameMap()[json['goal']] ??
          NutritionGoal.maintenance,
      activity:
          ActivityLevel.values.asNameMap()[json['activity']] ??
          ActivityLevel.moderate,
    );
  }

  Future<void> set(CalculatorChoice choice) async {
    state = AsyncData(choice);
    await ref
        .read(appDatabaseProvider)
        .writeMeta(
          key,
          jsonEncode({
            'goal': choice.goal.name,
            'activity': choice.activity.name,
          }),
        );
  }
}
