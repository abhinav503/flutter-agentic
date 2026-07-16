import 'package:flutter/material.dart';

import 'package:core/core/ui/atoms/button.dart';

import 'package:gravia/constants/text_style_const.dart';

/// Gravia's full-width primary CTA — [AppButton] with the pack's docked-bar
/// button spec baked in (large pill, 45px tall, textMd/medium on primary).
/// Every docked bottom bar's confirm action renders this, never a re-typed
/// [AppButton] param recipe.
class GraviaPrimaryButton extends StatelessWidget {
  /// The kit's CTA height — shorter than [AppButtonSize.large]'s default.
  static const double barHeight = 45;

  final String label;
  final VoidCallback? onTap;

  const GraviaPrimaryButton({super.key, required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return AppButton(
      label: label,
      fullWidth: true,
      size: AppButtonSize.large,
      height: barHeight,
      labelStyle: TextStyleConst.textMdMedium(tt).copyWith(color: cs.onPrimary),
      onTap: onTap,
    );
  }
}
