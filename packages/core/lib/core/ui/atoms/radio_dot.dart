import 'package:flutter/material.dart';

/// Classic outer-ring + inner-dot radio indicator — a stroked circle at the
/// full bounds, with a smaller filled circle inside when [selected]. Painted
/// rather than built from a bordered `Container` (as `AppCheckbox`'s circle
/// shape is) so the ring and dot can size independently of each other,
/// matching a native radio button's proportions exactly.
///
/// ```dart
/// AppRadioDot(selected: option == value)
/// ```
class AppRadioDot extends StatelessWidget {
  final bool selected;
  final double size;
  final double borderWidth;
  final Color? fillColor;
  final Color? borderColor;

  const AppRadioDot({
    super.key,
    required this.selected,
    this.size = 16,
    this.borderWidth = 1,
    this.fillColor,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return CustomPaint(
      size: Size(size, size),
      painter: _RadioDotPainter(
        fillColor: selected ? (fillColor ?? cs.primary) : Colors.transparent,
        borderColor: borderColor ?? (selected ? cs.primary : cs.outline),
        borderWidth: borderWidth,
      ),
    );
  }
}

class _RadioDotPainter extends CustomPainter {
  final Color fillColor;
  final Color borderColor;
  final double borderWidth;

  const _RadioDotPainter({
    required this.fillColor,
    required this.borderColor,
    required this.borderWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paintFill = Paint()
      ..color = fillColor
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final paintBorder = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = borderWidth;

    final offset = Offset(size.width * 0.5, size.height * 0.5);
    canvas.drawCircle(offset, size.width * 0.3, paintFill);
    canvas.drawCircle(offset, size.width * 0.5, paintBorder);
  }

  @override
  bool shouldRepaint(covariant _RadioDotPainter old) =>
      old.fillColor != fillColor ||
      old.borderColor != borderColor ||
      old.borderWidth != borderWidth;
}
