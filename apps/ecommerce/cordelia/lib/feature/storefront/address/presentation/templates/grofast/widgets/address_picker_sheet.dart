import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:core/core/base/base_screen.dart';
import 'package:core/core/services/shared_pref_service/shared_preference_service.dart';
import 'package:core/core/theme/app_spacing.dart';

import 'package:cordelia/constants/app_routes.dart';
import 'package:cordelia/di/injection_container.dart';
import 'package:cordelia/templates/grofast/constants/grofast_dimen_const.dart';
import 'package:cordelia/templates/grofast/constants/grofast_value_const.dart';
import 'package:cordelia/templates/grofast/widgets/grofast_product_grid.dart';
import 'package:cordelia/templates/grofast/widgets/grofast_sheet.dart';
import 'package:cordelia/templates/grofast/widgets/grofast_state_views.dart';

import '../../../../domain/entities/address_entity.dart';
import '../../../address_pref_keys.dart';
import '../../../bloc/address_bloc.dart';

import 'grofast_address_tile.dart';

/// The kit's Select Location **sheet** (frame `129:1458`) — how this pack
/// picks a delivery address mid-flow (Bag → checkout, Checkout's change
/// address): the domed sheet rises over the screen with the saved addresses
/// as `Item/Location` cards, and tapping one *is* the commit. The routed
/// Select Address page stays, but it is Profile's — address management, not
/// mid-flow picking.
///
/// Owns its own [AddressBloc] and dispatches `started` on open: warm cache →
/// the cards render immediately; cold → the tile-shaped shimmer runs while
/// the fetch is out. Resolves with the picked address, or null when the
/// shopper swipes the sheet away.
Future<AddressEntity?> showGrofastAddressPicker(
  BaseScreenState<BaseScreen> screen,
) {
  return screen.showGrofastSheet<AddressEntity>(
    child: BlocProvider(
      create: (_) => AddressBloc(
        getAddressesUseCase: sl(),
        createAddressUseCase: sl(),
        updateAddressUseCase: sl(),
        deleteAddressUseCase: sl(),
      )..add(const AddressEvent.started()),
      child: const _PickerBody(),
    ),
  );
}

class _PickerBody extends StatelessWidget {
  const _PickerBody();

  /// Same commit as the Select Address page: persist the choice for Home's
  /// header, reflect it, then pop the *sheet* with the entity.
  Future<void> _select(BuildContext context, AddressEntity address) async {
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
    if (!context.mounted) return;
    context.pop(address);
  }

  /// The empty state's way out — the form pushes *over* the open sheet, and
  /// a saved address lands back in this sheet's bloc.
  Future<void> _addNew(BuildContext context) async {
    final bloc = context.read<AddressBloc>();
    final saved = await context.push<AddressEntity>(AppRoutes.addressForm);
    if (saved == null) return;
    bloc.add(AddressEvent.saved(address: saved));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddressBloc, AddressState>(
      builder: (context, state) => GrofastSwitcher(
        child: switch (state) {
          AddressLoading() => Column(
            children: [
              for (var i = 0; i < 2; i++) ...[
                if (i > 0) const SizedBox(height: AppSpacing.lg),
                const GrofastCardSkeleton(
                  height: GrofastDimenConst.addressTileHeight,
                  radius: GrofastDimenConst.tileRadius,
                ),
              ],
            ],
          ),
          AddressError(:final message) => GrofastErrorView(
            message: message,
            onRetry: () =>
                context.read<AddressBloc>().add(const AddressEvent.started()),
          ),
          AddressLoaded(addresses: []) => GrofastEmptyState(
            icon: Icons.location_on_outlined,
            title: GrofastValueConst.addressEmptyTitle,
            subtitle: GrofastValueConst.addressEmptySubtitle,
            actionLabel: GrofastValueConst.addNewAddressLabel,
            onAction: () => _addNew(context),
          ),
          AddressLoaded(:final addresses, :final selectedAddressId) => Column(
            children: [
              for (final (index, address) in addresses.indexed) ...[
                if (index > 0) const SizedBox(height: AppSpacing.lg),
                GrofastAddressTile(
                  address: address,
                  index: index,
                  isSelected: address.id == selectedAddressId,
                  onTap: () => _select(context, address),
                ),
              ],
            ],
          ),
        },
      ),
    );
  }
}
