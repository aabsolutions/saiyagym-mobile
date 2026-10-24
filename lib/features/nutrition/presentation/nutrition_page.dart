import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:saiyagym_mobile/features/nutrition/presentation/calculator_tab.dart';
import 'package:saiyagym_mobile/features/nutrition/presentation/foods_tab.dart';
import 'package:saiyagym_mobile/features/nutrition/presentation/guidelines_tab.dart';
import 'package:saiyagym_mobile/features/nutrition/presentation/meals_tab.dart';

/// Calculator · Meals · Guides · Foods (secondary tabs inside the Library),
/// under an always-visible "orientative, consult a professional" notice
/// (SPEC).
class NutritionView extends StatelessWidget {
  const NutritionView({super.key});

  @override
  Widget build(BuildContext context) => DefaultTabController(
    length: 4,
    child: Scaffold(
      appBar: TabBar.secondary(
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        tabs: [
          Tab(text: context.tr('nutrition.tabs.calculator')),
          Tab(text: context.tr('nutrition.tabs.meals')),
          Tab(text: context.tr('nutrition.tabs.guides')),
          Tab(text: context.tr('nutrition.tabs.foods')),
        ],
      ),
      body: const Column(
        children: [
          NutritionDisclaimer(),
          Expanded(
            child: TabBarView(
              children: [
                CalculatorTab(),
                MealsTab(),
                GuidelinesTab(),
                FoodsTab(),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

class NutritionDisclaimer extends StatelessWidget {
  const NutritionDisclaimer({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Semantics(
      container: true,
      child: ColoredBox(
        color: scheme.tertiaryContainer,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              Icon(
                Icons.health_and_safety_outlined,
                color: scheme.onTertiaryContainer,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  context.tr('nutrition.disclaimer'),
                  style: TextStyle(color: scheme.onTertiaryContainer),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
