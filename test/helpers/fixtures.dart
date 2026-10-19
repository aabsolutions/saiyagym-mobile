import 'package:saiyagym_mobile/features/auth/data/models/me_model.dart';
import 'package:saiyagym_mobile/features/auth/domain/entities/user.dart';

/// `PlanEntitlementsDto` of the seeded Free plan.
const Map<String, Object?> freeEntitlementsJson = {
  'statsHistoryDays': 90,
  'limits': {'routines': 3, 'activePrograms': 1, 'customExercises': 10},
  'features': {
    'progressPhotos': false,
    'autoProgression': false,
    'fullStats': false,
    'fullNutrition': false,
    'dataExport': false,
  },
};

const Map<String, Object?> premiumEntitlementsJson = {
  'statsHistoryDays': null,
  'limits': {'routines': null, 'activePrograms': null, 'customExercises': null},
  'features': {
    'progressPhotos': true,
    'autoProgression': true,
    'fullStats': true,
    'fullNutrition': true,
    'dataExport': true,
  },
};

/// A `GET /users/me` body, as the API sends it.
Map<String, dynamic> meJson({
  String id = 'user-1',
  String email = 'ana@example.com',
  String language = 'es',
  bool emailVerified = true,
  bool onboarded = true,
  bool premium = false,
}) => {
  'id': id,
  'email': email,
  'role': 'user',
  'emailVerified': emailVerified,
  'profile': {
    'name': 'Ana',
    'birthDate': '1994-05-10T00:00:00.000Z',
    'sex': 'female',
    'heightCm': 168,
    'level': onboarded ? 'intermediate' : null,
    'goal': onboarded ? 'both' : null,
  },
  'preferences': {
    'units': 'metric',
    'theme': 'system',
    'language': language,
    'defaultRestSeconds': 120,
    'firstDayOfWeek': 1,
  },
  'subscription': {
    'planId': null,
    'status': 'active',
    'currentPeriodEnd': null,
    'provider': 'manual',
  },
  'plan': {
    'id': premium ? 'plan-premium' : 'plan-free',
    'code': premium ? 'premium' : 'free',
    'name': premium ? 'Premium' : 'Free',
    'entitlements': premium ? premiumEntitlementsJson : freeEntitlementsJson,
  },
  'createdAt': '2026-10-01T10:00:00.000Z',
};

MeModel meModel({
  String id = 'user-1',
  String email = 'ana@example.com',
  bool emailVerified = true,
  bool onboarded = true,
  bool premium = false,
}) => MeModel.fromJson(
  meJson(
    id: id,
    email: email,
    emailVerified: emailVerified,
    onboarded: onboarded,
    premium: premium,
  ),
);

User testUser({
  String id = 'user-1',
  String email = 'ana@example.com',
  bool emailVerified = true,
  bool onboarded = true,
  bool premium = false,
}) => meModel(
  id: id,
  email: email,
  emailVerified: emailVerified,
  onboarded: onboarded,
  premium: premium,
).toEntity();
