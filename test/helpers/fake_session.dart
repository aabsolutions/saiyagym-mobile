import 'package:saiyagym_mobile/features/auth/domain/entities/session.dart';
import 'package:saiyagym_mobile/features/auth/domain/entities/user.dart';
import 'package:saiyagym_mobile/features/auth/presentation/controllers/session_controller.dart';

/// Starts with a fixed session; signing in / updates work as in the app.
class FakeSession extends SessionController {
  FakeSession(this._session);

  FakeSession.user(User? user, {bool offline = false})
    : this(user == null ? null : Session(user: user, isOffline: offline));

  final Session? _session;

  @override
  Future<Session?> build() async => _session;
}
