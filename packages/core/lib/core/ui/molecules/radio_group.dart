import 'package:flutter/material.dart';

import '../../theme/app_spacing.dart';
import '../atoms/radio_dot.dart';

/// Single-select radio list — one [AppRadioRow] per option, generic over [T]
/// so it fits any bounded picklist (sort/filter sheets, form pickers).
///
/// Style packs override [labelStyle] (or wrap this in an app preset that
/// bakes their spec in); the default reads the theme.
///
/// ```dart
/// AppRadioGroup(
///   options: ProductSortOption.values,
///   labelOf: (o) => o.label,
///   selected: current,
///   onSelected: (o) => ...,
/// )
/// ```
class AppRadioGroup<T> extends StatelessWidget {
  final List<T> options;
  final String Function(T) labelOf;
  final T selected;
  final ValueChanged<T> onSelected;
  final TextStyle? labelStyle;

  const AppRadioGroup({
    super.key,
    required this.options,
    required this.labelOf,
    required this.selected,
    required this.onSelected,
    this.labelStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final option in options)
          AppRadioRow(
            label: labelOf(option),
            selected: option == selected,
            labelStyle: labelStyle,
            onTap: () => onSelected(option),
          ),
      ],
    );
  }
}

/// One radio row — also composable on its own for radios that sit inline
/// among other fields rather than as a whole-list group.
class AppRadioRow extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final TextStyle? labelStyle;

  const AppRadioRow({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.labelStyle,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        child: Row(
          children: [
            AppRadioDot(selected: selected),
            const SizedBox(width: AppSpacing.base),
            Text(
              label,
              style:
                  labelStyle ?? tt.bodyLarge!.copyWith(color: cs.onSurface),
            ),
          ],
        ),
      ),
    );
  }
}
