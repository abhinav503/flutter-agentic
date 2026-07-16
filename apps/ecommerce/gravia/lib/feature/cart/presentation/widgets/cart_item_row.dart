import 'package:flutter/material.dart';

import 'package:core/core/theme/app_radius.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/network_image.dart';
import 'package:core/core/ui/atoms/svg_image.dart';
import 'package:core/core/ui/blocks/quantity_stepper.dart';

import 'package:gravia/constants/color_const.dart';
import 'package:gravia/constants/image_const.dart';
import 'package:gravia/constants/text_style_const.dart';
import 'package:gravia/enums/product_unit_type.dart';

import '../../domain/entities/cart_item_entity.dart';

/// One cart line: thumbnail + name/weight on the left, price + a live
/// quantity stepper on the right — the "pill quantity stepper on cart rows"
/// composition from design.md.
class CartItemRow extends StatelessWidget {
  final CartItemEntity item;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const CartItemRow({
    super.key,
    required this.item,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final product = item.product;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ClipRRect(
          borderRadius: AppRadius.lg,
          child: SizedBox(
            width: AppSpacing.xl13,
            height: AppSpacing.xl13,
            child: AppNetworkImage(url: product.imageUrl, fit: BoxFit.cover),
          ),
        ),
        const SizedBox(width: AppSpacing.base),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product.name,
                style: TextStyleConst.textMdBold(
                  tt,
                ).copyWith(color: cs.onSurface),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                product.unitType.format(product.unitValue),
                style: TextStyleConst.textSmRegular(
                  tt,
                ).copyWith(color: cs.onSurfaceVariant),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '\$${(product.price * item.quantity).toStringAsFixed(2)}',
                    style: TextStyleConst.textMdBold(
                      tt,
                    ).copyWith(color: cs.onSurface),
                  ),
                  QuantityStepper(
                    value: item.quantity,
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
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
