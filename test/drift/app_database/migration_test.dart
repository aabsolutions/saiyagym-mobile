// dart format width=80
import 'package:drift/drift.dart';
import 'package:drift_dev/api/migrations_native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saiyagym_mobile/core/database/app_database.dart';

import 'generated/schema.dart';

import 'generated/schema_v1.dart' as v1;
import 'generated/schema_v2.dart' as v2;

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  late SchemaVerifier verifier;

  setUpAll(() {
    verifier = SchemaVerifier(GeneratedHelper());
  });

  group('simple database migrations', () {
    // These simple tests verify all possible schema updates with a simple (no
    // data) migration. This is a quick way to ensure that written database
    // migrations properly alter the schema.
    const versions = GeneratedHelper.versions;
    for (final (i, fromVersion) in versions.indexed) {
      group('from $fromVersion', () {
        for (final toVersion in versions.skip(i + 1)) {
          test('to $toVersion', () async {
            final schema = await verifier.schemaAt(fromVersion);
            final db = AppDatabase(schema.newConnection());
            await verifier.migrateAndValidate(db, toVersion);
            await db.close();
          });
        }
      });
    }
  });

  // v1 → v2 only adds tables, but app_meta holds the cached session: a user
  // updating the app must stay signed in (and keep the sync cursor).
  test('migration from v1 to v2 keeps app_meta', () async {
    const rows = [
      v1.AppMetaData(
        key: 'session.user',
        value: '{"id":"user-1"}',
        updatedAt: '2026-10-18T10:00:00.000Z',
      ),
      v1.AppMetaData(
        key: 'sync.cursor',
        value: '2026-10-18T09:00:00.000Z',
        updatedAt: '2026-10-18T10:00:00.000Z',
      ),
    ];

    await verifier.testWithDataIntegrity(
      oldVersion: 1,
      newVersion: 2,
      createOld: v1.DatabaseAtV1.new,
      createNew: v2.DatabaseAtV2.new,
      openTestedDatabase: AppDatabase.new,
      createItems: (batch, oldDb) => batch.insertAll(oldDb.appMeta, rows),
      validateItems: (newDb) async {
        final migrated = await newDb.select(newDb.appMeta).get();
        expect(
          {for (final row in migrated) row.key: row.value},
          {for (final row in rows) row.key: row.value},
        );
        expect(await newDb.select(newDb.syncQueue).get(), isEmpty);
      },
    );
  });
}
