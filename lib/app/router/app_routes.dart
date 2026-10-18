abstract final class AppRoutes {
  static const splash = '/splash';
  static const login = '/login';
  static const register = '/register';

  // Bottom navigation tabs, in order.
  static const today = '/today';
  static const train = '/train';
  static const history = '/history';
  static const progress = '/progress';
  static const profile = '/profile';

  static const Set<String> public = {login, register};
}
