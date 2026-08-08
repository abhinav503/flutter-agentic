import 'package:flutter/material.dart';

import '../../../theme/app_spacing.dart';

/// One label/value row of a [PriceBreakdown].
class PriceLine {
  final String label;
  final String value;
  final TextStyle? labelStyle;
  final TextStyle? valueStyle;

  const PriceLine({
    required this.label,
    required this.value,
    this.labelStyle,
    this.valueStyle,
  });
}

/// A cart/checkout totals panel: an optional leading slot (each pack's own
/// coupon row), the label/value [lines], then a hairline divider and the
/// [total] row. Both storefront templates were carrying a byte-identical
/// private `_SummaryRow` plus this exact composition; the block owns the
/// arrangement while every style stays with the caller via [PriceLine].
class PriceBreakdown extends StatelessWidget {
  /// Rendered above the lines — typically the pack's coupon row.
  final Widget? leading;

  /// Gap between [leading] and the first line.
  final double leadingGap;

  final List<PriceLine> lines;

  /// Gap between adjacent lines.
  final double lineGap;

  /// The emphasised row under the divider.
  final PriceLine total;

  /// Gap on each side of the divider.
  final double dividerGap;

  /// Hairline colour; defaults to `outlineVariant`.
  final Color? dividerColor;

  final CrossAxisAlignment crossAxisAlignment;

  const PriceBreakdown({
    super.key,
    this.leading,
    this.leadingGap = AppSpacing.lg,
    required this.lines,
    this.lineGap = AppSpacing.base,
    required this.total,
    this.dividerGap = AppSpacing.lg,
    this.dividerColor,
    this.crossAxisAlignment = CrossAxisAlignment.start,
  });

  Widget _row(BuildContext context, PriceLine line) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          line.label,
          style:
              line.labelStyle ??
              tt.bodyMedium!.copyWith(color: cs.onSurfaceVariant),
        ),
        Text(
          line.value,
          style:
              line.valueStyle ?? tt.bodyMedium!.copyWith(color: cs.onSurface),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: crossAxisAlignment,
      children: [
        if (leading != null) ...[leading!, SizedBox(height: leadingGap)],
        for (var i = 0; i < lines.length; i++) ...[
          if (i > 0) SizedBox(height: lineGap),
          _row(context, lines[i]),
        ],
        SizedBox(height: dividerGap),
        Divider(
          color: dividerColor ?? cs.outlineVariant,
          height: 1,
          thickness: 1,
        ),
        SizedBox(height: dividerGap),
        _row(context, total),
      ],
    );
  }
}
