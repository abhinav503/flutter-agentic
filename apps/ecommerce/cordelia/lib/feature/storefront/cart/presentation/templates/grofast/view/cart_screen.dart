import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:core/core/base/base_screen.dart';
import 'package:core/core/extensions/num_extensions.dart';
import 'package:core/core/theme/app_colors_extension.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/svg_image.dart';
import 'package:core/core/ui/blocks/ecommerce/price_breakdown.dart';
import 'package:core/core/ui/molecules/swipe_to_delete_row.dart';

import 'package:cordelia/constants/app_routes.dart';
import 'package:cordelia/enums/product_unit_type.dart';
import 'package:cordelia/feature/storefront/address/domain/entities/address_entity.dart';
import 'package:cordelia/feature/storefront/cart/domain/entities/cart_item_entity.dart';
import 'package:cordelia/feature/storefront/favourites/presentation/cubit/favourites_cubit.dart';
import 'package:cordelia/templates/grofast/constants/grofast_dimen_const.dart';
import 'package:cordelia/templates/grofast/constants/grofast_image_const.dart';
import 'package:cordelia/templates/grofast/constants/grofast_text_style_const.dart';
import 'package:cordelia/templates/grofast/constants/grofast_value_const.dart';
import 'package:cordelia/templates/grofast/widgets/grofast_line_item_row.dart';
import 'package:cordelia/templates/grofast/widgets/grofast_product_card.dart';
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
        // The count belongs to the "My Bag" line, not up here — see
        // `_BagContent`. With no title and no trailing action, the back
        // control is the whole header: as the tab it drops out entirely
        // rather than leaving an empty row's height above "My Bag".
        onBack: widget.onBack,
        showBack: widget.showBack,
        gap: AppSpacing.xl2,
        // As a tab this scroll view reaches under the nav (the shell runs
        // `extendBody`), so it clears the bar itself and lets its last row
        // pass behind the dome; the routed copy has no nav below it and owns
        // the bottom edge, so it takes the shell's default.
        bottomInset: widget.showBack
            ? null
            : GrofastDimenConst.navScrollInset(context),
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

/// The kit prints "3 items" on the title's baseline, at the far end of the
/// "My Bag" row — a count *of* the thing the title names, not a control.
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

    final favourites = context.watch<FavouritesCubit>().state.items;
    final label = GrofastTextStyleConst.bodyMedium(
      tt,
    ).copyWith(color: cs.onSurfaceVariant);
    final value = GrofastTextStyleConst.price(tt).copyWith(color: cs.primary);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              GrofastValueConst.bagTitle,
              style: GrofastTextStyleConst.displayBold(tt),
            ),
            const Spacer(),
            Padding(
              // Sits on the title's baseline rather than its box, which is
              // ~11 taller than the count's line.
              padding: const EdgeInsets.only(bottom: AppSpacing.xs),
              child: _ItemCount(count: items.itemCount),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xl2),
        for (final item in items) ...[
          _DismissibleRow(
            productId: item.product.id,
            onDelete: () => cart.removeItem(item.product.id),
            child: GrofastLineItemRow(
              imageUrl: item.product.imageUrl,
              name: item.product.name,
              subtitle: item.product.unitType.format(item.product.unitValue),
              price: item.lineTotal,
              // The kit's row carries the *favourite* heart here, not a
              // remove control — removing is the swipe (see `_DismissibleRow`),
              // so the visible control is the one that can't be undone by
              // accident.
              topTrailing: GrofastFavouriteHeart(
                size: GrofastDimenConst.lineItemHeartSize,
                isFavourite: favourites.any((p) => p.id == item.product.id),
                onTap: () =>
                    context.read<FavouritesCubit>().toggle(item.product),
              ),
              trailing: GrofastQuantityStepper(
                quantity: item.quantity,
                onIncrement: () => cart.incrementQuantity(item.product.id),
                onDecrement: item.quantity > 1
                    ? () => cart.decrementQuantity(item.product.id)
                    : null,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
        ],
        const SizedBox(height: AppSpacing.lg),
        Divider(color: context.appColors.dockedHairline, height: 1),
        const SizedBox(height: AppSpacing.xl4),
        // Every line that adds up to the total, on the same block Checkout
        // uses — a Bag that shows only the final figure asks the shopper to
        // trust it.
        PriceBreakdown(
          leading: GrofastPromoCodeRow(onApply: onPromoApply),
          lines: [
            PriceLine(
              label: GrofastValueConst.subtotalLabel,
              value: items.itemTotal.asPrice,
              labelStyle: label,
              valueStyle: value,
            ),
            if (items.discountTotal > 0)
              PriceLine(
                label: GrofastValueConst.discountLabel,
                value: '- ${items.discountTotal.asPrice}',
                labelStyle: label,
                valueStyle: value.copyWith(color: cs.error),
              ),
          ],
          total: PriceLine(
            label: GrofastValueConst.totalLabel,
            value: items.grandTotal.asPrice,
            labelStyle: GrofastTextStyleConst.rowTitleBold(tt),
            valueStyle: GrofastTextStyleConst.price(
              tt,
            ).copyWith(color: cs.primary),
          ),
          dividerColor: cs.outlineVariant,
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

/// Swipe a Bag row left to delete it (the kit's `Card/Product/Wide+Delete`)
/// — core's [SwipeToDeleteRow] with the kit's outlined trash glyph.
///
/// No confirm sheet — the swipe is deliberate enough on its own, and the
/// product is one tap away in the catalog. That's also why the row's visible
/// control is the favourite heart instead: the destructive action should be
/// the one you have to mean.
class _DismissibleRow extends StatelessWidget {
  final String productId;
  final VoidCallback onDelete;
  final Widget child;

  const _DismissibleRow({
    required this.productId,
    required this.onDelete,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return SwipeToDeleteRow(
      itemKey: productId,
      onDelete: onDelete,
      borderRadius: BorderRadius.circular(GrofastDimenConst.tileRadius),
      iconInset: AppSpacing.xl2,
      icon: AppSvgImage.asset(
        GrofastImageConst.delete,
        width: AppSpacing.xl,
        height: AppSpacing.xl,
        color: cs.error,
      ),
      child: child,
    );
  }
}
