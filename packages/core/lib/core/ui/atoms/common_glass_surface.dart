import 'dart:ui';

import 'package:flutter/material.dart';

/// Rounded-rect glass container — the [AppGlassSurface] frosted-disc effect
/// (backdrop blur, tinted fill, inset top glow / bottom shadow, gradient rim)
/// generalized to an arbitrary [borderRadius] instead of a circle, for
/// content that isn't circular (e.g. [AppTextField]).
///
/// [tintColor] should usually be the color the surface would otherwise be
/// painted (e.g. `colorScheme.surface`), not a fixed white — the glass effect
/// is a frosted version of that color, not a white overlay.
class CommonGlassSurface extends StatelessWidget {
  const CommonGlassSurface({
    super.key,
    required this.child,
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
    this.tintColor = Colors.white,
    this.blurSigma = 10,
  });

  final Widget child;
  final BorderRadius borderRadius;
  final Color tintColor;
  final double blurSigma;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
        child: CustomPaint(
          painter: _GlassRectPainter(
            tintColor: tintColor,
            borderRadius: borderRadius,
          ),
          child: child,
        ),
      ),
    );
  }
}

class _GlassRectPainter extends CustomPainter {
  const _GlassRectPainter({required this.tintColor, required this.borderRadius});

  final Color tintColor;
  final BorderRadius borderRadius;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final rrect = borderRadius.toRRect(rect);

    // Semi-transparent glass fill, tinted to whatever this would otherwise
    // be painted solid.
    canvas.drawRRect(rrect, Paint()..color = tintColor.withValues(alpha: 0.15));

    // Top/bottom rim, traced along the ACTUAL rounded outline (not just the
    // straight edges) and split into a lit half and a shadowed half — the
    // rect counterpart of the circle painter's two opposing arcs. A large
    // borderRadius (e.g. a pill-shaped input) is mostly curve, so a treatment
    // limited to the flat top/bottom segments would leave both end-caps bare.
    // Traced 1.5px inset from the true edge so the highlight/shadow survive
    // the surrounding ClipRRect (which would otherwise clip a boundary-drawn
    // stroke roughly in half).
    final rimPath = Path()..addRRect(rrect.deflate(1.5));
    final rimMetric = rimPath.computeMetrics().first;
    final rimLength = rimMetric.length;

    canvas.drawPath(
      rimMetric.extractPath(0, rimLength / 2),
      Paint()
        ..color = Colors.white.withValues(alpha: 0.4)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
    );

    canvas.drawPath(
      rimMetric.extractPath(rimLength / 2, rimLength),
      Paint()
        ..color = Colors.black.withValues(alpha: 0.2)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
    );

    // Gradient border stroke around the whole shape.
    canvas.drawRRect(
      rrect.deflate(0.25),
      Paint()
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
        ..strokeWidth = 0.5,
    );
  }

  @override
  bool shouldRepaint(covariant _GlassRectPainter old) =>
      old.tintColor != tintColor || old.borderRadius != borderRadius;
}
