import 'package:flutter/material.dart';

import '../../theme/app_radius.dart';
import '../../theme/app_shapes_extension.dart';

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

  /// Null means "the theme's card radius" — only [ShimmerBox.card] sets it
  /// null; both public constructors otherwise pin a concrete radius.
  final BorderRadius? borderRadius;

  /// Override the theme-derived shimmer colours — for a skeleton sitting on
  /// a canvas where the surface-container ramp has no contrast left (e.g. a
  /// brand-tinted page background). Omit both for the theme defaults.
  final Color? baseColor;
  final Color? sweepColor;

  // Small default — matches a thin text-line placeholder (title/label/price
  // bars, the majority of call sites). Pass an explicit borderRadius (e.g.
  // the theme's AppShapes.cardRadius) for anything mimicking a card or image.
  const ShimmerBox({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = AppRadius.sm,
    this.baseColor,
    this.sweepColor,
  });

  /// Circular variant — e.g. a category tile's image circle.
  const ShimmerBox.circle({
    super.key,
    required double size,
    this.baseColor,
    this.sweepColor,
  }) : width = size,
       height = size,
       borderRadius = const BorderRadius.all(Radius.circular(9999));

  /// Card-silhouette variant: shimmers at the theme's `AppShapes.cardRadius`
  /// so a card skeleton never hand-derives
  /// `BorderRadius.circular(context.appShapes.cardRadius)` at the call site.
  const ShimmerBox.card({
    super.key,
    required this.height,
    this.width = double.infinity,
    this.baseColor,
    this.sweepColor,
  }) : borderRadius = null;

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
    final base = widget.baseColor ?? cs.surfaceContainerHighest;
    final sweep = widget.sweepColor ?? cs.surfaceContainerHigh;
    final radius =
        widget.borderRadius ??
        BorderRadius.circular(context.appShapes.cardRadius);

    return ClipRRect(
      borderRadius: radius,
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
