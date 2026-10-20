// Copies the app icon from the design folder into the project (run from the
// project root):
//
//   dart run tool/sync_branding.dart [path/to/icono-app]   # default ../icono-app
//   dart run flutter_native_splash:create
//
// The design folder is the source of truth (master SVG/PNG plus exports per
// platform); this script only copies and adapts:
// - Android: mipmap-* (legacy, adaptive and Android 13 monochrome icons).
// - iOS: AppIcon.appiconset, flattened on the background colour — the App
//   Store rejects icons with an alpha channel.
// - assets/branding/: the in-app logo and the splash image.
// Colours live in lib/core/theme/app_theme.dart (AppColors), taken from
// master/icon.svg; the splash colour in pubspec.yaml.
import 'dart:io';

import 'package:image/image.dart' as img;

/// Background of master/icon.svg (`#C9C23A`).
final _iconBackground = img.ColorRgb8(0xC9, 0xC2, 0x3A);

void main(List<String> args) {
  final source = Directory(args.isEmpty ? '../icono-app' : args.first);
  if (!source.existsSync()) {
    stderr.writeln('Design folder not found: ${source.path}');
    exitCode = 1;
    return;
  }
  final from = source.path;

  // Android: replace the launcher icons; drop the ones a previous tool
  // generated elsewhere (they would shadow or duplicate these).
  const res = 'android/app/src/main/res';
  for (final density in ['mdpi', 'hdpi', 'xhdpi', 'xxhdpi', 'xxxhdpi']) {
    final stale = File('$res/drawable-$density/ic_launcher_foreground.png');
    if (stale.existsSync()) stale.deleteSync();
  }
  final staleColors = File('$res/values/colors.xml');
  if (staleColors.existsSync() &&
      staleColors.readAsStringSync().contains('ic_launcher_background')) {
    staleColors.deleteSync();
  }
  _copyTree(Directory('$from/android/res'), Directory(res));

  // iOS: same set, without alpha.
  const iconSet = 'ios/Runner/Assets.xcassets/AppIcon.appiconset';
  final iosTarget = Directory(iconSet);
  if (iosTarget.existsSync()) iosTarget.deleteSync(recursive: true);
  iosTarget.createSync(recursive: true);
  for (final file in Directory(
    '$from/ios/AppIcon.appiconset',
  ).listSync().whereType<File>()) {
    final name = file.uri.pathSegments.last;
    final target = File('$iconSet/$name');
    if (name.endsWith('.png')) {
      target.writeAsBytesSync(img.encodePng(_opaque(file)));
    } else {
      file.copySync(target.path);
    }
  }

  // In-app logo and native splash image.
  Directory('assets/branding').createSync(recursive: true);
  File('$from/master/icon-1024.png').copySync('assets/branding/icon.png');
  File('$from/android/res/mipmap-xxxhdpi/ic_launcher_foreground.png')
      .copySync('assets/branding/splash.png');

  stdout.writeln(
    'Synced from $from. Now run: dart run flutter_native_splash:create',
  );
}

void _copyTree(Directory from, Directory to) {
  for (final entity in from.listSync(recursive: true)) {
    if (entity is! File) continue;
    final relative = entity.path
        .substring(from.path.length + 1)
        .replaceAll(r'\', '/');
    final target = File('${to.path}/$relative')
      ..parent.createSync(recursive: true);
    entity.copySync(target.path);
  }
}

/// RGB copy of [file] composited over the icon background.
img.Image _opaque(File file) {
  final image = img.decodePng(file.readAsBytesSync())!;
  final flat = img.Image(width: image.width, height: image.height)
    ..clear(_iconBackground);
  return img.compositeImage(flat, image);
}
