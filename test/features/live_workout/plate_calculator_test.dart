import 'package:flutter_test/flutter_test.dart';
import 'package:saiyagym_mobile/core/units/unit_formatter.dart';
import 'package:saiyagym_mobile/features/live_workout/domain/plate_calculator.dart';

void main() {
  final kg = PlateConfig.defaults(UnitSystem.metric);

  test('loads each side heaviest first', () {
    // 61.25 per side.
    final load = loadBar(142.5, kg);
    expect(load.perSide, [25, 25, 10, 1.25]);
    expect(load.exact, isTrue);
  });

  test('small plates survive float noise (2 × 1.25)', () {
    final load = loadBar(22.5, kg);
    expect(load.perSide, [1.25]);
    expect(load.achieved, 22.5);
  });

  test('impossible with the available plates → closest below', () {
    final load = loadBar(101, kg);
    expect(load.exact, isFalse);
    expect(load.achieved, 100);
  });

  test('below the bar', () {
    final load = loadBar(15, kg);
    expect(load.perSide, isEmpty);
    expect(load.belowBar, isTrue);
  });

  test('lb gyms use lb plates and a 45 lb bar', () {
    final lb = PlateConfig.defaults(UnitSystem.imperial);
    expect(loadBar(225, lb).perSide, [45, 45]);
  });

  test('only the plates the user has', () {
    final noSmall = kg.copyWith(plates: [20, 10]);
    // 25 per side wanted, only 20 and 10 exist: 20 fits, 5 is missing.
    final short = loadBar(70, noSmall);
    expect(short.perSide, [20]);
    expect(short.achieved, 60);
    expect(loadBar(80, noSmall).perSide, [20, 10]);
  });

  test('survives a JSON round trip', () {
    final config = kg.copyWith(barWeight: 15, plates: [20, 2.5]);
    final copy = PlateConfig.fromJson(config.toJson());
    expect(copy.unit, UnitSystem.metric);
    expect(copy.barWeight, 15);
    expect(copy.plates, [20, 2.5]);
  });
}
