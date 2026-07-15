import 'package:flutter/material.dart';

import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/button.dart';
import 'package:core/core/ui/atoms/svg_image.dart';
import 'package:core/core/ui/blocks/quantity_stepper.dart';

import 'package:gravia/constants/color_const.dart';
import 'package:gravia/constants/image_const.dart';
import 'package:gravia/constants/text_style_const.dart';
import 'package:gravia/constants/value_const.dart';

/// Docked bottom CTA (design.md's "Docked bottom CTA" pattern): a quantity
/// stepper next to a full-width primary pill whose label live-updates with
/// the line total for the chosen quantity.
class ProductDetailBottomBar extends StatelessWidget {
  final int quantity;
  final double unitPrice;
  final VoidCallback onIncrement;
  final VoidCallback? onDecrement;
  final VoidCallback onAddToCart;

  const ProductDetailBottomBar({
    super.key,
    required this.quantity,
    required this.unitPrice,
    required this.onIncrement,
    required this.onDecrement,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;
    // Same top-border treatment as BottomNavBar (ShellPage's
    // _dividerColor) — Gray/500 in light, white in dark — so this docked
    // CTA separates from scrollable content the same way the nav bar does.
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
          child: Row(
            children: [
              QuantityStepper(
                value: quantity,
                iconColor: ColorConst.gray700,
                valueTextStyle: TextStyleConst.textMdBold(tt),
                decrementIconBuilder: (color, size) =>
                    AppSvgImage.asset(ImageConst.minus, color: color, width: size, height: size),
                incrementIconBuilder: (color, size) =>
                    AppSvgImage.asset(ImageConst.plus, color: color, width: size, height: size),
                onDecrement: onDecrement,
                onIncrement: onIncrement,
              ),
              const SizedBox(width: AppSpacing.base),
              Expanded(
                child: AppButton(
                  label: ValueConst.addToCartWithPrice(unitPrice * quantity),
                  fullWidth: true,
                  labelStyle: TextStyleConst.textMdMedium(tt).copyWith(color: cs.onPrimary),
                  onTap: onAddToCart,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
