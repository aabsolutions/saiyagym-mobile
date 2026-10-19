import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Overlays a "waking up the server" notice on top of the whole app while
/// [slow] is true (a request has been waiting > 3 s, see
/// `SlowRequestMonitor`).
class ServerWakingBanner extends StatelessWidget {
  const ServerWakingBanner({
    required this.slow,
    required this.child,
    super.key,
  });

  final ValueListenable<bool> slow;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: slow,
      child: child,
      builder: (context, isSlow, child) => Column(
        children: [
          AnimatedSize(
            duration: const Duration(milliseconds: 200),
            child: isSlow
                ? const _Notice()
                : const SizedBox(width: double.infinity),
          ),
          Expanded(
            // The notice already consumed the status bar inset.
            child: isSlow
                ? MediaQuery.removePadding(
                    context: context,
                    removeTop: true,
                    child: child!,
                  )
                : child!,
          ),
        ],
      ),
    );
  }
}

class _Notice extends StatelessWidget {
  const _Notice();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    return Material(
      color: scheme.secondaryContainer,
      child: SafeArea(
        bottom: false,
        child: Semantics(
          liveRegion: true,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            child: Row(
              children: [
                SizedBox.square(
                  dimension: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    color: scheme.onSecondaryContainer,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.tr('server.waking.title'),
                        style: text.titleSmall?.copyWith(
                          color: scheme.onSecondaryContainer,
                        ),
                      ),
                      Text(
                        context.tr('server.waking.message'),
                        style: text.bodyMedium?.copyWith(
                          color: scheme.onSecondaryContainer,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
