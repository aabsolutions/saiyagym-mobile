import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:saiyagym_mobile/core/network/api_exception.dart';

/// Display text for any error.
///
/// 1. `errors.<code>` from the app's i18n files, when the app defines one
///    (client-side codes like NETWORK_ERROR, or an app-specific wording).
/// 2. The API's `message` (already localized via `Accept-Language`).
/// 3. A generic fallback.
String errorText(BuildContext context, Object error) {
  if (error is ApiException) {
    final key = 'errors.${error.code}';
    if (key.trExists(context: context)) return context.tr(key);
    final message = error.message;
    if (message != null && message.isNotEmpty) return message;
  }
  return context.tr('errors.${ApiException.unknown}');
}

class ErrorBanner extends StatelessWidget {
  const ErrorBanner({required this.error, super.key});

  final Object error;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Semantics(
      liveRegion: true,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: scheme.errorContainer,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(Icons.error_outline, color: scheme.onErrorContainer),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                errorText(context, error),
                style: Theme.of(context).textTheme.bodyLarge
                    ?.copyWith(color: scheme.onErrorContainer),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
