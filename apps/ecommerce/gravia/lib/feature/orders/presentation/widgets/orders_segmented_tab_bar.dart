import 'package:flutter/material.dart';

import 'package:core/core/theme/app_colors_extension.dart';
import 'package:core/core/theme/app_radius.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/common_glass_surface.dart';

import 'package:gravia/constants/dimen_const.dart';
import 'package:gravia/constants/text_style_const.dart';
import 'package:gravia/constants/value_const.dart';
import 'package:gravia/enums/orders_tab.dart';

/// The Orders header's Upcoming/Past switch — a real frosted-glass pill
/// track (`CommonGlassSurface`, the same backdrop-blur treatment
/// `SearchFieldBar` uses, not a flat translucent `Container`) with a single
/// solid pill (`cs.surface` — white light / near-black dark) that slides
/// left/right between the two segments via `AnimatedAlign`, rather than
/// each segment independently crossfading its own background. The active
/// label reads Text/sm/bold; the inactive one stays Text/sm/medium. Single
/// caller today (Orders), so this stays feature-local rather than a
/// `lib/widgets/` preset — promote it if a second segmented control shows
/// up.
class OrdersSegmentedTabBar extends StatelessWidget {
  /// Public so tab-driven header changes (the filter button's fade) animate
  /// in sync with the pill's slide.
  static const slideDuration = Duration(milliseconds: 250);

  // Matches the app's other fixed control heights (GraviaGlassIconButton's
  // disc, GraviaTintedButton). Pinned explicitly rather than left to intrinsic
  // sizing: a Stack, unlike the Row this replaced, only sizes itself from its
  // non-positioned child (the Row) — nesting the pill-sliding Positioned.fill
  // in there shouldn't change that math, but pinning the height directly
  // removes any dependency on that unbounded-constraint edge case entirely,
  // and is what actually fixed the bar visibly shrinking when the slide
  // animation was added.
  static const _barHeight = DimenConst.controlHeight;

  final OrdersTab selected;
  final ValueChanged<OrdersTab> onChanged;

  const OrdersSegmentedTabBar({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return SizedBox(
      height: _barHeight,
      child: CommonGlassSurface(
        borderRadius: AppRadius.full,
        tintColor: cs.surfaceContainerHighest,
        child: Stack(
          children: [
            // Positioned.fill (not a plain Stack child) so the sliding pill
            // never participates in the Stack's own size computation — only
            // the Row below does. Without this, AnimatedAlign receives an
            // unbounded height during Stack's sizing pass (it wants to be "as
            // big as possible") and FractionallySizedBox's heightFactor: 1
            // then multiplies against infinity, crashing layout.
            Positioned.fill(
              child: AnimatedAlign(
                duration: slideDuration,
                curve: Curves.easeInOut,
                alignment: selected == OrdersTab.upcoming
                    ? Alignment.centerLeft
                    : Alignment.centerRight,
                child: FractionallySizedBox(
                  widthFactor: 0.5,
                  heightFactor: 1,
                  child: Container(
                    margin: const EdgeInsets.all(AppSpacing.xs3),
                    decoration: BoxDecoration(
                      color: cs.surface,
                      borderRadius: AppRadius.full,
                    ),
                  ),
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: _SegmentLabel(
                    label: ValueConst.upcomingTabLabel,
                    active: selected == OrdersTab.upcoming,
                    onTap: () => onChanged(OrdersTab.upcoming),
                  ),
                ),
                Expanded(
                  child: _SegmentLabel(
                    label: ValueConst.pastTabLabel,
                    active: selected == OrdersTab.past,
                    onTap: () => onChanged(OrdersTab.past),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SegmentLabel extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _SegmentLabel({
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final onOverlay = Theme.of(
      context,
    ).extension<AppColorsExtension>()!.onOverlay;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        child: Center(
          child: AnimatedDefaultTextStyle(
            duration: OrdersSegmentedTabBar.slideDuration,
            curve: Curves.easeInOut,
            style: active
                ? TextStyleConst.textSmBold(tt).copyWith(color: cs.onSurface)
                : TextStyleConst.textSmMedium(tt).copyWith(color: onOverlay),
            child: Text(label),
          ),
        ),
      ),
    );
  }
}
