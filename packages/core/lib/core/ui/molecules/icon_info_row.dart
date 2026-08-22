import 'package:flutter/material.dart';

import '../../theme/app_spacing.dart';

/// A leading block beside a title (optionally over a subtitle), with an
/// optional trailing control — the notification-row / activity-feed /
/// list-result silhouette. The caller supplies [leading] and [trailing]
/// fully styled (disc colour, glyph, size are the style pack's business);
/// this molecule owns only the arrangement, like [AppMenuTile] does for
/// settings rows.
class IconInfoRow extends StatelessWidget {
  final Widget leading;
  final String title;
  final String? subtitle;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;

  /// Ellipsised cap for list rows; null keeps the title unclamped (the
  /// notification-feed usage, where copy wraps).
  final int? titleMaxLines;

  /// The same cap for the subtitle. A settings row that prints an address or
  /// a phone number under its label wants one line; a feed row that explains
  /// itself wants none.
  final int? subtitleMaxLines;

  /// Rendered after the text column. Non-interactive by itself — give it
  /// its own handler, or set [onTap] for whole-row taps.
  final Widget? trailing;

  /// Whole-row tap (opaque hit area). Null keeps the row read-only.
  final VoidCallback? onTap;

  /// Outer inset — list rows typically pad vertically; null adds none.
  final EdgeInsetsGeometry? padding;

  /// Gap between [leading] and the text column.
  final double gap;

  /// Gap before [trailing]; defaults to [gap].
  final double? trailingGap;

  /// Gap between the title and subtitle lines.
  final double lineGap;

  final CrossAxisAlignment crossAxisAlignment;

  const IconInfoRow({
    super.key,
    required this.leading,
    required this.title,
    this.subtitle,
    this.titleStyle,
    this.subtitleStyle,
    this.titleMaxLines,
    this.subtitleMaxLines,
    this.trailing,
    this.onTap,
    this.padding,
    this.gap = AppSpacing.base,
    this.trailingGap,
    this.lineGap = AppSpacing.xs3,
    this.crossAxisAlignment = CrossAxisAlignment.center,
  });

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;

    Widget row = Row(
      crossAxisAlignment: crossAxisAlignment,
      children: [
        leading,
        SizedBox(width: gap),
        Expanded(
          child: Column(
            // Min, so a row pinned to a fixed height (a kit's menu strip)
            // centres its text block instead of pinning it to the top.
            // Unbounded rows are unaffected — a flex under infinite
            // constraints is min-sized either way.
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style:
                    titleStyle ?? tt.titleMedium!.copyWith(color: cs.onSurface),
                maxLines: titleMaxLines,
                overflow: titleMaxLines == null ? null : TextOverflow.ellipsis,
              ),
              if (subtitle != null) ...[
                SizedBox(height: lineGap),
                Text(
                  subtitle!,
                  style:
                      subtitleStyle ??
                      tt.bodySmall!.copyWith(color: cs.onSurfaceVariant),
                  maxLines: subtitleMaxLines,
                  overflow: subtitleMaxLines == null
                      ? null
                      : TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
        if (trailing != null) ...[
          SizedBox(width: trailingGap ?? gap),
          trailing!,
        ],
      ],
    );

    if (padding != null) row = Padding(padding: padding!, child: row);
    if (onTap != null) {
      row = GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: row,
      );
    }
    return row;
  }
}
