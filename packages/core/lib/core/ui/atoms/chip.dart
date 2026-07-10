import 'package:flutter/material.dart';

import '../../theme/app_shapes_extension.dart';
import '../../theme/app_spacing.dart';

/// Selectable chip for filters, tags, and multi-select UI.
///
/// ```dart
/// AppChip(
///   label: 'Flutter',
///   selected: _selected,
///   onTap: () => setState(() => _selected = !_selected),
/// )
/// ```
class AppChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback? onTap;
  final Widget? leadingIcon;

  const AppChip({
    super.key,
    required this.label,
    this.selected = false,
    this.onTap,
    this.leadingIcon,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final shapes = Theme.of(context).extension<AppShapes>() ?? AppShapes.standard;
    final bg = selected ? cs.primaryContainer : cs.surfaceContainerHighest;
    final fg = selected ? cs.onPrimaryContainer : cs.onSurfaceVariant;
    final border = selected
        ? BorderSide(color: cs.primary)
        : BorderSide(color: cs.outline.withValues(alpha: 0.5));

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.base,
          vertical: AppSpacing.xs3,
        ),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(shapes.chipRadius),
          border: Border.fromBorderSide(border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (leadingIcon != null) ...[
              IconTheme(
                data: IconThemeData(color: fg, size: 16),
                child: leadingIcon!,
              ),
              const SizedBox(width: AppSpacing.xs3),
            ],
            Text(
              label,
              style: Theme.of(context).textTheme.labelMedium!.copyWith(color: fg),
            ),
            if (selected) ...[
              const SizedBox(width: AppSpacing.xs3),
              Icon(Icons.check, size: 14, color: fg),
            ],
          ],
        ),
      ),
    );
  }
}
