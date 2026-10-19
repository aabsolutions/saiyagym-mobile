import 'dart:convert';

import 'package:saiyagym_mobile/core/database/app_database.dart';
import 'package:saiyagym_mobile/core/units/unit_formatter.dart';
import 'package:saiyagym_mobile/features/live_workout/domain/plate_calculator.dart';

/// Device-local training preferences (not part of the API's preferences):
/// plates in the user's gym and whether to keep the screen on.
class TrainingSettings {
  const TrainingSettings({required this.plates, this.keepScreenOn = true});

  final PlateConfig plates;
  final bool keepScreenOn;

  TrainingSettings copyWith({PlateConfig? plates, bool? keepScreenOn}) =>
      TrainingSettings(
        plates: plates ?? this.plates,
        keepScreenOn: keepScreenOn ?? this.keepScreenOn,
      );
}

class TrainingSettingsStore {
  const TrainingSettingsStore(this._db);

  static const _platesKey = 'settings.plates';
  static const _keepScreenOnKey = 'settings.keepScreenOn';

  final AppDatabase _db;

  /// Plates follow the unit system: a lb gym has lb plates.
  Future<TrainingSettings> read(UnitSystem units) async {
    final rawPlates = await _db.readMeta(_platesKey);
    PlateConfig? plates;
    if (rawPlates != null) {
      try {
        plates = PlateConfig.fromJson(
          jsonDecode(rawPlates) as Map<String, dynamic>,
        );
      } on Object {
        plates = null;
      }
    }
    return TrainingSettings(
      plates: plates != null && plates.unit == units
          ? plates
          : PlateConfig.defaults(units),
      keepScreenOn: await _db.readMeta(_keepScreenOnKey) != 'false',
    );
  }

  Future<void> write(TrainingSettings settings) async {
    await _db.writeMeta(_platesKey, jsonEncode(settings.plates.toJson()));
    await _db.writeMeta(_keepScreenOnKey, '${settings.keepScreenOn}');
  }
}
