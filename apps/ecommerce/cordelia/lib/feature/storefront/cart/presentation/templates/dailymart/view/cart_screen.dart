import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:core/core/base/base_screen.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/molecules/empty_state.dart';
import 'package:core/core/ui/atoms/button.dart';

import 'package:cordelia/constants/app_routes.dart';
import 'package:cordelia/constants/value_const.dart';
import 'package:cordelia/feature/storefront/address/domain/entities/address_entity.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_value_const.dart';
import 'package:cordelia/templates/dailymart/widgets/dailymart_header_row.dart';
import 'package:cordelia/templates/dailymart/widgets/dailymart_sheet.dart';

import '../../../../domain/entities/cart_item_entity.dart';
import '../../../bloc/checkout_bloc.dart';
import '../../../cubit/cart_cubit.dart';
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
/// Cart state is the app-root [CartCubit]; a [CheckoutBloc] must be
/// provided above this screen by whichever host mounts it.
class CartScreen extends BaseScreen {
  final VoidCallback onBack;
  final bool showBack;

  const CartScreen({super.key, required this.onBack, this.showBack = true});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends BaseScreenState<CartScreen> {
  @override
  void initState() {
    super.initState();
    // The CheckoutBloc outlives this screen (shell-level in the tab host),
    // so a success that landed while the tab was unmounted had no listener
    // to react — reconcile on mount. `acknowledged` in _onOrderPlaced
    // resets the bloc so this can't re-fire on a later remount.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (context.read<CheckoutBloc>().state case CheckoutSuccess()) {
        _onOrderPlaced();
      }
    });
  }

  void _showComingSoon() => showSnackBar(ValueConst.comingSoonMessage);

  // Checkout first gates on picking a delivery address — reuses the Select
  // Address screen, which pops with the chosen address (null if the shopper
  // backs out). The cart clears only once the server confirms the order
  // (see the CheckoutBloc listener), never optimistically here.
  Future<void> _startCheckout(List<CartItemEntity> items) async {
    final address = await context.push<AddressEntity>(AppRoutes.selectAddress);
    if (address == null || !mounted) return;
    context.read<CheckoutBloc>().add(
      CheckoutEvent.submitted(items: items, addressId: address.id),
    );
  }

  void _onOrderPlaced() {
    context.read<CartCubit>().clear();
    context.read<CheckoutBloc>().add(const CheckoutEvent.acknowledged());
    // No Orders tab in this template's shell — the one exit resumes
    // shopping wherever the cart was opened from.
    showDailyMartOrderPlacedSheet(onContinue: widget.onBack);
  }

  @override
  SystemUiOverlayStyle? overlayStyle(BuildContext context) =>
      BaseScreenState.themedStatusIcons(context);

  @override
  Widget body(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final cartItems = context.watch<CartCubit>().state;

    return ColoredBox(
      color: cs.surface,
      child: SafeArea(
        // The summary panel handles the bottom inset itself so its surface
        // runs to the screen's edge.
        bottom: false,
        child: BlocListener<CheckoutBloc, CheckoutState>(
          listener: (context, state) {
            switch (state) {
              case CheckoutSuccess():
                _onOrderPlaced();
              case CheckoutFailure(:final message):
                showSnackBar(message);
              case CheckoutIdle() || CheckoutSubmitting():
                break;
            }
          },
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
                            onIncrement: () => context
                                .read<CartCubit>()
                                .incrementQuantity(cartItems[i].product.id),
                            onDecrement: () => context
                                .read<CartCubit>()
                                .decrementQuantity(cartItems[i].product.id),
                            onRemove: () {
                              context
                                  .read<CartCubit>()
                                  .removeItem(cartItems[i].product.id);
                              showSnackBar(
                                DailyMartValueConst.removedFromCartMessage,
                              );
                            },
                          ),
                        ],
                        const SizedBox(height: AppSpacing.xl2),
                        DailyMartCartSummarySection(
                          items: cartItems,
                          onApplyCoupon: _showComingSoon,
                        ),
                      ],
                    ),
                  ),
                ),
                BlocBuilder<CheckoutBloc, CheckoutState>(
                  builder: (context, state) => DailyMartCartCheckoutBar(
                    // Submitting spans the whole flow (payment + placement),
                    // so the CTA stays loading and un-tappable throughout.
                    busy: state is CheckoutSubmitting,
                    onCheckout: () => _startCheckout(cartItems),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
