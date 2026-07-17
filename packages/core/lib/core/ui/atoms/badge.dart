import 'package:flutter/material.dart';

import '../../theme/app_colors_extension.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';

enum AppBadgeIntent { neutral, info, success, warning, error }

enum AppBadgeSize { small, medium }

/// Inline status badge.
///
/// ```dart
/// AppBadge(text: 'Active', intent: AppBadgeIntent.success)
/// AppBadge(text: '3', intent: AppBadgeIntent.error, size: AppBadgeSize.small)
/// ```
class AppBadge extends StatelessWidget {
  final String text;
  final AppBadgeIntent intent;
  final AppBadgeSize size;
  final Widget? icon;
  final TextStyle? textStyle;
  final Color? backgroundColor;

  const AppBadge({
    super.key,
    required this.text,
    this.intent = AppBadgeIntent.neutral,
    this.size = AppBadgeSize.medium,
    this.icon,
    this.textStyle,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final (intentBg, fg) = _colors(context);
    final bg = backgroundColor ?? intentBg;
    final tt = Theme.of(context).textTheme;
    final baseStyle =
        textStyle ?? (size == AppBadgeSize.small ? tt.labelSmall : tt.labelMedium);
    final resolvedStyle = baseStyle!.copyWith(color: textStyle?.color ?? fg);

    return Container(
      padding: size == AppBadgeSize.small
          ? const EdgeInsets.symmetric(
              horizontal: AppSpacing.xs, vertical: AppSpacing.xs4)
          : const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm, vertical: AppSpacing.xs3),
      decoration: BoxDecoration(color: bg, borderRadius: AppRadius.full),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            IconTheme(
              data: IconThemeData(
                  color: fg, size: size == AppBadgeSize.small ? 10 : 12),
              child: icon!,
            ),
            const SizedBox(width: AppSpacing.xs4),
          ],
          Text(
            text,
            style: resolvedStyle,
            // Every text theme role (and every gravia TextStyleConst
            // override) sets an explicit `height`. Flutter distributes the
            // leading that adds above/below the glyph using the font's own
            // ascent:descent ratio, not a 50/50 split — for most fonts that
            // visibly pushes single-line text off-centre inside a tightly,
            // symmetrically padded pill. Dropping the height contribution at
            // both ends of this (single) line falls back to the font's
            // natural, symmetric metrics, which centres correctly.
            textHeightBehavior: const TextHeightBehavior(
              applyHeightToFirstAscent: false,
              applyHeightToLastDescent: false,
            ),
          ),
        ],
      ),
    );
  }

  (Color, Color) _colors(BuildContext context) {
    final cs  = Theme.of(context).colorScheme;
    final ext = Theme.of(context).extension<AppColorsExtension>()!;

    return switch (intent) {
      AppBadgeIntent.neutral => (cs.surfaceContainerHighest, cs.onSurfaceVariant),
      AppBadgeIntent.info    => (cs.secondaryContainer,      cs.onSecondaryContainer),
      AppBadgeIntent.error   => (cs.errorContainer,          cs.onErrorContainer),
      AppBadgeIntent.success => (ext.successContainer,       ext.onSuccessContainer),
      AppBadgeIntent.warning => (ext.warningContainer,       ext.onWarningContainer),
    };
  }
}
