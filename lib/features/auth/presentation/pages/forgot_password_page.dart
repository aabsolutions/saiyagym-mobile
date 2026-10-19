import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:saiyagym_mobile/app/router/app_routes.dart';
import 'package:saiyagym_mobile/core/widgets/error_banner.dart';
import 'package:saiyagym_mobile/core/widgets/primary_button.dart';
import 'package:saiyagym_mobile/features/auth/presentation/controllers/auth_form_controller.dart';
import 'package:saiyagym_mobile/features/auth/presentation/validators.dart';
import 'package:saiyagym_mobile/features/auth/presentation/widgets/auth_scaffold.dart';

/// Requests the reset email. The link opens the web app, which sets the
/// new password (same flow as on the web).
class ForgotPasswordPage extends ConsumerStatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  ConsumerState<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends ConsumerState<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    await ref
        .read(forgotPasswordControllerProvider.notifier)
        .submit(_email.text);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(forgotPasswordControllerProvider);
    final sent = state.value ?? false;

    return AuthScaffold(
      title: context.tr('auth.forgot.title'),
      subtitle: context.tr(sent ? 'auth.forgot.sent' : 'auth.forgot.subtitle'),
      onBack: () => context.go(AppRoutes.login),
      children: [
        if (sent)
          PrimaryButton(
            label: context.tr('auth.forgot.backToLogin'),
            onPressed: () => context.go(AppRoutes.login),
          )
        else ...[
          Form(
            key: _formKey,
            child: TextFormField(
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              autofillHints: const [AutofillHints.email],
              textInputAction: TextInputAction.send,
              onFieldSubmitted: (_) => _submit(),
              validator: emailValidator(context),
              decoration: InputDecoration(
                labelText: context.tr('auth.email'),
                prefixIcon: const Icon(Icons.mail_outline),
              ),
            ),
          ),
          if (state case AsyncError(:final error)) ...[
            const SizedBox(height: 16),
            ErrorBanner(error: error),
          ],
          const SizedBox(height: 24),
          PrimaryButton(
            label: context.tr('auth.forgot.submit'),
            isLoading: state.isLoading,
            onPressed: _submit,
          ),
        ],
      ],
    );
  }
}
