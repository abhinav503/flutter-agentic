import 'package:flutter/material.dart';

/// A non-interactive tinted disc holding a centred glyph — the decorative
/// leading circle of notification rows, menu tiles, and status bars. Kept
/// separate from [AppIconButton]: that atom is a *button* (InkWell, splash,
/// onTap) while this is pure decoration, and wrapping every static disc in
/// a dead button would cost hit-testing and imply tappability.
class AppIconCircle extends StatelessWidget {
  final double size;
  final Color color;
  final Widget child;

  const AppIconCircle({
    super.key,
    required this.size,
    required this.color,
    required this.child,
  });

  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    alignment: Alignment.center,
    child: child,
  );
}
