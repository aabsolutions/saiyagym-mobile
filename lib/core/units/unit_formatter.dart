import 'dart:math' as math;

import 'package:intl/intl.dart';

/// Mirrors `preferences.units` from the API.
enum UnitSystem {
  metric,
  imperial;

  static UnitSystem fromApi(String? value) =>
      value == 'imperial' ? imperial : metric;
}

/// Presentation-only conversions. Data is ALWAYS stored and sent in kg/cm;
/// convert user input back with [weightToKg] / [lengthToCm] before saving.
class UnitFormatter {
  UnitFormatter(this.system, {String locale = 'es'})
    : _number = NumberFormat('#,##0.##', locale);

  static const kgPerLb = 0.45359237;
  static const cmPerInch = 2.54;

  /// The API's precision (`maxDecimalPlaces`): a raw `225 lb` is
  /// 102.05828325 kg and the whole document is rejected. Weights keep 3
  /// decimals because 2 can't round-trip lb (160 lb → 72.57 kg → 159.99 lb).
  static const kgDecimals = 3;
  static const cmDecimals = 2;

  static double roundTo(double value, int decimals) {
    final factor = math.pow(10, decimals);
    return (value * factor).round() / factor;
  }

  final UnitSystem system;
  final NumberFormat _number;

  bool get _imperial => system == UnitSystem.imperial;

  // Unit symbols are international (SI / customary), not translatable text.
  String get weightUnit => _imperial ? 'lb' : 'kg';
  String get lengthUnit => _imperial ? 'in' : 'cm';

  double displayWeight(double kg) => _imperial ? kg / kgPerLb : kg;
  double weightToKg(double value) =>
      roundTo(_imperial ? value * kgPerLb : value, kgDecimals);

  double displayLength(double cm) => _imperial ? cm / cmPerInch : cm;
  double lengthToCm(double value) =>
      roundTo(_imperial ? value * cmPerInch : value, cmDecimals);

  /// A value already in display units, without the unit (`102,5`).
  String formatNumber(double value) => _number.format(value);

  /// Parses user input in display units; accepts `,` or `.` as decimal
  /// separator (tired thumbs type either). `null` when not a number.
  static double? parseNumber(String input) =>
      double.tryParse(input.trim().replaceAll(',', '.'));

  /// `102.5 kg` / `225.97 lb` (locale-aware decimal separator).
  String formatWeight(double kg) =>
      '${_number.format(displayWeight(kg))} $weightUnit';

  String formatLength(double cm) =>
      '${_number.format(displayLength(cm))} $lengthUnit';
}
