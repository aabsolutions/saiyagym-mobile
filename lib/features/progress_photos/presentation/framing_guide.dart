import 'package:flutter/material.dart';
import 'package:saiyagym_mobile/features/progress_photos/domain/progress_photo.dart';

/// Silhouette + center line over the photo (portrait 3:4), so every photo
/// of a view is framed the same way and comparisons are fair.
class FramingGuide extends StatelessWidget {
  const FramingGuide({required this.view, this.color, super.key});

  final PhotoView view;
  final Color? color;

  @override
  Widget build(BuildContext context) => CustomPaint(
    painter: _GuidePainter(
      view,
      color ?? Theme.of(context).colorScheme.primary,
    ),
    child: const SizedBox.expand(),
  );
}

class _GuidePainter extends CustomPainter {
  _GuidePainter(this.view, this.color);

  final PhotoView view;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final line = Paint()
      ..color = color.withValues(alpha: 0.85)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;
    final faint = Paint()
      ..color = color.withValues(alpha: 0.35)
      ..strokeWidth = 1;

    // Center line and eye / hip levels.
    canvas
      ..drawLine(Offset(w / 2, 0), Offset(w / 2, h), faint)
      ..drawLine(Offset(0, h * 0.14), Offset(w, h * 0.14), faint)
      ..drawLine(Offset(0, h * 0.55), Offset(w, h * 0.55), faint)
      ..drawCircle(Offset(w / 2, h * 0.12), w * 0.075, line);

    // Half-widths (fractions of w) at shoulder / waist / hip / knee / feet.
    final side = view == PhotoView.side;
    final shoulder = side ? 0.11 : 0.21;
    final waist = side ? 0.10 : 0.14;
    final hip = side ? 0.12 : 0.17;
    final knee = side ? 0.08 : 0.12;
    final feet = side ? 0.10 : 0.14;

    Path half(double sign) {
      double x(double fraction) => w / 2 + sign * fraction * w;
      return Path()
        ..moveTo(x(0.04), h * 0.20)
        ..quadraticBezierTo(x(shoulder), h * 0.22, x(shoulder), h * 0.27)
        ..lineTo(x(waist), h * 0.45)
        ..lineTo(x(hip), h * 0.55)
        ..lineTo(x(knee), h * 0.75)
        ..lineTo(x(feet), h * 0.95);
    }

    canvas
      ..drawPath(half(-1), line)
      ..drawPath(half(1), line);
  }

  @override
  bool shouldRepaint(_GuidePainter old) =>
      old.view != view || old.color != color;
}
