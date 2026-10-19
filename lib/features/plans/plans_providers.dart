import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:saiyagym_mobile/core/network/api_client.dart';
import 'package:saiyagym_mobile/core/network/api_exception.dart';
import 'package:saiyagym_mobile/features/auth/presentation/controllers/session_controller.dart';
import 'package:saiyagym_mobile/features/plans/data/plan_models.dart';
import 'package:saiyagym_mobile/features/plans/domain/entitlements.dart';
import 'package:saiyagym_mobile/features/plans/domain/plan.dart';

part 'plans_providers.g.dart';

/// Entitlements of the signed-in user's effective plan
/// ([Entitlements.none] when signed out).
@riverpod
Entitlements entitlements(Ref ref) => ref.watch(
  currentUserProvider.select(
    (user) => user?.plan.entitlements ?? Entitlements.none,
  ),
);

/// Public plan catalog (`GET /plans`) for the upgrade sheet.
@riverpod
Future<List<Plan>> availablePlans(Ref ref) async {
  final dio = ref.watch(apiClientProvider);
  return await guardApi(() async {
    final response = await dio.get<List<dynamic>>('/plans');
    return [
      for (final json in response.data!)
        PublicPlanModel.fromJson(json as Map<String, dynamic>).toEntity(),
    ];
  });
}

@Riverpod(keepAlive: true)
PaymentProvider paymentProvider(Ref ref) => const ManualPaymentProvider();
