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

  /// Selected state shows a trailing check mark by default. Set false for a
  /// selector where the fill/border alone communicates selection (e.g. a
  /// size picker).
  final bool showCheckIcon;

  /// Per-state style overrides — omit to keep the themed default
  /// (`primaryContainer`/`surfaceContainerHighest` fill, `primary`/`outline`
  /// border). Callers pass these for a brand-specific look (a fixed border
  /// colour that doesn't flip with the theme, a tinted fill, …).
  final Color? backgroundColor;
  final Color? selectedBackgroundColor;
  final Color? borderColor;
  final Color? selectedBorderColor;
  final TextStyle? labelStyle;

  /// How long a selection change crossfades. Defaults to a quick 150ms;
  /// pass [Duration.zero] for an instant switch — e.g. a multi-option
  /// selector where a visible crossfade on both the newly- and
  /// previously-selected chip at once reads as a flicker rather than a
  /// deliberate transition.
  final Duration animationDuration;

  const AppChip({
    super.key,
    required this.label,
    this.selected = false,
    this.onTap,
    this.leadingIcon,
    this.showCheckIcon = true,
    this.backgroundColor,
    this.selectedBackgroundColor,
    this.borderColor,
    this.selectedBorderColor,
    this.labelStyle,
    this.animationDuration = const Duration(milliseconds: 150),
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final shapes = Theme.of(context).extension<AppShapes>() ?? AppShapes.standard;
    final bg = selected
        ? (selectedBackgroundColor ?? cs.primaryContainer)
        : (backgroundColor ?? cs.surfaceContainerHighest);
    final fg = labelStyle?.color ??
        (selected ? cs.onPrimaryContainer : cs.onSurfaceVariant);
    final border = selected
        ? BorderSide(color: selectedBorderColor ?? cs.primary)
        : BorderSide(color: borderColor ?? cs.outline.withValues(alpha: 0.5));

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: animationDuration,
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
            // AnimatedDefaultTextStyle, not a plain Text — the label colour
            // must crossfade in step with the AnimatedContainer's bg/border,
            // otherwise it snaps instantly while the fill is still easing
            // in, which reads as a flash/glitch when two chips (the
            // newly-selected one and the previously-selected one) transition
            // at once.
            AnimatedDefaultTextStyle(
              duration: animationDuration,
              style: (labelStyle ?? Theme.of(context).textTheme.labelMedium)!
                  .copyWith(color: fg),
              child: Text(label),
            ),
            if (selected && showCheckIcon) ...[
              const SizedBox(width: AppSpacing.xs3),
              Icon(Icons.check, size: 14, color: fg),
            ],
          ],
        ),
      ),
    );
  }
}
