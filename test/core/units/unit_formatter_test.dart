import 'package:flutter_test/flutter_test.dart';
import 'package:saiyagym_mobile/core/units/unit_formatter.dart';

void main() {
  group('UnitFormatter', () {
    test('metric shows stored values as-is', () {
      final formatter = UnitFormatter(UnitSystem.metric);

      expect(formatter.formatWeight(102.5), '102,5 kg');
      expect(formatter.formatLength(180), '180 cm');
      expect(formatter.weightToKg(100), 100);
    });

    test('imperial converts kg → lb and cm → in for display', () {
      final formatter = UnitFormatter(UnitSystem.imperial, locale: 'en');

      expect(formatter.formatWeight(100), '220.46 lb');
      expect(formatter.formatLength(180), '70.87 in');
      expect(formatter.weightUnit, 'lb');
      expect(formatter.lengthUnit, 'in');
    });

    test('imperial input converts back to kg / cm before saving', () {
      final formatter = UnitFormatter(UnitSystem.imperial);

      expect(formatter.weightToKg(225), closeTo(102.058, 0.001));
      expect(formatter.lengthToCm(70), closeTo(177.8, 0.001));
    });

    test('round-trips without drift', () {
      final formatter = UnitFormatter(UnitSystem.imperial);

      const kg = 142.5;
      expect(
        formatter.weightToKg(formatter.displayWeight(kg)),
        closeTo(kg, 1e-9),
      );
    });

    test('the decimal separator follows the locale', () {
      expect(UnitFormatter(UnitSystem.imperial).formatWeight(100), '220,46 lb');
    });

    test('maps the API value, defaulting to metric', () {
      expect(UnitSystem.fromApi('imperial'), UnitSystem.imperial);
      expect(UnitSystem.fromApi('metric'), UnitSystem.metric);
      expect(UnitSystem.fromApi(null), UnitSystem.metric);
      expect(UnitSystem.fromApi('nautical'), UnitSystem.metric);
    });
  });
}
