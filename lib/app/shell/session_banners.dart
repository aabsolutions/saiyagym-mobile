import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saiyagym_mobile/core/widgets/error_banner.dart';
import 'package:saiyagym_mobile/features/auth/presentation/controllers/email_verification_controller.dart';
import 'package:saiyagym_mobile/features/auth/presentation/controllers/session_controller.dart';

/// Session notices above the bottom navigation: offline mode and an
/// unverified email. Offline wins: the email actions need the API.
class SessionBanners extends ConsumerStatefulWidget {
  const SessionBanners({super.key});

  @override
  ConsumerState<SessionBanners> createState() => _SessionBannersState();
}

class _SessionBannersState extends ConsumerState<SessionBanners> {
  bool _retrying = false;

  /// Hidden for this app run only; it comes back on the next start.
  bool _verificationDismissed = false;

  Future<void> _retry() async {
    setState(() => _retrying = true);
    try {
      await ref.read(sessionControllerProvider.notifier).refreshUser();
    } on Object catch (error) {
      if (mounted) _snack(errorText(context, error));
    } finally {
      if (mounted) setState(() => _retrying = false);
    }
  }

  void _snack(String text) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(sessionControllerProvider).value;
    if (session == null) return const SizedBox.shrink();

    ref.listen(emailVerificationControllerProvider, (_, next) {
      switch (next) {
        case AsyncData(value: VerificationOutcome.emailSent):
          _snack(
            context.tr(
              'verification.sent',
              namedArgs: {'email': session.user.email},
            ),
          );
        case AsyncData(value: VerificationOutcome.verified):
          _snack(context.tr('verification.done'));
        case AsyncData(value: VerificationOutcome.stillPending):
          _snack(context.tr('verification.pending'));
        case AsyncError(:final error):
          _snack(errorText(context, error));
        default:
          break;
      }
    });

    if (session.isOffline) {
      return _Banner(
        icon: Icons.cloud_off,
        message: context.tr('session.offline'),
        actions: [
          TextButton(
            onPressed: _retrying ? null : _retry,
            child: Text(context.tr('common.retry')),
          ),
        ],
      );
    }

    if (!session.user.emailVerified && !_verificationDismissed) {
      final busy = ref.watch(emailVerificationControllerProvider).isLoading;
      final verification = ref.read(
        emailVerificationControllerProvider.notifier,
      );
      return _Banner(
        icon: Icons.mark_email_unread_outlined,
        message: context.tr(
          'verification.banner',
          namedArgs: {'email': session.user.email},
        ),
        onClose: () => setState(() => _verificationDismissed = true),
        actions: [
          TextButton(
            onPressed: busy ? null : verification.resend,
            child: Text(context.tr('verification.resend')),
          ),
          TextButton(
            onPressed: busy ? null : verification.check,
            child: Text(context.tr('verification.check')),
          ),
        ],
      );
    }

    return const SizedBox.shrink();
  }
}

class _Banner extends StatelessWidget {
  const _Banner({
    required this.icon,
    required this.message,
    required this.actions,
    this.onClose,
  });

  final IconData icon;
  final String message;
  final List<Widget> actions;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: scheme.tertiaryContainer,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 8, 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, color: scheme.onTertiaryContainer),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    message,
                    style: Theme.of(context).textTheme.bodyMedium
                        ?.copyWith(color: scheme.onTertiaryContainer),
                  ),
                ),
                if (onClose != null)
                  IconButton(
                    tooltip: MaterialLocalizations.of(context)
                        .closeButtonTooltip,
                    icon: const Icon(Icons.close),
                    onPressed: onClose,
                  ),
              ],
            ),
            Wrap(spacing: 8, children: actions),
          ],
        ),
      ),
    );
  }
}
