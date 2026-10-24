import 'package:dio/dio.dart';
import 'package:drift/drift.dart';
import 'package:saiyagym_mobile/core/network/api_exception.dart';
import 'package:saiyagym_mobile/core/sync/stores.dart';
import 'package:saiyagym_mobile/core/sync/sync_writer.dart';
import 'package:saiyagym_mobile/core/sync/synced_store.dart';
import 'package:saiyagym_mobile/core/training/training_types.dart';
import 'package:saiyagym_mobile/features/exercises/domain/exercise.dart';
import 'package:uuid/uuid.dart';

/// Reads ALWAYS from the local database; writes go local + sync queue.
class ExercisesRepositoryImpl implements ExercisesRepository {
  ExercisesRepositoryImpl({
    required this._stores,
    required this._writer,
    required this._languageCode,
    required this._dio,
    this._uuid = const Uuid(),
  });

  final Dio _dio;

  final SyncStores _stores;
  final SyncWriter _writer;
  final String Function() _languageCode;
  final Uuid _uuid;

  Exercise _decode(LocalDoc doc) => Exercise.fromJson({
    ...doc.json,
    // Custom exercises keep their `{es, en}` maps.
    'name': localizedName(doc.json['name'], _languageCode()),
    'description': localizedName(doc.json['description'], _languageCode()),
    'instructions': localizedName(doc.json['instructions'], _languageCode()),
  });

  @override
  Stream<List<Exercise>> watchCatalog({String? search}) {
    final store = _stores.exercises;
    final term = search?.trim().toLowerCase();
    final query = store.db.select(store.table)
      ..where(
        (e) =>
            e.deletedAt.isNull() &
            (term == null || term.isEmpty
                ? const Constant(true)
                : e.name.lower().like('%$term%')),
      )
      ..orderBy([(e) => OrderingTerm.asc(e.name)]);
    return query.watch().map(
      (rows) => [for (final row in rows) _decode(store.toDoc(row))],
    );
  }

  @override
  Future<Exercise?> find(String id) async {
    final doc = await _stores.exercises.find(id);
    return doc == null ? null : _decode(doc);
  }

  @override
  Stream<Map<String, ExercisePref>> watchPrefs() =>
      _stores.exercisePrefs.watchActive().map(
        (docs) => {
          for (final doc in docs)
            doc.json['exerciseId'] as String: ExercisePref.fromJson(doc.json),
        },
      );

  Future<void> _update(
    String exerciseId,
    ExercisePref Function(ExercisePref current) change,
  ) async {
    final existing = await _stores.exercisePrefs.findByExercise(exerciseId);
    final current = existing == null || existing.isDeleted
        ? ExercisePref(exerciseId: exerciseId)
        : ExercisePref.fromJson(existing.json);
    await _writer.save(
      _stores.exercisePrefs,
      // Reuse the (server) id when known; the server converges by exercise.
      existing?.id ?? _uuid.v4(),
      change(current).toJson(),
    );
  }

  @override
  Future<void> setFavorite(String exerciseId, {required bool favorite}) =>
      _update(exerciseId, (pref) => pref.copyWith(isFavorite: favorite));

  @override
  Future<void> setPersonalTier(String exerciseId, Goal goal, Tier? tier) =>
      _update(
        exerciseId,
        (pref) => pref.copyWith(
          personalTiers: switch (goal) {
            Goal.hypertrophy => pref.personalTiers.copyWith(hypertrophy: tier),
            Goal.powerlifting => pref.personalTiers.copyWith(
              powerlifting: tier,
            ),
          },
        ),
      );

  @override
  Future<Exercise> createCustom(CustomExerciseDraft draft) async {
    final body = await guardApi(() async {
      final response = await _dio.post<Map<String, dynamic>>(
        '/exercises',
        data: draft.toJson(),
      );
      return response.data!;
    });
    final id = body['id'] as String;
    // Version 0: the raw document arriving with the next pull replaces it.
    await _stores.exercises.put(
      {...body, 'isGlobal': false, 'isCustom': true},
      id: id,
      updatedAt: DateTime.fromMillisecondsSinceEpoch(0, isUtc: true),
      deletedAt: null,
    );
    return _decode((await _stores.exercises.find(id))!);
  }
}
