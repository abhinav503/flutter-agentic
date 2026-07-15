import 'package:flutter/material.dart';

import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/svg_image.dart';

import 'package:gravia/constants/color_const.dart';
import 'package:gravia/constants/image_const.dart';
import 'package:gravia/constants/text_style_const.dart';

/// One row of the Profile menu: an icon on a circle, a label, and a trailing
/// chevron (navigable) or arbitrary trailing content (e.g. a `Switch`) —
/// [danger] tints the whole row red for a destructive action (Logout)
/// instead of the neutral icon-circle/text colours.
class ProfileMenuTile extends StatelessWidget {
  /// Receives the resolved icon colour + size, same convention as
  /// [AppIconButton.iconBuilder] — most rows pass an `AppSvgImage.asset`,
  /// but a row without a dedicated kit SVG yet (e.g. "My Cards") can pass a
  /// plain `Icon` instead.
  final Widget Function(Color color, double size) iconBuilder;
  final String label;
  final VoidCallback? onTap;
  final Widget? trailing;
  final bool danger;

  const ProfileMenuTile({
    super.key,
    required this.iconBuilder,
    required this.label,
    this.onTap,
    this.trailing,
    this.danger = false,
  });

  static const _iconCircleSize = 44.0;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final iconCircleColor =
        danger ? cs.error.withValues(alpha: 0.12) : (isDark ? ColorConst.gray950 : ColorConst.gray50);
    final foregroundColor = danger ? cs.error : cs.onSurface;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        child: Row(
          children: [
            Container(
              width: _iconCircleSize,
              height: _iconCircleSize,
              decoration: BoxDecoration(color: iconCircleColor, shape: BoxShape.circle),
              alignment: Alignment.center,
              child: iconBuilder(foregroundColor, 20),
            ),
            const SizedBox(width: AppSpacing.base),
            Expanded(
              child: Text(
                label,
                style: TextStyleConst.textMdMedium(tt).copyWith(color: foregroundColor),
              ),
            ),
            trailing ??
                (onTap != null
                    ? AppSvgImage.asset(
                        ImageConst.directionRight,
                        color: cs.onSurfaceVariant,
                        width: 18,
                        height: 18,
                      )
                    : const SizedBox.shrink()),
          ],
        ),
      ),
    );
  }
}
