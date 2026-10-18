import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

/// Small key/value store for app state: cached profile, sync cursor, …
@DataClassName('AppMetaEntry')
class AppMeta extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column<Object>> get primaryKey => {key};
}

/// Local SQLite database (offline-first: the device writes here first).
///
/// Schema changes: bump [schemaVersion], run
/// `dart run drift_dev make-migrations` (exports `drift_schemas/` and
/// generates `app_database.steps.dart` + migration tests), then add the step
/// to `onUpgrade: stepByStep(from1To2: …)`.
@DriftDatabase(tables: [AppMeta])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
    : super(executor ?? driftDatabase(name: 'saiyagym'));

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );

  Future<String?> readMeta(String key) => (select(
    appMeta,
  )..where((t) => t.key.equals(key))).map((row) => row.value).getSingleOrNull();

  Future<void> writeMeta(String key, String value) =>
      into(appMeta).insertOnConflictUpdate(
        AppMetaCompanion.insert(
          key: key,
          value: value,
          updatedAt: Value(DateTime.now().toUtc()),
        ),
      );

  Future<void> deleteMeta(String key) =>
      (delete(appMeta)..where((t) => t.key.equals(key))).go();
}
