import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:saiyagym_mobile/app/router/app_routes.dart';
import 'package:saiyagym_mobile/core/feedback/haptics.dart';
import 'package:saiyagym_mobile/core/training/training_types.dart';
import 'package:saiyagym_mobile/core/widgets/async_body.dart';
import 'package:saiyagym_mobile/features/auth/domain/entities/user.dart';
import 'package:saiyagym_mobile/features/auth/presentation/controllers/session_controller.dart';
import 'package:saiyagym_mobile/features/exercises/domain/exercise.dart';
import 'package:saiyagym_mobile/features/exercises/domain/exercise_catalog.dart';
import 'package:saiyagym_mobile/features/exercises/exercises_providers.dart';

String tierLabel(Tier tier) => tier.name.toUpperCase();

/// Catalog list with filters, and the S/A/B/C tier board. Offline: it is
/// the local copy of the catalog plus the user's custom exercises.
class ExercisesPage extends ConsumerStatefulWidget {
  const ExercisesPage({super.key});

  @override
  ConsumerState<ExercisesPage> createState() => _ExercisesPageState();
}

class _ExercisesPageState extends ConsumerState<ExercisesPage> {
  ExerciseFilter _filter = const ExerciseFilter();
  late Goal _goal;
  TierSource _source = TierSource.global;
  String? _tierMuscle;

  @override
  void initState() {
    super.initState();
    _goal =
        ref.read(currentUserProvider)?.profile.goal == TrainingGoal.powerlifting
        ? Goal.powerlifting
        : Goal.hypertrophy;
  }

  @override
  Widget build(BuildContext context) {
    final catalog = ref.watch(exerciseCatalogProvider);
    final exercises = catalog.value ?? const <Exercise>[];
    final prefs =
        ref.watch(exercisePrefsProvider).value ??
        const <String, ExercisePref>{};

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(context.tr('exercises.title')),
          bottom: TabBar(
            tabs: [
              Tab(text: context.tr('exercises.tabs.list')),
              Tab(text: context.tr('exercises.tabs.tiers')),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          icon: const Icon(Icons.add),
          label: Text(context.tr('exercises.create')),
          onPressed: () => context.go(AppRoutes.newExercise),
        ),
        body: AsyncBody(
          value: catalog,
          onRetry: () => ref.invalidate(exerciseCatalogProvider),
          builder: (_) => TabBarView(
            children: [
              _ListTab(
                exercises: filterExercises(exercises, _filter, prefs),
                prefs: prefs,
                filter: _filter,
                onFilter: (filter) => setState(() => _filter = filter),
              ),
              _TierTab(
                board: tierBoard(
                  exercises,
                  goal: _goal,
                  prefs: prefs,
                  source: _source,
                  muscle: _tierMuscle,
                ),
                goal: _goal,
                source: _source,
                muscle: _tierMuscle,
                onGoal: (goal) => setState(() => _goal = goal),
                onSource: (source) => setState(() => _source = source),
                onMuscle: (muscle) => setState(() => _tierMuscle = muscle),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ListTab extends ConsumerWidget {
  const _ListTab({
    required this.exercises,
    required this.prefs,
    required this.filter,
    required this.onFilter,
  });

  final List<Exercise> exercises;
  final Map<String, ExercisePref> prefs;
  final ExerciseFilter filter;
  final ValueChanged<ExerciseFilter> onFilter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repository = ref.read(exercisesRepositoryProvider);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          child: TextField(
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              hintText: context.tr('live.picker.search'),
            ),
            onChanged: (value) => onFilter(filter.copyWith(search: value)),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              _ChoiceMenu(
                label: filter.muscle == null
                    ? context.tr('exercises.filters.muscle')
                    : context.tr('muscles.${filter.muscle}'),
                active: filter.muscle != null,
                options: muscles,
                optionLabel: (m) => context.tr('muscles.$m'),
                onSelected: (m) => onFilter(filter.copyWith(muscle: () => m)),
              ),
              _ChoiceMenu(
                label: filter.equipment == null
                    ? context.tr('exercises.filters.equipment')
                    : context.tr('equipment.${filter.equipment}'),
                active: filter.equipment != null,
                options: equipments,
                optionLabel: (e) => context.tr('equipment.$e'),
                onSelected: (e) =>
                    onFilter(filter.copyWith(equipment: () => e)),
              ),
              Padding(
                padding: const EdgeInsets.all(4),
                child: FilterChip(
                  label: Text(context.tr('exercises.filters.favorites')),
                  selected: filter.favoritesOnly,
                  onSelected: (v) =>
                      onFilter(filter.copyWith(favoritesOnly: v)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4),
                child: FilterChip(
                  label: Text(context.tr('exercises.filters.custom')),
                  selected: filter.customOnly,
                  onSelected: (v) => onFilter(filter.copyWith(customOnly: v)),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: exercises.isEmpty
              ? Center(child: Text(context.tr('exercises.noResults')))
              : ListView.builder(
                  padding: const EdgeInsets.only(bottom: 96),
                  itemCount: exercises.length,
                  itemBuilder: (context, index) {
                    final exercise = exercises[index];
                    final favorite = prefs[exercise.id]?.isFavorite ?? false;
                    return ListTile(
                      title: Text(exercise.name),
                      subtitle: Text(
                        [
                          context.tr('muscles.${exercise.primaryMuscle}'),
                          context.tr('equipment.${exercise.equipment}'),
                          if (!exercise.isGlobal)
                            context.tr('exercises.customTag'),
                        ].join(' · '),
                      ),
                      trailing: IconButton(
                        tooltip: context.tr(
                          favorite
                              ? 'exercises.unfavorite'
                              : 'exercises.favorite',
                        ),
                        icon: Icon(favorite ? Icons.star : Icons.star_border),
                        color: favorite
                            ? Theme.of(context).colorScheme.primary
                            : null,
                        onPressed: () {
                          unawaited(confirmHaptic());
                          unawaited(
                            repository.setFavorite(
                              exercise.id,
                              favorite: !favorite,
                            ),
                          );
                        },
                      ),
                      onTap: () => context.go(AppRoutes.exercise(exercise.id)),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class _ChoiceMenu extends StatelessWidget {
  const _ChoiceMenu({
    required this.label,
    required this.active,
    required this.options,
    required this.optionLabel,
    required this.onSelected,
  });

  final String label;
  final bool active;
  final List<String> options;
  final String Function(String option) optionLabel;

  /// `null` = clear.
  final ValueChanged<String?> onSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: PopupMenuButton<String>(
        tooltip: label,
        onSelected: (value) => onSelected(value.isEmpty ? null : value),
        itemBuilder: (_) => [
          PopupMenuItem(
            value: '',
            child: Text(context.tr('exercises.filters.all')),
          ),
          for (final option in options)
            PopupMenuItem(value: option, child: Text(optionLabel(option))),
        ],
        child: Chip(
          avatar: Icon(
            active ? Icons.filter_alt : Icons.arrow_drop_down,
            size: 18,
          ),
          label: Text(label),
          backgroundColor: active
              ? Theme.of(context).colorScheme.secondaryContainer
              : null,
        ),
      ),
    );
  }
}

class _TierTab extends StatelessWidget {
  const _TierTab({
    required this.board,
    required this.goal,
    required this.source,
    required this.muscle,
    required this.onGoal,
    required this.onSource,
    required this.onMuscle,
  });

  final Map<Tier?, List<Exercise>> board;
  final Goal goal;
  final TierSource source;
  final String? muscle;
  final ValueChanged<Goal> onGoal;
  final ValueChanged<TierSource> onSource;
  final ValueChanged<String?> onMuscle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = {
      Tier.s: theme.colorScheme.primary,
      Tier.a: theme.colorScheme.tertiary,
      Tier.b: theme.colorScheme.secondary,
      Tier.c: theme.colorScheme.outline,
    };
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 96),
      children: [
        SegmentedButton<Goal>(
          segments: [
            for (final g in Goal.values)
              ButtonSegment(
                value: g,
                label: Text(context.tr('profile.goals.${g.name}.title')),
              ),
          ],
          selected: {goal},
          onSelectionChanged: (value) => onGoal(value.single),
        ),
        const SizedBox(height: 8),
        SegmentedButton<TierSource>(
          segments: [
            ButtonSegment(
              value: TierSource.global,
              label: Text(context.tr('exercises.tiers.global')),
            ),
            ButtonSegment(
              value: TierSource.personal,
              label: Text(context.tr('exercises.tiers.personal')),
            ),
          ],
          selected: {source},
          onSelectionChanged: (value) => onSource(value.single),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: _ChoiceMenu(
            label: muscle == null
                ? context.tr('exercises.filters.allMuscles')
                : context.tr('muscles.$muscle'),
            active: muscle != null,
            options: muscles,
            optionLabel: (m) => context.tr('muscles.$m'),
            onSelected: onMuscle,
          ),
        ),
        for (final MapEntry(key: tier, value: items) in board.entries)
          if (items.isNotEmpty)
            Card(
              margin: const EdgeInsets.only(top: 12),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: tier == null
                            ? theme.colorScheme.surfaceContainerHighest
                            : colors[tier],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        tier == null ? '–' : tierLabel(tier),
                        style: theme.textTheme.headlineSmall?.copyWith(
                          color: tier == null
                              ? null
                              : theme.colorScheme.surface,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: [
                          for (final exercise in items)
                            ActionChip(
                              label: Text(exercise.name),
                              onPressed: () =>
                                  context.go(AppRoutes.exercise(exercise.id)),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
      ],
    );
  }
}
