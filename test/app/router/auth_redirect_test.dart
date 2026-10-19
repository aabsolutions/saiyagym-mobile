import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saiyagym_mobile/app/router/app_router.dart';
import 'package:saiyagym_mobile/app/router/app_routes.dart';
import 'package:saiyagym_mobile/features/auth/domain/entities/session.dart';

import '../../helpers/fixtures.dart';

void main() {
  String? redirect(AsyncValue<Session?> session, String location) =>
      authRedirect(session: session, location: location);

  final signedIn = AsyncData<Session?>(Session(user: testUser()));
  final notOnboarded = AsyncData<Session?>(
    Session(user: testUser(onboarded: false)),
  );
  const signedOut = AsyncData<Session?>(null);
  const restoring = AsyncLoading<Session?>();

  const tabs = [
    AppRoutes.today,
    AppRoutes.train,
    AppRoutes.history,
    AppRoutes.progress,
    AppRoutes.profile,
    AppRoutes.editProfile,
  ];

  test('restoring the session holds every route on the splash', () {
    expect(redirect(restoring, AppRoutes.today), AppRoutes.splash);
    expect(redirect(restoring, AppRoutes.login), AppRoutes.splash);
    expect(redirect(restoring, AppRoutes.splash), isNull);
  });

  test('signed out: protected routes go to welcome, public ones stay', () {
    for (final route in [...tabs, AppRoutes.onboarding, AppRoutes.splash]) {
      expect(redirect(signedOut, route), AppRoutes.welcome, reason: route);
    }
    for (final route in AppRoutes.public) {
      expect(redirect(signedOut, route), isNull, reason: route);
    }
  });

  test('signed in: never on splash, auth screens or onboarding', () {
    for (final route in [
      ...AppRoutes.public,
      AppRoutes.splash,
      AppRoutes.onboarding,
    ]) {
      expect(redirect(signedIn, route), AppRoutes.today, reason: route);
    }
    for (final route in tabs) {
      expect(redirect(signedIn, route), isNull, reason: route);
    }
  });

  test('without level and goal, onboarding is the only way in', () {
    for (final route in [...tabs, ...AppRoutes.public, AppRoutes.splash]) {
      expect(
        redirect(notOnboarded, route),
        AppRoutes.onboarding,
        reason: route,
      );
    }
    expect(redirect(notOnboarded, AppRoutes.onboarding), isNull);
  });

  test('an offline session still gets in', () {
    final offline = AsyncData<Session?>(
      Session(user: testUser(), isOffline: true),
    );

    expect(redirect(offline, AppRoutes.splash), AppRoutes.today);
  });

  test('a failed restore counts as signed out', () {
    final failed = AsyncError<Session?>(Exception('boom'), StackTrace.empty);

    expect(redirect(failed, AppRoutes.today), AppRoutes.welcome);
  });
}
