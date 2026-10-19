// Draws the app icon and splash logo (run from the project root):
//
//   dart run tool/generate_branding.dart
//   dart run flutter_launcher_icons
//   dart run flutter_native_splash:create
//
// A simple brand mark (white dumbbell on the brand teal) until a designed
// logo exists: replace the PNGs in assets/branding/ and run the last two
// commands again.
import 'dart:io';

import 'package:image/image.dart' as img;

final _brand = img.ColorRgba8(0x00, 0xC9, 0xB7, 0xFF);
final _white = img.ColorRgba8(0xFF, 0xFF, 0xFF, 0xFF);
final _clear = img.ColorRgba8(0, 0, 0, 0);

/// Horizontal dumbbell centered on [canvas], [scale] of its width wide.
void _dumbbell(img.Image canvas, img.Color color, {double scale = 0.62}) {
  final size = canvas.width;
  final width = size * scale;
  final left = (size - width) / 2;
  final cy = size / 2;
  void rect(double x, double w, double h) => img.fillRect(
    canvas,
    x1: (left + x * width).round(),
    y1: (cy - h * width / 2).round(),
    x2: (left + (x + w) * width).round(),
    y2: (cy + h * width / 2).round(),
    color: color,
    radius: (0.03 * width).round(),
  );

  rect(0.24, 0.52, 0.08); // bar
  for (final x in [0.0, 0.88]) {
    rect(x, 0.12, 0.30); // outer plates
  }
  for (final x in [0.13, 0.75]) {
    rect(x, 0.12, 0.52); // inner plates
  }
}

img.Image _square(int size, img.Color background) =>
    img.Image(width: size, height: size, numChannels: 4)..clear(background);

void main() {
  final dir = Directory('assets/branding')..createSync(recursive: true);
  void save(String name, img.Image image) =>
      File('${dir.path}/$name').writeAsBytesSync(img.encodePng(image));

  // iOS / legacy Android: full-bleed square (the OS rounds it).
  save('icon.png', _square(1024, _brand).._draw());
  // Android adaptive: foreground inside the 66 % safe zone, teal behind.
  save(
    'icon_foreground.png',
    _square(1024, _clear)..apply((c) => _dumbbell(c, _white, scale: 0.42)),
  );
  // Splash: white mark on the brand color set in pubspec.yaml.
  save(
    'splash.png',
    _square(768, _clear)..apply((c) => _dumbbell(c, _white, scale: 0.7)),
  );
  stdout.writeln('assets/branding/{icon,icon_foreground,splash}.png written');
}

extension on img.Image {
  void _draw() => _dumbbell(this, _white);

  void apply(void Function(img.Image canvas) draw) => draw(this);
}
