import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saiyagym_mobile/core/database/app_database.dart';

void main() {
  late AppDatabase database;

  setUp(() {
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
    database = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() => database.close());

  test('is at schema version 1 (drift_schemas/ must match)', () {
    expect(database.schemaVersion, 1);
  });

  test('meta entries are written, overwritten and deleted by key', () async {
    expect(await database.readMeta('sync.cursor'), isNull);

    await database.writeMeta('sync.cursor', '2026-10-18T10:00:00.000Z');
    await database.writeMeta('sync.cursor', '2026-10-18T11:00:00.000Z');
    expect(await database.readMeta('sync.cursor'), '2026-10-18T11:00:00.000Z');

    await database.deleteMeta('sync.cursor');
    expect(await database.readMeta('sync.cursor'), isNull);
  });
}
