import 'package:flutter_test/flutter_test.dart';
import 'package:saiyagym_mobile/core/network/api_exception.dart';
import 'package:saiyagym_mobile/features/plans/data/plan_models.dart';
import 'package:saiyagym_mobile/features/plans/domain/entitlements.dart';

import '../../helpers/fixtures.dart';

void main() {
  group('Entitlements from the API', () {
    test('Free: limits, stats window, no features', () {
      final free = EntitlementsModel.fromJson(freeEntitlementsJson).toEntity();

      expect(free.has(PlanFeature.fullStats), isFalse);
      expect(free.limitOf(PlanLimit.routines), 3);
      expect(free.statsHistoryDays, 90);
      expect(free.canAdd(PlanLimit.routines, current: 2), isTrue);
      expect(free.canAdd(PlanLimit.routines, current: 3), isFalse);
      expect(free.canAdd(PlanLimit.routines, current: 2, amount: 2), isFalse);
    });

    test('Premium: null means unlimited', () {
      final premium = EntitlementsModel.fromJson(premiumEntitlementsJson)
          .toEntity();

      expect(premium.has(PlanFeature.progressPhotos), isTrue);
      expect(premium.limitOf(PlanLimit.routines), isNull);
      expect(premium.canAdd(PlanLimit.routines, current: 999), isTrue);
      expect(premium.statsHistoryDays, isNull);
    });

    test('ignores features and limits this app version does not know', () {
      final entitlements = EntitlementsModel.fromJson(const {
        'statsHistoryDays': 30,
        'limits': {'routines': 1, 'teleporters': 2},
        'features': {'fullStats': true, 'hologram': true},
      }).toEntity();

      expect(entitlements.features, {PlanFeature.fullStats});
      expect(entitlements.limits, {PlanLimit.routines: 1});
      // Unknown to the app → treated as unlimited (the API still enforces).
      expect(
        entitlements.canAdd(PlanLimit.customExercises, current: 50),
        isTrue,
      );
    });

    test('compares by value', () {
      expect(
        EntitlementsModel.fromJson(freeEntitlementsJson).toEntity(),
        EntitlementsModel.fromJson(freeEntitlementsJson).toEntity(),
      );
    });
  });

  group('UpgradeReason.fromError', () {
    test('PLAN_FEATURE_REQUIRED → the feature', () {
      final reason = UpgradeReason.fromError(
        const ApiException(
          code: 'PLAN_FEATURE_REQUIRED',
          statusCode: 403,
          details: {'feature': 'progressPhotos'},
        ),
      );

      expect(reason, isA<FeatureRequired>());
      expect((reason! as FeatureRequired).feature, PlanFeature.progressPhotos);
    });

    test('PLAN_LIMIT_REACHED → the limit and its max', () {
      final reason = UpgradeReason.fromError(
        const ApiException(
          code: 'PLAN_LIMIT_REACHED',
          statusCode: 403,
          details: {
            'resource': 'routines',
            'limit': 3,
            'current': 3,
            'requested': 1,
          },
        ),
      );

      expect(reason, isA<LimitReached>());
      final limit = reason! as LimitReached;
      expect(limit.limit, PlanLimit.routines);
      expect(limit.max, 3);
    });

    test('anything else is not a plan problem', () {
      expect(
        UpgradeReason.fromError(const ApiException(code: 'ROUTINE_NOT_FOUND')),
        isNull,
      );
      expect(UpgradeReason.fromError(Exception('x')), isNull);
      expect(
        UpgradeReason.fromError(
          const ApiException(
            code: 'PLAN_FEATURE_REQUIRED',
            details: {'feature': 'teleport'},
          ),
        ),
        isNull,
      );
    });
  });
}
