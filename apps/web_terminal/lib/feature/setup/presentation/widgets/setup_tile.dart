import 'package:core/core/theme/app_radius.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';

class SetupTile extends StatelessWidget {
  final IconData icon;
  final Color? iconColor;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color? background;
  final Color? titleColor;
  final Widget? child;

  const SetupTile({
    super.key,
    required this.icon,
    required this.title,
    this.iconColor,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.background,
    this.titleColor,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final fg = titleColor ?? cs.onSurface;

    final header = Padding(
      padding: const EdgeInsets.all(AppSpacing.base),
      child: Row(
        children: [
          Icon(icon, color: iconColor ?? fg, size: AppSpacing.xl2),
          const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: tt.bodyMedium?.copyWith(color: fg)),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                  ),
              ],
            ),
          ),
          if (trailing != null) ...[
            const SizedBox(width: AppSpacing.xs),
            trailing!,
          ],
        ],
      ),
    );

    return Container(
      decoration: BoxDecoration(
        color: background ?? cs.surfaceContainerLow,
        borderRadius: AppRadius.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (onTap != null)
            InkWell(onTap: onTap, borderRadius: AppRadius.md, child: header)
          else
            header,
          ?child,
        ],
      ),
    );
  }
}
