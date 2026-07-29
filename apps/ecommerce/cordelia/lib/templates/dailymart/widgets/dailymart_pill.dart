import 'package:flutter/material.dart';

import 'package:core/core/theme/app_radius.dart';
import 'package:core/core/theme/app_spacing.dart';

/// The pack's static label pill — the card's discount badge, Search's
/// category-row badge, the Reviews frame's amber rating pill. One silhouette
/// (radius-full fill, `base` side padding, optional leading glyph) so the
/// recipe can't drift per call site. Non-interactive by design — the
/// tappable "See All" chip is a different control (`DailyMartSectionHeader`).
class DailyMartPill extends StatelessWidget {
  final String label;
  final Color color;

  /// The exact label style incl. its `on*` colour — copy tiers differ per
  /// site (`bodyXsSemibold` badges vs `bodyXsMedium` rating).
  final TextStyle style;
  final Widget? leading;

  /// Fixed-height mode (the rating pill); text-only pills size from their
  /// `xs3` vertical padding instead.
  final double? height;

  const DailyMartPill({
    super.key,
    required this.label,
    required this.color,
    required this.style,
    this.leading,
    this.height,
  });

  @override
  Widget build(BuildContext context) => Container(
    height: height,
    padding: EdgeInsets.symmetric(
      horizontal: AppSpacing.base,
      vertical: height == null ? AppSpacing.xs3 : 0,
    ),
    decoration: BoxDecoration(color: color, borderRadius: AppRadius.full),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (leading != null) ...[
          leading!,
          const SizedBox(width: AppSpacing.xs3),
        ],
        Text(label, style: style),
      ],
    ),
  );
}
