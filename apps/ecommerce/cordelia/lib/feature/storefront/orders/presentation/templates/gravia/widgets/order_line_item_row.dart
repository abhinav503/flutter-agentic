import 'package:cordelia/templates/gravia/constants/gravia_color_const.dart';
import 'package:cordelia/templates/gravia/constants/gravia_text_style_const.dart';
import 'package:cordelia/templates/gravia/constants/gravia_value_const.dart';
import 'package:cordelia/templates/gravia/widgets/gravia_list_thumbnail.dart';
import 'package:flutter/material.dart';
import 'package:core/core/ui/molecules/icon_info_row.dart';
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

    return IconInfoRow(
      crossAxisAlignment: CrossAxisAlignment.start,
      leading: GraviaListThumbnail(url: item.imageUrl, size: _imageSize),
      title: item.productName,
      titleStyle: GraviaTextStyleConst.textMdBold(
        tt,
      ).copyWith(color: cs.onSurface),
      titleMaxLines: 1,
      subtitle: GraviaValueConst.weightQuantityLabel(
        item.weight,
        item.quantity,
      ),
      subtitleStyle: GraviaTextStyleConst.textSmRegular(
        tt,
      ).copyWith(color: GraviaColorConst.gray500),
      // The kit sets the two lines solid — line-height alone spaces them.
      lineGap: 0,
      trailing: Text(
        GraviaValueConst.formattedPrice(item.lineTotal),
        style: GraviaTextStyleConst.textMdBold(tt).copyWith(color: cs.onSurface),
      ),
    );
  }
}
