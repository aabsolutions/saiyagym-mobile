import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:saiyagym_mobile/core/widgets/empty_state.dart';

class TrainPage extends StatelessWidget {
  const TrainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.tr('train.title'))),
      body: EmptyState(
        icon: Icons.fitness_center,
        title: context.tr('train.emptyTitle'),
        message: context.tr('train.emptyMessage'),
      ),
    );
  }
}
