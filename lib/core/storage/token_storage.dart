import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'token_storage.g.dart';

/// The API's `TokenPairDto` (only what the client needs).
class AuthTokens {
  const AuthTokens({required this.accessToken, required this.refreshToken});

  factory AuthTokens.fromJson(Map<String, dynamic> json) => AuthTokens(
    accessToken: json['accessToken'] as String,
    refreshToken: json['refreshToken'] as String,
  );

  final String accessToken;

  /// Opaque and single-use: every refresh returns a new one (rotation).
  final String refreshToken;

  Map<String, dynamic> toJson() => {
    'accessToken': accessToken,
    'refreshToken': refreshToken,
  };
}

abstract interface class TokenStorage {
  Future<AuthTokens?> read();
  Future<void> write(AuthTokens tokens);
  Future<void> clear();
}

/// Keychain / Keystore backed. Tokens are cached in memory so the auth
/// interceptor doesn't hit the platform channel on every request.
class SecureTokenStorage implements TokenStorage {
  SecureTokenStorage(this._storage);

  static const _accessKey = 'auth.accessToken';
  static const _refreshKey = 'auth.refreshToken';

  final FlutterSecureStorage _storage;
  AuthTokens? _cached;
  bool _loaded = false;

  @override
  Future<AuthTokens?> read() async {
    if (_loaded) return _cached;
    final access = await _storage.read(key: _accessKey);
    final refresh = await _storage.read(key: _refreshKey);
    _cached = access != null && refresh != null
        ? AuthTokens(accessToken: access, refreshToken: refresh)
        : null;
    _loaded = true;
    return _cached;
  }

  @override
  Future<void> write(AuthTokens tokens) async {
    _cached = tokens;
    _loaded = true;
    await _storage.write(key: _accessKey, value: tokens.accessToken);
    await _storage.write(key: _refreshKey, value: tokens.refreshToken);
  }

  @override
  Future<void> clear() async {
    _cached = null;
    _loaded = true;
    await _storage.delete(key: _accessKey);
    await _storage.delete(key: _refreshKey);
  }
}

@Riverpod(keepAlive: true)
TokenStorage tokenStorage(Ref ref) => SecureTokenStorage(
  const FlutterSecureStorage(
    // Readable after the first unlock: background sync must reach the tokens.
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  ),
);
