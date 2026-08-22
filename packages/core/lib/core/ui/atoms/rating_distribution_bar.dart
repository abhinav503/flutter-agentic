import 'package:flutter/material.dart';

import '../../theme/app_radius.dart';
import 'rating_stars.dart';

/// One row of a rating histogram: the share of reviews that gave this many
/// stars, as a filled track.
///
/// Fills whatever width it is given — put it in an `Expanded` for a
/// width-driven histogram, or a `SizedBox(width: …)` for the fixed-width
/// kind. The label beside it ("5", "5 stars") stays with the caller, since
/// that is the part every kit words differently.
///
/// Both ends of the fill are rounded, like the track. A `LinearProgressIndicator`
/// clipped to a stadium leaves the fill's leading edge square, which reads as
/// a progress bar that stopped rather than a proportion.
class RatingDistributionBar extends StatelessWidget {
  /// 0–1. Values outside that are clamped rather than overflowing the track.
  final double share;

  final double height;

  /// The filled portion. Defaults to the same amber [RatingStars] uses — a
  /// rating histogram in the brand colour reads as progress, not rating.
  final Color? color;

  /// The unfilled remainder; defaults to `cs.surfaceContainerHighest`.
  final Color? trackColor;

  const RatingDistributionBar({
    super.key,
    required this.share,
    this.height = 6,
    this.color,
    this.trackColor,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return SizedBox(
      height: height,
      child: LayoutBuilder(
        builder: (context, constraints) => Stack(
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color: trackColor ?? cs.surfaceContainerHighest,
                borderRadius: AppRadius.full,
              ),
              child: SizedBox(width: constraints.maxWidth, height: height),
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                color: color ?? RatingStars.defaultStarColor,
                borderRadius: AppRadius.full,
              ),
              child: SizedBox(
                width: constraints.maxWidth * share.clamp(0, 1),
                height: height,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
