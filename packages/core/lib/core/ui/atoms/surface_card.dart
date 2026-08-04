import 'package:flutter/material.dart';

import '../../theme/app_shapes_extension.dart';

/// The tappable-card surface recipe — shadow under an ink-capable rounded
/// fill with an optional outline:
///
/// `DecoratedBox(boxShadow) → Material(color) → InkWell → Container(border)`
///
/// The layering is load-bearing and easy to get wrong when hand-rolled: a
/// `boxShadow` declared on a child of the [Material] paints **after** the
/// fill, so the shadow must live on a wrapper outside it — which packs kept
/// re-deriving per card. This atom owns that ordering once; packs pass their
/// colours/radius/shadows and compose their content inside.
class AppSurfaceCard extends StatelessWidget {
  final Widget child;

  /// Fill (default `cs.surface`).
  final Color? color;

  /// Corner radius (default the theme's `AppShapes.cardRadius`).
  final BorderRadius? borderRadius;

  /// Drop shadows, painted under the fill — e.g. `context.appShadows.card`.
  /// Omit for a flat card.
  final List<BoxShadow>? shadows;

  /// Optional outline drawn over the fill's edge.
  final Color? borderColor;
  final double borderWidth;

  /// Null renders no [InkWell] at all — a decorative card costs no hit-test.
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  final double? height;
  final double? width;
  final EdgeInsetsGeometry? padding;
  final AlignmentGeometry? alignment;

  /// [Clip.antiAlias] by default so content (an image bleeding to the card
  /// edge) honours the radius; pass [Clip.none] for content that must
  /// overflow the card's bounds (a welded corner control).
  final Clip clipBehavior;

  const AppSurfaceCard({
    super.key,
    required this.child,
    this.color,
    this.borderRadius,
    this.shadows,
    this.borderColor,
    this.borderWidth = 1,
    this.onTap,
    this.onLongPress,
    this.height,
    this.width,
    this.padding,
    this.alignment,
    this.clipBehavior = Clip.antiAlias,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final radius =
        borderRadius ?? BorderRadius.circular(context.appShapes.cardRadius);

    Widget content = Container(
      height: height,
      width: width,
      padding: padding,
      alignment: alignment,
      decoration: borderColor != null
          ? BoxDecoration(
              borderRadius: radius,
              border: Border.all(color: borderColor!, width: borderWidth),
            )
          : null,
      child: child,
    );

    if (onTap != null || onLongPress != null) {
      content = InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: radius,
        child: content,
      );
    }

    Widget card = Material(
      color: color ?? cs.surface,
      borderRadius: radius,
      clipBehavior: clipBehavior,
      child: content,
    );

    if (shadows != null && shadows!.isNotEmpty) {
      card = DecoratedBox(
        decoration: BoxDecoration(borderRadius: radius, boxShadow: shadows),
        child: card,
      );
    }

    return card;
  }
}
