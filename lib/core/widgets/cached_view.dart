import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saiyagym_mobile/core/cache/json_cache.dart';
import 'package:saiyagym_mobile/core/widgets/error_banner.dart';

/// Loading / error (no local copy either) / data + "offline since" note.
class CachedView<T> extends StatelessWidget {
  const CachedView({
    required this.value,
    required this.onRetry,
    required this.builder,
    this.loadingHeight = 180,
    super.key,
  });

  final AsyncValue<Cached<T>> value;
  final VoidCallback onRetry;
  final Widget Function(T data) builder;

  /// Height of the loading placeholder (keeps the layout from jumping).
  final double loadingHeight;

  @override
  Widget build(BuildContext context) => switch (value) {
    AsyncValue(:final value?) => Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [builder(value.data), CacheNote(value)],
    ),
    AsyncValue(:final error?) => Column(
      children: [
        Text(errorText(context, error), textAlign: TextAlign.center),
        TextButton(onPressed: onRetry, child: Text(context.tr('common.retry'))),
      ],
    ),
    _ => SizedBox(
      height: loadingHeight,
      child: const Center(child: CircularProgressIndicator()),
    ),
  };
}

/// "Offline · data from Oct 18, 10:00" when the API couldn't be reached.
class CacheNote extends StatelessWidget {
  const CacheNote(this.cached, {super.key});

  final Cached<Object?> cached;

  @override
  Widget build(BuildContext context) {
    if (!cached.fromCache) return const SizedBox.shrink();
    final theme = Theme.of(context);
    final when = DateFormat.MMMd(context.locale.toLanguageTag())
        .add_Hm()
        .format(cached.fetchedAt.toLocal());
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        children: [
          Icon(
            Icons.cloud_off,
            size: 16,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              context.tr('progress.cachedAt', namedArgs: {'date': when}),
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
