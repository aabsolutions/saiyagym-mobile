import 'package:saiyagym_mobile/features/auth/data/models/me_model.dart';
import 'package:saiyagym_mobile/features/auth/domain/entities/user.dart';

/// A `GET /users/me` body, as the API sends it.
Map<String, dynamic> meJson({
  String email = 'ana@example.com',
  String language = 'es',
}) => {
  'id': 'user-1',
  'email': email,
  'role': 'user',
  'emailVerified': true,
  'profile': {
    'name': 'Ana',
    'birthDate': null,
    'sex': null,
    'heightCm': null,
    'level': null,
    'goal': null,
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
  'plan': {'id': 'plan-free', 'code': 'free', 'name': 'Free'},
  'createdAt': '2026-10-01T10:00:00.000Z',
};

MeModel meModel({String email = 'ana@example.com'}) =>
    MeModel.fromJson(meJson(email: email));

User testUser({String email = 'ana@example.com'}) =>
    meModel(email: email).toEntity();
