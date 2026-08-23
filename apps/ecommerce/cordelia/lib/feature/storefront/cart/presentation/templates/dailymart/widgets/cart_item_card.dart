import 'package:flutter/material.dart';

import 'package:core/core/theme/app_shapes_extension.dart';
import 'package:core/core/ui/atoms/svg_image.dart';
import 'package:core/core/ui/molecules/swipe_to_delete_row.dart';

import 'package:cordelia/templates/dailymart/constants/dailymart_image_const.dart';
import 'package:cordelia/templates/dailymart/widgets/dailymart_product_list_tile.dart';

import '../../../../domain/entities/cart_item_entity.dart';
import '../../../cart_availability.dart';

/// One cart line (kit frames `24`/`25`) — the pack's shared product line
/// ([DailyMartProductListTile]) on core's [SwipeToDeleteRow].
/// The kit's card carries no stepper, but a cart without quantity control
/// forces remove-and-re-add — the pack's bare stepper rides the price row
/// at the card size instead (recorded as a deviation in the spec sheet).
class DailyMartCartItemCard extends StatelessWidget {
  final CartItemEntity item;

  /// Null at the product's remaining stock — see [DailyMartQuantityStepper].
  final VoidCallback? onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onRemove;

  const DailyMartCartItemCard({
    super.key,
    required this.item,
    required this.onIncrement,
    required this.onDecrement,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return SwipeToDeleteRow(
      // Keyed by line, not product — the same product can sit in the cart
      // twice in two pack sizes, and duplicate keys would confuse dismissal.
      itemKey: '${item.product.id}-${item.variantId ?? item.sizeValue}',
      onDelete: onRemove,
      borderRadius: BorderRadius.circular(context.appShapes.cardRadius),
      icon: AppSvgImage.asset(DailyMartImageConst.delete),
      child: DailyMartProductListTile(
        product: item.product,
        quantity: item.quantity,
        unitPrice: item.effectiveUnitPrice,
        packSize: item.effectiveSizeValue,
        onIncrement: onIncrement,
        onDecrement: onDecrement,
        unavailableLabel: item.availabilityLabel,
        subtitle: item.subtitle,
      ),
    );
  }
}
