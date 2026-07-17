import 'package:flutter/material.dart';

import 'package:core/core/ui/atoms/svg_image.dart';
import 'package:core/core/ui/blocks/quantity_stepper.dart';

import 'package:gravia/constants/color_const.dart';
import 'package:gravia/constants/image_const.dart';
import 'package:gravia/constants/text_style_const.dart';

/// Gravia's one true quantity stepper — core's [QuantityStepper] with the
/// pack's fixed spec baked in: Gray/700 icon colour (same in both themes),
/// Text/md/bold count, and the kit's own minus/plus SVGs. Every quantity
/// control in the app (cart rows, product detail's docked bar, the quick-add
/// sheet) renders this, never a re-typed [QuantityStepper] recipe.
class GraviaQuantityStepper extends StatelessWidget {
  final int value;
  final VoidCallback? onIncrement;
  final VoidCallback? onDecrement;

  /// Pins the pill to an exact height — for docking next to a fixed-height
  /// sibling (e.g. [GraviaPrimaryButton] in a docked bar). Omit to keep the
  /// default content-driven height.
  final double? height;

  const GraviaQuantityStepper({
    super.key,
    required this.value,
    this.onIncrement,
    this.onDecrement,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return QuantityStepper(
      value: value,
      height: height,
      iconColor: ColorConst.gray700,
      valueTextStyle: TextStyleConst.textMdBold(tt),
      decrementIconBuilder: (color, size) => AppSvgImage.asset(
        ImageConst.minus,
        color: color,
        width: size,
        height: size,
      ),
      incrementIconBuilder: (color, size) => AppSvgImage.asset(
        ImageConst.plus,
        color: color,
        width: size,
        height: size,
      ),
      onDecrement: onDecrement,
      onIncrement: onIncrement,
    );
  }
}
