import 'dart:convert';

import 'package:saiyagym_mobile/core/database/app_database.dart';
import 'package:saiyagym_mobile/features/auth/data/models/me_model.dart';

/// Last known `/users/me`, so the app opens offline.
class AuthLocalDataSource {
  const AuthLocalDataSource(this._database);

  static const _userKey = 'session.user';

  final AppDatabase _database;

  Future<void> cacheUser(MeModel user) =>
      _database.writeMeta(_userKey, jsonEncode(user.toJson()));

  Future<MeModel?> readUser() async {
    final raw = await _database.readMeta(_userKey);
    if (raw == null) return null;
    try {
      return MeModel.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } on Object {
      // Cached with an older shape: drop it, the next fetch refills it.
      await clear();
      return null;
    }
  }

  Future<void> clear() => _database.deleteMeta(_userKey);
}
