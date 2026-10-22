import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:saiyagym_mobile/core/network/api_exception.dart';

part 'entitlements.freezed.dart';

/// Keys of `PlanFeaturesDto`.
enum PlanFeature {
  progressPhotos,
  autoProgression,
  fullStats,
  fullNutrition,
  dataExport,
  premiumSounds,
}

/// Keys of `PlanLimitsDto`.
enum PlanLimit { routines, activePrograms, customExercises }

/// What the user's plan allows. The API is the only authority (it rejects
/// with PLAN_FEATURE_REQUIRED / PLAN_LIMIT_REACHED); this is for hiding UI
/// and explaining why, never for security.
@freezed
abstract class Entitlements with _$Entitlements {
  const factory Entitlements({
    @Default({}) Set<PlanFeature> features,

    /// `null` value = unlimited. A missing key (a limit unknown to this app
    /// version) is treated as unlimited too: the API still enforces it.
    @Default({}) Map<PlanLimit, int?> limits,

    /// `null` = full history.
    int? statsHistoryDays,
  }) = _Entitlements;

  const Entitlements._();

  /// Signed out / unknown: nothing enabled.
  static const none = Entitlements();

  bool has(PlanFeature feature) => features.contains(feature);

  int? limitOf(PlanLimit limit) => limits[limit];

  bool canAdd(PlanLimit limit, {required int current, int amount = 1}) {
    final max = limits[limit];
    return max == null || current + amount <= max;
  }
}

/// Why the plan blocks something; drives `UpgradeCta`.
sealed class UpgradeReason {
  const UpgradeReason();

  /// From an API rejection, or `null` when the error isn't plan-related.
  static UpgradeReason? fromError(Object error) {
    if (error is! ApiException) return null;
    final details = error.details;
    final map = details is Map ? details : const <Object?, Object?>{};
    switch (error.code) {
      case 'PLAN_FEATURE_REQUIRED':
        final feature = PlanFeature.values.asNameMap()[map['feature']];
        return feature == null ? null : FeatureRequired(feature);
      case 'PLAN_LIMIT_REACHED':
        final limit = PlanLimit.values.asNameMap()[map['resource']];
        final max = map['limit'];
        return limit == null
            ? null
            : LimitReached(limit, max: max is num ? max.toInt() : null);
      default:
        return null;
    }
  }
}

final class FeatureRequired extends UpgradeReason {
  const FeatureRequired(this.feature);

  final PlanFeature feature;
}

final class LimitReached extends UpgradeReason {
  const LimitReached(this.limit, {this.max});

  final PlanLimit limit;
  final int? max;
}
