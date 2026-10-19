import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_config.g.dart';

enum Flavor { dev, prod }

/// Build-time configuration. One instance per run, chosen by flavor.
class AppConfig {
  const AppConfig({required this.flavor, required this.apiBaseUrl});

  /// [flavorName] comes from `appFlavor` (`--flavor`) or, where native
  /// flavors aren't wired yet (iOS), from `--dart-define=FLAVOR=...`.
  /// `--dart-define=API_BASE_URL=...` overrides the URL (e.g. a physical
  /// device hitting the dev API on the LAN).
  factory AppConfig.resolve({String? flavorName}) {
    final flavor = Flavor.values.firstWhere(
      (f) => f.name == flavorName,
      orElse: () => Flavor.dev,
    );
    const override = String.fromEnvironment('API_BASE_URL');
    return AppConfig(
      flavor: flavor,
      apiBaseUrl: override.isNotEmpty
          ? override
          : switch (flavor) {
              // The Android emulator reaches the host at 10.0.2.2; the iOS
              // simulator shares the host's network (localhost).
              Flavor.dev =>
                defaultTargetPlatform == TargetPlatform.iOS
                    ? 'http://localhost:3000/api/v1'
                    : 'http://10.0.2.2:3000/api/v1',
              // Render (free plan: the first request after idling can
              // take ~40 s; the app shows a "server waking up" banner).
              Flavor.prod => 'https://saiyagym-api.onrender.com/api/v1',
            },
    );
  }

  final Flavor flavor;
  final String apiBaseUrl;

  bool get isDev => flavor == Flavor.dev;
}

/// Overridden in `main.dart` with the resolved config.
@Riverpod(keepAlive: true)
AppConfig appConfig(Ref ref) =>
    throw UnimplementedError('appConfigProvider must be overridden at startup');
