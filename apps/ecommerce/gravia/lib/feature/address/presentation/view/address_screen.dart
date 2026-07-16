import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:core/core/base/base_screen.dart';
import 'package:core/core/services/shared_pref_service/shared_preference_service.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/button.dart';
import 'package:core/core/ui/atoms/loading_indicator.dart';
import 'package:core/core/ui/atoms/svg_image.dart';
import 'package:core/core/ui/blocks/collapsing_header_sheet.dart';
import 'package:core/core/ui/blocks/section_header.dart';
import 'package:core/core/ui/molecules/error_view.dart';

import 'package:gravia/constants/app_routes.dart';
import 'package:gravia/constants/image_const.dart';
import 'package:gravia/constants/text_style_const.dart';
import 'package:gravia/constants/value_const.dart';
import 'package:gravia/widgets/gravia_docked_bar.dart';
import 'package:gravia/widgets/gravia_hero_header.dart';
import 'package:gravia/widgets/gravia_primary_button.dart';

import '../../domain/entities/address_entity.dart';
import '../bloc/address_bloc.dart';
import '../widgets/address_card.dart';
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
    context.pop();
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

  @override
  Widget body(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: BlocConsumer<AddressBloc, AddressState>(
        listener: (context, state) {
          if (state case AddressError(:final message)) showSnackBar(message);
        },
        builder: (context, state) => switch (state) {
          AddressLoading() => Container(
            color: cs.primary,
            child: const SafeArea(child: Center(child: LoadingIndicator())),
          ),
          AddressError() => SafeArea(
            child: ErrorView(
              message: ValueConst.addressLoadErrorMessage,
              onRetry: () =>
                  context.read<AddressBloc>().add(const AddressEvent.started()),
            ),
          ),
          AddressLoaded(:final addresses, :final selectedAddressId) =>
            _buildLoaded(context, addresses, selectedAddressId),
        },
      ),
    );
  }

  Widget _buildLoaded(
    BuildContext context,
    List<AddressEntity> addresses,
    String selectedAddressId,
  ) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    if (addresses.isEmpty) {
      return const SafeArea(
        child: Center(child: Text(ValueConst.addressLoadErrorMessage)),
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

    void showComingSoon() => showSnackBar(ValueConst.comingSoonMessage);

    return Column(
      children: [
        Expanded(
          child: CollapsingHeaderSheet(
            initialHeaderHeight: 110,
            header: GraviaHeroHeader(
              title: ValueConst.selectAddressTitle,
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
                  AppButton(
                    label: ValueConst.addNewAddressLabel,
                    variant: AppButtonVariant.secondary,
                    fullWidth: true,
                    borderColor: cs.primary,
                    height: 45,
                    labelStyle: TextStyleConst.textSmMedium(
                      tt,
                    ).copyWith(color: cs.primary),
                    leadingIcon: AppSvgImage.asset(
                      ImageConst.plus,
                      color: cs.primary,
                      width: 24,
                      height: 24,
                    ),
                    onTap: () => _openAddressForm(null),
                  ),
                  const SizedBox(height: AppSpacing.xl4),
                  SectionHeader(
                    title: ValueConst.defaultAddressSectionTitle,
                    titleStyle: TextStyleConst.textLgBold(tt),
                  ),
                  const SizedBox(height: AppSpacing.base),
                  AddressCard(
                    address: defaultAddress,
                    selected: defaultAddress.id == selectedAddressId,
                    onSelect: () => selectAddress(defaultAddress.id),
                    onEdit: () => _openAddressForm(defaultAddress),
                    onDelete: showComingSoon,
                  ),
                  if (otherAddresses.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.xl4),
                    SectionHeader(
                      title: ValueConst.otherAddressSectionTitle,
                      titleStyle: TextStyleConst.textLgBold(tt),
                    ),
                    const SizedBox(height: AppSpacing.base),
                    for (var i = 0; i < otherAddresses.length; i++) ...[
                      if (i > 0) const SizedBox(height: AppSpacing.xl2),
                      AddressCard(
                        address: otherAddresses[i],
                        selected: otherAddresses[i].id == selectedAddressId,
                        onSelect: () => selectAddress(otherAddresses[i].id),
                        onEdit: () => _openAddressForm(otherAddresses[i]),
                        onDelete: showComingSoon,
                      ),
                    ],
                  ],
                ],
              ),
            ),
          ),
        ),
        GraviaDockedBar(
          child: GraviaPrimaryButton(
            label: ValueConst.selectAddressTitle,
            onTap: () => _confirmSelection(addresses, selectedAddressId),
          ),
        ),
      ],
    );
  }
}
