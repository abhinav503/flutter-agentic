import 'package:flutter/material.dart';

import '../../theme/app_spacing.dart';

/// A section header over a horizontally scrolling rail of items — the
/// "Popular Items" / "Shop by category" / "Similar Products" composition
/// every storefront repeats. The caller supplies [header] fully styled
/// (each pack's own section-header widget) and builds items by index; this
/// block owns only the arrangement and the one subtle rule everyone was
/// re-deriving per copy: the rail takes a **left inset only**, matching the
/// header's gutter, so items scroll all the way to the true screen edge
/// instead of stopping a gutter short of it.
class SectionRail extends StatelessWidget {
  final Widget header;
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;

  /// Horizontal inset for the header and the rail's leading edge. Zero when
  /// the section already sits inside a padded body.
  final double gutter;

  /// Gap between adjacent rail items.
  final double itemSpacing;

  /// Gap between the header and the rail.
  final double headerGap;

  /// Extra padding under the rail — room for item shadows that would
  /// otherwise clip against the scroll view's edge.
  final double railBottomPadding;

  /// Spacer after the last item, so content doesn't end flush against the
  /// screen edge when scrolled to the end.
  final double trailingGap;

  /// The rail Row's cross-axis alignment — `start` keeps variable-height
  /// cards top-aligned.
  final CrossAxisAlignment crossAxisAlignment;

  const SectionRail({
    super.key,
    required this.header,
    required this.itemCount,
    required this.itemBuilder,
    this.gutter = AppSpacing.lg,
    this.itemSpacing = AppSpacing.base,
    this.headerGap = AppSpacing.base,
    this.railBottomPadding = 0,
    this.trailingGap = 0,
    this.crossAxisAlignment = CrossAxisAlignment.center,
  });

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: EdgeInsets.symmetric(horizontal: gutter),
        child: header,
      ),
      SizedBox(height: headerGap),
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.only(left: gutter, bottom: railBottomPadding),
        child: Row(
          crossAxisAlignment: crossAxisAlignment,
          children: [
            for (var i = 0; i < itemCount; i++) ...[
              if (i > 0) SizedBox(width: itemSpacing),
              itemBuilder(context, i),
            ],
            if (trailingGap > 0) SizedBox(width: trailingGap),
          ],
        ),
      ),
    ],
  );
}
