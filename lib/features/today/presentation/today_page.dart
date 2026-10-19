import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:saiyagym_mobile/core/widgets/empty_state.dart';
import 'package:saiyagym_mobile/core/widgets/sync_status_button.dart';

class TodayPage extends StatelessWidget {
  const TodayPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('today.title')),
        actions: const [SyncStatusButton()],
      ),
      body: EmptyState(
        icon: Icons.today,
        title: context.tr('today.emptyTitle'),
        message: context.tr('today.emptyMessage'),
      ),
    );
  }
}
