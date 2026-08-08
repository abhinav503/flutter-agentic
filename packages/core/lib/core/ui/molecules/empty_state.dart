import 'package:flutter/material.dart';

import '../../theme/app_spacing.dart';

class EmptyState extends StatelessWidget {
  final IconData iconData;
  final String title;
  final String? subtitle;
  final List<Widget>? actions;

  /// Replaces the default [Icon] entirely (a pack glyph, an illustration) —
  /// receives the resolved colour and size so a custom asset can match the
  /// default's footprint.
  final Widget Function(Color color, double size)? iconBuilder;

  /// Glyph size (default 64) and colour (default `cs.outlineVariant`) — for
  /// packs whose empty glyphs are smaller or brand-tinted.
  final double iconSize;
  final Color? iconColor;

  /// Style overrides for the two text lines — for packs whose spec calls out
  /// exact typography rather than the `titleMedium`/`bodyMedium` roles.
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;

  /// Outer inset override (default `EdgeInsets.all(xl4)`) — pack wrappers
  /// existed solely to change this, so it's a param instead.
  final EdgeInsetsGeometry? padding;

  const EmptyState({
    super.key,
    required this.iconData,
    required this.title,
    this.subtitle,
    this.actions,
    this.iconBuilder,
    this.iconSize = 64,
    this.iconColor,
    this.titleStyle,
    this.subtitleStyle,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final resolvedIconColor = iconColor ?? cs.outlineVariant;

    // Center makes the molecule self-centering in any parent — the Column
    // shrink-wraps its width to the widest text line, so without this the
    // whole block sits top-left whenever it's narrower than the screen.
    return Center(
      child: Padding(
        padding: padding ?? const EdgeInsets.all(AppSpacing.xl4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            iconBuilder != null
                ? iconBuilder!(resolvedIconColor, iconSize)
                : Icon(iconData, size: iconSize, color: resolvedIconColor),
            const SizedBox(height: AppSpacing.lg),
            Text(
              title,
              style:
                  titleStyle ?? tt.titleMedium!.copyWith(color: cs.onSurface),
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              const SizedBox(height: AppSpacing.xs),
              Text(
                subtitle!,
                style:
                    subtitleStyle ??
                    tt.bodyMedium!.copyWith(color: cs.onSurfaceVariant),
                textAlign: TextAlign.center,
              ),
            ],
            if (actions != null && actions!.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.xl4),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (int i = 0; i < actions!.length; i++) ...[
                    if (i > 0) const SizedBox(width: AppSpacing.base),
                    actions![i],
                  ],
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
