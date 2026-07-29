import 'package:flutter/material.dart';

import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/molecules/radio_group.dart';

import 'package:cordelia/templates/dailymart/constants/dailymart_text_style_const.dart';

/// Body of a DailyMart bounded-picklist sheet — core's [AppRadioGroup] in
/// the pack's Body/Medium/Regular labels (spec sheet §9/§13). Selecting an
/// option pops the sheet and then reports it, so callers never re-type the
/// pop-then-apply dance.
class DailyMartRadioSheetContent<T> extends StatelessWidget {
  final List<T> options;
  final String Function(T) labelOf;
  final T selected;
  final ValueChanged<T> onSelected;

  const DailyMartRadioSheetContent({
    super.key,
    required this.options,
    required this.labelOf,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        0,
        AppSpacing.lg,
        AppSpacing.lg,
      ),
      child: AppRadioGroup<T>(
        options: options,
        labelOf: labelOf,
        selected: selected,
        labelStyle: DailyMartTextStyleConst.bodyMdRegular(
          tt,
        ).copyWith(color: cs.onSurface),
        onSelected: (option) {
          Navigator.of(context).pop();
          onSelected(option);
        },
      ),
    );
  }
}
