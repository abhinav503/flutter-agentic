import 'package:flutter/material.dart';

import 'package:core/core/theme/app_spacing.dart';

import 'package:cordelia/feature/storefront/home/domain/entities/product_entity.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_value_const.dart';

import 'dailymart_primary_button.dart';
import 'dailymart_product_list_tile.dart';

/// Body of the DailyMart "Add To Cart" sheet — the same product line the
/// Cart draws ([DailyMartProductListTile], live line total beside the
/// stepper), then a single full-width CTA (a terminal confirmation per spec
/// sheet §9, so one pill, not an action pair). Owns the CTA itself rather
/// than using `AppBottomSheet`'s `actions:` slot so it shares this widget's
/// local quantity state.
class DailyMartAddToCartSheetContent extends StatefulWidget {
  final ProductEntity product;
  final ValueChanged<int> onAddToCart;

  const DailyMartAddToCartSheetContent({
    super.key,
    required this.product,
    required this.onAddToCart,
  });

  @override
  State<DailyMartAddToCartSheetContent> createState() =>
      _DailyMartAddToCartSheetContentState();
}

class _DailyMartAddToCartSheetContentState
    extends State<DailyMartAddToCartSheetContent> {
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.base,
        AppSpacing.lg,
        AppSpacing.lg,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DailyMartProductListTile(
            product: widget.product,
            quantity: _quantity,
            onDecrement: _quantity > 1
                ? () => setState(() => _quantity--)
                : null,
            onIncrement: () => setState(() => _quantity++),
          ),
          const SizedBox(height: AppSpacing.xl4),
          DailyMartPrimaryButton(
            label: DailyMartValueConst.addToCart,
            onTap: () {
              widget.onAddToCart(_quantity);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
