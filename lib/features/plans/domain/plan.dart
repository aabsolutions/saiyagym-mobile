import 'package:saiyagym_mobile/features/plans/domain/entitlements.dart';

/// A plan offered to users (`GET /plans`), as shown in the upgrade sheet.
class Plan {
  const Plan({
    required this.code,
    required this.name,
    required this.description,
    required this.isDefault,
    required this.entitlements,
  });

  final String code;
  final String name;
  final String description;

  /// The plan every new account gets (Free).
  final bool isDefault;
  final Entitlements entitlements;
}

/// Store purchases (RevenueCat on mobile, per the spec) plug in here. Today
/// plans are assigned manually by an admin, so nothing can be bought.
abstract interface class PaymentProvider {
  bool get canPurchase;

  Future<void> purchase(String planCode);
}

class ManualPaymentProvider implements PaymentProvider {
  const ManualPaymentProvider();

  @override
  bool get canPurchase => false;

  @override
  Future<void> purchase(String planCode) =>
      throw UnsupportedError('Plans are assigned by an admin for now');
}
