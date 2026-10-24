import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:saiyagym_mobile/app/router/app_routes.dart';
import 'package:saiyagym_mobile/app/shell/home_shell.dart';
import 'package:saiyagym_mobile/features/auth/domain/entities/session.dart';
import 'package:saiyagym_mobile/features/auth/presentation/controllers/session_controller.dart';
import 'package:saiyagym_mobile/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:saiyagym_mobile/features/auth/presentation/pages/login_page.dart';
import 'package:saiyagym_mobile/features/auth/presentation/pages/register_page.dart';
import 'package:saiyagym_mobile/features/auth/presentation/pages/splash_page.dart';
import 'package:saiyagym_mobile/features/auth/presentation/pages/welcome_page.dart';
import 'package:saiyagym_mobile/features/body_metrics/presentation/body_metric_form_page.dart';
import 'package:saiyagym_mobile/features/body_metrics/presentation/body_metrics_page.dart';
import 'package:saiyagym_mobile/features/exercises/presentation/custom_exercise_page.dart';
import 'package:saiyagym_mobile/features/exercises/presentation/exercise_detail_page.dart';
import 'package:saiyagym_mobile/features/history/presentation/history_page.dart';
import 'package:saiyagym_mobile/features/history/presentation/workout_detail_page.dart';
import 'package:saiyagym_mobile/features/history/presentation/workout_edit_page.dart';
import 'package:saiyagym_mobile/features/library/library_page.dart';
import 'package:saiyagym_mobile/features/live_workout/presentation/live_workout_controller.dart';
import 'package:saiyagym_mobile/features/live_workout/presentation/live_workout_page.dart';
import 'package:saiyagym_mobile/features/live_workout/presentation/workout_summary_page.dart';
import 'package:saiyagym_mobile/features/onboarding/presentation/onboarding_page.dart';
import 'package:saiyagym_mobile/features/profile/presentation/edit_profile_page.dart';
import 'package:saiyagym_mobile/features/profile/presentation/profile_page.dart';
import 'package:saiyagym_mobile/features/programs/presentation/program_detail_page.dart';
import 'package:saiyagym_mobile/features/progress/presentation/progress_page.dart';
import 'package:saiyagym_mobile/features/progress/presentation/records_page.dart';
import 'package:saiyagym_mobile/features/progress_photos/domain/progress_photo.dart';
import 'package:saiyagym_mobile/features/progress_photos/presentation/photo_compare_page.dart';
import 'package:saiyagym_mobile/features/progress_photos/presentation/progress_photos_page.dart';
import 'package:saiyagym_mobile/features/reminders/presentation/reminders_page.dart';
import 'package:saiyagym_mobile/features/routines/presentation/routine_editor_page.dart';
import 'package:saiyagym_mobile/features/today/presentation/today_page.dart';
import 'package:saiyagym_mobile/features/train/presentation/train_page.dart';

part 'app_router.g.dart';

/// Route guard, pure so it can be unit-tested.
///
/// - Restoring the session → splash.
/// - Signed out → only public routes (welcome by default).
/// - Signed in without level/goal → onboarding, and nothing else.
/// - Signed in → never on splash, public routes or a finished onboarding.
String? authRedirect({
  required AsyncValue<Session?> session,
  required String location,
}) {
  final isPublic = AppRoutes.public.contains(location);
  if (session.isLoading && !session.hasValue) {
    return location == AppRoutes.splash ? null : AppRoutes.splash;
  }
  final user = session.value?.user;
  if (user == null) return isPublic ? null : AppRoutes.welcome;
  if (user.needsOnboarding) {
    return location == AppRoutes.onboarding ? null : AppRoutes.onboarding;
  }
  if (isPublic ||
      location == AppRoutes.splash ||
      location == AppRoutes.onboarding) {
    return AppRoutes.today;
  }
  return null;
}

@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) {
  // One router for the app's lifetime; session changes re-run the redirect.
  final session = ValueNotifier<AsyncValue<Session?>>(const AsyncLoading());
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
      GoRoute(path: AppRoutes.welcome, builder: (_, _) => const WelcomePage()),
      GoRoute(path: AppRoutes.login, builder: (_, _) => const LoginPage()),
      GoRoute(
        path: AppRoutes.register,
        builder: (_, _) => const RegisterPage(),
      ),
      GoRoute(
        path: AppRoutes.forgotPassword,
        builder: (_, _) => const ForgotPasswordPage(),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (_, _) => const OnboardingPage(),
      ),
      GoRoute(
        path: AppRoutes.workout,
        builder: (_, _) => const LiveWorkoutPage(),
        routes: [
          GoRoute(
            path: 'summary',
            // Lost after an app restart (extra isn't persisted): go home.
            redirect: (_, state) =>
                state.extra is FinishOutcome ? null : AppRoutes.history,
            builder: (_, state) =>
                WorkoutSummaryPage(outcome: state.extra! as FinishOutcome),
          ),
        ],
      ),
      StatefulShellRoute.indexedStack(
        builder: (_, _, shell) => HomeShell(navigationShell: shell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.today,
                builder: (_, _) => const TodayPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.train,
                builder: (_, _) => const TrainPage(),
                routes: [
                  GoRoute(
                    path: 'routines/:id',
                    builder: (_, state) => RoutineEditorPage(
                      routineId: state.pathParameters['id'] == 'new'
                          ? null
                          : state.pathParameters['id'],
                    ),
                  ),
                  GoRoute(
                    path: 'programs/:id',
                    builder: (_, state) => ProgramDetailPage(
                      programId: state.pathParameters['id']!,
                    ),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.library,
                builder: (_, state) => LibraryPage(
                  section: LibrarySection.parse(
                    state.uri.queryParameters['section'],
                  ),
                ),
                routes: [
                  // Before ':id', or 'new' would be read as an id.
                  GoRoute(
                    path: 'exercises/new',
                    builder: (_, _) => const CustomExercisePage(),
                  ),
                  GoRoute(
                    path: 'exercises/:id',
                    builder: (_, state) => ExerciseDetailPage(
                      exerciseId: state.pathParameters['id']!,
                    ),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.progress,
                builder: (_, _) => const ProgressPage(),
                routes: [
                  GoRoute(
                    path: 'history',
                    builder: (_, _) => const HistoryPage(),
                    routes: [
                      GoRoute(
                        path: 'workouts/:id',
                        builder: (_, state) => WorkoutDetailPage(
                          workoutId: state.pathParameters['id']!,
                        ),
                        routes: [
                          GoRoute(
                            path: 'edit',
                            builder: (_, state) => WorkoutEditPage(
                              workoutId: state.pathParameters['id']!,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  GoRoute(
                    path: 'records',
                    builder: (_, _) => const RecordsPage(),
                  ),
                  GoRoute(
                    path: 'body',
                    builder: (_, _) => const BodyMetricsPage(),
                    routes: [
                      GoRoute(
                        path: ':id',
                        builder: (_, state) => BodyMetricFormPage(
                          metricId: state.pathParameters['id'] == 'new'
                              ? null
                              : state.pathParameters['id'],
                        ),
                      ),
                    ],
                  ),
                  GoRoute(
                    path: 'photos',
                    builder: (_, _) => const ProgressPhotosPage(),
                    routes: [
                      GoRoute(
                        path: 'compare',
                        builder: (_, state) => PhotoComparePage(
                          initialView:
                              PhotoView.values.asNameMap()[state
                                  .uri
                                  .queryParameters['view']] ??
                              PhotoView.front,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.profile,
                builder: (_, _) => const ProfilePage(),
                routes: [
                  GoRoute(
                    path: 'edit',
                    builder: (_, _) => const EditProfilePage(),
                  ),
                  GoRoute(
                    path: 'reminders',
                    builder: (_, _) => const RemindersPage(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
  ref.onDispose(router.dispose);
  return router;
}
