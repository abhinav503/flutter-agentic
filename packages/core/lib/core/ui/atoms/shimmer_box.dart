import 'package:flutter/material.dart';

import '../../theme/app_radius.dart';

/// A single shimmering placeholder shape — the building block for skeleton
/// loading states. Compose several inside a layout that mirrors the real
/// content's silhouette (e.g. a row of circular [ShimmerBox]es for category
/// tiles, a rounded-rect [ShimmerBox] per product card) rather than
/// replacing a whole screen with a spinner.
///
/// Colour is theme-derived (`surfaceContainerHighest` base,
/// `surfaceContainerHigh` sweep) — no hardcoded greys, so it re-skins with
/// the active theme/dark mode like every other atom.
class ShimmerBox extends StatefulWidget {
  final double width;
  final double height;
  final BorderRadius borderRadius;

  // Small default — matches a thin text-line placeholder (title/label/price
  // bars, the majority of call sites). Pass an explicit borderRadius (e.g.
  // the theme's AppShapes.cardRadius) for anything mimicking a card or image.
  const ShimmerBox({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = AppRadius.sm,
  });

  /// Circular variant — e.g. a category tile's image circle.
  const ShimmerBox.circle({super.key, required double size})
    : width = size,
      height = size,
      borderRadius = const BorderRadius.all(Radius.circular(9999));

  @override
  State<ShimmerBox> createState() => _ShimmerBoxState();
}

class _ShimmerBoxState extends State<ShimmerBox>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final base = cs.surfaceContainerHighest;
    final sweep = cs.surfaceContainerHigh;

    return ClipRRect(
      borderRadius: widget.borderRadius,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          // Sweeps a highlight band left-to-right, looping past both edges
          // so the seam never freezes mid-frame.
          final t = _controller.value;
          return DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment(-1 - 2 * t, 0),
                end: Alignment(1 - 2 * t, 0),
                colors: [base, sweep, base],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
            child: SizedBox(width: widget.width, height: widget.height),
          );
        },
      ),
    );
  }
}
