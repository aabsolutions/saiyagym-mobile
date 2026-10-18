import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// Shown while the stored session is restored.
class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.fitness_center,
              size: 72,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(context.tr('app.name'), style: theme.textTheme.headlineSmall),
            const SizedBox(height: 32),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
