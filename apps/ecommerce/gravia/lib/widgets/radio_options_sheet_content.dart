import 'package:flutter/material.dart';

import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/molecules/radio_group.dart';

import 'package:gravia/constants/text_style_const.dart';

/// Gravia's single-select radio sheet body — core's [AppRadioGroup] with the
/// pack's spec baked in: Text/md/regular labels and the sheet's LTRB content
/// padding. Started as Category Details' "Sort by"/"Price" filter content;
/// the Add/Edit Address form's City/Country pickers are its second caller,
/// which is what moved it here out of that feature's own `widgets/` folder.
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
      child: AppRadioGroup(
        options: options,
        labelOf: labelOf,
        selected: selected,
        onSelected: onSelected,
        labelStyle: RadioOptionRow.labelStyle(context),
      ),
    );
  }
}

/// One radio row in gravia's spec — core's [AppRadioRow] with the pack's
/// Text/md/regular label baked in. Also composed directly by the Orders
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

  /// Public so [RadioOptionsSheetContent] passes the identical style through
  /// [AppRadioGroup] without re-deriving it.
  static TextStyle labelStyle(BuildContext context) =>
      TextStyleConst.textMdRegular(
        Theme.of(context).textTheme,
      ).copyWith(color: Theme.of(context).colorScheme.onSurface);

  @override
  Widget build(BuildContext context) {
    return AppRadioRow(
      label: label,
      selected: selected,
      onTap: onTap,
      labelStyle: labelStyle(context),
    );
  }
}
