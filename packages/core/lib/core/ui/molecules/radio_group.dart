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

  /// Pops the enclosing route (the sheet) **before** reporting the pick — the
  /// standard picklist-sheet contract, so callers never re-type the
  /// pop-then-apply dance and can't get its order wrong (apply-then-pop
  /// re-renders the sheet against the new state for one frame).
  final bool popOnSelect;

  /// Outer inset around the list (default none — the sheet's own gutter
  /// pads) — for a sheet body that owns its horizontal inset.
  final EdgeInsetsGeometry? padding;

  /// Caps the list at this fraction of the screen height and makes it
  /// scrollable — for open-ended picklists (a city list) that would
  /// otherwise push the sheet past the viewport. Omit for shrink-wrap.
  final double? maxHeightFraction;

  const AppRadioGroup({
    super.key,
    required this.options,
    required this.labelOf,
    required this.selected,
    required this.onSelected,
    this.labelStyle,
    this.popOnSelect = false,
    this.padding,
    this.maxHeightFraction,
  });

  @override
  Widget build(BuildContext context) {
    Widget list = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final option in options)
          AppRadioRow(
            label: labelOf(option),
            selected: option == selected,
            labelStyle: labelStyle,
            onTap: () {
              if (popOnSelect) Navigator.of(context).pop();
              onSelected(option);
            },
          ),
      ],
    );
    if (maxHeightFraction != null) {
      list = ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * maxHeightFraction!,
        ),
        child: SingleChildScrollView(child: list),
      );
    }
    if (padding != null) list = Padding(padding: padding!, child: list);
    return list;
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
