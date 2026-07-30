import 'package:flutter/material.dart';

import 'package:core/core/ui/atoms/button.dart';

import 'package:cordelia/templates/dailymart/constants/dailymart_dimen_const.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_text_style_const.dart';

/// The outlined half of the pack's CTA pair — [AppButton] at the same 56px
/// pill as [DailyMartPrimaryButton] but transparent behind a 1px
/// `cs.primary` ring, with the label in primary (spec sheet §13).
///
/// The kit's Reset/Apply pair is where this silhouette comes from; the
/// confirmation sheet's Cancel reuses it so the pack has one "secondary
/// action" look rather than a per-sheet one.
class DailyMartOutlineButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;

  const DailyMartOutlineButton({super.key, required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return AppButton(
      label: label,
      onTap: onTap,
      variant: AppButtonVariant.secondary,
      size: AppButtonSize.large,
      fullWidth: true,
      height: DailyMartDimenConst.ctaHeight,
      borderColor: cs.primary,
      labelStyle: DailyMartTextStyleConst.bodyMdMedium(
        tt,
      ).copyWith(color: cs.primary),
    );
  }
}
