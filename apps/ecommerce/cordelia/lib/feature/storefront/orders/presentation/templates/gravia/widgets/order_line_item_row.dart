import 'package:cordelia/templates/gravia/constants/gravia_color_const.dart';
import 'package:cordelia/templates/gravia/constants/gravia_text_style_const.dart';
import 'package:cordelia/templates/gravia/constants/gravia_value_const.dart';
import 'package:cordelia/templates/gravia/widgets/gravia_list_thumbnail.dart';
import 'package:flutter/material.dart';
import 'package:core/core/theme/app_spacing.dart';
import '../../../../domain/entities/order_line_item_entity.dart';

/// One product within an order — thumbnail + name/weight-and-quantity on
/// the left, that line's total price on the right. Read-only (the order is
/// already placed), so unlike `CartItemRow` there's no quantity stepper.
class OrderLineItemRow extends StatelessWidget {
  final OrderLineItemEntity item;

  const OrderLineItemRow({super.key, required this.item});

  static const double _imageSize = 56;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GraviaListThumbnail(url: item.imageUrl, size: _imageSize),
        const SizedBox(width: AppSpacing.base),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                item.productName,
                style: GraviaTextStyleConst.textMdBold(
                  tt,
                ).copyWith(color: cs.onSurface),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                GraviaValueConst.weightQuantityLabel(item.weight, item.quantity),
                style: GraviaTextStyleConst.textSmRegular(
                  tt,
                ).copyWith(color: GraviaColorConst.gray500),
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.base),
        Text(
          GraviaValueConst.formattedPrice(item.lineTotal),
          style: GraviaTextStyleConst.textMdBold(tt).copyWith(color: cs.onSurface),
        ),
      ],
    );
  }
}
