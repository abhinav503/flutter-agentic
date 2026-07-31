import 'package:cordelia/constants/value_const.dart';
import 'package:cordelia/templates/gravia/widgets/gravia_glass_icon_button.dart';
import 'package:cordelia/templates/gravia/widgets/gravia_hero_header.dart';
import 'package:flutter/material.dart';

import 'package:core/core/theme/app_colors_extension.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/shimmer_box.dart';

/// Loading mirror of `ProfileHeroHeader` — the real page title over a shimmer
/// identity row (avatar disc, name/email lines, edit disc). The shimmer sits
/// on the primary canvas, where the surface-container ramp has no contrast
/// left, so it tints from `onOverlay` instead of the theme defaults.
class ProfileSkeletonHeader extends StatelessWidget {
  const ProfileSkeletonHeader({super.key});

  // ProfileHeroHeader._avatarSize.
  static const double _avatarSize = 56;

  @override
  Widget build(BuildContext context) {
    final onOverlay = context.appColors.onOverlay;
    final base = onOverlay.withValues(alpha: 0.20);
    final sweep = onOverlay.withValues(alpha: 0.35);

    return GraviaHeroHeader.page(
      title: ValueConst.profilePageTitle,
      bottomGap: AppSpacing.lg,
      bottom: Row(
        children: [
          ShimmerBox.circle(
            size: _avatarSize,
            baseColor: base,
            sweepColor: sweep,
          ),
          const SizedBox(width: AppSpacing.base),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                ShimmerBox(
                  width: 140,
                  height: 16,
                  baseColor: base,
                  sweepColor: sweep,
                ),
                const SizedBox(height: AppSpacing.xs4),
                ShimmerBox(
                  width: 180,
                  height: 14,
                  baseColor: base,
                  sweepColor: sweep,
                ),
              ],
            ),
          ),
          ShimmerBox.circle(
            size: GraviaGlassIconButton.containerSize,
            baseColor: base,
            sweepColor: sweep,
          ),
        ],
      ),
    );
  }
}

/// Mirrors the loaded Profile body — seven `ProfileMenuTile` rows (44px icon
/// disc + label + 18px chevron at `AppMenuTile`'s paddings) inside the same
/// sheet inset, so nothing reflows when the profile lands.
class ProfileSkeletonBody extends StatelessWidget {
  const ProfileSkeletonBody({super.key});

  /// Matches the loaded screen's menu-row count.
  static const int _rowCount = 7;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(
      horizontal: AppSpacing.lg,
      vertical: AppSpacing.xl2,
    ),
    child: Column(
      children: [
        for (var i = 0; i < _rowCount; i++)
          const Padding(
            // AppMenuTile's own row padding.
            padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
            child: Row(
              children: [
                // AppMenuTile's default iconCircleSize.
                ShimmerBox.circle(size: 44),
                SizedBox(width: AppSpacing.base),
                ShimmerBox(width: 160, height: 16),
                Spacer(),
                // The chevron slot.
                ShimmerBox(width: 18, height: 18),
              ],
            ),
          ),
      ],
    ),
  );
}
