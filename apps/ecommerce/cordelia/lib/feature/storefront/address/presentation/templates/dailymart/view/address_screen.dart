import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:core/core/base/base_screen.dart';
import 'package:core/core/services/shared_pref_service/shared_preference_service.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/molecules/empty_state.dart';
import 'package:core/core/ui/molecules/error_view.dart';

import 'package:cordelia/constants/app_routes.dart';
import 'package:cordelia/feature/storefront/address/presentation/address_pref_keys.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_dimen_const.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_value_const.dart';
import 'package:cordelia/templates/dailymart/widgets/dailymart_bottom_fade.dart';
import 'package:cordelia/templates/dailymart/widgets/dailymart_header_row.dart';
import 'package:cordelia/templates/dailymart/widgets/dailymart_primary_button.dart';
import 'package:cordelia/templates/dailymart/widgets/dailymart_top_switcher.dart';

import '../../../../domain/entities/address_entity.dart';
import '../../../bloc/address_bloc.dart';
import '../widgets/address_card.dart';
import '../widgets/address_skeleton_body.dart';

/// `dailymart` template's Select Address (kit frame `30 Checkout - Shipping
/// Address`) — a white sheet of tinted address cards with one floating
/// "Add New Address" CTA.
///
/// Structurally different from gravia's version in one way that matters:
/// the kit gives this screen no confirm button, so **tapping a card commits
/// the choice and pops**, rather than arming a docked Select Address bar.
/// Callers are unaffected — this still pops the chosen [AddressEntity], the
/// same contract the Cart's checkout gate awaits.
///
/// Per-card Edit/Delete are not drawn yet: the kit's frame has no affordance
/// for either, and inventing one would be this pack guessing at a screen the
/// kit will supply.
class AddressScreen extends BaseScreen {
  const AddressScreen({super.key});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends BaseScreenState<AddressScreen> {
  Future<void> _select(AddressEntity address) async {
    // Reflect the tap immediately: the pop is animated, so without this the
    // card the shopper just chose stays unselected for the whole exit.
    context.read<AddressBloc>().add(
      AddressEvent.selected(addressId: address.id),
    );
    await SharedPreferenceService.instance.setString(
      kSelectedAddressIdPrefKey,
      address.id,
    );
    await SharedPreferenceService.instance.setString(
      kSelectedAddressLabelPrefKey,
      address.displayLine,
    );
    if (!mounted) return;
    // Pop with the confirmed address so a caller gating an action on it (the
    // Cart's checkout flow) can proceed; callers that just open this to set
    // the current address (Profile) ignore the return value.
    context.pop(address);
  }

  /// Pushes the Add/Edit Address form — this pack has no form screen of its
  /// own yet, so that route still resolves to gravia's — then, if it
  /// returned a result, dispatches it into this screen's own `AddressBloc`
  /// so the list updates without a re-fetch.
  Future<void> _openAddressForm() async {
    final result = await context.push<AddressEntity>(AppRoutes.addressForm);
    if (result == null || !mounted) return;
    context.read<AddressBloc>().add(AddressEvent.saved(address: result));
  }

  @override
  SystemUiOverlayStyle? overlayStyle(BuildContext context) =>
      BaseScreenState.themedStatusIcons(context);

  @override
  Widget body(BuildContext context) {
    return ColoredBox(
      color: Theme.of(context).colorScheme.surface,
      child: SafeArea(
        bottom: false,
        child: Stack(
          // The scroll view shrink-wraps its content; without expanding, a
          // one-card list ends the stack early and the positioned fade + CTA
          // pin to the content's bottom edge instead of the device's.
          fit: StackFit.expand,
          children: [
            BlocConsumer<AddressBloc, AddressState>(
              listener: (context, state) {
                if (state case AddressError(:final message)) {
                  showSnackBar(message);
                }
                if (state case AddressLoaded(saveFailed: true)) {
                  showSnackBar(DailyMartValueConst.addressSaveFailedMessage);
                }
              },
              builder: (context, state) => DailyMartTopSwitcher(
                child: switch (state) {
                  AddressLoading() => const _Page(
                    key: ValueKey('loading'),
                    body: DailyMartAddressSkeletonBody(),
                  ),
                  AddressError() => _Page(
                    key: const ValueKey('error'),
                    body: ErrorView(
                      message: DailyMartValueConst.addressLoadErrorMessage,
                      onRetry: () => context.read<AddressBloc>().add(
                        const AddressEvent.started(),
                      ),
                    ),
                  ),
                  AddressLoaded(:final addresses, :final selectedAddressId) =>
                    _Page(
                      key: const ValueKey('loaded'),
                      body: addresses.isEmpty
                          ? const EmptyState(
                              iconData: Icons.location_on_outlined,
                              title: DailyMartValueConst.addressEmptyTitle,
                              subtitle:
                                  DailyMartValueConst.addressEmptySubtitle,
                            )
                          : Column(
                              children: [
                                for (var i = 0; i < addresses.length; i++) ...[
                                  if (i > 0)
                                    const SizedBox(height: AppSpacing.lg),
                                  AddressCard(
                                    address: addresses[i],
                                    selected:
                                        addresses[i].id == selectedAddressId,
                                    onTap: () => _select(addresses[i]),
                                  ),
                                ],
                              ],
                            ),
                    ),
                },
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
                label: DailyMartValueConst.addNewAddressLabel,
                onTap: _openAddressForm,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The scroll view every state sits in — header row pinned to the top of the
/// content (this pack scrolls its header away rather than docking it), one
/// padding recipe so a state swap never shifts the list sideways.
class _Page extends StatelessWidget {
  final Widget body;

  const _Page({super.key, required this.body});

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: const EdgeInsets.fromLTRB(
      AppSpacing.lg,
      AppSpacing.base,
      AppSpacing.lg,
      // Clears the floating CTA docked over the fade.
      DailyMartDimenConst.floatingActionScrollInset,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DailyMartHeaderRow(
          title: DailyMartValueConst.selectAddressTitle,
          onBack: () => context.pop(),
        ),
        const SizedBox(height: AppSpacing.xl2),
        body,
      ],
    ),
  );
}
