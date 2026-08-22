import 'package:flutter/material.dart';

import 'package:core/core/theme/app_radius.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/svg_image.dart';
import 'package:core/core/ui/molecules/picker_field.dart';

import 'package:cordelia/templates/dailymart/constants/dailymart_dimen_const.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_image_const.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_text_style_const.dart';

/// DailyMart's bounded-picklist field — [DailyMartFormField]'s chrome exactly
/// (a 56px box at radius 12 with a `cs.outline` hairline, 14/500 ink label
/// above), so a form that mixes typed and picked values still reads as one
/// stack of fields rather than two control families.
///
/// A pure trigger: it shows [value] and calls [onTap]. Picking happens in
/// whatever the caller opens — a [DailyMartRadioSheetContent] over
/// `showDailyMartSheet`.
///
/// The chevron is the kit's `arrow-right` under a quarter turn: the pack
/// ships no down-chevron of its own (see [DailyMartImageConst.chevronRight]),
/// and a Material stand-in beside kit glyphs reads as a foreign pack.
class DailyMartDropdownField extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onTap;

  const DailyMartDropdownField({
    super.key,
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return AppPickerField(
      label: label,
      value: value,
      onTap: onTap,
      labelStyle: DailyMartTextStyleConst.bodySmMedium(
        tt,
      ).copyWith(color: cs.onSurface),
      labelSpacing: AppSpacing.xs,
      valueStyle: DailyMartTextStyleConst.bodySmRegular(
        tt,
      ).copyWith(color: cs.onSurface),
      borderRadius: AppRadius.lg,
      height: DailyMartDimenConst.formFieldHeight,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.base),
      // Matches the pack's typed field, which ripples.
      splashOnTap: true,
      trailing: RotatedBox(
        quarterTurns: 1,
        child: AppSvgImage.asset(
          DailyMartImageConst.chevronRight,
          color: cs.onSurfaceVariant,
          width: AppSpacing.xl2,
          height: AppSpacing.xl2,
        ),
      ),
    );
  }
}
