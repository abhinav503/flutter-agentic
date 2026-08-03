import 'package:flutter/material.dart';

import 'package:core/core/extensions/num_extensions.dart';

import 'package:cordelia/templates/grofast/constants/grofast_text_style_const.dart';
import 'package:cordelia/templates/grofast/constants/grofast_value_const.dart';

/// A price the GROFAST way (spec sheet §10): Montserrat, `cs.primary`, with
/// the **decimals a size smaller than the integer part** and an optional unit
/// suffix trailing at half opacity.
///
/// The split is the pack's most-repeated micro-detail — it appears on every
/// card, row, hero and total — so it lives here rather than being re-derived
/// from a formatted string at each call site.
class GrofastPrice extends StatelessWidget {
  final double value;

  /// e.g. `kg` — rendered as "/kg" after the number. Omit on totals, which
  /// the kit prints bare.
  final String? unit;

  /// Overrides the accent colour — a cancelled/refunded total prints in
  /// `cs.error`, everything else in `cs.primary`.
  final Color? color;

  /// Scales the whole composition, keeping the integer/decimal ratio — the
  /// hero on Product Details and a Total row are the same recipe, larger.
  final double scale;

  const GrofastPrice({
    super.key,
    required this.value,
    this.unit,
    this.color,
    this.scale = 1,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final accent = color ?? cs.primary;

    // `asPrice` is the app-wide money format ("$12.50"); this splits it at the
    // decimal point rather than re-formatting, so the two can't drift.
    final formatted = value.asPrice;
    final dot = formatted.indexOf('.');
    final leading = dot == -1 ? formatted : formatted.substring(0, dot + 1);
    final decimals = dot == -1 ? '' : formatted.substring(dot + 1);

    final priceStyle = GrofastTextStyleConst.price(tt);
    final decimalStyle = GrofastTextStyleConst.priceDecimal(tt);

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text.rich(
          TextSpan(
            style: priceStyle.copyWith(
              color: accent,
              fontSize: priceStyle.fontSize! * scale,
            ),
            children: [
              TextSpan(text: leading),
              if (decimals.isNotEmpty)
                TextSpan(
                  text: decimals,
                  style: decimalStyle.copyWith(
                    color: accent,
                    fontSize: decimalStyle.fontSize! * scale,
                  ),
                ),
            ],
          ),
        ),
        if (unit != null)
          Padding(
            padding: const EdgeInsets.only(left: 2, bottom: 2),
            child: Opacity(
              opacity: 0.5,
              child: Text(
                GrofastValueConst.perUnitSuffix(unit!),
                style: GrofastTextStyleConst.unitSuffix(
                  tt,
                ).copyWith(color: cs.onSurfaceVariant),
              ),
            ),
          ),
      ],
    );
  }
}
