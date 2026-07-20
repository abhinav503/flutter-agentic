import 'package:flutter/material.dart';

import 'package:core/core/theme/app_spacing.dart';

import 'package:gravia/constants/text_style_const.dart';
import 'package:gravia/constants/value_const.dart';
import 'package:gravia/enums/product_unit_type.dart';
import 'package:gravia/widgets/gravia_list_thumbnail.dart';
import 'package:gravia/widgets/gravia_quantity_stepper.dart';

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
        GraviaListThumbnail(url: product.imageUrl, size: AppSpacing.xl13),
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
                    ValueConst.formattedPrice(product.price * item.quantity),
                    style: TextStyleConst.textMdBold(
                      tt,
                    ).copyWith(color: cs.onSurface),
                  ),
                  GraviaQuantityStepper(
                    value: item.quantity,
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
