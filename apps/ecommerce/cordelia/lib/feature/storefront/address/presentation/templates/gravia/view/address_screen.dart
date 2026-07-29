import 'package:cordelia/constants/app_routes.dart';
import 'package:cordelia/templates/gravia/constants/gravia_dimen_const.dart';
import 'package:cordelia/templates/gravia/constants/gravia_image_const.dart';
import 'package:cordelia/templates/gravia/constants/gravia_text_style_const.dart';
import 'package:cordelia/templates/gravia/constants/gravia_value_const.dart';
import 'package:cordelia/templates/gravia/widgets/gravia_sheet.dart';
import 'package:cordelia/templates/gravia/widgets/gravia_hero_header.dart';
import 'package:cordelia/templates/gravia/widgets/gravia_primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:core/core/ui/atoms/app_switcher.dart';
import 'package:core/core/base/base_screen.dart';
import 'package:core/core/services/shared_pref_service/shared_preference_service.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/button.dart';
import 'package:core/core/ui/atoms/svg_image.dart';
import 'package:core/core/ui/blocks/collapsing_header_sheet.dart';
import 'package:core/core/ui/blocks/section_header.dart';
import 'package:core/core/ui/molecules/empty_state.dart';
import 'package:core/core/ui/molecules/error_view.dart';
import 'package:core/core/ui/blocks/docked_bar.dart';

import '../../../../domain/entities/address_entity.dart';
import '../../../bloc/address_bloc.dart';
import '../widgets/address_card.dart';
import '../widgets/address_skeleton_body.dart';
import 'address_page.dart';

class AddressScreen extends BaseScreen {
  const AddressScreen({super.key});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends BaseScreenState<AddressScreen> {
  Future<void> _confirmSelection(
    List<AddressEntity> addresses,
    String selectedAddressId,
  ) async {
    final selected = addresses.firstWhere((a) => a.id == selectedAddressId);
    await SharedPreferenceService.instance.setString(
      kSelectedAddressIdPrefKey,
      selected.id,
    );
    await SharedPreferenceService.instance.setString(
      kSelectedAddressLabelPrefKey,
      selected.displayLine,
    );
    if (!mounted) return;
    // Pop with the confirmed address so a caller gating an action on it (the
    // Cart's checkout flow) can proceed with it; callers that just open this
    // to set the current address (Home, Profile) ignore the return value.
    context.pop(selected);
  }

  /// Pushes the Add/Edit Address form — [address] null opens it in Add mode,
  /// non-null in Edit mode prefilled from it — then, if the form returned a
  /// result (Cancel/back pops with none), dispatches it into this screen's
  /// own `AddressBloc` so the list updates without a re-fetch.
  Future<void> _openAddressForm(AddressEntity? address) async {
    final result = await context.push<AddressEntity>(
      AppRoutes.addressForm,
      extra: address,
    );
    if (result == null || !mounted) return;
    context.read<AddressBloc>().add(AddressEvent.saved(address: result));
  }

  void _confirmDelete(AddressEntity address) => showGraviaDeleteAddressSheet(
    onConfirm: () => context.read<AddressBloc>().add(
      AddressEvent.deleted(addressId: address.id),
    ),
  );

  @override
  SystemUiOverlayStyle? overlayStyle(BuildContext context) =>
      BaseScreenState.lightStatusIcons;

  @override
  Widget body(BuildContext context) {
    return BlocConsumer<AddressBloc, AddressState>(
      listener: (context, state) {
        if (state case AddressError(:final message)) showSnackBar(message);
        if (state case AddressLoaded(saveFailed: true)) {
          showSnackBar(GraviaValueConst.addressSaveFailedMessage);
        }
        if (state case AddressLoaded(deleteFailed: true)) {
          showSnackBar(GraviaValueConst.addressDeleteFailedMessage);
        }
      },
      builder: (context, state) => AppSwitcher(
        child: switch (state) {
          AddressLoading() => CollapsingHeaderSheet(
            key: const ValueKey('loading'),
            initialHeaderHeight: GraviaDimenConst.headerHeightCompact,
            header: GraviaHeroHeader(
              title: GraviaValueConst.selectAddressTitle,
              onBack: () => context.pop(),
            ),
            body: const AddressSkeletonBody(),
          ),
          AddressError() => SafeArea(
            key: const ValueKey('error'),
            child: ErrorView(
              message: GraviaValueConst.addressLoadErrorMessage,
              onRetry: () => context.read<AddressBloc>().add(
                const AddressEvent.started(),
              ),
            ),
          ),
          AddressLoaded(:final addresses, :final selectedAddressId) =>
            KeyedSubtree(
              key: const ValueKey('loaded'),
              child: _buildLoaded(context, addresses, selectedAddressId),
            ),
        },
      ),
    );
  }

  Widget _addNewAddressButton(ColorScheme cs, TextTheme tt) => AppButton(
    label: GraviaValueConst.addNewAddressLabel,
    variant: AppButtonVariant.secondary,
    fullWidth: true,
    borderColor: cs.primary,
    height: GraviaDimenConst.controlHeight,
    labelStyle: GraviaTextStyleConst.textSmMedium(tt).copyWith(color: cs.primary),
    leadingIcon: AppSvgImage.asset(
      GraviaImageConst.plus,
      color: cs.primary,
      width: 24,
      height: 24,
    ),
    onTap: () => _openAddressForm(null),
  );

  Widget _buildLoaded(
    BuildContext context,
    List<AddressEntity> addresses,
    String selectedAddressId,
  ) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    // A brand-new shopper has zero addresses — still needs the header (to
    // go back) and the Add button (there's no other way to create one), but
    // no docked select bar, since there's nothing to select yet.
    if (addresses.isEmpty) {
      return CollapsingHeaderSheet(
        initialHeaderHeight: GraviaDimenConst.headerHeightCompact,
        header: GraviaHeroHeader(
          title: GraviaValueConst.selectAddressTitle,
          onBack: () => context.pop(),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.xl2,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _addNewAddressButton(cs, tt),
              EmptyState(
                iconData: Icons.location_on_outlined,
                title: GraviaValueConst.addressEmptyTitle,
                subtitle: GraviaValueConst.addressEmptySubtitle,
              ),
            ],
          ),
        ),
      );
    }

    final defaultAddress = addresses.firstWhere(
      (a) => a.isDefault,
      orElse: () => addresses.first,
    );
    final otherAddresses = addresses
        .where((a) => a.id != defaultAddress.id)
        .toList();

    void selectAddress(String id) =>
        context.read<AddressBloc>().add(AddressEvent.selected(addressId: id));

    return Column(
      children: [
        Expanded(
          child: CollapsingHeaderSheet(
            initialHeaderHeight: GraviaDimenConst.headerHeightCompact,
            header: GraviaHeroHeader(
              title: GraviaValueConst.selectAddressTitle,
              onBack: () => context.pop(),
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.xl2,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _addNewAddressButton(cs, tt),
                  const SizedBox(height: AppSpacing.xl4),
                  SectionHeader(
                    title: GraviaValueConst.defaultAddressSectionTitle,
                    titleStyle: GraviaTextStyleConst.textLgBold(tt),
                  ),
                  const SizedBox(height: AppSpacing.base),
                  AddressCard(
                    address: defaultAddress,
                    selected: defaultAddress.id == selectedAddressId,
                    onSelect: () => selectAddress(defaultAddress.id),
                    onEdit: () => _openAddressForm(defaultAddress),
                    onDelete: () => _confirmDelete(defaultAddress),
                  ),
                  if (otherAddresses.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.xl4),
                    SectionHeader(
                      title: GraviaValueConst.otherAddressSectionTitle,
                      titleStyle: GraviaTextStyleConst.textLgBold(tt),
                    ),
                    const SizedBox(height: AppSpacing.base),
                    for (var i = 0; i < otherAddresses.length; i++) ...[
                      if (i > 0) const SizedBox(height: AppSpacing.xl2),
                      AddressCard(
                        address: otherAddresses[i],
                        selected: otherAddresses[i].id == selectedAddressId,
                        onSelect: () => selectAddress(otherAddresses[i].id),
                        onEdit: () => _openAddressForm(otherAddresses[i]),
                        onDelete: () => _confirmDelete(otherAddresses[i]),
                      ),
                    ],
                  ],
                ],
              ),
            ),
          ),
        ),
        DockedBar(
          child: GraviaPrimaryButton(
            label: GraviaValueConst.selectAddressTitle,
            onTap: () => _confirmSelection(addresses, selectedAddressId),
          ),
        ),
      ],
    );
  }
}
