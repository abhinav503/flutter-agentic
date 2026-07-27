import 'package:flutter/material.dart';

import 'package:core/core/theme/app_radius.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/network_image.dart';

import 'package:cordelia/enums/product_unit_type.dart';
import 'package:cordelia/templates/gravia/constants/gravia_text_style_const.dart';
import 'package:cordelia/templates/gravia/constants/gravia_value_const.dart';
import 'package:cordelia/feature/storefront/home/domain/entities/product_entity.dart';

import 'gravia_action_pair.dart';
import 'gravia_quantity_stepper.dart';

/// Body of the "Add to Cart" sheet opened from a product card's quick-add
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
                      style: GraviaTextStyleConst.textMdBold(tt),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSpacing.xs3),
                    Text(
                      widget.product.unitType.format(
                        widget.product.unitValue * _quantity,
                      ),
                      style: GraviaTextStyleConst.textSmRegular(
                        tt,
                      ).copyWith(color: cs.onSurfaceVariant),
                    ),
                    const SizedBox(height: AppSpacing.base),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          // Line total for the chosen quantity, not the flat
                          // unit price — updates live as the stepper changes.
                          GraviaValueConst.formattedPrice(
                            widget.product.price * _quantity,
                          ),
                          style: GraviaTextStyleConst.textMdBold(
                            tt,
                          ).copyWith(color: cs.onSurface),
                        ),
                        GraviaQuantityStepper(
                          value: _quantity,
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
          GraviaActionPair(
            left: GraviaAction(
              label: GraviaValueConst.cancel,
              kind: GraviaActionKind.secondary,
              // Kit spec: a neutral black/white Cancel outline, not
              // core's default primary-coloured secondary text.
              labelColor: cs.onSurface,
              onTap: () => Navigator.of(context).pop(),
            ),
            right: GraviaAction(
              label: GraviaValueConst.addToCart,
              kind: GraviaActionKind.primary,
              onTap: () {
                widget.onAddToCart(_quantity);
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      ),
    );
  }
}
