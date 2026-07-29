import 'package:flutter/material.dart';

import 'package:core/core/theme/app_radius.dart';
import 'package:core/core/theme/app_shapes_extension.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/network_image.dart';

import 'package:cordelia/enums/product_unit_type.dart';
import 'package:cordelia/feature/storefront/home/domain/entities/product_entity.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_dimen_const.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_text_style_const.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_value_const.dart';

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

  const DailyMartProductListTile({
    super.key,
    required this.product,
    required this.quantity,
    this.onIncrement,
    this.onDecrement,
  });

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
                  style: DailyMartTextStyleConst.bodyMdSemibold(
                    tt,
                  ).copyWith(color: cs.onSurface),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.xs4),
                Text(
                  product.unitType.format(product.unitValue),
                  style: DailyMartTextStyleConst.bodySmRegular(
                    tt,
                  ).copyWith(color: cs.onSurfaceVariant),
                ),
                const SizedBox(height: AppSpacing.xs2),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        DailyMartValueConst.formattedPrice(
                          product.price * quantity,
                        ),
                        style: DailyMartTextStyleConst.bodyMdSemibold(
                          tt,
                        ).copyWith(color: cs.onSurface),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    DailyMartQuantityStepper(
                      value: quantity,
                      controlSize: AppSpacing.xl2,
                      onDecrement: onDecrement,
                      onIncrement: onIncrement,
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
