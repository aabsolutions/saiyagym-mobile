import 'package:saiyagym_mobile/features/progress_photos/domain/progress_photo.dart';

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

  static const nutrition = '/today/nutrition';

  static const editProfile = '/profile/edit';
  static const reminders = '/profile/reminders';

  // Inside the Progress tab.
  static const records = '/progress/records';
  static const bodyMetrics = '/progress/body';
  static const newBodyMetric = '/progress/body/new';
  static String bodyMetric(String id) => '/progress/body/$id';
  static const progressPhotos = '/progress/photos';
  static String photoCompare(PhotoView view) =>
      '/progress/photos/compare?view=${view.name}';

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
