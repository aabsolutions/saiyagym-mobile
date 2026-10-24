import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:saiyagym_mobile/app/router/app_routes.dart';
import 'package:saiyagym_mobile/core/widgets/sync_status_button.dart';
import 'package:saiyagym_mobile/features/exercises/presentation/exercises_page.dart';
import 'package:saiyagym_mobile/features/nutrition/presentation/nutrition_page.dart';

/// Reference material, like the web's catalog: exercises (with their
/// guides and execution steps) and nutrition. Primary tabs here; each
/// section keeps its own secondary tabs.
class LibraryPage extends StatefulWidget {
  const LibraryPage({this.section = LibrarySection.exercises, super.key});

  /// From `?section=` (e.g. Today's nutrition shortcut).
  final LibrarySection section;

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage>
    with SingleTickerProviderStateMixin {
  late final _tabs = TabController(
    length: LibrarySection.values.length,
    initialIndex: widget.section.index,
    vsync: this,
  );

  @override
  void didUpdateWidget(LibraryPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    // The branch keeps this page alive: a later link picks the section.
    if (oldWidget.section != widget.section) {
      _tabs.animateTo(widget.section.index);
    }
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(context.tr('library.title')),
      actions: const [SyncStatusButton()],
      bottom: TabBar(
        controller: _tabs,
        tabs: [
          Tab(
            icon: const Icon(Icons.fitness_center),
            text: context.tr('library.exercises'),
          ),
          Tab(
            icon: const Icon(Icons.restaurant_outlined),
            text: context.tr('library.nutrition'),
          ),
        ],
      ),
    ),
    body: TabBarView(
      controller: _tabs,
      // Swiping belongs to each section's own tabs.
      physics: const NeverScrollableScrollPhysics(),
      children: const [ExercisesView(), NutritionView()],
    ),
  );
}
