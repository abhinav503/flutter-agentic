import 'package:cordelia/templates/dailymart/constants/dailymart_image_const.dart';
import 'package:core/core/ui/atoms/svg_image.dart';
import 'package:flutter/material.dart';

import 'package:core/core/theme/app_shapes_extension.dart';
import 'package:core/core/theme/app_spacing.dart';

import 'package:cordelia/templates/dailymart/widgets/dailymart_product_list_tile.dart';

import '../../../../domain/entities/cart_item_entity.dart';

/// One cart line (kit frames `24`/`25`) — the pack's shared product line
/// ([DailyMartProductListTile]), swiped left to reveal the delete state.
/// The kit's card carries no stepper, but a cart without quantity control
/// forces remove-and-re-add — the pack's bare stepper rides the price row
/// at the card size instead (recorded as a deviation in the spec sheet).
class DailyMartCartItemCard extends StatelessWidget {
  final CartItemEntity item;
  final VoidCallback onIncrement;
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
  final cs = Theme.of(context).colorScheme;
  final shapes =
      Theme.of(context).extension<AppShapes>() ?? AppShapes.standard;
  final radius = BorderRadius.circular(shapes.cardRadius);

  return Container(
    decoration: BoxDecoration(
      color: cs.errorContainer,
      borderRadius: radius,
    ),
    child: ClipRRect(
      borderRadius: radius,
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: AppSpacing.lg),
              color: cs.errorContainer,
              child: AppSvgImage.asset(DailyMartImageConst.delete),
            ),
          ),
          Dismissible(
            key: ValueKey(item.product.id),
            direction: DismissDirection.endToStart,
            onDismissed: (_) => onRemove(),
            // Empty container because the actual visual background is rendered by the Stack
            background: const SizedBox.shrink(),
            child: DailyMartProductListTile(
              product: item.product,
              quantity: item.quantity,
              onIncrement: onIncrement,
              onDecrement: onDecrement,
            ),
          ),
        ],
      ),
    ),
  );
}
}
