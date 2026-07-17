import 'package:flutter/material.dart';

import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/radio_dot.dart';

import 'package:gravia/constants/text_style_const.dart';

/// Single-select radio list for a bottom sheet — same row layout, generic
/// over [T] so it fits any bounded picklist. Started as Category Details'
/// "Sort by"/"Price" filter content; the Add/Edit Address form's City/Country
/// pickers are its second caller, which is what moved it here out of that
/// feature's own `widgets/` folder.
class RadioOptionsSheetContent<T> extends StatelessWidget {
  final List<T> options;
  final String Function(T) labelOf;
  final T selected;
  final ValueChanged<T> onSelected;

  const RadioOptionsSheetContent({
    super.key,
    required this.options,
    required this.labelOf,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.base,
        AppSpacing.lg,
        AppSpacing.lg,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final option in options)
            RadioOptionRow(
              label: labelOf(option),
              selected: option == selected,
              onTap: () => onSelected(option),
            ),
        ],
      ),
    );
  }
}

/// One radio row of the sheet's list — also composed directly by the Orders
/// filter sheet, whose "Select a Reason" radios sit inline among other
/// fields rather than as a whole-sheet list.
class RadioOptionRow extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const RadioOptionRow({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
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
              style: TextStyleConst.textMdRegular(
                tt,
              ).copyWith(color: cs.onSurface),
            ),
          ],
        ),
      ),
    );
  }
}
