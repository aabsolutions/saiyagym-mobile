import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:saiyagym_mobile/core/network/api_client.dart';
import 'package:saiyagym_mobile/features/auth/auth_providers.dart';
import 'package:saiyagym_mobile/features/auth/domain/entities/user.dart';

part 'session_controller.g.dart';

/// Who is signed in. `null` = signed out; loading = restoring at startup.
/// The router redirects from this state.
@Riverpod(keepAlive: true)
class SessionController extends _$SessionController {
  @override
  Future<User?> build() {
    final subscription = ref
        .read(sessionEventsProvider)
        .expired
        .listen((_) => _expire());
    ref.onDispose(subscription.cancel);
    return ref.read(restoreSessionUseCaseProvider)();
  }

  void signedIn(User user) => state = AsyncData(user);

  void userUpdated(User user) => state = AsyncData(user);

  Future<void> logout() async {
    await ref.read(logoutUseCaseProvider)();
    state = const AsyncData(null);
  }

  Future<void> _expire() async {
    await ref.read(authRepositoryProvider).clearSession();
    state = const AsyncData(null);
  }
}
