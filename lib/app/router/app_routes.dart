abstract final class AppRoutes {
  static const splash = '/splash';
  static const welcome = '/welcome';
  static const login = '/login';
  static const register = '/register';
  static const forgotPassword = '/forgot-password';
  static const onboarding = '/onboarding';

  // Bottom navigation tabs, in order.
  static const today = '/today';
  static const train = '/train';
  static const history = '/history';
  static const progress = '/progress';
  static const profile = '/profile';

  static const editProfile = '/profile/edit';

  // Inside the Train tab (keep the bottom bar).
  static String routine(String id) => '/train/routines/$id';
  static const newRoutine = '/train/routines/new';
  static String program(String id) => '/train/programs/$id';
  static const exercises = '/train/exercises';
  static const newExercise = '/train/exercises/new';
  static String exercise(String id) => '/train/exercises/$id';

  // Inside the History tab.
  static String workoutDetail(String id) => '/history/workouts/$id';
  static String workoutEdit(String id) => '/history/workouts/$id/edit';

  /// Full screen, outside the tabs.
  static const workout = '/workout';
  static const workoutSummary = '/workout/summary';

  /// Reachable signed out (and only then).
  static const Set<String> public = {welcome, login, register, forgotPassword};
}
