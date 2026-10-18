import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// Shared layout of the auth screens: brand header + scrollable form.
class AuthScaffold extends StatelessWidget {
  const AuthScaffold({
    required this.title,
    required this.subtitle,
    required this.children,
    super.key,
  });

  final String title;
  final String subtitle;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.all(24),
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: CircleAvatar(
                    radius: 32,
                    backgroundColor: theme.colorScheme.primary,
                    child: Icon(
                      Icons.fitness_center,
                      size: 32,
                      color: theme.colorScheme.onPrimary,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  context.tr('app.name'),
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(title, style: theme.textTheme.headlineMedium),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 32),
                ...children,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Password field with a show/hide toggle (large tap target).
class PasswordField extends StatefulWidget {
  const PasswordField({
    required this.controller,
    required this.label,
    required this.validator,
    required this.autofillHints,
    this.onSubmitted,
    super.key,
  });

  final TextEditingController controller;
  final String label;
  final FormFieldValidator<String> validator;
  final Iterable<String> autofillHints;
  final ValueChanged<String>? onSubmitted;

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscured = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: _obscured,
      autofillHints: widget.autofillHints,
      textInputAction: TextInputAction.done,
      onFieldSubmitted: widget.onSubmitted,
      validator: widget.validator,
      decoration: InputDecoration(
        labelText: widget.label,
        prefixIcon: const Icon(Icons.lock_outline),
        suffixIcon: IconButton(
          iconSize: 26,
          tooltip: context.tr(
            _obscured ? 'auth.showPassword' : 'auth.hidePassword',
          ),
          icon: Icon(_obscured ? Icons.visibility : Icons.visibility_off),
          onPressed: () => setState(() => _obscured = !_obscured),
        ),
      ),
    );
  }
}
