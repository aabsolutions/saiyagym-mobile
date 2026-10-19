import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../tool/check_i18n.dart';

void main() {
  test('every language has the same keys and every used key exists', () {
    expect(checkI18n(), isEmpty);
  });

  test('the scanner sees the keys used in lib/', () {
    final used = usedKeys(Directory('lib'));
    expect(used.length, greaterThan(200));
    expect(used.keys, contains('nutrition.disclaimer'));
    expect(used.keys, contains(r'muscles.$m'));
  });

  test('reports missing keys, extra keys and placeholder mismatches', () {
    final root = Directory.systemTemp.createTempSync('i18n');
    addTearDown(() => root.deleteSync(recursive: true));
    final i18n = Directory('${root.path}/i18n')..createSync();
    final lib = Directory('${root.path}/lib')..createSync();
    File('${i18n.path}/es.json')
        .writeAsStringSync('{"a": {"b": "Hola {name}", "c": "x"}}');
    File('${i18n.path}/en.json')
        .writeAsStringSync('{"a": {"b": "Hi {user}", "d": "y"}}');
    File('${lib.path}/page.dart')
        .writeAsStringSync("final t = context.tr('a.c') + context.tr('a.zz');");

    final problems = checkI18n(i18nDir: i18n, libDir: lib);

    expect(problems, hasLength(4));
    expect(problems.join('\n'), contains('missing "a.c"'));
    expect(problems.join('\n'), contains('placeholders differ in "a.b"'));
    expect(problems.join('\n'), contains('"a.d" is not in es.json'));
    expect(problems.join('\n'), contains('unknown key "a.zz"'));
  });
}
