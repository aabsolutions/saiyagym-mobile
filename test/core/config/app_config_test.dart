import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saiyagym_mobile/core/config/app_config.dart';

void main() {
  tearDown(() => debugDefaultTargetPlatformOverride = null);

  test('unknown or missing flavor falls back to dev', () {
    expect(AppConfig.resolve().flavor, Flavor.dev);
    expect(AppConfig.resolve(flavorName: 'staging').flavor, Flavor.dev);
  });

  test('prod: the Render API, over HTTPS, with the /api/v1 prefix', () {
    final config = AppConfig.resolve(flavorName: 'prod');

    expect(config.flavor, Flavor.prod);
    expect(config.apiBaseUrl, 'https://saiyagym-api.onrender.com/api/v1');
  });

  test('dev targets the host machine from each simulator', () {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    expect(
      AppConfig.resolve(flavorName: 'dev').apiBaseUrl,
      'http://10.0.2.2:3000/api/v1',
    );

    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    expect(
      AppConfig.resolve(flavorName: 'dev').apiBaseUrl,
      'http://localhost:3000/api/v1',
    );
  });
}
