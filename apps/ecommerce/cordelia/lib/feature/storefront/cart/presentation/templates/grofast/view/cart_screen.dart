import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:core/core/base/base_screen.dart';
import 'package:core/core/theme/app_colors_extension.dart';
import 'package:core/core/theme/app_spacing.dart';

import 'package:cordelia/constants/app_routes.dart';
import 'package:cordelia/enums/product_unit_type.dart';
import 'package:cordelia/feature/storefront/address/domain/entities/address_entity.dart';
import 'package:cordelia/feature/storefront/cart/domain/entities/cart_item_entity.dart';
import 'package:cordelia/templates/grofast/constants/grofast_text_style_const.dart';
import 'package:cordelia/templates/grofast/constants/grofast_value_const.dart';
import 'package:cordelia/templates/grofast/widgets/grofast_header_row.dart';
import 'package:cordelia/templates/grofast/widgets/grofast_line_item_row.dart';
import 'package:cordelia/templates/grofast/widgets/grofast_price.dart';
import 'package:cordelia/templates/grofast/widgets/grofast_primary_button.dart';
import 'package:cordelia/templates/grofast/widgets/grofast_promo_code_row.dart';
import 'package:cordelia/templates/grofast/widgets/grofast_screen_body.dart';
import 'package:cordelia/templates/grofast/widgets/grofast_state_views.dart';

import '../../../cubit/cart_cubit.dart';

/// `grofast` template's Bag (kit frames `129:1262` / `129:1144` / `119:650`)
/// — served two ways: as the shell's Bag **tab** (back returns Home) and as
/// the routed page the header bag controls push (back pops). [onBack] carries
/// that difference; [showBack] hides the header's back control on the tab,
/// which is a nav root with nowhere to pop to.
///
/// Rows, promo code and totals all scroll together; only the checkout CTA
/// floats. Bag state is the app-root `CartCubit`. Placing the order is not
/// this screen's job — the CTA gates on an address and hands off to Checkout,
/// which owns the `CheckoutBloc` and the confirmation.
class CartScreen extends BaseScreen {
  final VoidCallback onBack;
  final bool showBack;

  const CartScreen({super.key, required this.onBack, this.showBack = true});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends BaseScreenState<CartScreen> {
  /// Checkout gates on picking a delivery address first — reuses the Select
  /// Address screen, which pops with the chosen address (null if the shopper
  /// backs out) — then hands off to the Checkout route, which owns the order
  /// from there.
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
    final items = context.watch<CartCubit>().state;

    return SafeArea(
      bottom: false,
      child: GrofastScreenBody(
        headerRow: GrofastHeaderRow(
          onBack: widget.onBack,
          showBack: widget.showBack,
          trailing: items.isEmpty ? null : _ItemCount(count: items.itemCount),
        ),
        gap: AppSpacing.xl2,
        // As a tab, the nav bar below already reserves its own height (and
        // the device inset with it), so this is breathing room only; the
        // routed copy owns the bottom edge and takes the shell's default.
        bottomInset: widget.showBack ? null : AppSpacing.xl2,
        // No floating CTA: the kit runs "Proceed To Checkout" in the scroll
        // flow under the totals, not docked over a fade.
        body: GrofastSwitcher(
          child: items.isEmpty
              ? GrofastEmptyState(
                  icon: Icons.shopping_bag_outlined,
                  title: GrofastValueConst.bagEmptyTitle,
                  subtitle: GrofastValueConst.bagEmptySubtitle,
                  actionLabel: GrofastValueConst.bagExploreAction,
                  onAction: widget.onBack,
                )
              : _BagContent(
                  items: items,
                  onPromoApply: () =>
                      showSnackBar(GrofastValueConst.promoComingSoonMessage),
                  onCheckout: _startCheckout,
                ),
        ),
      ),
    );
  }
}

/// The kit prints "3 items" where other screens put a trailing control.
class _ItemCount extends StatelessWidget {
  final int count;

  const _ItemCount({required this.count});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Text(
      GrofastValueConst.bagItemCount(count),
      style: GrofastTextStyleConst.bodyMedium(
        tt,
      ).copyWith(color: cs.onSurfaceVariant),
    );
  }
}

class _BagContent extends StatelessWidget {
  final List<CartItemEntity> items;

  /// Reports the coupon stub through the screen's own `showSnackBar` rather
  /// than reaching for a ScaffoldMessenger down here.
  final VoidCallback onPromoApply;

  final VoidCallback onCheckout;

  const _BagContent({
    required this.items,
    required this.onPromoApply,
    required this.onCheckout,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final cart = context.read<CartCubit>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          GrofastValueConst.bagTitle,
          style: GrofastTextStyleConst.displayBold(tt),
        ),
        const SizedBox(height: AppSpacing.xl2),
        for (final item in items) ...[
          GrofastLineItemRow(
            imageUrl: item.product.imageUrl,
            name: item.product.name,
            subtitle: item.product.unitType.format(item.product.unitValue),
            price: item.lineTotal,
            topTrailing: GrofastRemoveDisc(
              tooltip: GrofastValueConst.removeItemTooltip,
              onTap: () => cart.removeItem(item.product.id),
            ),
            trailing: GrofastQuantityStepper(
              quantity: item.quantity,
              onIncrement: () => cart.incrementQuantity(item.product.id),
              onDecrement: item.quantity > 1
                  ? () => cart.decrementQuantity(item.product.id)
                  : null,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
        ],
        const SizedBox(height: AppSpacing.lg),
        Divider(color: context.appColors.dockedHairline, height: 1),
        const SizedBox(height: AppSpacing.xl4),
        GrofastPromoCodeRow(onApply: onPromoApply),
        const SizedBox(height: AppSpacing.xl4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              GrofastValueConst.totalLabel,
              style: GrofastTextStyleConst.rowTitleBold(
                tt,
              ).copyWith(color: cs.onSurface),
            ),
            GrofastPrice(value: items.grandTotal, scale: 1.2),
          ],
        ),
        const SizedBox(height: AppSpacing.xl4),
        GrofastPrimaryButton(
          label: GrofastValueConst.proceedToCheckoutLabel,
          onTap: onCheckout,
        ),
      ],
    );
  }
}
