import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:core/core/base/base_screen.dart';
import 'package:core/core/services/shared_pref_service/shared_preference_service.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/svg_image.dart';
import 'package:core/core/ui/molecules/swipe_to_delete_row.dart';

import 'package:cordelia/constants/app_routes.dart';
import 'package:cordelia/feature/storefront/address/domain/entities/address_entity.dart';
import 'package:cordelia/feature/storefront/address/presentation/address_pref_keys.dart';
import 'package:cordelia/templates/grofast/constants/grofast_value_const.dart';
import 'package:cordelia/templates/grofast/constants/grofast_color_const.dart';
import 'package:cordelia/templates/grofast/constants/grofast_dimen_const.dart';
import 'package:cordelia/templates/grofast/constants/grofast_image_const.dart';
import 'package:cordelia/templates/grofast/widgets/grofast_primary_button.dart';
import 'package:cordelia/templates/grofast/widgets/grofast_product_grid.dart';
import 'package:cordelia/templates/grofast/widgets/grofast_screen_body.dart';
import 'package:cordelia/templates/grofast/widgets/grofast_sheet.dart';
import 'package:cordelia/templates/grofast/widgets/grofast_state_views.dart';

import '../../../bloc/address_bloc.dart';
import '../widgets/grofast_address_tile.dart';

/// `grofast` template's address **management** page — Profile's My Address
/// row is its only way in. Mid-flow *picking* (Bag → checkout, Checkout's
/// change address) is the kit's Select Location sheet instead
/// (`showGrofastAddressPicker`); both render the same `Item/Location` cards
/// ([GrofastAddressTile]), this page adding the edit/delete actions the
/// feature has but the kit's frame doesn't draw.
///
/// Selecting **is** still committing here too: the tap persists the choice
/// and pops with the address, so the list needs no confirm button.
class AddressScreen extends BaseScreen {
  const AddressScreen({super.key});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends BaseScreenState<AddressScreen> {
  /// Records the picked address's label so Home's header can show it, then
  /// pops with the entity for callers that need the whole thing (Cart's
  /// checkout hand-off).
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
    // Bag's checkout flow) can proceed; callers that just set the current
    // address (Profile) ignore the return value.
    context.pop(address);
  }

  Future<void> _openForm({AddressEntity? address}) async {
    final saved = await context.push<AddressEntity>(
      AppRoutes.addressForm,
      extra: address,
    );
    if (saved == null || !mounted) return;
    context.read<AddressBloc>().add(AddressEvent.saved(address: saved));
  }

  /// Gates the swipe behind the pack's confirm sheet, then always answers
  /// `false`: the delete is a server round-trip the bloc awaits, so the row
  /// leaves when the new list lands and survives a failed delete — answering
  /// `true` would drop it optimistically, and re-emitting the same list
  /// rebuilds a `Dismissible` the framework believes it already dismissed,
  /// which throws (same shape as dailymart's address card).
  Future<bool> _confirmDelete(AddressEntity address) async {
    await showGrofastConfirmSheet(
      context: context,
      title: GrofastValueConst.deleteAddressTitle,
      message: GrofastValueConst.deleteAddressMessage,
      confirmLabel: GrofastValueConst.deleteLabel,
      onConfirm: () => context.read<AddressBloc>().add(
        AddressEvent.deleted(addressId: address.id),
      ),
    );
    return false;
  }

  @override
  SystemUiOverlayStyle? overlayStyle(BuildContext context) =>
      BaseScreenState.themedStatusIcons(context);

  @override
  Widget body(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: BlocConsumer<AddressBloc, AddressState>(
        listener: (context, state) {
          if (state case AddressLoaded(saveFailed: true)) {
            showSnackBar(GrofastValueConst.addressSaveFailedMessage);
          }
          if (state case AddressLoaded(deleteFailed: true)) {
            showSnackBar(GrofastValueConst.addressDeleteFailedMessage);
          }
        },
        builder: (context, state) => GrofastScreenBody(
          title: GrofastValueConst.selectAddressTitle,
          onBack: () => context.pop(),
          gap: AppSpacing.xl4,
          floatingAction: GrofastPrimaryButton(
            label: GrofastValueConst.addNewAddressLabel,
            onTap: _openForm,
          ),
          body: GrofastSwitcher(
            child: switch (state) {
              AddressLoading() => Column(
                children: [
                  for (var i = 0; i < 3; i++) ...[
                    if (i > 0) const SizedBox(height: AppSpacing.base),
                    const GrofastCardSkeleton(
                      height: GrofastDimenConst.addressTileHeight,
                      radius: GrofastDimenConst.tileRadius,
                    ),
                  ],
                ],
              ),
              AddressError(:final message) => GrofastErrorView(
                message: message,
                onRetry: () => context.read<AddressBloc>().add(
                  const AddressEvent.started(),
                ),
              ),
              AddressLoaded(addresses: []) => GrofastEmptyState(
                icon: Icons.location_on_outlined,
                title: GrofastValueConst.addressEmptyTitle,
                subtitle: GrofastValueConst.addressEmptySubtitle,
                actionLabel: GrofastValueConst.addNewAddressLabel,
                onAction: _openForm,
              ),
              AddressLoaded(:final addresses, :final selectedAddressId) =>
                Column(
                  children: [
                    for (final (index, address) in addresses.indexed) ...[
                      _DismissibleAddressTile(
                        address: address,
                        index: index,
                        isSelected: address.id == selectedAddressId,
                        onTap: () => _select(address),
                        onEdit: () => _openForm(address: address),
                        confirmDismiss: () => _confirmDelete(address),
                      ),
                      const SizedBox(height: AppSpacing.base),
                    ],
                  ],
                ),
            },
          ),
        ),
      ),
    );
  }
}

/// The page's swipeable row: core's [SwipeToDeleteRow] under a **static**
/// selection ring. The ring is painted as a non-hit-testing overlay rather
/// than by the tile itself, so the swipe slides the card's *contents* out
/// from inside it — the selected outline stays put instead of riding off the
/// screen with the row.
class _DismissibleAddressTile extends StatelessWidget {
  final AddressEntity address;
  final int index;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final Future<bool> Function() confirmDismiss;

  const _DismissibleAddressTile({
    required this.address,
    required this.index,
    required this.isSelected,
    required this.onTap,
    required this.onEdit,
    required this.confirmDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final radius = BorderRadius.circular(GrofastDimenConst.tileRadius);

    return Stack(
      children: [
        SwipeToDeleteRow(
          itemKey: address.id,
          confirmDismiss: confirmDismiss,
          borderRadius: radius,
          icon: AppSvgImage.asset(
            GrofastImageConst.delete,
            width: AppSpacing.xl,
            height: AppSpacing.xl,
            color: cs.error,
          ),
          // The overlay owns the ring, so the tile renders unselected.
          child: GrofastAddressTile(
            address: address,
            index: index,
            isSelected: false,
            onTap: onTap,
            trailing: GrofastAddressTileAction(
              asset: GrofastImageConst.edit,
              tooltip: GrofastValueConst.editAddressTooltip,
              color: cs.onSurfaceVariant,
              onTap: onEdit,
            ),
          ),
        ),
        if (isSelected)
          Positioned.fill(
            child: IgnorePointer(
              child: DecoratedBox(
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    borderRadius: radius,
                    side: const BorderSide(
                      color: GrofastColorConst.gradientStart,
                      width: GrofastDimenConst.selectedCardBorderWidth,
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
