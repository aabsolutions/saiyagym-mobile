import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:saiyagym_mobile/core/widgets/empty_state.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.tr('history.title'))),
      body: EmptyState(
        icon: Icons.history,
        title: context.tr('history.emptyTitle'),
        message: context.tr('history.emptyMessage'),
      ),
    );
  }
}
