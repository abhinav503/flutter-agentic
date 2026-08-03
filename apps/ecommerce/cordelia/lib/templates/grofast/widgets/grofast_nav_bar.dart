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
/// The bar is white with a **circular notch cut out of its top edge**, and
/// the active tab's gradient disc drops into that hole, rising above the bar
/// with the label beneath it inside the bar. Notch and disc are concentric
/// and animate together as one movement; animating them separately makes the
/// disc visibly leave its hole mid-flight (spec sheet §7).
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
    final activeCenter = _slotCenter(currentIndex, width);

    return SizedBox(
      width: width,
      // The disc rises a full radius above the bar, so the widget is taller
      // than the bar itself; the device inset is paid inside the bar, below
      // the labels.
      height: barHeight + discSize / 2 + bottomInset,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomCenter,
        children: [
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: activeCenter, end: activeCenter),
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
              builder: (context, notchX, child) => ClipPath(
                clipper: GrofastNavBarClipper(notchCenterX: notchX),
                child: child,
              ),
              child: Container(
                height: barHeight + bottomInset,
                color: cs.surface,
                padding: EdgeInsets.only(bottom: bottomInset),
                child: Stack(
                  children: [
                    for (var i = 0; i < items.length; i++)
                      if (i != currentIndex)
                        Positioned(
                          left: _slotCenter(i, width) - AppSpacing.xl9 / 2,
                          top:
                              GrofastDimenConst.navGlyphTop -
                              (AppSpacing.xl9 -
                                      GrofastDimenConst.navGlyphSize) /
                                  2,
                          child: _NavSlot(
                            item: items[i],
                            color: cs.onSurfaceVariant,
                            onTap: () => onTap(i),
                          ),
                        ),
                    Positioned(
                      left: 0,
                      right: 0,
                      top: GrofastDimenConst.navLabelTop,
                      child: IgnorePointer(
                        child: Align(
                          alignment: Alignment(
                            // Alignment.x runs −1…1 across the bar.
                            (activeCenter / width) * 2 - 1,
                            0,
                          ),
                          child: Text(
                            items[currentIndex].label,
                            style: GrofastTextStyleConst.labelSemibold(
                              tt,
                            ).copyWith(color: cs.onSurfaceVariant),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            left: activeCenter - discSize / 2,
            bottom: barHeight + bottomInset - discSize / 2,
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
