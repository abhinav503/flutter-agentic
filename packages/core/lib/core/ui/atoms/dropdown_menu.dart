import 'package:flutter/material.dart';

import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';

/// One selectable option in an [AppDropdownMenu].
class AppDropdownItem<T> {
  final T value;
  final String label;
  final String? subtitle;
  final IconData? icon;

  const AppDropdownItem({
    required this.value,
    required this.label,
    this.subtitle,
    this.icon,
  });
}

/// A themed dropdown menu — a `PopupMenuButton` styled with the design tokens
/// (rounded [AppRadius] surface, `surfaceContainerHigh` background, themed text)
/// and a check on the selected row. Provide the [trigger] the user taps (an
/// icon, a labelled box, etc.).
///
/// ```dart
/// AppDropdownMenu<Mode>(
///   value: mode,
///   trigger: Icon(Icons.bolt),
///   items: const [
///     AppDropdownItem(value: Mode.a, label: 'Streaming', subtitle: 'Token by token', icon: Icons.bolt),
///     AppDropdownItem(value: Mode.b, label: 'One-shot',  subtitle: 'Whole reply',   icon: Icons.article_outlined),
///   ],
///   onSelected: (m) => ...,
/// )
/// ```
class AppDropdownMenu<T> extends StatelessWidget {
  final List<AppDropdownItem<T>> items;
  final T value;
  final ValueChanged<T> onSelected;
  final Widget trigger;
  final String? tooltip;
  final bool enabled;

  const AppDropdownMenu({
    super.key,
    required this.items,
    required this.value,
    required this.onSelected,
    required this.trigger,
    this.tooltip,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return PopupMenuButton<T>(
      enabled: enabled,
      tooltip: tooltip,
      initialValue: value,
      onSelected: onSelected,
      color: cs.surfaceContainerHigh,
      surfaceTintColor: Colors.transparent,
      position: PopupMenuPosition.under,
      shape: const RoundedRectangleBorder(borderRadius: AppRadius.md),
      itemBuilder: (context) => [
        for (final item in items)
          PopupMenuItem<T>(
            value: item.value,
            child: _Row(item: item, selected: item.value == value),
          ),
      ],
      child: trigger,
    );
  }
}

class _Row<T> extends StatelessWidget {
  final AppDropdownItem<T> item;
  final bool selected;

  const _Row({required this.item, required this.selected});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final accent = selected ? cs.primary : cs.onSurface;
    return Row(
      children: [
        if (item.icon != null) ...[
          Icon(item.icon, size: AppSpacing.xl, color: accent),
          const SizedBox(width: AppSpacing.base),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(item.label, style: tt.bodyMedium?.copyWith(color: accent)),
              if (item.subtitle != null)
                Text(
                  item.subtitle!,
                  style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                ),
            ],
          ),
        ),
        if (selected) ...[
          const SizedBox(width: AppSpacing.base),
          Icon(Icons.check, size: AppSpacing.xl, color: cs.primary),
        ],
      ],
    );
  }
}
