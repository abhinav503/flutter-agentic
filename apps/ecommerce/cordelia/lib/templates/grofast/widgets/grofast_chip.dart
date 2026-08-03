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
