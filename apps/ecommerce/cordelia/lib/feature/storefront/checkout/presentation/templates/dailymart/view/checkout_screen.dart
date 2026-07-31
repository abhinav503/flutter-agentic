import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:core/core/base/base_screen.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/app_switcher.dart';
import 'package:core/core/ui/atoms/button.dart';

import 'package:cordelia/constants/app_routes.dart';
import 'package:cordelia/feature/storefront/address/domain/entities/address_entity.dart';
import 'package:cordelia/feature/storefront/cart/domain/entities/cart_item_entity.dart';
import 'package:cordelia/feature/storefront/cart/presentation/cubit/cart_cubit.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_dimen_const.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_text_style_const.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_value_const.dart';
import 'package:cordelia/templates/dailymart/widgets/dailymart_bottom_fade.dart';
import 'package:cordelia/templates/dailymart/widgets/dailymart_header_row.dart';
import 'package:cordelia/templates/dailymart/widgets/dailymart_primary_button.dart';
import 'package:cordelia/templates/dailymart/widgets/dailymart_product_list_tile.dart';

import '../../../bloc/checkout_bloc.dart';
import '../widgets/checkout_address_card.dart';
import '../widgets/order_success_body.dart';

/// `dailymart` template's Checkout (kit frame `29 Checkout`) — the delivery
/// address, the read-only order list, and the "Continue to Payment" CTA
/// floating over the pack's bottom fade. On success the same screen swaps to
/// the kit's `34 Order Successfully` body under an unchanged header.
///
/// The kit's **Shipping Type** block (and its picker sheet, frame `31`) is
/// deliberately not built: this storefront has one flat delivery perk and no
/// courier tiers to choose between, so the block would be three fixed options
/// that change nothing about the order.
///
/// Reached from the Cart's CTA *after* an address is picked, so [address] is
/// never null on entry — tapping the address card re-opens Select Address to
/// change it. Cart state is the app-root `CartCubit`, read live here so a
/// change made elsewhere can't leave this screen ordering a stale basket.
class CheckoutScreen extends BaseScreen {
  final AddressEntity address;

  const CheckoutScreen({super.key, required this.address});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends BaseScreenState<CheckoutScreen> {
  late AddressEntity _address = widget.address;

  Future<void> _changeAddress() async {
    final picked = await context.push<AddressEntity>(AppRoutes.selectAddress);
    if (picked == null || !mounted) return;
    setState(() => _address = picked);
  }

  void _submit(List<CartItemEntity> items) => context.read<CheckoutBloc>().add(
    CheckoutEvent.submitted(items: items, addressId: _address.id),
  );

  /// The cart empties only once the server has confirmed the order — never
  /// optimistically on tap.
  void _onOrderPlaced() => context.read<CartCubit>().clear();

  /// This template's shell has no Orders tab and no Orders screen yet, so the
  /// success CTA says so instead of opening gravia's and putting two packs on
  /// one nav bar — the same answer Profile's My Orders row gives. Re-point
  /// this at the Orders route once the screen lands.
  void _trackOrder() => showSnackBar(
    DailyMartValueConst.comingSoonSubtitle(DailyMartValueConst.myOrdersLabel),
  );

  @override
  SystemUiOverlayStyle? overlayStyle(BuildContext context) =>
      BaseScreenState.themedStatusIcons(context);

  @override
  Widget body(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final items = context.watch<CartCubit>().state;

    return ColoredBox(
      color: cs.surface,
      child: SafeArea(
        bottom: false,
        child: BlocConsumer<CheckoutBloc, CheckoutState>(
          listener: (context, state) => switch (state) {
            CheckoutSuccess() => _onOrderPlaced(),
            CheckoutFailure(:final message) => showSnackBar(message),
            CheckoutIdle() || CheckoutSubmitting() => null,
          },
          builder: (context, state) => Column(
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
                  title: DailyMartValueConst.checkoutTitle,
                  // Pops the whole route in both states, so from the success
                  // body this leaves checkout rather than returning to a form
                  // whose order is already placed. It stays visible there (as
                  // the kit draws it) because Track My Order has nowhere to go
                  // yet — without it the shopper would be stranded.
                  onBack: () => context.pop(),
                ),
              ),
              Expanded(
                child: AppSwitcher(
                  child: state is CheckoutSuccess
                      ? OrderSuccessBody(onTrackOrder: _trackOrder)
                      : _Form(
                          address: _address,
                          items: items,
                          busy: state is CheckoutSubmitting,
                          onChangeAddress: _changeAddress,
                          onSubmit: () => _submit(items),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Form extends StatelessWidget {
  final AddressEntity address;
  final List<CartItemEntity> items;
  final bool busy;
  final VoidCallback onChangeAddress;
  final VoidCallback onSubmit;

  const _Form({
    required this.address,
    required this.items,
    required this.busy,
    required this.onChangeAddress,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Stack(
      fit: StackFit.expand,
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.xl4,
            AppSpacing.lg,
            // Clears the CTA floating over the fade.
            DailyMartDimenConst.floatingActionScrollInset,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CheckoutAddressCard(
                address: address,
                onChange: onChangeAddress,
              ),
              const SizedBox(height: AppSpacing.xl5),
              Text(
                DailyMartValueConst.orderListLabel,
                style: DailyMartTextStyleConst.bodyLgSemibold(
                  tt,
                ).copyWith(color: cs.onSurface),
              ),
              const SizedBox(height: AppSpacing.xl2),
              for (var i = 0; i < items.length; i++) ...[
                if (i > 0) const SizedBox(height: AppSpacing.base),
                DailyMartProductListTile(
                  product: items[i].product,
                  quantity: items[i].quantity,
                  showStepper: false,
                ),
              ],
            ],
          ),
        ),
        const Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: DailyMartBottomFade(),
        ),
        Positioned(
          left: AppSpacing.lg,
          right: AppSpacing.lg,
          bottom: MediaQuery.paddingOf(context).bottom + AppSpacing.lg,
          child: DailyMartPrimaryButton(
            label: DailyMartValueConst.continueToPaymentLabel,
            // Submitting spans the whole flow (payment intent, provider
            // checkout, order placement), so the CTA stays loading throughout.
            state: busy ? AppButtonState.loading : AppButtonState.idle,
            onTap: busy ? null : onSubmit,
          ),
        ),
      ],
    );
  }
}
