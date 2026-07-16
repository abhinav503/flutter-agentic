import 'package:flutter/material.dart';

import 'package:core/core/theme/app_radius.dart';
import 'package:core/core/theme/app_spacing.dart';

import 'package:gravia/constants/color_const.dart';
import 'package:gravia/constants/text_style_const.dart';

/// A bounded-picklist field (City, Country) styled to match the Add/Edit
/// Address form's text fields exactly — label above, same square-rounded
/// (16, this form's own spec — not the pack's shared pill input radius)
/// bordered box, same label/text colours — so it reads as one of the form's
/// fields rather than a differently-styled control.
///
/// A pure trigger: it just shows [value] and calls [onTap] — picking happens
/// in a bottom sheet the caller opens (`RadioOptionsSheetContent` in a
/// `showGraviaSheet`), the same "filter chip opens a radio-list sheet"
/// pattern as Category Details' Sort/Price controls, not a popup menu.
class AddressDropdownField extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onTap;

  const AddressDropdownField({
    super.key,
    required this.label,
    required this.value,
    required this.onTap,
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
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: cs.onSurfaceVariant,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
