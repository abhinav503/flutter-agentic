import 'package:cordelia/constants/app_routes.dart';
import 'package:cordelia/feature/storefront/cart/domain/entities/cart_item_entity.dart';
import 'package:cordelia/feature/storefront/cart/presentation/cubit/cart_cubit.dart';
import 'package:cordelia/feature/storefront/cart/presentation/templates/gravia/widgets/cart_status_bar.dart';
import 'package:cordelia/templates/gravia/constants/gravia_value_const.dart';
import 'package:cordelia/templates/gravia/widgets/gravia_quantity_stepper.dart';
import 'package:cordelia/widgets/cordelia_primary_button.dart';
import 'package:flutter/material.dart';

import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/blocks/docked_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// [DockedBar] for Product Details: a quantity stepper next to the primary
/// CTA whose label live-updates with the line total for the chosen quantity.
class ProductDetailBottomBar extends StatelessWidget {
  final String storeId;
  final int quantity;
  final double unitPrice;
  final VoidCallback onIncrement;
  final VoidCallback? onDecrement;
  final VoidCallback onAddToCart;

  const ProductDetailBottomBar({
    super.key,
    required this.storeId,
    required this.quantity,
    required this.unitPrice,
    required this.onIncrement,
    required this.onDecrement,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BlocBuilder<CartCubit, List<CartItemEntity>>(
          builder: (context, items) => items.isEmpty
              ? const SizedBox.shrink()
              : CartStatusBar(
                  itemCount: items.itemCount,
                  grandTotal: items.grandTotal,
                  onTap: () => context.push(AppRoutes.cart, extra: storeId),
                  onClear: () => context.read<CartCubit>().clear(),
                ),
        ),
        DockedBar(
          child: Row(
            children: [
              GraviaQuantityStepper(
                value: quantity,
                height: CordeliaPrimaryButton.barHeight,
                onDecrement: onDecrement,
                onIncrement: onIncrement,
              ),
              const SizedBox(width: AppSpacing.base),
              Expanded(
                child: CordeliaPrimaryButton(
                  label: GraviaValueConst.addToCartWithPrice(unitPrice * quantity),
                  onTap: onAddToCart,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
