import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:saiyagym_mobile/core/network/api_client.dart';
import 'package:saiyagym_mobile/features/auth/auth_providers.dart';
import 'package:saiyagym_mobile/features/auth/domain/entities/session.dart';
import 'package:saiyagym_mobile/features/auth/domain/entities/user.dart';

part 'session_controller.g.dart';

/// Who is signed in. `null` = signed out; loading = restoring at startup.
/// The router redirects from this state.
@Riverpod(keepAlive: true)
class SessionController extends _$SessionController {
  @override
  Future<Session?> build() {
    final subscription = ref
        .read(sessionEventsProvider)
        .expired
        .listen((_) => _expire());
    ref.onDispose(subscription.cancel);
    return ref.read(restoreSessionUseCaseProvider)();
  }

  void signedIn(User user) => state = AsyncData(Session(user: user));

  /// A fresh user from the API: also means we're online again.
  void userUpdated(User user) => state = AsyncData(Session(user: user));

  /// Re-fetches `/users/me` (email verified elsewhere, back online, …).
  /// Throws `ApiException`; the current session is kept on failure.
  Future<void> refreshUser() async {
    final user = await ref.read(authRepositoryProvider).refreshUser();
    if (ref.mounted) userUpdated(user);
  }

  Future<void> logout() async {
    await ref.read(logoutUseCaseProvider)();
    state = const AsyncData(null);
  }

  Future<void> _expire() async {
    await ref.read(authRepositoryProvider).clearSession();
    state = const AsyncData(null);
  }
}

/// The signed-in user, or `null`.
@Riverpod(keepAlive: true)
User? currentUser(Ref ref) =>
    ref.watch(sessionControllerProvider.select((s) => s.value?.user));
