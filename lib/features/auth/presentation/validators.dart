import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';

// Client-side checks are UX only; the API validates again (strict DTOs).

final _email = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

/// Same bounds as `RegisterDto.password`.
const minPasswordLength = 8;
const maxPasswordLength = 128;

FormFieldValidator<String> emailValidator(BuildContext context) => (value) {
  final email = value?.trim() ?? '';
  if (email.isEmpty) return context.tr('validation.required');
  if (!_email.hasMatch(email)) return context.tr('validation.email');
  return null;
};

FormFieldValidator<String> requiredValidator(BuildContext context) =>
    (value) => (value == null || value.isEmpty)
    ? context.tr('validation.required')
    : null;

FormFieldValidator<String> newPasswordValidator(BuildContext context) =>
    (value) {
      final password = value ?? '';
      if (password.isEmpty) return context.tr('validation.required');
      if (password.length < minPasswordLength) {
        return context.tr(
          'validation.passwordMin',
          namedArgs: {'min': '$minPasswordLength'},
        );
      }
      if (password.length > maxPasswordLength) {
        return context.tr(
          'validation.passwordMax',
          namedArgs: {'max': '$maxPasswordLength'},
        );
      }
      return null;
    };
