import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:saiyagym_mobile/core/widgets/empty_state.dart';

class ProgressPage extends StatelessWidget {
  const ProgressPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.tr('progress.title'))),
      body: EmptyState(
        icon: Icons.insights,
        title: context.tr('progress.emptyTitle'),
        message: context.tr('progress.emptyMessage'),
      ),
    );
  }
}
