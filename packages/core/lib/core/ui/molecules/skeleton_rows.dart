import 'package:flutter/material.dart';

import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import '../atoms/shimmer_box.dart';

/// Skeleton of the commonest list-row silhouette — a leading disc beside a
/// title line over a subtitle line. Set [itemCount] > 1 for a column of
/// identical rows (a whole loading list in one widget).
///
/// Every dimension is a parameter so a style pack can mirror its own row
/// exactly (disc size, line heights, gaps); [baseColor]/[sweepColor] pass
/// through to the underlying [ShimmerBox]es for tinted canvases.
class ShimmerListRow extends StatelessWidget {
  final int itemCount;

  /// Vertical gap between rows when [itemCount] > 1.
  final double rowGap;

  final double leadingSize;

  /// Corner radius of the leading block — omit for a full circle.
  final BorderRadius? leadingRadius;

  /// Gap between the leading block and the text column.
  final double gap;

  final double titleWidth;
  final double titleHeight;

  /// `double.infinity` fills the remaining row width.
  final double subtitleWidth;
  final double subtitleHeight;

  /// Gap between the title and subtitle lines.
  final double lineGap;

  final CrossAxisAlignment crossAxisAlignment;
  final Color? baseColor;
  final Color? sweepColor;

  const ShimmerListRow({
    super.key,
    this.itemCount = 1,
    this.rowGap = AppSpacing.lg,
    this.leadingSize = 48,
    this.leadingRadius,
    this.gap = AppSpacing.lg,
    this.titleWidth = 180,
    this.titleHeight = AppSpacing.xl2,
    this.subtitleWidth = double.infinity,
    this.subtitleHeight = AppSpacing.lg,
    this.lineGap = AppSpacing.xs3,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.baseColor,
    this.sweepColor,
  });

  Widget _row() => Row(
    crossAxisAlignment: crossAxisAlignment,
    children: [
      ShimmerBox(
        width: leadingSize,
        height: leadingSize,
        borderRadius:
            leadingRadius ?? const BorderRadius.all(Radius.circular(9999)),
        baseColor: baseColor,
        sweepColor: sweepColor,
      ),
      SizedBox(width: gap),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ShimmerBox(
              width: titleWidth,
              height: titleHeight,
              baseColor: baseColor,
              sweepColor: sweepColor,
            ),
            SizedBox(height: lineGap),
            ShimmerBox(
              width: subtitleWidth,
              height: subtitleHeight,
              baseColor: baseColor,
              sweepColor: sweepColor,
            ),
          ],
        ),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    if (itemCount == 1) return _row();
    return Column(
      children: [
        for (var i = 0; i < itemCount; i++) ...[
          if (i > 0) SizedBox(height: rowGap),
          _row(),
        ],
      ],
    );
  }
}

/// Skeleton of a section header — a title line with an optional trailing
/// action block (the "See all" chip/link slot), spread to the row's edges the
/// way [SectionHeader] lays out its real counterpart.
class ShimmerSectionHeader extends StatelessWidget {
  final double titleWidth;
  final double titleHeight;

  /// Trailing action block — pass `actionWidth: 0` to omit it.
  final double actionWidth;
  final double actionHeight;
  final BorderRadius actionRadius;

  final Color? baseColor;
  final Color? sweepColor;

  const ShimmerSectionHeader({
    super.key,
    this.titleWidth = 140,
    this.titleHeight = AppSpacing.xl2,
    this.actionWidth = 64,
    this.actionHeight = AppSpacing.xl5,
    this.actionRadius = AppRadius.sm,
    this.baseColor,
    this.sweepColor,
  });

  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      ShimmerBox(
        width: titleWidth,
        height: titleHeight,
        baseColor: baseColor,
        sweepColor: sweepColor,
      ),
      if (actionWidth > 0)
        ShimmerBox(
          width: actionWidth,
          height: actionHeight,
          borderRadius: actionRadius,
          baseColor: baseColor,
          sweepColor: sweepColor,
        ),
    ],
  );
}
