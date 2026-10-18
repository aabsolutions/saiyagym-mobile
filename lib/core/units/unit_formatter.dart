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

  final UnitSystem system;
  final NumberFormat _number;

  bool get _imperial => system == UnitSystem.imperial;

  // Unit symbols are international (SI / customary), not translatable text.
  String get weightUnit => _imperial ? 'lb' : 'kg';
  String get lengthUnit => _imperial ? 'in' : 'cm';

  double displayWeight(double kg) => _imperial ? kg / kgPerLb : kg;
  double weightToKg(double value) => _imperial ? value * kgPerLb : value;

  double displayLength(double cm) => _imperial ? cm / cmPerInch : cm;
  double lengthToCm(double value) => _imperial ? value * cmPerInch : value;

  /// `102.5 kg` / `225.97 lb` (locale-aware decimal separator).
  String formatWeight(double kg) =>
      '${_number.format(displayWeight(kg))} $weightUnit';

  String formatLength(double cm) =>
      '${_number.format(displayLength(cm))} $lengthUnit';
}
