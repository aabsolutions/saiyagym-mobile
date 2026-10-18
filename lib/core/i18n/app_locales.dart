import 'package:flutter/widgets.dart';

/// A UI language. [nativeName] is data (how the language calls itself),
/// so the picker can list every language without loading its JSON.
class AppLanguage {
  const AppLanguage(this.code, this.nativeName);

  final String code;
  final String nativeName;

  Locale get locale => Locale(code);
}

/// Adding a language = drop `assets/i18n/<code>.json` + one entry here.
abstract final class AppLocales {
  static const path = 'assets/i18n';

  static const languages = [
    AppLanguage('es', 'Español'),
    AppLanguage('en', 'English'),
  ];

  static const fallback = Locale('es');

  static List<Locale> get supported => [
    for (final language in languages) language.locale,
  ];

  static bool isSupported(String? code) =>
      languages.any((language) => language.code == code);
}
