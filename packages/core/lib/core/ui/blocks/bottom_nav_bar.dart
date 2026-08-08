import 'package:flutter/material.dart';

import '../../theme/app_colors_extension.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';

/// Single tab definition for [BottomNavBar].
///
/// Pass either [icon] (Material icon) or [iconBuilder] (custom icon widget,
/// e.g. an SVG asset) — [iconBuilder] receives the resolved foreground colour
/// and icon size, matching [AppIconButton]'s `iconBuilder` convention.
class BottomNavBarItem {
  final IconData? icon;
  final Widget Function(Color color, double size)? iconBuilder;
  final String label;

  const BottomNavBarItem({this.icon, this.iconBuilder, required this.label})
    : assert(
        icon != null || iconBuilder != null,
        'BottomNavBarItem requires either icon or iconBuilder',
      );
}

/// Which bottom-nav look a style pack's kit specs. Both render the same
/// [BottomNavBarItem] list — packs differ in the highlight, not the data.
enum BottomNavBarVariant {
  /// Active tab is a filled pill with icon + label; inactive tabs are
  /// icon-only circles (e.g. `gravia`).
  pill,

  /// Every tab shows icon above label at all times; only colour marks the
  /// active one, and no tab carries a background (e.g. `dailyMart`).
  stacked,
}

/// Bottom nav in one of two pack looks — see [BottomNavBarVariant]. Pass this
/// to [BasePageState.buildBottomNav] instead of the default
/// [BottomNavigationBar] on style packs whose signature look calls for it.
class BottomNavBar extends StatelessWidget {
  final List<BottomNavBarItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;

  /// Defaults to [BottomNavBarVariant.pill] — the look this block shipped
  /// with, so existing callers are unaffected.
  final BottomNavBarVariant variant;

  /// Hairline divider on the bar's top edge, separating it from the screen
  /// content above — omit (default) for no divider. Colour is a caller
  /// concern (e.g. an app's raw kit swatch), not something `core` should
  /// assume.
  final Color? topBorderColor;
  final double topBorderWidth;

  /// Inactive-tab icon colour override — a caller concern for style packs
  /// whose spec calls out an exact shade rather than the `onSurfaceVariant`
  /// role. Omit (default) to use the theme role.
  final Color? inactiveIconColor;

  /// [BottomNavBarVariant.stacked] only — the active tab's icon+label
  /// colour. Omit to use `cs.primary`. (The pill variant paints its
  /// foreground on `cs.primary` itself, so it uses `onOverlay` instead and
  /// ignores this.)
  final Color? activeColor;

  /// Drop shadow cast upward from the bar's top edge — packs that float the
  /// bar over content spec this instead of (or alongside) a hairline. Omit
  /// for no shadow.
  final List<BoxShadow>? shadows;

  const BottomNavBar({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
    this.variant = BottomNavBarVariant.pill,
    this.topBorderColor,
    this.topBorderWidth = 0.5,
    this.inactiveIconColor,
    this.activeColor,
    this.shadows,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: cs.surface,
        border: topBorderColor != null
            ? Border(
                top: BorderSide(color: topBorderColor!, width: topBorderWidth),
              )
            : null,
        boxShadow: shadows,
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.xs,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (final (index, item) in items.indexed)
                switch (variant) {
                  BottomNavBarVariant.pill => _NavTab(
                    item: item,
                    isActive: index == currentIndex,
                    onTap: () => onTap(index),
                    inactiveIconColor: inactiveIconColor,
                  ),
                  // Expanded, not intrinsic: stacked labels vary in width
                  // ("Cart" vs "Wishlist"), and equal shares keep the icons
                  // evenly spaced instead of bunching toward the long label.
                  BottomNavBarVariant.stacked => Expanded(
                    child: _StackedNavTab(
                      item: item,
                      isActive: index == currentIndex,
                      onTap: () => onTap(index),
                      activeColor: activeColor ?? cs.primary,
                      inactiveColor: inactiveIconColor ?? cs.onSurfaceVariant,
                    ),
                  ),
                },
            ],
          ),
        ),
      ),
    );
  }
}

class _StackedNavTab extends StatelessWidget {
  final BottomNavBarItem item;
  final bool isActive;
  final VoidCallback onTap;
  final Color activeColor;
  final Color inactiveColor;

  const _StackedNavTab({
    required this.item,
    required this.isActive,
    required this.onTap,
    required this.activeColor,
    required this.inactiveColor,
  });

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final color = isActive ? activeColor : inactiveColor;

    return GestureDetector(
      onTap: onTap,
      // Opaque so the whole column — including the gap between icon and
      // label — is tappable, not just the glyphs.
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (item.iconBuilder != null)
              SizedBox(
                width: 24,
                height: 24,
                child: item.iconBuilder!(color, 24),
              )
            else
              Icon(item.icon, size: 24, color: color),
            const SizedBox(height: AppSpacing.xs4),
            Text(
              item.label,
              style: tt.labelMedium!.copyWith(color: color),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _NavTab extends StatelessWidget {
  final BottomNavBarItem item;
  final bool isActive;
  final VoidCallback onTap;
  final Color? inactiveIconColor;

  const _NavTab({
    required this.item,
    required this.isActive,
    required this.onTap,
    this.inactiveIconColor,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final onOverlay = Theme.of(
      context,
    ).extension<AppColorsExtension>()!.onOverlay;
    // Active pill sits on `cs.primary` — a colour block, not contrast-paired
    // text, so it uses the fixed `onOverlay` role rather than `cs.onPrimary`
    // (which would invert dark in dark theme).
    final iconColor = isActive
        ? onOverlay
        : (inactiveIconColor ?? cs.onSurfaceVariant);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        // Inactive = a true 48×48 circle; active = a 48-tall pill. Equal
        // heights keep the row stable as the highlight moves, and 48 clears
        // the 44px touch-target floor.
        padding: isActive
            ? const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.base,
              )
            : const EdgeInsets.all(AppSpacing.base),
        decoration: BoxDecoration(
          // Inactive circles sit barely off the surface (Gray/50 in light,
          // the elevated cool-grey in dark) — Low, not Highest.
          color: isActive ? cs.primary : cs.surfaceContainerLow,
          borderRadius: AppRadius.full,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (item.iconBuilder != null)
              SizedBox(
                width: 24,
                height: 24,
                child: item.iconBuilder!(iconColor, 24),
              )
            else
              Icon(item.icon, size: 24, color: iconColor),
            if (isActive) ...[
              const SizedBox(width: AppSpacing.xs3),
              Text(
                item.label,
                style: tt.labelLarge!.copyWith(
                  color: onOverlay,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
