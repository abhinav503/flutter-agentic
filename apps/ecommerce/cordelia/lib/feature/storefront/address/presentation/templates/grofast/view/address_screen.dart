import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:core/core/base/base_screen.dart';
import 'package:core/core/services/shared_pref_service/shared_preference_service.dart';
import 'package:core/core/theme/app_shapes_extension.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/molecules/skeleton_rows.dart';

import 'package:cordelia/constants/app_routes.dart';
import 'package:cordelia/feature/storefront/address/domain/entities/address_entity.dart';
import 'package:cordelia/feature/storefront/address/presentation/address_pref_keys.dart';
import 'package:cordelia/templates/grofast/constants/grofast_text_style_const.dart';
import 'package:cordelia/templates/grofast/constants/grofast_value_const.dart';
import 'package:cordelia/templates/grofast/widgets/grofast_primary_button.dart';
import 'package:cordelia/templates/grofast/widgets/grofast_screen_body.dart';
import 'package:cordelia/templates/grofast/widgets/grofast_sheet.dart';
import 'package:cordelia/templates/grofast/widgets/grofast_state_views.dart';

import '../../../bloc/address_bloc.dart';

/// `grofast` template's Select Address (kit frame `129:1458`) — the saved
/// locations as outlined cards, the selected one carrying the pack's primary
/// border, with Add New Address floating over the bottom fade.
///
/// Selecting **is** committing: the screen pops with the chosen address, so
/// the kit's card list needs no confirm button. Each row also carries the two
/// affordances the kit's frame doesn't draw but the feature has: edit (a
/// pencil) and delete (behind the pack's confirm sheet).
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
    if (!context.mounted) return;
    context.read<AddressBloc>().add(AddressEvent.saved(address: saved));
  }

  void _confirmDelete(AddressEntity address) => showGrofastConfirmSheet(
    context: context,
    title: GrofastValueConst.deleteAddressTitle,
    message: GrofastValueConst.deleteAddressMessage,
    confirmLabel: GrofastValueConst.deleteLabel,
    onConfirm: () => context.read<AddressBloc>().add(
      AddressEvent.deleted(addressId: address.id),
    ),
  );

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
              AddressLoading() => const ShimmerListRow(itemCount: 3),
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
                    for (final address in addresses) ...[
                      _AddressCard(
                        address: address,
                        isSelected: address.id == selectedAddressId,
                        onTap: () => _select(address),
                        onEdit: () => _openForm(address: address),
                        onDelete: () => _confirmDelete(address),
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

class _AddressCard extends StatelessWidget {
  final AddressEntity address;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _AddressCard({
    required this.address,
    required this.isSelected,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final radius = BorderRadius.circular(context.appShapes.cardRadius);

    return Material(
      color: cs.surfaceContainerLow,
      shape: RoundedRectangleBorder(
        borderRadius: radius,
        side: BorderSide(color: isSelected ? cs.primary : Colors.transparent),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl2),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.location_on_rounded,
                size: AppSpacing.xl4,
                color: isSelected ? cs.primary : cs.onSurfaceVariant,
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      address.tag.isEmpty ? address.name : address.tag,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GrofastTextStyleConst.rowTitleBold(tt),
                    ),
                    const SizedBox(height: AppSpacing.xs3),
                    Text(
                      address.displayLine,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GrofastTextStyleConst.bodySmall(
                        tt,
                      ).copyWith(color: cs.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
              _RowAction(
                icon: Icons.edit_rounded,
                tooltip: GrofastValueConst.editAddressTooltip,
                color: cs.onSurfaceVariant,
                onTap: onEdit,
              ),
              _RowAction(
                icon: Icons.delete_outline_rounded,
                tooltip: GrofastValueConst.deleteLabel,
                color: cs.error,
                onTap: onDelete,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RowAction extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final Color color;
  final VoidCallback onTap;

  const _RowAction({
    required this.icon,
    required this.tooltip,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    label: tooltip,
    child: GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.only(left: AppSpacing.base),
        child: Icon(icon, size: AppSpacing.xl2, color: color),
      ),
    ),
  );
}
