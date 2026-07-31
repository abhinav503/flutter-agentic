import 'package:flutter/material.dart';

import 'package:core/core/theme/app_radius.dart';
import 'package:core/core/theme/app_spacing.dart';

import 'package:cordelia/templates/dailymart/constants/dailymart_dimen_const.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_text_style_const.dart';

/// The kit's `Badge` used as a selectable filter (My Orders' status row) — a
/// 36px radius-16 chip: primary fill with an `onPrimary` label when
/// selected, plain surface behind a `cs.outline` hairline when not.
///
/// Not core's [AppChip]: that atom draws a *tinted* selected state (a
/// container fill with an ink label) and takes its radius from the theme's
/// chip shape, which this pack pins to a pill. Every slot would need an
/// override — the same §12 reasoning that keeps the product card local.
class DailyMartFilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const DailyMartFilterChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Material(
      color: selected ? cs.primary : cs.surface,
      borderRadius: AppRadius.xl,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.xl,
        child: Container(
          height: DailyMartDimenConst.orderFilterChipHeight,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl2),
          decoration: BoxDecoration(
            borderRadius: AppRadius.xl,
            border: Border.all(
              color: selected ? Colors.transparent : cs.outline,
            ),
          ),
          child: Text(
            label,
            style: DailyMartTextStyleConst.bodySmMedium(
              tt,
            ).copyWith(color: selected ? cs.onPrimary : cs.onSurfaceVariant),
          ),
        ),
      ),
    );
  }
}
