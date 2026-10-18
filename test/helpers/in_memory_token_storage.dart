import 'package:saiyagym_mobile/core/storage/token_storage.dart';

class InMemoryTokenStorage implements TokenStorage {
  InMemoryTokenStorage([this._tokens]);

  AuthTokens? _tokens;

  @override
  Future<AuthTokens?> read() async => _tokens;

  @override
  Future<void> write(AuthTokens tokens) async => _tokens = tokens;

  @override
  Future<void> clear() async => _tokens = null;
}
