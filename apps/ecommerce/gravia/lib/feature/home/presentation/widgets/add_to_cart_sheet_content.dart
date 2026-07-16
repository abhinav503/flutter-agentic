import 'package:flutter/material.dart';

import 'package:core/core/theme/app_radius.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/button.dart';
import 'package:core/core/ui/atoms/network_image.dart';
import 'package:core/core/ui/atoms/svg_image.dart';
import 'package:core/core/ui/blocks/quantity_stepper.dart';

import 'package:gravia/constants/color_const.dart';
import 'package:gravia/constants/image_const.dart';
import 'package:gravia/constants/text_style_const.dart';
import 'package:gravia/constants/value_const.dart';
import 'package:gravia/enums/product_unit_type.dart';

import '../../domain/entities/product_entity.dart';

/// Body of the "Add to Cart" sheet opened from [ProductCard]'s quick-add
/// icon — lets the shopper pick a quantity before confirming. Owns the
/// Cancel/Add to Cart buttons itself (rather than via [AppBottomSheet]'s
/// `actions:` slot) so they share this widget's local quantity state.
class AddToCartSheetContent extends StatefulWidget {
  final ProductEntity product;
  final ValueChanged<int> onAddToCart;

  const AddToCartSheetContent({
    super.key,
    required this.product,
    required this.onAddToCart,
  });

  @override
  State<AddToCartSheetContent> createState() => _AddToCartSheetContentState();
}

class _AddToCartSheetContentState extends State<AddToCartSheetContent> {
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.base,
        AppSpacing.lg,
        AppSpacing.lg,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: AppRadius.lg,
                child: SizedBox(
                  width: AppSpacing.xl13,
                  height: AppSpacing.xl13,
                  child: AppNetworkImage(
                    url: widget.product.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.base),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.product.name,
                      style: TextStyleConst.textMdBold(tt),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSpacing.xs3),
                    Text(
                      widget.product.unitType
                          .format(widget.product.unitValue * _quantity),
                      style: TextStyleConst.textSmRegular(tt)
                          .copyWith(color: cs.onSurfaceVariant),
                    ),
                    const SizedBox(height: AppSpacing.base),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          // Line total for the chosen quantity, not the flat
                          // unit price — updates live as the stepper changes.
                          '\$${(widget.product.price * _quantity).toStringAsFixed(2)}',
                          style: TextStyleConst.textMdBold(tt).copyWith(color: cs.onSurface),
                        ),
                        QuantityStepper(
                          value: _quantity,
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
                          onDecrement: _quantity > 1
                              ? () => setState(() => _quantity--)
                              : null,
                          onIncrement: () => setState(() => _quantity++),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl2),
          Row(
            children: [
              Expanded(
                child: AppButton(
                  label: ValueConst.cancel,
                  variant: AppButtonVariant.secondary,
                  fullWidth: true,
                  size: AppButtonSize.large,
                  height: 45,
                  // Kit spec: a neutral black/white Cancel outline, not
                  // core's default primary-coloured secondary text.
                  labelStyle: TextStyle(color: cs.onSurface),
                  onTap: () => Navigator.of(context).pop(),
                ),
              ),
              const SizedBox(width: AppSpacing.base),
              Expanded(
                child: AppButton(
                  label: ValueConst.addToCart,
                  fullWidth: true,
                  size: AppButtonSize.large,
                  height: 45,
                  onTap: () {
                    widget.onAddToCart(_quantity);
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
