import 'package:flutter/material.dart';

import '../../theme/app_spacing.dart';

class EmptyState extends StatelessWidget {
  final IconData iconData;
  final String title;
  final String? subtitle;
  final List<Widget>? actions;

  const EmptyState({
    super.key,
    required this.iconData,
    required this.title,
    this.subtitle,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    // Center makes the molecule self-centering in any parent — the Column
    // shrink-wraps its width to the widest text line, so without this the
    // whole block sits top-left whenever it's narrower than the screen.
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(iconData, size: 64, color: cs.outlineVariant),
            const SizedBox(height: AppSpacing.lg),
            Text(
              title,
              style: tt.titleMedium!.copyWith(color: cs.onSurface),
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              const SizedBox(height: AppSpacing.xs),
              Text(
                subtitle!,
                style: tt.bodyMedium!.copyWith(color: cs.onSurfaceVariant),
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
