import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saiyagym_mobile/core/sync/sync_providers.dart';
import 'package:saiyagym_mobile/core/sync/sync_state.dart';
import 'package:saiyagym_mobile/core/widgets/error_banner.dart';

/// Global sync indicator for the app bars: synced, pending (n), syncing,
/// offline or error. Tap for details and actions.
class SyncStatusButton extends ConsumerWidget {
  const SyncStatusButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(syncStatusProvider);
    final scheme = Theme.of(context).colorScheme;
    final (icon, color) = switch (status.indicator) {
      SyncIndicator.synced => (Icons.cloud_done_outlined, scheme.primary),
      SyncIndicator.pending => (Icons.cloud_upload_outlined, scheme.onSurface),
      SyncIndicator.syncing => (Icons.cloud_sync_outlined, scheme.primary),
      SyncIndicator.offline => (Icons.cloud_off_outlined, scheme.outline),
      SyncIndicator.error => (Icons.sync_problem, scheme.error),
    };
    final count = status.indicator == SyncIndicator.error
        ? status.failed
        : status.pending;

    return IconButton(
      tooltip: syncStatusText(context, status),
      iconSize: 28,
      onPressed: () => showModalBottomSheet<void>(
        context: context,
        showDragHandle: true,
        isScrollControlled: true,
        builder: (_) => const SyncSheet(),
      ),
      icon: Badge(
        isLabelVisible: count > 0,
        label: Text('$count'),
        child: Icon(icon, color: color),
      ),
    );
  }
}

String syncStatusText(BuildContext context, SyncState status) =>
    switch (status.indicator) {
      SyncIndicator.synced => context.tr('sync.status.synced'),
      SyncIndicator.syncing => context.tr('sync.status.syncing'),
      SyncIndicator.pending => context.tr(
        'sync.status.pending',
        namedArgs: {'count': '${status.pending}'},
      ),
      SyncIndicator.offline => context.tr(
        status.pending > 0
            ? 'sync.status.offlinePending'
            : 'sync.status.offline',
        namedArgs: {'count': '${status.pending}'},
      ),
      SyncIndicator.error => context.tr('sync.status.error'),
    };

/// Details: what's going on, sync now, and the changes the API rejected.
class SyncSheet extends ConsumerWidget {
  const SyncSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(syncStatusProvider);
    final service = ref.read(syncServiceProvider);
    final failed = ref.watch(failedChangesProvider).value ?? const [];
    final theme = Theme.of(context);
    final lastError = status.lastError;

    return SafeArea(
      child: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        children: [
          Text(context.tr('sync.title'), style: theme.textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text(
            syncStatusText(context, status),
            style: theme.textTheme.bodyLarge,
          ),
          if (status.lastSyncedAt case final at?) ...[
            const SizedBox(height: 4),
            Text(
              context.tr(
                'sync.lastSynced',
                namedArgs: {
                  'time': DateFormat.yMMMd(context.locale.languageCode)
                      .add_Hm()
                      .format(at.toLocal()),
                },
              ),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
          if (lastError != null) ...[
            const SizedBox(height: 16),
            ErrorBanner(error: lastError),
          ],
          const SizedBox(height: 16),
          FilledButton.icon(
            icon: const Icon(Icons.sync),
            label: Text(context.tr('sync.now')),
            onPressed: status.syncing ? null : () => unawaited(service.sync()),
          ),
          if (failed.isNotEmpty) ...[
            const SizedBox(height: 24),
            Text(
              context.tr('sync.failedTitle'),
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Text(
              context.tr('sync.failedHelp'),
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            for (final entry in failed)
              _FailedChangeTile(
                entry: entry,
                onRetry: () => service.retryFailed(id: entry.id),
                onDiscard: () => _confirmDiscard(context, () {
                  unawaited(service.discard(entry));
                }),
              ),
          ],
        ],
      ),
    );
  }

  Future<void> _confirmDiscard(
    BuildContext context,
    VoidCallback discard,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(dialogContext.tr('sync.discard.title')),
        content: Text(dialogContext.tr('sync.discard.message')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(dialogContext.tr('common.cancel')),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(dialogContext.tr('sync.discard.confirm')),
          ),
        ],
      ),
    );
    if (confirmed ?? false) discard();
  }
}

class _FailedChangeTile extends StatelessWidget {
  const _FailedChangeTile({
    required this.entry,
    required this.onRetry,
    required this.onDiscard,
  });

  final FailedChange entry;
  final VoidCallback onRetry;
  final VoidCallback onDiscard;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final key = 'sync.collections.${entry.collection}';
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 8, 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.error_outline, color: scheme.error),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    key.trExists(context: context)
                        ? context.tr(key)
                        : entry.collection,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(entry.message ?? entry.code ?? ''),
            Align(
              alignment: Alignment.centerRight,
              child: Wrap(
                spacing: 8,
                children: [
                  TextButton(
                    onPressed: onDiscard,
                    child: Text(context.tr('sync.discard.action')),
                  ),
                  TextButton(
                    onPressed: onRetry,
                    child: Text(context.tr('common.retry')),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
