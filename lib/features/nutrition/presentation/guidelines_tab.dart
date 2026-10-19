import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saiyagym_mobile/core/widgets/cached_view.dart';
import 'package:saiyagym_mobile/features/nutrition/domain/nutrition_calculator.dart';
import 'package:saiyagym_mobile/features/nutrition/nutrition_providers.dart';
import 'package:saiyagym_mobile/features/nutrition/presentation/calculator_tab.dart';

/// Short articles (protein, hydration, timing…) by goal.
class GuidelinesTab extends ConsumerStatefulWidget {
  const GuidelinesTab({super.key});

  @override
  ConsumerState<GuidelinesTab> createState() => _GuidelinesTabState();
}

class _GuidelinesTabState extends ConsumerState<GuidelinesTab> {
  NutritionGoal? _goal;

  @override
  Widget build(BuildContext context) => RefreshIndicator(
    onRefresh: () => ref.refresh(guidelinesProvider.future),
    child: ListView(
      padding: const EdgeInsets.all(16),
      children: [
        GoalSelector(
          value: _goal,
          allowAll: true,
          onChanged: (goal) => setState(() => _goal = goal),
        ),
        const SizedBox(height: 12),
        CachedView(
          value: ref.watch(guidelinesProvider),
          onRetry: () => ref.invalidate(guidelinesProvider),
          builder: (all) {
            final items = [
              for (final g in all)
                if (_goal == null || g.goals.contains(_goal)) g,
            ];
            if (items.isEmpty) {
              return Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  context.tr('nutrition.guides.empty'),
                  textAlign: TextAlign.center,
                ),
              );
            }
            return Column(
              children: [
                for (final guide in items)
                  Card(
                    child: ExpansionTile(
                      title: Text(guide.title),
                      subtitle: Text(guide.summary),
                      childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                      expandedCrossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (final paragraph in guide.body.split(
                          RegExp(r'\n\s*\n'),
                        ))
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Text(paragraph.trim()),
                          ),
                      ],
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    ),
  );
}
