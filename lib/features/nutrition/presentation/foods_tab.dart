import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saiyagym_mobile/core/widgets/cached_view.dart';
import 'package:saiyagym_mobile/features/nutrition/domain/nutrition_catalog.dart';
import 'package:saiyagym_mobile/features/nutrition/nutrition_providers.dart';
import 'package:saiyagym_mobile/features/profile/presentation/preferences_providers.dart';

/// Food search (accent-insensitive, on the device) with macros per 100 g.
class FoodsTab extends ConsumerStatefulWidget {
  const FoodsTab({super.key});

  @override
  ConsumerState<FoodsTab> createState() => _FoodsTabState();
}

class _FoodsTabState extends ConsumerState<FoodsTab> {
  String _query = '';
  String? _category;

  @override
  Widget build(BuildContext context) {
    final formatter = ref.unitFormatter(context);
    String grams(double v) => '${formatter.formatNumber(v)} g';

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: TextField(
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              hintText: context.tr('nutrition.foods.search'),
            ),
            onChanged: (value) => setState(() => _query = value),
          ),
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () => ref.refresh(foodsProvider.future),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              children: [
                CachedView(
                  value: ref.watch(foodsProvider),
                  onRetry: () => ref.invalidate(foodsProvider),
                  builder: (all) {
                    final categories = {
                      for (final f in all) f.category,
                    }.toList()..sort();
                    final foods = filterFoods(
                      all,
                      query: _query,
                      category: _category,
                    )..sort((a, b) => a.name.compareTo(b.name));
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              for (final c in categories)
                                Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: FilterChip(
                                    label: Text(
                                      context.tr('nutrition.categories.$c'),
                                    ),
                                    selected: _category == c,
                                    onSelected: (on) => setState(
                                      () => _category = on ? c : null,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        if (foods.isEmpty)
                          Padding(
                            padding: const EdgeInsets.all(24),
                            child: Text(
                              context.tr('nutrition.foods.empty'),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        for (final food in foods)
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(food.name),
                            subtitle: Text(
                              context.tr(
                                'nutrition.macroLine',
                                namedArgs: {
                                  'protein': grams(food.per100g.proteinG),
                                  'carbs': grams(food.per100g.carbsG),
                                  'fat': grams(food.per100g.fatG),
                                },
                              ),
                            ),
                            trailing: Text(
                              context.tr(
                                'nutrition.kcalPer100',
                                namedArgs: {
                                  'value': food.per100g.kcal.round().toString(),
                                },
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
