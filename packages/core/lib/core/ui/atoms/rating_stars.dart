import 'package:flutter/material.dart';

import '../../theme/app_spacing.dart';

/// A row of stars showing a rating.
///
/// Takes a fractional rating (4.3) rather than a whole one, because that is
/// what an average of many reviews actually is — the trailing star renders
/// partly filled instead of rounding a 4.5 up to five full stars.
///
/// Every visual is a parameter and nothing is read from the theme's brand
/// roles: a rating star is amber in both light and dark (a theme colour
/// would flip it in dark mode and it would stop reading as a rating), and
/// each style pack pins its kit's own swatch. Packs whose kit ships star
/// artwork pass [starBuilder] and keep their asset.
class RatingStars extends StatelessWidget {
  final double rating;
  final int starCount;
  final double size;

  /// The filled colour. Defaults to the widely-understood rating amber; a
  /// pack passes its kit's exact swatch.
  final Color color;

  /// The unfilled remainder. Defaults to [color] at low opacity, so a
  /// caller that only pins the fill still gets a coherent pair.
  final Color? emptyColor;

  final double spacing;

  /// Draws one star at [fill] (0 = empty, 1 = full). The default renders
  /// Material's rounded star, half star, or outline.
  final Widget Function(BuildContext context, double fill)? starBuilder;

  const RatingStars({
    super.key,
    required this.rating,
    this.starCount = 5,
    this.size = AppSpacing.lg,
    this.color = defaultStarColor,
    this.emptyColor,
    this.spacing = AppSpacing.xs4,
    this.starBuilder,
  });

  /// Amber in both themes — see the class doc for why this isn't a role.
  static const defaultStarColor = Color(0xFFF5A623);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < starCount; i++) ...[
          if (i > 0) SizedBox(width: spacing),
          _star(context, (rating - i).clamp(0.0, 1.0)),
        ],
      ],
    );
  }

  Widget _star(BuildContext context, double fill) {
    final builder = starBuilder;
    if (builder != null) return builder(context, fill);

    // Thirds, not halves: a 4.3 average should not draw a half star at 4.3
    // and a full one at 4.7 — those read as the same rating.
    final (icon, tint) = switch (fill) {
      >= 0.75 => (Icons.star_rounded, color),
      >= 0.25 => (Icons.star_half_rounded, color),
      _ => (
        Icons.star_outline_rounded,
        emptyColor ?? color.withValues(alpha: 0.3),
      ),
    };
    return Icon(icon, size: size, color: tint);
  }
}

/// The tappable counterpart — a whole-star rating input.
///
/// Whole stars only: a shopper picks 1–5, and the fractional averages
/// [RatingStars] renders are something only a set of reviews produces.
/// [value] 0 means nothing is chosen yet, which is how a write-review form
/// knows to keep its submit disabled.
class RatingStarsField extends StatelessWidget {
  final int value;
  final ValueChanged<int> onChanged;
  final int starCount;
  final double size;
  final Color color;
  final Color? emptyColor;
  final double spacing;

  /// Blocks input while a submit is in flight, without dimming the row —
  /// the stars stay legible so the shopper can see what they picked.
  final bool enabled;

  const RatingStarsField({
    super.key,
    required this.value,
    required this.onChanged,
    this.starCount = 5,
    this.size = AppSpacing.xl4,
    this.color = RatingStars.defaultStarColor,
    this.emptyColor,
    this.spacing = AppSpacing.xs,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var star = 1; star <= starCount; star++) ...[
          if (star > 1) SizedBox(width: spacing),
          GestureDetector(
            // The star itself is smaller than the minimum comfortable touch
            // target, so the gesture is taken on padded box around it.
            behavior: HitTestBehavior.opaque,
            onTap: enabled ? () => onChanged(star) : null,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs2),
              child: Icon(
                star <= value ? Icons.star_rounded : Icons.star_outline_rounded,
                size: size,
                color: star <= value
                    ? color
                    : emptyColor ?? color.withValues(alpha: 0.3),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
