import 'package:flutter/material.dart';

import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/button.dart';

import 'package:gravia/constants/color_const.dart';
import 'package:gravia/constants/text_style_const.dart';
import 'package:gravia/constants/value_const.dart';

/// Docked bottom CTA (design.md's "Docked bottom CTA" pattern): a single
/// full-width primary pill that confirms the radio selection made above,
/// with the same top-hairline treatment as [ProductDetailBottomBar]/
/// `BottomNavBar` so every docked bar in the app separates from scrollable
/// content the same way.
class AddressBottomBar extends StatelessWidget {
  final VoidCallback onConfirm;

  const AddressBottomBar({super.key, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dividerColor = isDark ? Colors.white : ColorConst.gray500;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: cs.surface,
        border: Border(top: BorderSide(color: dividerColor, width: 0.5)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.base,
            AppSpacing.lg,
            AppSpacing.base,
          ),
          child: AppButton(
            label: ValueConst.selectAddressTitle,
            fullWidth: true,
            size: AppButtonSize.large,
            height: 45,
            labelStyle: TextStyleConst.textMdMedium(tt).copyWith(color: cs.onPrimary),
            onTap: onConfirm,
          ),
        ),
      ),
    );
  }
}
