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

  /// Reachable signed out (and only then).
  static const Set<String> public = {welcome, login, register, forgotPassword};
}
