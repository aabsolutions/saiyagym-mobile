import 'package:flutter/material.dart';

/// The app icon (assets/branding/icon.png, synced from ../icono-app),
/// rounded like on the home screen. Decorative: the app name is always
/// written next to it, so screen readers skip the image.
class AppLogo extends StatelessWidget {
  const AppLogo({this.size = 88, super.key});

  final double size;

  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(size * 0.22),
    child: Image.asset(
      'assets/branding/icon.png',
      width: size,
      height: size,
      excludeFromSemantics: true,
    ),
  );
}
