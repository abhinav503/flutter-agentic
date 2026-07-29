import 'package:flutter/material.dart';

import 'package:core/core/ui/atoms/button.dart';

import 'package:cordelia/templates/dailymart/constants/dailymart_dimen_const.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_text_style_const.dart';

/// DailyMart's full-width primary CTA — [AppButton] pinned to the pack's
/// 56px pill with the Body/Medium/Medium label (spec sheet §13), so no
/// screen re-types the height/style pair.
class DailyMartPrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final AppButtonState state;

  const DailyMartPrimaryButton({
    super.key,
    required this.label,
    this.onTap,
    this.state = AppButtonState.idle,
  });

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return AppButton(
      label: label,
      onTap: onTap,
      state: state,
      size: AppButtonSize.large,
      fullWidth: true,
      height: DailyMartDimenConst.ctaHeight,
      // No colour override: AppButton applies its own onPrimary foreground.
      labelStyle: DailyMartTextStyleConst.bodyMdMedium(tt),
    );
  }
}
