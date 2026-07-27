import 'package:flutter/material.dart';

import 'package:core/core/theme/app_radius.dart';
import 'package:core/core/theme/app_spacing.dart';

import 'package:cordelia/templates/gravia/constants/gravia_color_const.dart';
import 'package:cordelia/templates/gravia/constants/gravia_text_style_const.dart';

/// A bounded-picklist field styled to match the storefront's form text
/// fields exactly — label above, same square-rounded (16, the forms' own
/// spec — not the pack's shared pill input radius) bordered box, same
/// label/text colours — so it reads as one of the form's fields rather than
/// a differently-styled control.
///
/// A pure trigger: it just shows [value] and calls [onTap] — picking happens
/// in whatever the caller opens (a `RadioOptionsSheetContent` sheet via
/// `showGraviaSheet`, a date-range picker).
class GraviaDropdownField extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onTap;

  /// Picklist chevron by default; a Date field can swap in a calendar glyph
  /// (Material fallback — the kit has no calendar SVG yet).
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
          style: GraviaTextStyleConst.textSmRegular(
            tt,
          ).copyWith(color: GraviaColorConst.gray500),
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
