import 'package:flutter/material.dart';

import 'package:core/core/theme/app_radius.dart';
import 'package:core/core/theme/app_shapes_extension.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/network_image.dart';

import 'package:cordelia/templates/dailymart/constants/dailymart_dimen_const.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_text_style_const.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_value_const.dart';

import '../../../../domain/entities/order_line_item_entity.dart';

/// One product within a placed order (Track Order's Order List) — the pack's
/// recessed product row, the same silhouette Checkout's Order List uses.
///
/// It can't be `DailyMartProductListTile` itself: that takes a live
/// `ProductEntity`, while an order carries only the snapshot it was placed
/// with (name, weight, price, quantity), which is what should be shown —
/// today's catalogue price is not what the shopper paid. Read-only for the
/// same reason the Checkout row is: the basket is settled by this point, so
/// the stepper slot reads `× quantity` instead.
class DailyMartOrderItemRow extends StatelessWidget {
  final OrderLineItemEntity item;

  const DailyMartOrderItemRow({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final shapes =
        Theme.of(context).extension<AppShapes>() ?? AppShapes.standard;

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
              child: AppNetworkImage(url: item.imageUrl, fit: BoxFit.cover),
            ),
          ),
          const SizedBox(width: AppSpacing.base),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.productName,
                  style: DailyMartTextStyleConst.bodyMdSemibold(
                    tt,
                  ).copyWith(color: cs.onSurface),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.xs4),
                Text(
                  item.weight,
                  style: DailyMartTextStyleConst.bodySmRegular(
                    tt,
                  ).copyWith(color: cs.onSurfaceVariant),
                ),
                const SizedBox(height: AppSpacing.xs2),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        DailyMartValueConst.formattedPrice(item.lineTotal),
                        style: DailyMartTextStyleConst.bodyMdSemibold(
                          tt,
                        ).copyWith(color: cs.onSurface),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      DailyMartValueConst.orderLineQuantity(item.quantity),
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
