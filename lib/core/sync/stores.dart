import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:saiyagym_mobile/core/database/app_database.dart';
import 'package:saiyagym_mobile/core/sync/sync_collection.dart';
import 'package:saiyagym_mobile/core/sync/synced_store.dart';

// One store per synced table: which typed columns come from the JSON.

class WorkoutsStore extends SyncedStore<$WorkoutsTable, WorkoutRow> {
  WorkoutsStore(super.db);

  @override
  SyncCollection get collection => SyncCollection.workouts;
  @override
  TableInfo<$WorkoutsTable, WorkoutRow> get table => db.workouts;

  @override
  Insertable<WorkoutRow> toRow(
    Map<String, dynamic> json, {
    required String id,
    required DateTime updatedAt,
    required DateTime? deletedAt,
  }) => WorkoutsCompanion.insert(
    id: id,
    updatedAt: updatedAt,
    deletedAt: Value(deletedAt),
    data: jsonEncode(json),
    startedAt: parseUtc(json['startedAt']) ?? updatedAt,
    finishedAt: Value(parseUtc(json['finishedAt'])),
    routineId: Value(json['routineId'] as String?),
  );

  @override
  LocalDoc toDoc(WorkoutRow row) => LocalDoc(
    id: row.id,
    updatedAt: row.updatedAt,
    deletedAt: row.deletedAt,
    json: decodeData(row.data),
  );
}

class RoutinesStore extends SyncedStore<$RoutinesTable, RoutineRow> {
  RoutinesStore(super.db);

  @override
  SyncCollection get collection => SyncCollection.routines;
  @override
  TableInfo<$RoutinesTable, RoutineRow> get table => db.routines;

  @override
  Insertable<RoutineRow> toRow(
    Map<String, dynamic> json, {
    required String id,
    required DateTime updatedAt,
    required DateTime? deletedAt,
  }) => RoutinesCompanion.insert(
    id: id,
    updatedAt: updatedAt,
    deletedAt: Value(deletedAt),
    data: jsonEncode(json),
    name: json['name'] as String? ?? '',
    archivedAt: Value(parseUtc(json['archivedAt'])),
  );

  @override
  LocalDoc toDoc(RoutineRow row) => LocalDoc(
    id: row.id,
    updatedAt: row.updatedAt,
    deletedAt: row.deletedAt,
    json: decodeData(row.data),
  );
}

class ProgramsStore extends SyncedStore<$ProgramsTable, ProgramRow> {
  ProgramsStore(super.db);

  @override
  SyncCollection get collection => SyncCollection.programs;
  @override
  TableInfo<$ProgramsTable, ProgramRow> get table => db.programs;

  @override
  Insertable<ProgramRow> toRow(
    Map<String, dynamic> json, {
    required String id,
    required DateTime updatedAt,
    required DateTime? deletedAt,
  }) => ProgramsCompanion.insert(
    id: id,
    updatedAt: updatedAt,
    deletedAt: Value(deletedAt),
    data: jsonEncode(json),
    name: json['name'] as String? ?? '',
    status: json['status'] as String? ?? 'draft',
  );

  @override
  LocalDoc toDoc(ProgramRow row) => LocalDoc(
    id: row.id,
    updatedAt: row.updatedAt,
    deletedAt: row.deletedAt,
    json: decodeData(row.data),
  );
}

class BodyMetricsStore extends SyncedStore<$BodyMetricsTable, BodyMetricRow> {
  BodyMetricsStore(super.db);

  @override
  SyncCollection get collection => SyncCollection.bodyMetrics;
  @override
  TableInfo<$BodyMetricsTable, BodyMetricRow> get table => db.bodyMetrics;

  @override
  Insertable<BodyMetricRow> toRow(
    Map<String, dynamic> json, {
    required String id,
    required DateTime updatedAt,
    required DateTime? deletedAt,
  }) => BodyMetricsCompanion.insert(
    id: id,
    updatedAt: updatedAt,
    deletedAt: Value(deletedAt),
    data: jsonEncode(json),
    measuredAt: parseUtc(json['measuredAt']) ?? updatedAt,
  );

  @override
  LocalDoc toDoc(BodyMetricRow row) => LocalDoc(
    id: row.id,
    updatedAt: row.updatedAt,
    deletedAt: row.deletedAt,
    json: decodeData(row.data),
  );
}

/// Primary key is `exerciseId`: the server keys prefs by (user, exercise),
/// so a pref created offline with one id converges on the server's id.
class ExercisePrefsStore
    extends SyncedStore<$UserExercisePrefsTable, ExercisePrefRow> {
  ExercisePrefsStore(super.db);

  @override
  SyncCollection get collection => SyncCollection.userExercisePrefs;
  @override
  TableInfo<$UserExercisePrefsTable, ExercisePrefRow> get table =>
      db.userExercisePrefs;

  @override
  Insertable<ExercisePrefRow> toRow(
    Map<String, dynamic> json, {
    required String id,
    required DateTime updatedAt,
    required DateTime? deletedAt,
  }) => UserExercisePrefsCompanion.insert(
    id: id,
    updatedAt: updatedAt,
    deletedAt: Value(deletedAt),
    data: jsonEncode(json),
    exerciseId: json['exerciseId'] as String,
    isFavorite: Value(json['isFavorite'] as bool? ?? false),
  );

  @override
  LocalDoc toDoc(ExercisePrefRow row) => LocalDoc(
    id: row.id,
    updatedAt: row.updatedAt,
    deletedAt: row.deletedAt,
    json: decodeData(row.data),
  );

  @override
  Future<LocalDoc?> findIncoming(Map<String, dynamic> doc) async =>
      await find(doc['id'] as String) ??
      await findByExercise(doc['exerciseId'] as String);

  Future<LocalDoc?> findByExercise(String exerciseId) async {
    final row = await (db.select(
      table,
    )..where((t) => t.exerciseId.equals(exerciseId))).getSingleOrNull();
    return row == null ? null : toDoc(row);
  }

  /// The push result named a different stored id: adopt it.
  Future<void> adoptServerId(String localId, String serverId) async {
    final doc = await find(localId);
    if (doc == null) return;
    await (db.update(table)..where((t) => t.id.equals(localId))).write(
      UserExercisePrefsCompanion(
        id: Value(serverId),
        data: Value(jsonEncode({...doc.json, 'id': serverId})),
      ),
    );
  }
}

/// Custom exercises (pulled) and the global catalog (`ExerciseCatalogSync`).
class ExercisesStore extends SyncedStore<$ExercisesTable, ExerciseRow> {
  ExercisesStore(super.db, {required this.languageCode});

  /// Custom exercises keep their name map; the `name` column is resolved
  /// in the UI language for sorting and search.
  final String Function() languageCode;

  @override
  SyncCollection get collection => SyncCollection.exercises;
  @override
  TableInfo<$ExercisesTable, ExerciseRow> get table => db.exercises;

  @override
  Insertable<ExerciseRow> toRow(
    Map<String, dynamic> json, {
    required String id,
    required DateTime updatedAt,
    required DateTime? deletedAt,
  }) => ExercisesCompanion.insert(
    id: id,
    updatedAt: updatedAt,
    deletedAt: Value(deletedAt),
    data: jsonEncode(json),
    isGlobal: json['isGlobal'] as bool? ?? false,
    name: localizedName(json['name'], languageCode()),
    primaryMuscle: json['primaryMuscle'] as String? ?? '',
    equipment: json['equipment'] as String? ?? 'other',
  );

  @override
  LocalDoc toDoc(ExerciseRow row) => LocalDoc(
    id: row.id,
    updatedAt: row.updatedAt,
    deletedAt: row.deletedAt,
    json: decodeData(row.data),
  );
}

/// `name` is a plain string (REST, already localized) or a `{es, en}` map
/// (raw custom exercise from pull). Falls back to `es`, like the API.
String localizedName(Object? name, String language) => switch (name) {
  final String text => text,
  final Map<String, dynamic> map =>
    (map[language] ?? map['es'] ?? map.values.firstOrNull ?? '') as String,
  _ => '',
};

/// All stores, by collection.
class SyncStores {
  SyncStores(AppDatabase db, {required String Function() languageCode})
    : workouts = WorkoutsStore(db),
      routines = RoutinesStore(db),
      programs = ProgramsStore(db),
      bodyMetrics = BodyMetricsStore(db),
      exercisePrefs = ExercisePrefsStore(db),
      exercises = ExercisesStore(db, languageCode: languageCode);

  final WorkoutsStore workouts;
  final RoutinesStore routines;
  final ProgramsStore programs;
  final BodyMetricsStore bodyMetrics;
  final ExercisePrefsStore exercisePrefs;
  final ExercisesStore exercises;

  SyncedStore<SyncedColumns, DataClass> of(SyncCollection collection) =>
      switch (collection) {
        SyncCollection.workouts => workouts,
        SyncCollection.routines => routines,
        SyncCollection.programs => programs,
        SyncCollection.bodyMetrics => bodyMetrics,
        SyncCollection.userExercisePrefs => exercisePrefs,
        SyncCollection.exercises => exercises,
      } as SyncedStore<SyncedColumns, DataClass>;
}
