import 'package:flutter/material.dart';

import 'package:core/core/theme/app_radius.dart';
import 'package:core/core/theme/app_spacing.dart';

import 'package:cordelia/templates/grofast/constants/grofast_color_const.dart';
import 'package:cordelia/templates/grofast/constants/grofast_dimen_const.dart';
import 'package:cordelia/templates/grofast/constants/grofast_text_style_const.dart';

/// The pack's single-select option chip (spec sheet §13), in the kit's two
/// sizes:
///
/// - default — the 28px outlined pill the *sheet* frames draw (Search
///   Option `23:285`): mint-tinted with `cs.primary` ink when chosen.
/// - [GrofastChip.big] — `Button-Text/Big` (Notification `168:2316`), the
///   filter row on a *list screen* (My Orders): a 22 × 10 padded pill at the
///   pack's 23 tile radius, Montserrat label, and the kit's Medium-Green as
///   the active ink/border with the mint `cs.surfaceContainer` fill.
///
/// Not core's `AppChip`: that atom draws a check glyph on selection and sizes
/// off the theme's chip padding, while the kit's chips change only colour.
class GrofastChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final bool big;

  /// No unit exists for this value with the other options as picked (or it
  /// is sold out) — drawn struck through. Still tappable: picking it
  /// re-resolves the other rows to a unit that does exist.
  final bool unavailable;

  const GrofastChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.unavailable = false,
  }) : big = false;

  const GrofastChip.big({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.unavailable = false,
  }) : big = true;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    final activeInk = big ? GrofastColorConst.chipActiveInk : cs.primary;
    final activeFill = big
        ? cs.surfaceContainer
        : cs.primary.withValues(alpha: 0.08);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        height: big
            ? GrofastDimenConst.bigChipHeight
            : GrofastDimenConst.chipHeight,
        padding: EdgeInsets.symmetric(
          horizontal: big
              ? GrofastDimenConst.bigChipHorizontalPad
              : AppSpacing.lg,
        ),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? activeFill : cs.surface,
          borderRadius: big
              ? BorderRadius.circular(GrofastDimenConst.tileRadius)
              : AppRadius.full,
          border: Border.all(color: selected ? activeInk : cs.outline),
        ),
        child: Text(
          label,
          style:
              (big
                      ? GrofastTextStyleConst.chipMedium(tt)
                      : GrofastTextStyleConst.bodySmall(tt))
                  .copyWith(
                    color: selected ? activeInk : cs.onSurfaceVariant,
                    decoration: unavailable && !selected
                        ? TextDecoration.lineThrough
                        : null,
                  ),
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

/// A single-select row of [GrofastChip]s that scrolls **horizontally** — the
/// kit runs its filter rows off the screen's edge (Notification `168:2316`
/// crops "Canceled" mid-word) rather than wrapping to a second line. One
/// widget for the filter sheet's rows and My Orders' status row, so the 8px
/// gaps can't drift between them.
class GrofastChipRow extends StatelessWidget {
  final List<String> labels;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  /// Renders each chip as [GrofastChip.big] — the list-screen size.
  final bool big;

  /// Indices drawn as unavailable (see [GrofastChip.unavailable]).
  final Set<int> unavailable;

  const GrofastChipRow({
    super.key,
    required this.labels,
    required this.selectedIndex,
    required this.onSelected,
    this.big = false,
    this.unavailable = const {},
  });

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    // Scrolls, so trailing chips leave cleanly instead of clipping hard.
    clipBehavior: Clip.none,
    child: Row(
      children: [
        for (var i = 0; i < labels.length; i++) ...[
          if (i > 0) const SizedBox(width: AppSpacing.xs),
          big
              ? GrofastChip.big(
                  label: labels[i],
                  selected: i == selectedIndex,
                  unavailable: unavailable.contains(i),
                  onTap: () => onSelected(i),
                )
              : GrofastChip(
                  label: labels[i],
                  selected: i == selectedIndex,
                  unavailable: unavailable.contains(i),
                  onTap: () => onSelected(i),
                ),
        ],
      ],
    ),
  );
}
