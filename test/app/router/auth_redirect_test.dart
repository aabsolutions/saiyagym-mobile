import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saiyagym_mobile/app/router/app_router.dart';
import 'package:saiyagym_mobile/app/router/app_routes.dart';
import 'package:saiyagym_mobile/features/auth/domain/entities/user.dart';

import '../../helpers/fixtures.dart';

void main() {
  String? redirect(AsyncValue<User?> session, String location) =>
      authRedirect(session: session, location: location);

  final signedIn = AsyncData<User?>(testUser());
  const signedOut = AsyncData<User?>(null);
  const restoring = AsyncLoading<User?>();

  test('restoring the session holds every route on the splash', () {
    expect(redirect(restoring, AppRoutes.today), AppRoutes.splash);
    expect(redirect(restoring, AppRoutes.login), AppRoutes.splash);
    expect(redirect(restoring, AppRoutes.splash), isNull);
  });

  test('signed out: protected routes go to login, public ones stay', () {
    for (final tab in [
      AppRoutes.today,
      AppRoutes.train,
      AppRoutes.history,
      AppRoutes.progress,
      AppRoutes.profile,
    ]) {
      expect(redirect(signedOut, tab), AppRoutes.login, reason: tab);
    }
    expect(redirect(signedOut, AppRoutes.splash), AppRoutes.login);
    expect(redirect(signedOut, AppRoutes.login), isNull);
    expect(redirect(signedOut, AppRoutes.register), isNull);
  });

  test('signed in: never stays on splash or the auth screens', () {
    expect(redirect(signedIn, AppRoutes.splash), AppRoutes.today);
    expect(redirect(signedIn, AppRoutes.login), AppRoutes.today);
    expect(redirect(signedIn, AppRoutes.register), AppRoutes.today);
    expect(redirect(signedIn, AppRoutes.history), isNull);
  });

  test('a failed restore counts as signed out', () {
    final failed = AsyncError<User?>(Exception('boom'), StackTrace.empty);

    expect(redirect(failed, AppRoutes.today), AppRoutes.login);
  });
}
