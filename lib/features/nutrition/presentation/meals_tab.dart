import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saiyagym_mobile/core/units/unit_formatter.dart';
import 'package:saiyagym_mobile/core/widgets/cached_view.dart';
import 'package:saiyagym_mobile/features/nutrition/domain/nutrition_calculator.dart';
import 'package:saiyagym_mobile/features/nutrition/domain/nutrition_catalog.dart';
import 'package:saiyagym_mobile/features/nutrition/nutrition_providers.dart';
import 'package:saiyagym_mobile/features/nutrition/presentation/calculator_tab.dart';
import 'package:saiyagym_mobile/features/plans/domain/entitlements.dart';
import 'package:saiyagym_mobile/features/plans/presentation/upgrade_cta.dart';
import 'package:saiyagym_mobile/features/profile/presentation/preferences_providers.dart';

/// Meal ideas by goal and meal. Free sees the API's sample + an upgrade CTA.
class MealsTab extends ConsumerStatefulWidget {
  const MealsTab({super.key});

  @override
  ConsumerState<MealsTab> createState() => _MealsTabState();
}

class _MealsTabState extends ConsumerState<MealsTab> {
  NutritionGoal? _goal;
  MealType? _type;

  @override
  Widget build(BuildContext context) {
    final formatter = ref.unitFormatter(context);
    return RefreshIndicator(
      onRefresh: () => ref.refresh(mealSuggestionsProvider.future),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          GoalSelector(
            value: _goal,
            allowAll: true,
            onChanged: (goal) => setState(() => _goal = goal),
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (final type in MealType.values)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(
                        context.tr('nutrition.mealTypes.${type.api}'),
                      ),
                      selected: _type == type,
                      onSelected: (on) =>
                          setState(() => _type = on ? type : null),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          CachedView(
            value: ref.watch(mealSuggestionsProvider),
            onRetry: () => ref.invalidate(mealSuggestionsProvider),
            builder: (data) {
              final meals = filterMeals(data.items, goal: _goal, type: _type);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (meals.isEmpty)
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        context.tr('nutrition.meals.empty'),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  for (final meal in meals)
                    _MealCard(meal: meal, formatter: formatter),
                  if (data.limitedByPlan) ...[
                    const SizedBox(height: 8),
                    if (data.lockedCount > 0)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text(
                          context.tr(
                            'nutrition.meals.locked',
                            namedArgs: {'count': '${data.lockedCount}'},
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    UpgradeCta.feature(PlanFeature.fullNutrition),
                  ],
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _MealCard extends StatelessWidget {
  const _MealCard({required this.meal, required this.formatter});

  final MealSuggestion meal;
  final UnitFormatter formatter;

  @override
  Widget build(BuildContext context) {
    final totals = meal.totals;
    String grams(double value) => '${formatter.formatNumber(value)} g';
    final kcal = context.tr(
      'nutrition.kcal',
      namedArgs: {'value': totals.kcal.round().toString()},
    );
    return Card(
      child: ExpansionTile(
        title: Text(meal.name),
        subtitle: Text(
          '${context.tr('nutrition.mealTypes.${meal.mealType.api}')} · '
          '$kcal',
        ),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (meal.description.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(meal.description),
            ),
          for (final item in meal.items)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                children: [
                  Expanded(child: Text(item.name)),
                  Text(grams(item.grams)),
                ],
              ),
            ),
          const SizedBox(height: 8),
          Text(
            context.tr(
              'nutrition.macroLine',
              namedArgs: {
                'protein': grams(totals.proteinG),
                'carbs': grams(totals.carbsG),
                'fat': grams(totals.fatG),
              },
            ),
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
