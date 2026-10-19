import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saiyagym_mobile/core/widgets/error_banner.dart';

/// Loading → spinner, error → message (+ retry), data → [builder]. Keeps
/// lists from flashing their empty state while the first rows load.
class AsyncBody<T> extends StatelessWidget {
  const AsyncBody({
    required this.value,
    required this.builder,
    this.onRetry,
    super.key,
  });

  final AsyncValue<T> value;
  final Widget Function(T data) builder;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    if (value.hasValue) return builder(value.requireValue);
    if (value.error case final error?) {
      return ErrorState(error: error, onRetry: onRetry);
    }
    return Center(
      child: Semantics(
        label: context.tr('common.loading'),
        child: const CircularProgressIndicator(),
      ),
    );
  }
}

class ErrorState extends StatelessWidget {
  const ErrorState({required this.error, this.onRetry, super.key});

  final Object error;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.error_outline,
            size: 48,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(height: 12),
          Text(errorText(context, error), textAlign: TextAlign.center),
          if (onRetry != null) ...[
            const SizedBox(height: 12),
            FilledButton.tonal(
              onPressed: onRetry,
              child: Text(context.tr('common.retry')),
            ),
          ],
        ],
      ),
    ),
  );
}
