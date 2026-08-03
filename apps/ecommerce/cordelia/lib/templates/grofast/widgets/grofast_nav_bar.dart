import 'package:flutter/material.dart';

import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/svg_image.dart';

import 'package:cordelia/templates/grofast/constants/grofast_color_const.dart';
import 'package:cordelia/templates/grofast/constants/grofast_dimen_const.dart';
import 'package:cordelia/templates/grofast/constants/grofast_text_style_const.dart';

import 'grofast_dome.dart';

/// One entry in [GrofastNavBar].
class GrofastNavItem {
  final String asset;
  final String label;

  /// Draws the unread dot on the glyph's top-right (the kit puts one on the
  /// Bag slot).
  final bool showDot;

  const GrofastNavItem({
    required this.asset,
    required this.label,
    this.showDot = false,
  });
}

/// The pack's bottom navigation (spec sheet §10) — and, with the domed sheet,
/// one of its two signature shapes.
///
/// The bar is white and its top edge **lifts into a dome** around the active
/// tab, with the tab's gradient disc sitting in the dome and the label beneath
/// it inside the bar. Dome and disc are concentric and animate as one
/// movement, off a single driver — running two animations of the same
/// duration would still let the disc drift out of its dome the moment either
/// curve is touched (spec sheet §7).
///
/// The dome only reads with content behind it, so the shell's `Scaffold`
/// runs `extendBody` and everything outside the dome in the widget's top
/// [GrofastDimenConst.navBumpDiameter] / 2 is transparent.
///
/// Inactive tabs are bare glyphs — no disc, no label.
class GrofastNavBar extends StatelessWidget {
  final List<GrofastNavItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;

  const GrofastNavBar({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
  });

  /// Slot centres: symmetric [GrofastDimenConst.navSlotEdgeInset] from each
  /// screen edge, with the rest divided evenly between them.
  double _slotCenter(int index, double width) {
    const inset = GrofastDimenConst.navSlotEdgeInset;
    if (items.length == 1) return width / 2;
    final span = width - inset * 2;
    return inset + span * index / (items.length - 1);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final width = MediaQuery.sizeOf(context).width;

    const discSize = GrofastDimenConst.navDiscSize;
    const barHeight = GrofastDimenConst.navBarHeight;
    // The dome is a half-circle above the bar's top edge, so its rise is the
    // radius — and that rise is the widget's headroom above the bar.
    const rise = GrofastDimenConst.navBumpDiameter / 2;
    final activeCenter = _slotCenter(currentIndex, width);

    // One driver for the dome, the disc and the label. The tween's `begin` is
    // ignored after the first build, so re-targeting `end` mid-flight resumes
    // from wherever the value currently is.
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: activeCenter, end: activeCenter),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
      builder: (context, centerX, _) => SizedBox(
        width: width,
        // The device inset is paid inside the bar, below the labels.
        height: rise + barHeight + bottomInset,
        child: Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(
                painter: GrofastNavBarSurface(
                  bumpCenterX: centerX,
                  color: cs.surface,
                ),
              ),
            ),
            for (var i = 0; i < items.length; i++)
              if (i != currentIndex)
                Positioned(
                  left: _slotCenter(i, width) - AppSpacing.xl9 / 2,
                  top:
                      rise +
                      GrofastDimenConst.navGlyphTop -
                      (AppSpacing.xl9 - GrofastDimenConst.navGlyphSize) / 2,
                  child: _NavSlot(
                    item: items[i],
                    color: cs.onSurfaceVariant,
                    onTap: () => onTap(i),
                  ),
                ),
            // A slot centred on the tab, not an Alignment: Alignment.x places
            // a child by its *edges*, so it can only put the label's centre on
            // the tab's centre when the label has zero width — every real
            // label lands short, pulled toward the bar's middle.
            Positioned(
              left: centerX - GrofastDimenConst.navLabelSlotWidth / 2,
              width: GrofastDimenConst.navLabelSlotWidth,
              top: rise + GrofastDimenConst.navLabelTop,
              child: IgnorePointer(
                child: Text(
                  items[currentIndex].label,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GrofastTextStyleConst.labelSemibold(
                    tt,
                  ).copyWith(color: cs.onSurfaceVariant),
                ),
              ),
            ),
            Positioned(
              left: centerX - discSize / 2,
              top: rise - discSize / 2,
              child: GestureDetector(
                onTap: () => onTap(currentIndex),
                child: Container(
                  width: discSize,
                  height: discSize,
                  decoration: BoxDecoration(
                    gradient: GrofastColorConst.brandGradient,
                    shape: BoxShape.circle,
                    boxShadow: GrofastElevation.raised,
                  ),
                  alignment: Alignment.center,
                  child: AppSvgImage.asset(
                    items[currentIndex].asset,
                    width: GrofastDimenConst.navGlyphSize,
                    height: GrofastDimenConst.navGlyphSize,
                    color: cs.onPrimary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavSlot extends StatelessWidget {
  final GrofastNavItem item;
  final Color color;
  final VoidCallback onTap;

  const _NavSlot({
    required this.item,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Semantics(
      button: true,
      label: item.label,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: SizedBox(
          width: AppSpacing.xl9,
          height: AppSpacing.xl9,
          child: Stack(
            alignment: Alignment.center,
            children: [
              AppSvgImage.asset(
                item.asset,
                width: GrofastDimenConst.navGlyphSize,
                height: GrofastDimenConst.navGlyphSize,
                color: color,
              ),
              if (item.showDot)
                Positioned(
                  top: AppSpacing.sm,
                  right: AppSpacing.base,
                  child: Container(
                    width: AppSpacing.xs2,
                    height: AppSpacing.xs2,
                    decoration: BoxDecoration(
                      color: cs.error,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
