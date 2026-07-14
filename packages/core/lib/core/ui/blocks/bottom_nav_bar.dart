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

/// Pill-highlight bottom nav: the active tab is a filled pill with icon +
/// label; inactive tabs are icon-only circles. Pass this to
/// [BasePageState.buildBottomNav] instead of the default
/// [BottomNavigationBar] on style packs whose signature look calls for it
/// (e.g. `gravia`).
class BottomNavBar extends StatelessWidget {
  final List<BottomNavBarItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;

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

  const BottomNavBar({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
    this.topBorderColor,
    this.topBorderWidth = 0.5,
    this.inactiveIconColor,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: cs.surface,
        border: topBorderColor != null
            ? Border(top: BorderSide(color: topBorderColor!, width: topBorderWidth))
            : null,
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
                _NavTab(
                  item: item,
                  isActive: index == currentIndex,
                  onTap: () => onTap(index),
                  inactiveIconColor: inactiveIconColor,
                ),
            ],
          ),
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
    final onOverlay = Theme.of(context).extension<AppColorsExtension>()!.onOverlay;
    // Active pill sits on `cs.primary` — a colour block, not contrast-paired
    // text, so it uses the fixed `onOverlay` role rather than `cs.onPrimary`
    // (which would invert dark in dark theme).
    final iconColor = isActive ? onOverlay : (inactiveIconColor ?? cs.onSurfaceVariant);

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
