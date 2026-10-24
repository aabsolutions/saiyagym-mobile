import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:saiyagym_mobile/features/plans/domain/entitlements.dart';
import 'package:saiyagym_mobile/features/plans/domain/plan.dart';

part 'plan_models.freezed.dart';
part 'plan_models.g.dart';

/// `PlanEntitlementsDto`. Plain maps so unknown keys from a newer API are
/// ignored instead of breaking parsing.
@freezed
abstract class EntitlementsModel with _$EntitlementsModel {
  const factory EntitlementsModel({
    int? statsHistoryDays,
    int? guidesPerRoutine,
    @Default({}) Map<String, int?> limits,
    @Default({}) Map<String, bool> features,
  }) = _EntitlementsModel;

  const EntitlementsModel._();

  factory EntitlementsModel.fromJson(Map<String, dynamic> json) =>
      _$EntitlementsModelFromJson(json);

  Entitlements toEntity() {
    final featureByName = PlanFeature.values.asNameMap();
    final limitByName = PlanLimit.values.asNameMap();
    return Entitlements(
      statsHistoryDays: statsHistoryDays,
      guidesPerRoutine: guidesPerRoutine,
      features: {
        for (final MapEntry(:key, :value) in features.entries)
          if (value && featureByName[key] != null) featureByName[key]!,
      },
      limits: {
        for (final MapEntry(:key, :value) in limits.entries)
          if (limitByName[key] != null) limitByName[key]!: value,
      },
    );
  }
}

/// `PublicPlanDto` (`GET /plans`).
@freezed
abstract class PublicPlanModel with _$PublicPlanModel {
  const factory PublicPlanModel({
    required String id,
    required String code,
    required String name,
    required EntitlementsModel entitlements,
    @Default('') String description,
    @Default(false) bool isDefault,
  }) = _PublicPlanModel;

  const PublicPlanModel._();

  factory PublicPlanModel.fromJson(Map<String, dynamic> json) =>
      _$PublicPlanModelFromJson(json);

  Plan toEntity() => Plan(
    code: code,
    name: name,
    description: description,
    isDefault: isDefault,
    entitlements: entitlements.toEntity(),
  );
}
