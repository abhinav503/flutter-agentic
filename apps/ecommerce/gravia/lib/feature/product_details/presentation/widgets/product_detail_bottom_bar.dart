import 'package:flutter/material.dart';

import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/svg_image.dart';
import 'package:core/core/ui/blocks/quantity_stepper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gravia/constants/app_routes.dart';

import 'package:gravia/constants/color_const.dart';
import 'package:gravia/constants/image_const.dart';
import 'package:gravia/constants/text_style_const.dart';
import 'package:gravia/constants/value_const.dart';
import 'package:gravia/feature/cart/domain/entities/cart_item_entity.dart';
import 'package:gravia/feature/cart/presentation/cubit/cart_cubit.dart';
import 'package:gravia/feature/cart/presentation/widgets/cart_status_bar.dart';
import 'package:gravia/widgets/gravia_docked_bar.dart';
import 'package:gravia/widgets/gravia_primary_button.dart';

/// [GraviaDockedBar] for Product Details: a quantity stepper next to the
/// primary CTA whose label live-updates with the line total for the chosen
/// quantity.
class ProductDetailBottomBar extends StatelessWidget {
  final int quantity;
  final double unitPrice;
  final VoidCallback onIncrement;
  final VoidCallback? onDecrement;
  final VoidCallback onAddToCart;

  const ProductDetailBottomBar({
    super.key,
    required this.quantity,
    required this.unitPrice,
    required this.onIncrement,
    required this.onDecrement,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Column(
      children: [
        BlocBuilder<CartCubit, List<CartItemEntity>>(
          builder: (context, items) => items.isEmpty
              ? const SizedBox.shrink()
              : CartStatusBar(
                  itemCount: items.itemCount,
                  grandTotal: items.grandTotal,
                  onTap: () => context.push(AppRoutes.cart),
                  onClear: () => context.read<CartCubit>().clear(),
                ),
        ),
        GraviaDockedBar(
          child: Row(
            children: [
              QuantityStepper(
                value: quantity,
                height: GraviaPrimaryButton.barHeight,
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
                onDecrement: onDecrement,
                onIncrement: onIncrement,
              ),
              const SizedBox(width: AppSpacing.base),
              Expanded(
                child: GraviaPrimaryButton(
                  label: ValueConst.addToCartWithPrice(unitPrice * quantity),
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
