import 'package:flutter/material.dart';

import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/molecules/radio_group.dart';

import 'package:cordelia/templates/grofast/constants/grofast_text_style_const.dart';

/// A bounded picklist inside the pack's dome sheet — City, Country, the
/// avatar source (spec sheet §9). Core's [AppRadioGroup] does the selecting;
/// this only pins the pack's type and closes the sheet on choice, because a
/// single-select list has nothing left to confirm.
class GrofastOptionsSheetContent<T> extends StatelessWidget {
  final List<T> options;
  final T selected;
  final String Function(T) labelOf;
  final ValueChanged<T> onSelected;

  const GrofastOptionsSheetContent({
    super.key,
    required this.options,
    required this.selected,
    required this.labelOf,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return ConstrainedBox(
      // A long list (the city picklist) has to stay inside the sheet's own
      // max height rather than pushing the dome off the screen.
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.5,
      ),
      child: SingleChildScrollView(
        child: AppRadioGroup<T>(
          options: options,
          selected: selected,
          labelOf: labelOf,
          labelStyle: GrofastTextStyleConst.bodyMedium(tt),
          onSelected: (value) {
            Navigator.of(context).pop();
            onSelected(value);
          },
        ),
      ),
    );
  }
}

/// A titled block inside a sheet — "Sort By" over its chips, "Price" over
/// its own. Two of these plus an Apply button are the whole filter sheet.
class GrofastSheetSection extends StatelessWidget {
  final String title;
  final Widget child;

  const GrofastSheetSection({
    super.key,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: GrofastTextStyleConst.subheadBold(tt)),
        const SizedBox(height: AppSpacing.base),
        child,
      ],
    );
  }
}
