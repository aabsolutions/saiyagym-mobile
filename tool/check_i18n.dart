// Checks the translation files (run from the project root):
//
//   dart run tool/check_i18n.dart
//
// 1. Every language has exactly the keys of the default one (es.json).
// 2. Every literal key used in lib/ (`tr('a.b')` / `context.tr('a.b')`)
//    exists; for interpolated keys (`'muscles.$m'`) the prefix must exist.
// 3. Placeholders (`{name}`) match between languages.
//
// Exit code 1 when something is wrong. Also run by test/i18n_test.dart.
import 'dart:convert';
import 'dart:io';

const defaultLanguage = 'es';

/// `{a: {b: 'x'}}` → `{'a.b': 'x'}`.
Map<String, String> flatten(Map<String, dynamic> json, [String prefix = '']) {
  final out = <String, String>{};
  json.forEach((key, value) {
    final path = prefix.isEmpty ? key : '$prefix.$key';
    if (value is Map) {
      out.addAll(flatten(Map<String, dynamic>.from(value), path));
    } else {
      out[path] = '$value';
    }
  });
  return out;
}

Set<String> placeholders(String text) => {
  for (final m in RegExp(r'\{(\w+)\}').allMatches(text)) m.group(1)!,
};

/// Keys passed to `tr(` as a string literal, with where they were found.
Map<String, String> usedKeys(Directory lib) {
  final pattern = RegExp(r"""\btr\(\s*\n?\s*'([a-zA-Z0-9_.${}]+)'""");
  final used = <String, String>{};
  for (final file in lib.listSync(recursive: true).whereType<File>()) {
    if (!file.path.endsWith('.dart') || file.path.endsWith('.g.dart')) {
      continue;
    }
    final source = file.readAsStringSync();
    for (final match in pattern.allMatches(source)) {
      used.putIfAbsent(match.group(1)!, () => file.path);
    }
  }
  return used;
}

List<String> checkI18n({Directory? i18nDir, Directory? libDir}) {
  final dir = i18nDir ?? Directory('assets/i18n');
  final files = {
    for (final f in dir.listSync().whereType<File>())
      if (f.path.endsWith('.json'))
        f.uri.pathSegments.last.replaceAll('.json', ''): flatten(
          jsonDecode(f.readAsStringSync()) as Map<String, dynamic>,
        ),
  };
  final problems = <String>[];
  final base = files[defaultLanguage];
  if (base == null) return ['missing $defaultLanguage.json'];

  for (final MapEntry(key: language, value: keys) in files.entries) {
    if (language == defaultLanguage) continue;
    for (final key in base.keys) {
      final translated = keys[key];
      if (translated == null) {
        problems.add('$language.json: missing "$key"');
      } else if (!_sameSet(
        placeholders(base[key]!),
        placeholders(translated),
      )) {
        problems.add('$language.json: placeholders differ in "$key"');
      }
    }
    for (final key in keys.keys) {
      if (!base.containsKey(key)) {
        problems.add('$language.json: "$key" is not in $defaultLanguage.json');
      }
    }
  }

  for (final MapEntry(:key, value: file) in usedKeys(
    libDir ?? Directory('lib'),
  ).entries) {
    final dollar = key.indexOf(r'$');
    final exists = dollar < 0
        ? base.containsKey(key)
        : base.keys.any((k) => k.startsWith(key.substring(0, dollar)));
    if (!exists) problems.add('$file: unknown key "$key"');
  }
  return problems;
}

bool _sameSet(Set<String> a, Set<String> b) =>
    a.length == b.length && a.containsAll(b);

void main() {
  final problems = checkI18n();
  if (problems.isEmpty) {
    stdout.writeln('i18n OK');
    return;
  }
  problems.forEach(stderr.writeln);
  exitCode = 1;
}
