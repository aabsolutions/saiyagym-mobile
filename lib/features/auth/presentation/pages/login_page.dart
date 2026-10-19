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

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    await ref
        .read(authFormControllerProvider.notifier)
        .login(email: _email.text, password: _password.text);
  }

  @override
  Widget build(BuildContext context) {
    final submission = ref.watch(authFormControllerProvider);

    return AuthScaffold(
      title: context.tr('auth.login.title'),
      subtitle: context.tr('auth.login.subtitle'),
      onBack: () => context.go(AppRoutes.welcome),
      children: [
        Form(
          key: _formKey,
          child: AutofillGroup(
            child: Column(
              children: [
                TextFormField(
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  autofillHints: const [AutofillHints.email],
                  textInputAction: TextInputAction.next,
                  validator: emailValidator(context),
                  decoration: InputDecoration(
                    labelText: context.tr('auth.email'),
                    prefixIcon: const Icon(Icons.mail_outline),
                  ),
                ),
                const SizedBox(height: 16),
                PasswordField(
                  controller: _password,
                  label: context.tr('auth.password'),
                  validator: requiredValidator(context),
                  autofillHints: const [AutofillHints.password],
                  onSubmitted: (_) => _submit(),
                ),
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () => context.go(AppRoutes.forgotPassword),
            child: Text(context.tr('auth.login.forgot')),
          ),
        ),
        if (submission case AsyncError(:final error)) ...[
          const SizedBox(height: 16),
          ErrorBanner(error: error),
        ],
        const SizedBox(height: 24),
        PrimaryButton(
          label: context.tr('auth.login.submit'),
          isLoading: submission.isLoading,
          onPressed: _submit,
        ),
        const SizedBox(height: 16),
        TextButton(
          onPressed: () => context.go(AppRoutes.register),
          child: Text(context.tr('auth.login.toRegister')),
        ),
      ],
    );
  }
}
