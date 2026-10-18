import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Bottom navigation. Each tab keeps its own navigation stack.
class HomeShell extends StatelessWidget {
  const HomeShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  // Same order as the shell branches in the router.
  static const List<(IconData, IconData, String)> _tabs = [
    (Icons.today_outlined, Icons.today, 'nav.today'),
    (Icons.fitness_center_outlined, Icons.fitness_center, 'nav.train'),
    (Icons.history_outlined, Icons.history, 'nav.history'),
    (Icons.insights_outlined, Icons.insights, 'nav.progress'),
    (Icons.person_outline, Icons.person, 'nav.profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        // Tapping the current tab pops it back to its root.
        onDestinationSelected: (index) => navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        ),
        destinations: [
          for (final (icon, selectedIcon, label) in _tabs)
            NavigationDestination(
              icon: Icon(icon),
              selectedIcon: Icon(selectedIcon),
              label: context.tr(label),
            ),
        ],
      ),
    );
  }
}
