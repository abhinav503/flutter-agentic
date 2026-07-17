import 'package:flutter/material.dart';

import 'package:core/core/theme/app_radius.dart';
import 'package:core/core/theme/app_spacing.dart';

import 'package:gravia/constants/color_const.dart';
import 'package:gravia/constants/text_style_const.dart';

/// A bounded-picklist field styled to match the app's form text fields
/// exactly — label above, same square-rounded (16, the forms' own spec — not
/// the pack's shared pill input radius) bordered box, same label/text
/// colours — so it reads as one of the form's fields rather than a
/// differently-styled control. Started as the Add/Edit Address form's
/// City/Country fields; the Orders filter sheet's Status/Date fields are its
/// second caller, which is what moved it here out of that feature's own
/// `widgets/` folder.
///
/// A pure trigger: it just shows [value] and calls [onTap] — picking happens
/// in whatever the caller opens (a `RadioOptionsSheetContent` sheet via
/// `showGraviaSheet`, a date-range picker), the same "filter chip opens a
/// radio-list sheet" pattern as Category Details' Sort/Price controls, not a
/// popup menu.
class GraviaDropdownField extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onTap;

  /// Picklist chevron by default; the Orders filter's Date field swaps in a
  /// calendar glyph (Material fallback — the kit has no calendar SVG yet).
  final IconData trailingIcon;

  const GraviaDropdownField({
    super.key,
    required this.label,
    required this.value,
    required this.onTap,
    this.trailingIcon = Icons.keyboard_arrow_down_rounded,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: TextStyleConst.textSmRegular(
            tt,
          ).copyWith(color: ColorConst.gray500),
        ),
        const SizedBox(height: AppSpacing.xs),
        GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.base,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              border: Border.all(color: cs.outline),
              borderRadius: AppRadius.xl,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    value,
                    style: tt.bodyMedium!.copyWith(color: cs.onSurface),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(trailingIcon, color: cs.onSurfaceVariant),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
