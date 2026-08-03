import 'package:flutter/material.dart';

import 'package:core/core/theme/app_radius.dart';
import 'package:core/core/theme/app_spacing.dart';

import 'package:cordelia/templates/grofast/constants/grofast_dimen_const.dart';
import 'package:cordelia/templates/grofast/constants/grofast_text_style_const.dart';

/// The pack's single-select option chip (spec sheet §13) — a 28px outlined
/// pill that fills with the mint tint and switches its ink and border to
/// `cs.primary` when chosen.
///
/// Used by the filter sheet's Sort By / Price rows, the notification kind
/// row, and My Orders' status row. Not core's `AppChip`: that atom draws a
/// check glyph on selection and sizes off the theme's chip padding, while the
/// kit's chip changes only colour and is pinned to 28.
class GrofastChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const GrofastChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        height: GrofastDimenConst.chipHeight,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? cs.primary.withValues(alpha: 0.08) : cs.surface,
          borderRadius: AppRadius.full,
          border: Border.all(color: selected ? cs.primary : cs.outline),
        ),
        child: Text(
          label,
          style: GrofastTextStyleConst.bodySmall(
            tt,
          ).copyWith(color: selected ? cs.primary : cs.onSurfaceVariant),
        ),
      ),
    );
  }
}

/// The static pills under Product Details' title (kit `102:427` and
/// `102:438`) — a rating and the product's category. They label the product;
/// unlike [GrofastChip] neither is a control, so neither takes an `onTap` and
/// neither carries a selected state.
///
/// Two fills, one silhouette: [GrofastBadge.outlined] for the rating (a
/// hairline on white) and [GrofastBadge.tinted] for the category (the pack's
/// mint, `cs.surfaceContainer`).
class GrofastBadge extends StatelessWidget {
  final String label;

  /// Sits before the label at [GrofastDimenConst.badgeLeadingSize] — the
  /// rating's star, the category's artwork.
  final Widget leading;
  final bool tinted;

  const GrofastBadge.outlined({
    super.key,
    required this.label,
    required this.leading,
  }) : tinted = false;

  const GrofastBadge.tinted({
    super.key,
    required this.label,
    required this.leading,
  }) : tinted = true;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: tinted ? cs.surfaceContainer : cs.surface,
        borderRadius: AppRadius.full,
        border: tinted ? null : Border.all(color: cs.outline),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox.square(
            dimension: GrofastDimenConst.badgeLeadingSize,
            child: leading,
          ),
          const SizedBox(width: AppSpacing.xs3),
          Text(
            label,
            style: GrofastTextStyleConst.bodySmall(
              tt,
            ).copyWith(color: cs.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

/// A wrapped row of [GrofastChip]s — the filter sheet's and the order list's
/// one layout, so the 8px gaps can't drift between them.
class GrofastChipWrap extends StatelessWidget {
  final List<String> labels;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  const GrofastChipWrap({
    super.key,
    required this.labels,
    required this.selectedIndex,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: AppSpacing.xs,
    runSpacing: AppSpacing.xs,
    children: [
      for (var i = 0; i < labels.length; i++)
        GrofastChip(
          label: labels[i],
          selected: i == selectedIndex,
          onTap: () => onSelected(i),
        ),
    ],
  );
}
