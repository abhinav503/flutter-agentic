import 'package:flutter/material.dart';

import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';

/// Single tab definition for [BottomNavBar].
class BottomNavBarItem {
  final IconData icon;
  final String label;

  const BottomNavBarItem({required this.icon, required this.label});
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

  const BottomNavBar({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return ColoredBox(
      color: cs.surface,
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

  const _NavTab({
    required this.item,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

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
            Icon(
              item.icon,
              size: 24,
              color: isActive ? cs.onPrimary : cs.onSurfaceVariant,
            ),
            if (isActive) ...[
              const SizedBox(width: AppSpacing.xs3),
              Text(
                item.label,
                style: tt.labelLarge!.copyWith(
                  color: cs.onPrimary,
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
