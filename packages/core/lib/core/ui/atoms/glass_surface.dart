import 'dart:ui';

import 'package:flutter/material.dart';

/// Circular glass container — backdrop blur + tinted fill, an inset
/// top glow / bottom shadow pair, and a gradient rim, giving a frosted
/// "glass" disc that any icon or small content can sit on top of.
///
/// Used by [AppIconButton]'s `glass` variant; reach for it directly when
/// something other than a tappable icon button needs the same glass disc
/// (e.g. a static badge over an image).
class AppGlassSurface extends StatelessWidget {
  const AppGlassSurface({
    super.key,
    required this.child,
    this.size = 40,
    this.tintColor = Colors.white,
    this.blurSigma = 12,
  });

  final Widget child;
  final double size;
  final Color tintColor;
  final double blurSigma;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: ClipOval(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
          child: CustomPaint(
            painter: _GlassCirclePainter(tintColor: tintColor),
            child: Center(child: child),
          ),
        ),
      ),
    );
  }
}

class _GlassCirclePainter extends CustomPainter {
  const _GlassCirclePainter({required this.tintColor});

  final Color tintColor;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    // Semi-transparent glass fill, tinted to whatever sits on top.
    canvas.drawCircle(
      center,
      radius,
      Paint()..color = tintColor.withValues(alpha: 0.15),
    );

    // Top inset white glow.
    final topGlowPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.4)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;
    canvas.drawArc(
      Rect.fromCircle(
          center: Offset(center.dx, center.dy - 1), radius: radius - 2),
      -2.2,
      4.4,
      false,
      topGlowPaint,
    );

    // Bottom inset dark shadow.
    final bottomShadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.2)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;
    canvas.drawArc(
      Rect.fromCircle(
          center: Offset(center.dx, center.dy + 1), radius: radius - 2),
      0.9,
      4.4,
      false,
      bottomShadowPaint,
    );

    // Gradient border stroke.
    final gradientBorderPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: [
          Colors.white.withValues(alpha: 0.05),
          Colors.white.withValues(alpha: 0.5),
          Colors.white.withValues(alpha: 0.05),
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;
    canvas.drawCircle(center, radius - 0.25, gradientBorderPaint);
  }

  @override
  bool shouldRepaint(covariant _GlassCirclePainter old) =>
      old.tintColor != tintColor;
}
