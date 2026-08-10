import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:core/core/base/base_screen.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/molecules/empty_state.dart';
import 'package:core/core/ui/atoms/button.dart';

import 'package:cordelia/feature/storefront/active_store/presentation/active_store_capture.dart';
import 'package:cordelia/constants/app_routes.dart';
import 'package:cordelia/feature/storefront/address/domain/entities/address_entity.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_value_const.dart';
import 'package:cordelia/templates/dailymart/widgets/dailymart_header_row.dart';
import 'package:cordelia/feature/storefront/active_store/presentation/cubit/active_store_cubit.dart';

import '../../../../domain/entities/cart_item_entity.dart';
import '../../../cubit/cart_cubit.dart';
import '../../../cubit/coupon_cubit.dart';
import '../widgets/cart_item_card.dart';
import '../widgets/cart_summary_panel.dart';

/// `dailymart` template's Cart (kit frames `24`/`25`) — served two ways: as
/// the shell's Cart **tab** (back returns to the Home tab) and as the
/// routed page the PDP/search cart controls push (back pops). [onBack]
/// carries that difference so the screen itself doesn't care; [showBack]
/// hides the header's back disc on the tab, which is a nav root with
/// nowhere to pop to. Coupon + totals scroll with the items; only the
/// checkout CTA docks.
///
/// Cart state is the app-root `CartCubit`. Placing the order is *not* this
/// screen's job in this template — the CTA gates on an address and hands off
/// to the Checkout route, which owns the `CheckoutBloc` and the confirmation.
class CartScreen extends BaseScreen {
  final VoidCallback onBack;
  final bool showBack;

  const CartScreen({super.key, required this.onBack, this.showBack = true});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends BaseScreenState<CartScreen>
    with ActiveStoreCapture {
  // Checkout gates on picking a delivery address first — reuses the Select
  // Address screen, which pops with the chosen address (null if the shopper
  // backs out) — then hands off to the Checkout route, which owns the order
  // from there (its own CheckoutBloc, its own success state).
  Future<void> _startCheckout() async {
    final address = await context.push<AddressEntity>(AppRoutes.selectAddress);
    if (address == null || !mounted) return;
    if (!context.mounted) return;
    await context.push(AppRoutes.checkout, extra: address);
  }

  @override
  SystemUiOverlayStyle? overlayStyle(BuildContext context) =>
      BaseScreenState.themedStatusIcons(context);

  @override
  Widget body(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final cartItems = context.watch<CartCubit>().state;
    final couponState = context.watch<CouponCubit>().state;
    // The store this cart belongs to — the coupon API is store-scoped.

    return BlocListener<CartCubit, List<CartItemEntity>>(
      // The held discount is only valid for the lines it was priced against
      // — any cart mutation re-prices the code (or clears it, with the
      // server's reason shown on the row).
      listener: (context, items) =>
          context.read<CouponCubit>().revalidate(storeId, items),
      child: ColoredBox(
        color: cs.surface,
        child: SafeArea(
          // The summary panel handles the bottom inset itself so its surface
          // runs to the screen's edge.
          bottom: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.base,
                  AppSpacing.lg,
                  0,
                ),
                child: DailyMartHeaderRow(
                  title: DailyMartValueConst.myCartTitle,
                  onBack: widget.showBack ? widget.onBack : null,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              if (cartItems.isEmpty)
                Expanded(
                  child: EmptyState(
                    iconData: Icons.shopping_bag_outlined,
                    title: DailyMartValueConst.cartEmptyTitle,
                    subtitle: DailyMartValueConst.cartEmptySubtitle,
                    actions: [
                      AppButton(
                        label: DailyMartValueConst.cartExploreAction,
                        variant: AppButtonVariant.secondary,
                        onTap: widget.onBack,
                      ),
                    ],
                  ),
                )
              else ...[
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.lg,
                      0,
                      AppSpacing.lg,
                      AppSpacing.xl4,
                    ),
                    child: Column(
                      children: [
                        for (var i = 0; i < cartItems.length; i++) ...[
                          if (i > 0) const SizedBox(height: AppSpacing.base),
                          DailyMartCartItemCard(
                            item: cartItems[i],
                            // sizeValue scopes each tap to this exact line —
                            // the same product can sit here twice in two pack
                            // sizes.
                            onIncrement: () =>
                                context.read<CartCubit>().incrementQuantity(
                                  cartItems[i].product.id,
                                  sizeValue: cartItems[i].sizeValue,
                                ),
                            onDecrement: () =>
                                context.read<CartCubit>().decrementQuantity(
                                  cartItems[i].product.id,
                                  sizeValue: cartItems[i].sizeValue,
                                ),
                            onRemove: () {
                              context.read<CartCubit>().removeItem(
                                cartItems[i].product.id,
                                sizeValue: cartItems[i].sizeValue,
                              );
                              showSnackBar(
                                DailyMartValueConst.removedFromCartMessage,
                              );
                            },
                          ),
                        ],
                        const SizedBox(height: AppSpacing.xl2),
                        DailyMartCartSummarySection(
                          items: cartItems,
                          delivery: context.storeDelivery,
                          couponState: couponState,
                          onApplyCoupon: (code) => context
                              .read<CouponCubit>()
                              .apply(storeId, code, cartItems),
                          onRemoveCoupon: () =>
                              context.read<CouponCubit>().remove(),
                        ),
                      ],
                    ),
                  ),
                ),
                // Never busy: this CTA only navigates now — the Checkout
                // screen's own CTA carries the order's loading state.
                DailyMartCartCheckoutBar(
                  busy: false,
                  onCheckout: _startCheckout,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
