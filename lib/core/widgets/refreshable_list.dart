import 'package:flutter/material.dart';

/// Pull-to-refresh that also works when the list is empty or short (the
/// empty state fills the viewport and can still be pulled).
class RefreshableList extends StatelessWidget {
  const RefreshableList({
    required this.onRefresh,
    required this.children,
    required this.empty,
    super.key,
  });

  final Future<void> Function() onRefresh;
  final List<Widget> children;
  final Widget empty;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: LayoutBuilder(
        builder: (context, constraints) => ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: children.isEmpty
              ? EdgeInsets.zero
              : const EdgeInsets.all(16),
          children: children.isEmpty
              ? [SizedBox(height: constraints.maxHeight, child: empty)]
              : children,
        ),
      ),
    );
  }
}
