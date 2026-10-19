import 'package:drift/drift.dart';

/// Key/value app state: cached profile, sync cursor, catalog freshness, …
@DataClassName('AppMetaEntry')
class AppMeta extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column<Object>> get primaryKey => {key};
}

/// Every synced document: the full JSON (`data`, embedded lists included)
/// plus typed columns to filter and sort without decoding it.
///
/// `updatedAt` is the client clock that decides last-write-wins;
/// `deletedAt` set = logically deleted (kept so the deletion syncs).
mixin SyncedColumns on Table {
  TextColumn get id => text()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();
  TextColumn get data => text()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Global catalog (from `GET /exercises`, localized) + the user's custom
/// exercises (from sync pull). Read-only for the app.
@DataClassName('ExerciseRow')
class Exercises extends Table with SyncedColumns {
  BoolColumn get isGlobal => boolean()();

  /// Already in the UI language (custom ones resolved from their name map).
  TextColumn get name => text()();
  TextColumn get primaryMuscle => text()();
  TextColumn get equipment => text()();
}

/// Keyed by exercise on the server too: two devices creating "the same"
/// pref offline converge on one document. `id` is the server's.
@DataClassName('ExercisePrefRow')
class UserExercisePrefs extends Table with SyncedColumns {
  TextColumn get exerciseId => text()();
  BoolColumn get isFavorite => boolean().withDefault(const Constant(false))();

  @override
  Set<Column<Object>> get primaryKey => {exerciseId};
}

@DataClassName('RoutineRow')
class Routines extends Table with SyncedColumns {
  TextColumn get name => text()();
  DateTimeColumn get archivedAt => dateTime().nullable()();
}

/// Pull-only (created and edited through the API).
@DataClassName('ProgramRow')
class Programs extends Table with SyncedColumns {
  TextColumn get name => text()();
  TextColumn get status => text()();
}

@DataClassName('WorkoutRow')
class Workouts extends Table with SyncedColumns {
  DateTimeColumn get startedAt => dateTime()();

  /// `null` = in progress.
  DateTimeColumn get finishedAt => dateTime().nullable()();
  TextColumn get routineId => text().nullable()();
}

@DataClassName('BodyMetricRow')
class BodyMetrics extends Table with SyncedColumns {
  DateTimeColumn get measuredAt => dateTime()();
}

/// Local changes waiting for `POST /sync/push`. ONE entry per document:
/// a new edit replaces the payload but keeps the entry's position, so a
/// routine created before a workout using it is still pushed first.
@DataClassName('SyncQueueEntry')
class SyncQueue extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get collection => text()();
  TextColumn get docId => text()();

  /// `upsert` | `delete`.
  TextColumn get op => text()();

  /// The `doc` of the push change, already whitelisted for the API.
  TextColumn get payload => text()();

  /// Version being pushed; a result only clears the entry if unchanged.
  DateTimeColumn get docUpdatedAt => dateTime()();
  IntColumn get attempts => integer().withDefault(const Constant(0))();

  /// `pending` | `failed` (permanent: needs the user).
  TextColumn get status => text().withDefault(const Constant('pending'))();
  TextColumn get errorCode => text().nullable()();
  TextColumn get errorMessage => text().nullable()();
  DateTimeColumn get nextAttemptAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  List<Set<Column<Object>>> get uniqueKeys => [
    {collection, docId},
  ];
}
