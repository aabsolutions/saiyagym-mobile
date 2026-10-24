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

    test('input is rounded to the precision the API accepts', () {
      final imperial = UnitFormatter(UnitSystem.imperial);

      // Raw 225 lb is 102.05828325 kg: the API rejects > 3 decimals.
      expect(imperial.weightToKg(225), 102.058);
      expect(imperial.lengthToCm(32.1), 81.53);
      expect(UnitFormatter(UnitSystem.metric).weightToKg(100.12345), 100.123);
    });

    test('rounded imperial input still shows what was typed', () {
      final formatter = UnitFormatter(UnitSystem.imperial, locale: 'en');

      const typed = [
        (45.0, '45'),
        (160.0, '160'),
        (225.0, '225'),
        (102.5, '102.5'),
      ];
      for (final (lb, shown) in typed) {
        final stored = formatter.weightToKg(lb);
        expect(formatter.formatNumber(formatter.displayWeight(stored)), shown);
      }
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
