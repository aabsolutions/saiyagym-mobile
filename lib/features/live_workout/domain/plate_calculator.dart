import 'package:saiyagym_mobile/core/units/unit_formatter.dart';

/// Bar and plates the user has, in ONE unit (kg gyms vs lb gyms use
/// different plates, not converted ones).
class PlateConfig {
  const PlateConfig({
    required this.unit,
    required this.barWeight,
    required this.plates,
  });

  factory PlateConfig.defaults(UnitSystem unit) => unit == UnitSystem.imperial
      ? const PlateConfig(
          unit: UnitSystem.imperial,
          barWeight: 45,
          plates: [45, 35, 25, 10, 5, 2.5],
        )
      : const PlateConfig(
          unit: UnitSystem.metric,
          barWeight: 20,
          plates: [25, 20, 15, 10, 5, 2.5, 1.25],
        );

  factory PlateConfig.fromJson(Map<String, dynamic> json) => PlateConfig(
    unit: UnitSystem.fromApi(json['unit'] as String?),
    barWeight: (json['barWeight'] as num).toDouble(),
    plates: [
      for (final plate in json['plates'] as List) (plate as num).toDouble(),
    ],
  );

  final UnitSystem unit;
  final double barWeight;

  /// Available plate sizes (as many pairs as needed).
  final List<double> plates;

  Map<String, Object> toJson() => {
    'unit': unit.name,
    'barWeight': barWeight,
    'plates': plates,
  };

  PlateConfig copyWith({double? barWeight, List<double>? plates}) =>
      PlateConfig(
        unit: unit,
        barWeight: barWeight ?? this.barWeight,
        plates: plates ?? this.plates,
      );
}

class PlateLoad {
  const PlateLoad({
    required this.perSide,
    required this.achieved,
    required this.target,
  });

  /// Heaviest first.
  final List<double> perSide;

  /// What the bar actually weighs loaded like this.
  final double achieved;
  final double target;

  bool get exact => (achieved - target).abs() < 0.001;

  /// Below the empty bar.
  bool get belowBar => perSide.isEmpty && target < achieved;
}

/// Greedy per side, heaviest plate first (optimal for standard plate sets).
/// Never goes over the target: the remainder is reported via [PlateLoad].
PlateLoad loadBar(double target, PlateConfig config) {
  var perSideLeft = (target - config.barWeight) / 2;
  final plates = [...config.plates]..sort((a, b) => b.compareTo(a));
  final perSide = <double>[];
  for (final plate in plates) {
    if (plate <= 0) continue;
    // Small epsilon: 1.25 + 1.25 must not lose to float noise.
    while (perSideLeft + 1e-9 >= plate) {
      perSide.add(plate);
      perSideLeft -= plate;
    }
  }
  final loaded = perSide.fold<double>(0, (sum, plate) => sum + plate);
  return PlateLoad(
    perSide: perSide,
    achieved: config.barWeight + loaded * 2,
    target: target,
  );
}
