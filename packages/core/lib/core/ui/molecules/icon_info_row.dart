import 'package:flutter/material.dart';

import '../../theme/app_spacing.dart';

/// A leading block beside a title over a subtitle — the notification-row /
/// activity-feed silhouette. The caller supplies [leading] fully styled
/// (disc colour, glyph, size are the style pack's business); this molecule
/// owns only the arrangement, like [AppMenuTile] does for settings rows.
///
/// Read-only by design — no tap or trailing affordance. The first screen
/// that needs a tappable variant adds it here rather than forking the row.
class IconInfoRow extends StatelessWidget {
  final Widget leading;
  final String title;
  final String subtitle;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;

  /// Gap between [leading] and the text column.
  final double gap;

  /// Gap between the title and subtitle lines.
  final double lineGap;

  final CrossAxisAlignment crossAxisAlignment;

  const IconInfoRow({
    super.key,
    required this.leading,
    required this.title,
    required this.subtitle,
    this.titleStyle,
    this.subtitleStyle,
    this.gap = AppSpacing.base,
    this.lineGap = AppSpacing.xs3,
    this.crossAxisAlignment = CrossAxisAlignment.center,
  });

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;

    return Row(
      crossAxisAlignment: crossAxisAlignment,
      children: [
        leading,
        SizedBox(width: gap),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style:
                    titleStyle ??
                    tt.titleMedium!.copyWith(color: cs.onSurface),
              ),
              SizedBox(height: lineGap),
              Text(
                subtitle,
                style:
                    subtitleStyle ??
                    tt.bodySmall!.copyWith(color: cs.onSurfaceVariant),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
