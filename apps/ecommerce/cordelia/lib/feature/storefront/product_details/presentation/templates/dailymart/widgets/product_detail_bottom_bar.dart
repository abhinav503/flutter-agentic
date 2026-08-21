import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/button.dart';

import 'package:cordelia/constants/app_routes.dart';
import 'package:cordelia/constants/value_const.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_dimen_const.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_image_const.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_value_const.dart';
import 'package:cordelia/templates/dailymart/widgets/dailymart_icon_disc.dart';
import 'package:cordelia/templates/dailymart/widgets/dailymart_primary_button.dart';

import '../../../../../cart/domain/entities/cart_item_entity.dart';
import '../../../../../cart/presentation/cubit/cart_cubit.dart';

/// Product Details' floating action row — the kit's outlined cart disc +
/// the Add To Cart pill — with the cart status pill docked above it while
/// the shared cart is non-empty (this screen sits outside the shell, so
/// the cart tab isn't visible to say so).
class DailyMartProductDetailBottomBar extends StatelessWidget {
  final String storeId;
  final VoidCallback onAddToCart;

  /// Sold out: the pill turns into an inert "Out of Stock". The cart disc
  /// beside it stays live — a cart that already holds other items is still
  /// worth opening.
  final bool soldOut;

  const DailyMartProductDetailBottomBar({
    super.key,
    required this.storeId,
    required this.onAddToCart,
    this.soldOut = false,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, List<CartItemEntity>>(
      builder: (context, items) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              DailyMartIconDisc.outlined(
                asset: DailyMartImageConst.navCart,
                onTap: () => _openCart(context),
                // The CTA's height, not the header band's 52 — and a solid
                // surface fill so the bottom fade can't show through.
                size: DailyMartDimenConst.ctaHeight,
                backgroundColor: Theme.of(context).colorScheme.surface,
              ),
              const SizedBox(width: AppSpacing.base),
              Expanded(
                child: DailyMartPrimaryButton(
                  label: soldOut
                      ? ValueConst.outOfStockLabel
                      : DailyMartValueConst.addToCart,
                  onTap: soldOut ? null : onAddToCart,
                  state: soldOut
                      ? AppButtonState.disabled
                      : AppButtonState.idle,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _openCart(BuildContext context) =>
      context.push(AppRoutes.cart, extra: storeId);
}
