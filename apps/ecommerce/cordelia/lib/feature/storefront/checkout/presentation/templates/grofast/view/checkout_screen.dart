import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:core/core/base/base_screen.dart';
import 'package:core/core/extensions/num_extensions.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/button.dart';
import 'package:core/core/ui/blocks/ecommerce/price_breakdown.dart';

import 'package:cordelia/feature/storefront/active_store/presentation/active_store_capture.dart';
import 'package:cordelia/constants/app_routes.dart';
import 'package:cordelia/enums/product_unit_type.dart';
import 'package:cordelia/feature/storefront/address/domain/entities/address_entity.dart';
import 'package:cordelia/feature/storefront/address/presentation/templates/grofast/widgets/address_picker_sheet.dart';
import 'package:cordelia/feature/storefront/address/presentation/templates/grofast/widgets/grofast_address_tile.dart';
import 'package:cordelia/feature/storefront/cart/domain/entities/cart_item_entity.dart';
import 'package:cordelia/feature/storefront/cart/presentation/cubit/cart_cubit.dart';
import 'package:cordelia/feature/storefront/cart/presentation/cubit/coupon_cubit.dart';
import 'package:cordelia/feature/storefront/presentation/view/storefront_page.dart';
import 'package:cordelia/templates/grofast/constants/grofast_text_style_const.dart';
import 'package:cordelia/templates/grofast/constants/grofast_value_const.dart';
import 'package:cordelia/templates/grofast/widgets/grofast_line_item_row.dart';
import 'package:cordelia/templates/grofast/widgets/grofast_primary_button.dart';
import 'package:cordelia/templates/grofast/widgets/grofast_promo_code_row.dart';
import 'package:cordelia/templates/grofast/widgets/grofast_screen_body.dart';
import 'package:cordelia/templates/grofast/widgets/grofast_section_header.dart';
import 'package:cordelia/templates/grofast/widgets/grofast_sheet.dart';
import 'package:cordelia/templates/grofast/widgets/grofast_success_sheet_content.dart';
import 'package:cordelia/feature/storefront/active_store/presentation/cubit/active_store_cubit.dart';
import 'package:cordelia/constants/value_const.dart';
import 'package:cordelia/feature/home/domain/entities/store_delivery_entity.dart';

import '../../../bloc/checkout_bloc.dart';

/// `grofast` template's Checkout (kit frame `119:819`) — the items, the
/// delivery address, the promo stub, the totals, and "Confirm Order" floating
/// over the pack's bottom fade.
///
/// On success the kit does **not** swap the body: it drops its domed
/// "Success!" sheet (frame `179:3199`) over the dimmed screen, which is what
/// this does through `showGrofastSuccessSheet` — the pack's terminal
/// confirmation (spec sheet §9).
///
/// The kit's saved **payment cards** block isn't built: payment runs through
/// Razorpay's own sheet, so a card picker here would be a control that
/// decides nothing (spec sheet §11).
///
/// Reached from the Bag's CTA *after* an address is picked, so [address] is
/// never null on entry — tapping the address card re-opens Select Address.
/// Bag state is the app-root `CartCubit`, read live so a change made
/// elsewhere can't leave this screen ordering a stale basket.
class CheckoutScreen extends BaseScreen {
  final AddressEntity address;

  const CheckoutScreen({super.key, required this.address});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends BaseScreenState<CheckoutScreen>
    with ActiveStoreCapture {
  late AddressEntity _address = widget.address;

  Future<void> _changeAddress() async {
    final picked = await showGrofastAddressPicker(this);
    if (picked == null || !mounted) return;
    setState(() => _address = picked);
  }

  void _submit(List<CartItemEntity> items) {
    // Refused here, before the payment intent exists, so an address the
    // store doesn't reach costs a message instead of a charge to unwind.
    // The server enforces the same rule — this is the localized half of it,
    // since server copy can only be English.
    if (!context.storeDelivery.serves(_address.postalCode)) {
      showSnackBar(ValueConst.deliveryUnavailableMessage);
      return;
    }
    context.read<CheckoutBloc>().add(
      CheckoutEvent.submitted(
        items: items,
        addressId: _address.id,
        // The code the Bag's promo row validated — the server re-prices it.
        couponCode: switch (context.read<CouponCubit>().state) {
          CouponApplied(:final coupon) => coupon.code,
          _ => '',
        },
      ),
    );
  }

  /// The bag empties only once the server has confirmed the order — never
  /// optimistically on tap — and then the terminal sheet takes over.
  void _onOrderPlaced() {
    context.read<CartCubit>().clear();
    context.read<CouponCubit>().reset();
    showGrofastSuccessSheet(
      context: context,
      child: GrofastSuccessSheetContent(
        title: GrofastValueConst.orderPlacedTitle,
        message: GrofastValueConst.orderPlacedMessage,
        actionLabel: GrofastValueConst.browseHomeLabel,
        onAction: _browseHome,
      ),
    );
  }

  /// Leaves the whole checkout stack behind for the storefront's Home tab —
  /// `go`, not `pop`, because the order is placed and there is nothing on
  /// this route worth returning to.
  void _browseHome() {
    final store = activeStore;
    context.go(AppRoutes.storefront, extra: StorefrontRouteArgs(store: store));
  }

  @override
  SystemUiOverlayStyle? overlayStyle(BuildContext context) =>
      BaseScreenState.themedStatusIcons(context);

  @override
  Widget body(BuildContext context) {
    final items = context.watch<CartCubit>().state;
    final couponState = context.watch<CouponCubit>().state;

    return SafeArea(
      bottom: false,
      child: BlocConsumer<CheckoutBloc, CheckoutState>(
        listener: (context, state) => switch (state) {
          CheckoutSuccess() => _onOrderPlaced(),
          CheckoutFailure(:final message) => showSnackBar(message),
          CheckoutIdle() || CheckoutSubmitting() => null,
        },
        builder: (context, state) => GrofastScreenBody(
          title: GrofastValueConst.checkoutTitle,
          onBack: () => context.pop(),
          gap: AppSpacing.xl4,
          floatingAction: GrofastPrimaryButton(
            label: GrofastValueConst.confirmOrderLabel,
            state: switch (state) {
              CheckoutSubmitting() => AppButtonState.loading,
              _ when items.isEmpty => AppButtonState.disabled,
              _ => AppButtonState.idle,
            },
            onTap: () => _submit(items),
          ),
          body: _CheckoutForm(
            items: items,
            address: _address,
            couponState: couponState,
            onChangeAddress: _changeAddress,
            onPromoApply: (code) =>
                context.read<CouponCubit>().apply(storeId, code, items),
            onPromoRemove: () => context.read<CouponCubit>().remove(),
          ),
        ),
      ),
    );
  }
}

class _CheckoutForm extends StatelessWidget {
  final List<CartItemEntity> items;
  final AddressEntity address;
  final CouponState couponState;
  final VoidCallback onChangeAddress;
  final ValueChanged<String> onPromoApply;
  final VoidCallback onPromoRemove;

  const _CheckoutForm({
    required this.items,
    required this.address,
    required this.couponState,
    required this.onChangeAddress,
    required this.onPromoApply,
    required this.onPromoRemove,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    final label = GrofastTextStyleConst.bodyMedium(
      tt,
    ).copyWith(color: cs.onSurfaceVariant);
    final value = GrofastTextStyleConst.bodyMedium(
      tt,
    ).copyWith(color: cs.onSurface);
    final appliedCoupon = switch (couponState) {
      CouponApplied(:final coupon) => coupon,
      _ => null,
    };
    // The fee rides on the basket after the coupon, matching the server.
    final goods = items.grandTotal - (appliedCoupon?.discount ?? 0);
    final deliveryFee = context.storeDelivery.feeFor(goods);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GrofastSectionHeader(title: GrofastValueConst.itemsTitle),
        const SizedBox(height: AppSpacing.lg),
        for (final item in items) ...[
          GrofastLineItemRow(
            imageUrl: item.product.imageUrl,
            name: item.product.name,
            subtitle: item.product.unitType.format(item.effectiveSizeValue),
            price: item.lineTotal,
            trailing: Text(
              GrofastValueConst.orderLineQuantity(item.quantity),
              style: GrofastTextStyleConst.meta(
                tt,
              ).copyWith(color: cs.onSurfaceVariant),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
        ],
        const SizedBox(height: AppSpacing.lg),
        GrofastSectionHeader(
          title: GrofastValueConst.deliveryAddressTitle,
          actionLabel: GrofastValueConst.changeAddressLabel,
          onAction: onChangeAddress,
        ),
        const SizedBox(height: AppSpacing.lg),
        // The same Item/Location card the picker sheet lists, in its active
        // ring — this is the chosen one, and tapping it re-opens the picker.
        GrofastAddressTile(
          address: address,
          index: 0,
          isSelected: true,
          onTap: onChangeAddress,
        ),
        const SizedBox(height: AppSpacing.xl4),
        PriceBreakdown(
          leading: GrofastPromoCodeRow(
            couponState: couponState,
            onApply: onPromoApply,
            onRemove: onPromoRemove,
          ),
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
            if (appliedCoupon != null)
              PriceLine(
                label: GrofastValueConst.couponLineLabel(appliedCoupon.code),
                value: '- ${appliedCoupon.discount.asPrice}',
                labelStyle: label,
                valueStyle: value.copyWith(color: cs.error),
              ),
            PriceLine(
              label: GrofastValueConst.deliveryLabel,
              value: deliveryFee > 0
                  ? deliveryFee.asPrice
                  : GrofastValueConst.deliveryFreeLabel,
              labelStyle: label,
              valueStyle: value,
            ),
          ],
          total: PriceLine(
            label: GrofastValueConst.totalLabel,
            value: (goods + deliveryFee).asPrice,
            labelStyle: GrofastTextStyleConst.rowTitleBold(tt),
            valueStyle: GrofastTextStyleConst.price(
              tt,
            ).copyWith(color: cs.primary),
          ),
          dividerColor: cs.outlineVariant,
        ),
      ],
    );
  }
}
