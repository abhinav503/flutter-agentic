import 'package:flutter/material.dart';

import 'package:core/core/extensions/num_extensions.dart';
import 'package:core/core/theme/app_radius.dart';
import 'package:core/core/theme/app_shapes_extension.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/network_image.dart';

import 'package:cordelia/constants/value_const.dart';
import 'package:cordelia/enums/product_unit_type.dart';
import 'package:cordelia/feature/storefront/home/domain/entities/product_entity.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_dimen_const.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_text_style_const.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_value_const.dart';

import 'dailymart_product_card.dart';
import 'dailymart_quantity_stepper.dart';

/// The pack's product line (kit frames `24`/`25`): a recessed card with the
/// photo thumb, name over the per-unit line, and the live line total
/// (`price × quantity`) beside the bare stepper. One silhouette serves the
/// Cart's item cards (wrapped in their swipe-to-delete `Dismissible`) and
/// the Add To Cart sheet, so the two can't drift apart.
class DailyMartProductListTile extends StatelessWidget {
  final ProductEntity product;
  final int quantity;
  final VoidCallback? onIncrement;
  final VoidCallback? onDecrement;

  /// False on Checkout's Order List, where the basket is already fixed — the
  /// kit's row there carries no stepper, so the slot shows the quantity as
  /// text instead of a control that would reopen a settled decision.
  final bool showStepper;

  /// Per-line overrides for a cart line holding a selected package size —
  /// null keeps the product's own price/pack, which is what the Add To Cart
  /// sheet (no line yet) renders.
  final double? unitPrice;
  final double? packSize;

  /// Why this line can't be bought as it stands, taking the pack-size
  /// subtitle's slot. A cart row passes `item.availabilityLabel`, which also
  /// covers "only N left" — a quantity problem the tile can't see from the
  /// product alone. A sold-out product falls back to saying so without it.
  final String? unavailableLabel;

  const DailyMartProductListTile({
    super.key,
    required this.product,
    required this.quantity,
    this.onIncrement,
    this.onDecrement,
    this.showStepper = true,
    this.unitPrice,
    this.packSize,
    this.unavailableLabel,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final shapes = context.appShapes;
    final soldOut = product.isOutOfStock;
    final unavailable =
        unavailableLabel ?? (soldOut ? ValueConst.outOfStockLabel : null);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.base),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLow,
        borderRadius: BorderRadius.circular(shapes.cardRadius),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: AppRadius.lg,
            child: Container(
              width: DailyMartDimenConst.cartThumbSize,
              height: DailyMartDimenConst.cartThumbSize,
              color: cs.surfaceContainerHighest,
              child: Opacity(
                opacity: soldOut ? DailyMartProductCard.soldOutImageOpacity : 1,
                child: AppNetworkImage(
                  url: product.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.base),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: DailyMartTextStyleConst.bodyMdSemibold(
                    tt,
                  ).copyWith(color: cs.onSurface),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.xs4),
                // The pack size gives way to the reason this line can't be
                // bought — a cart row has one subtitle slot, and which pack
                // of an unavailable product this is doesn't help anyone.
                Text(
                  unavailable ??
                      product.unitType.format(packSize ?? product.unitValue),
                  style: DailyMartTextStyleConst.bodySmRegular(tt).copyWith(
                    color: unavailable == null ? cs.onSurfaceVariant : cs.error,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs2),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        ((unitPrice ?? product.price) * quantity).asPrice,
                        style: DailyMartTextStyleConst.bodyMdSemibold(
                          tt,
                        ).copyWith(color: cs.onSurface),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (showStepper)
                      DailyMartQuantityStepper(
                        value: quantity,
                        controlSize: AppSpacing.xl2,
                        onDecrement: onDecrement,
                        onIncrement: onIncrement,
                      )
                    else
                      Text(
                        DailyMartValueConst.orderLineQuantity(quantity),
                        style: DailyMartTextStyleConst.bodyMdSemibold(
                          tt,
                        ).copyWith(color: cs.onSurfaceVariant),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
