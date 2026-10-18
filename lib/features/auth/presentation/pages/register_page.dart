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

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    await ref
        .read(authFormControllerProvider.notifier)
        .register(
          name: _name.text,
          email: _email.text,
          password: _password.text,
          // The API sends verification emails in this language.
          language: context.locale.languageCode,
        );
  }

  @override
  Widget build(BuildContext context) {
    final submission = ref.watch(authFormControllerProvider);

    return AuthScaffold(
      title: context.tr('auth.register.title'),
      subtitle: context.tr('auth.register.subtitle'),
      children: [
        Form(
          key: _formKey,
          child: AutofillGroup(
            child: Column(
              children: [
                TextFormField(
                  controller: _name,
                  textCapitalization: TextCapitalization.words,
                  autofillHints: const [AutofillHints.name],
                  textInputAction: TextInputAction.next,
                  maxLength: 80,
                  decoration: InputDecoration(
                    labelText: context.tr('auth.name'),
                    prefixIcon: const Icon(Icons.person_outline),
                    counterText: '',
                  ),
                ),
                const SizedBox(height: 16),
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
                  validator: newPasswordValidator(context),
                  autofillHints: const [AutofillHints.newPassword],
                  onSubmitted: (_) => _submit(),
                ),
              ],
            ),
          ),
        ),
        if (submission case AsyncError(:final error)) ...[
          const SizedBox(height: 16),
          ErrorBanner(error: error),
        ],
        const SizedBox(height: 24),
        PrimaryButton(
          label: context.tr('auth.register.submit'),
          isLoading: submission.isLoading,
          onPressed: _submit,
        ),
        const SizedBox(height: 16),
        TextButton(
          onPressed: () => context.go(AppRoutes.login),
          child: Text(context.tr('auth.register.toLogin')),
        ),
      ],
    );
  }
}
