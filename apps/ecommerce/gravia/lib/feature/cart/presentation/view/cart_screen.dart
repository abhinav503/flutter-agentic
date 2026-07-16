import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:core/core/base/base_screen.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/blocks/collapsing_header_sheet.dart';
import 'package:core/core/ui/blocks/section_header.dart';
import 'package:core/core/ui/molecules/empty_state.dart';

import 'package:gravia/constants/app_routes.dart';
import 'package:gravia/constants/text_style_const.dart';
import 'package:gravia/constants/value_const.dart';
import 'package:gravia/widgets/gravia_docked_bar.dart';
import 'package:gravia/widgets/gravia_hero_header.dart';
import 'package:gravia/widgets/gravia_primary_button.dart';
import 'package:gravia/widgets/gravia_product_card.dart';
import 'package:gravia/widgets/gravia_sheet.dart';

import '../../../home/domain/entities/product_entity.dart';
import '../bloc/cart_bloc.dart';
import '../cubit/cart_cubit.dart';
import '../widgets/cart_item_row.dart';
import '../widgets/cart_summary_section.dart';

class CartScreen extends BaseScreen {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends BaseScreenState<CartScreen> {
  void _showComingSoon() => showSnackBar(ValueConst.comingSoonMessage);

  void _addToCart(ProductEntity product, int quantity) {
    context.read<CartCubit>().addToCart(product, quantity);
  }

  void _openProductDetails(ProductEntity product) =>
      context.push(AppRoutes.productDetailsPath(product.id));

  void _showAddToCartSheet(ProductEntity product) =>
      showGraviaAddToCartSheet(product: product, onAddToCart: _addToCart);

  @override
  Widget body(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final cartItems = context.watch<CartCubit>().state;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: cartItems.isEmpty
          ? Column(
              children: [
                GraviaHeroHeader(
                  title: ValueConst.myCartTitle,
                  onBack: () => context.pop(),
                ),
                Expanded(
                  child: Container(
                    color: cs.surface,
                    child: const EmptyState(
                      iconData: Icons.shopping_bag_outlined,
                      title: ValueConst.cartEmptyTitle,
                      subtitle: ValueConst.cartEmptySubtitle,
                    ),
                  ),
                ),
              ],
            )
          : Column(
              children: [
                Expanded(
                  child: CollapsingHeaderSheet(
                    initialHeaderHeight: 110,
                    header: GraviaHeroHeader(
                      title: ValueConst.myCartTitle,
                      onBack: () => context.pop(),
                    ),
                    body: Padding(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (var i = 0; i < cartItems.length; i++) ...[
                            if (i > 0) const SizedBox(height: AppSpacing.xl2),
                            CartItemRow(
                              item: cartItems[i],
                              onIncrement: () => context
                                  .read<CartCubit>()
                                  .incrementQuantity(cartItems[i].product.id),
                              onDecrement: () => context
                                  .read<CartCubit>()
                                  .decrementQuantity(cartItems[i].product.id),
                            ),
                          ],
                          const SizedBox(height: AppSpacing.xl4),
                          BlocBuilder<CartBloc, CartState>(
                            builder: (context, state) => switch (state) {
                              CartLoaded(:final suggestions) =>
                                _BeforeYouCheckoutRail(
                                  products: suggestions,
                                  onAddToCart: (product) =>
                                      _addToCart(product, 1),
                                  onQuickAdd: _showAddToCartSheet,
                                  onProductTap: _openProductDetails,
                                ),
                              CartLoading() ||
                              CartError() => const SizedBox.shrink(),
                            },
                          ),
                          const SizedBox(height: AppSpacing.xl4),
                          CartSummarySection(
                            items: cartItems,
                            onApplyCoupon: _showComingSoon,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                GraviaDockedBar(
                  child: GraviaPrimaryButton(
                    label: ValueConst.proceedToCheckoutLabel,
                    onTap: _showComingSoon,
                  ),
                ),
              ],
            ),
    );
  }
}

class _BeforeYouCheckoutRail extends StatelessWidget {
  final List<ProductEntity> products;
  final ValueChanged<ProductEntity> onAddToCart;
  final ValueChanged<ProductEntity> onQuickAdd;
  final ValueChanged<ProductEntity> onProductTap;

  const _BeforeYouCheckoutRail({
    required this.products,
    required this.onAddToCart,
    required this.onQuickAdd,
    required this.onProductTap,
  });

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) return const SizedBox.shrink();

    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: ValueConst.beforeYouCheckoutTitle,
          titleStyle: TextStyleConst.textLgBold(
            tt,
          ).copyWith(color: cs.onSurface),
        ),
        const SizedBox(height: AppSpacing.base),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var i = 0; i < products.length; i++) ...[
                if (i > 0) const SizedBox(width: AppSpacing.base),
                GraviaProductCard(
                  product: products[i],
                  width: GraviaProductCard.railWidth,
                  // Kit's "Before you checkout" cards are barer — no
                  // prep-time/discount meta row.
                  showPrepTime: false,
                  showDiscount: false,
                  onAddToCart: () => onAddToCart(products[i]),
                  onQuickAdd: () => onQuickAdd(products[i]),
                  onTap: () => onProductTap(products[i]),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
