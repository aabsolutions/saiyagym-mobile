import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:saiyagym_mobile/core/database/app_database.steps.dart';
import 'package:saiyagym_mobile/core/database/tables.dart';

export 'package:saiyagym_mobile/core/database/tables.dart';

part 'app_database.g.dart';

/// Local SQLite database (offline-first: the device writes here first).
///
/// Schema changes: bump [schemaVersion], run
/// `dart run drift_dev make-migrations` (exports `drift_schemas/` and
/// generates `app_database.steps.dart` + migration tests), then add the step
/// to `onUpgrade: stepByStep(...)`.
@DriftDatabase(
  tables: [
    AppMeta,
    Exercises,
    UserExercisePrefs,
    Routines,
    Programs,
    Workouts,
    BodyMetrics,
    SyncQueue,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
    : super(
        executor ??
            driftDatabase(
              name: 'saiyagym',
              // The background sync isolate (workmanager) opens it too.
              native: const DriftNativeOptions(shareAcrossIsolates: true),
            ),
      );

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    onUpgrade: stepByStep(
      from1To2: (m, schema) async {
        // v2: offline-first data + the sync queue.
        await m.createTable(schema.exercises);
        await m.createTable(schema.userExercisePrefs);
        await m.createTable(schema.routines);
        await m.createTable(schema.programs);
        await m.createTable(schema.workouts);
        await m.createTable(schema.bodyMetrics);
        await m.createTable(schema.syncQueue);
      },
    ),
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

  /// Empties every table (logout, or a different user signing in). New
  /// tables are covered automatically through [allTables].
  Future<void> wipe() => transaction(() async {
    for (final table in allTables) {
      await delete(table).go();
    }
  });

  Future<void> deleteMeta(String key) =>
      (delete(appMeta)..where((t) => t.key.equals(key))).go();
}
