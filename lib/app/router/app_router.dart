import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:saiyagym_mobile/app/router/app_routes.dart';
import 'package:saiyagym_mobile/app/shell/home_shell.dart';
import 'package:saiyagym_mobile/features/auth/domain/entities/user.dart';
import 'package:saiyagym_mobile/features/auth/presentation/controllers/session_controller.dart';
import 'package:saiyagym_mobile/features/auth/presentation/pages/login_page.dart';
import 'package:saiyagym_mobile/features/auth/presentation/pages/register_page.dart';
import 'package:saiyagym_mobile/features/auth/presentation/pages/splash_page.dart';
import 'package:saiyagym_mobile/features/history/presentation/history_page.dart';
import 'package:saiyagym_mobile/features/profile/presentation/profile_page.dart';
import 'package:saiyagym_mobile/features/progress/presentation/progress_page.dart';
import 'package:saiyagym_mobile/features/today/presentation/today_page.dart';
import 'package:saiyagym_mobile/features/train/presentation/train_page.dart';

part 'app_router.g.dart';

/// Route guard, pure so it can be unit-tested.
///
/// - Restoring the session → splash.
/// - Signed out → only public routes (login, register).
/// - Signed in → never on splash or public routes.
String? authRedirect({
  required AsyncValue<User?> session,
  required String location,
}) {
  final isPublic = AppRoutes.public.contains(location);
  if (session.isLoading && !session.hasValue) {
    return location == AppRoutes.splash ? null : AppRoutes.splash;
  }
  final signedIn = session.value != null;
  if (!signedIn) return isPublic ? null : AppRoutes.login;
  if (isPublic || location == AppRoutes.splash) return AppRoutes.today;
  return null;
}

@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) {
  // One router for the app's lifetime; session changes re-run the redirect.
  final session = ValueNotifier<AsyncValue<User?>>(const AsyncLoading());
  ref
    ..listen(
      sessionControllerProvider,
      (_, next) => session.value = next,
      fireImmediately: true,
    )
    ..onDispose(session.dispose);

  final router = GoRouter(
    initialLocation: AppRoutes.splash,
    refreshListenable: session,
    redirect: (_, state) =>
        authRedirect(session: session.value, location: state.matchedLocation),
    routes: [
      GoRoute(path: AppRoutes.splash, builder: (_, _) => const SplashPage()),
      GoRoute(path: AppRoutes.login, builder: (_, _) => const LoginPage()),
      GoRoute(
        path: AppRoutes.register,
        builder: (_, _) => const RegisterPage(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (_, _, shell) => HomeShell(navigationShell: shell),
        branches: [
          _tab(AppRoutes.today, const TodayPage()),
          _tab(AppRoutes.train, const TrainPage()),
          _tab(AppRoutes.history, const HistoryPage()),
          _tab(AppRoutes.progress, const ProgressPage()),
          _tab(AppRoutes.profile, const ProfilePage()),
        ],
      ),
    ],
  );
  ref.onDispose(router.dispose);
  return router;
}

StatefulShellBranch _tab(String path, Widget page) => StatefulShellBranch(
  routes: [GoRoute(path: path, builder: (_, _) => page)],
);
