import 'package:cordelia/templates/gravia/constants/gravia_dimen_const.dart';
import 'package:cordelia/templates/gravia/constants/gravia_value_const.dart';
import 'package:cordelia/templates/gravia/widgets/gravia_dropdown_field.dart';
import 'package:cordelia/templates/gravia/widgets/gravia_sheet.dart';
import 'package:cordelia/templates/gravia/widgets/radio_options_sheet_content.dart';
import 'package:cordelia/templates/gravia/widgets/gravia_form_field.dart';
import 'package:cordelia/templates/gravia/widgets/gravia_hero_header.dart';
import 'package:cordelia/templates/gravia/widgets/gravia_primary_button.dart';
import 'package:cordelia/templates/gravia/widgets/gravia_tinted_button.dart';
import 'package:core/core/ui/atoms/loading_dots.dart';
import 'package:core/core/ui/blocks/docked_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:core/core/base/base_screen.dart';
import 'package:core/core/mixins/textfield_validations.dart';
import 'package:cordelia/utils/localized_validations.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/blocks/collapsing_header_sheet.dart';

import '../../../../../geo/presentation/bloc/address_lookup_bloc.dart';
import '../../../../../geo/presentation/location_failure_message.dart';
import '../../../../domain/entities/address_entity.dart';
import '../../../address_form_fields.dart';

/// Add/Edit Address form, reached from AddressScreen's "Add New Address"
/// button and each AddressCard's Edit action. [address] decides the mode:
/// null → a new address; non-null → that address, prefilled. Either way the
/// result is popped back to the caller as an [AddressEntity] — AddressScreen
/// dispatches it into the shared AddressBloc via `AddressEvent.saved`, the
/// same "push, await the pop, react" shape as
/// `HomeScreen._openSelectAddress`. All form behaviour lives in
/// [AddressFormFields]; this screen renders only the pack's chrome.
class AddressFormScreen extends BaseScreen {
  final AddressEntity? address;

  const AddressFormScreen({super.key, this.address});

  @override
  State<AddressFormScreen> createState() => _AddressFormScreenState();
}

class _AddressFormScreenState extends BaseScreenState<AddressFormScreen>
    with TextfieldValidations, LocalizedValidations, AddressFormFields {
  @override
  AddressEntity? get address => widget.address;

  @override
  String get requiredFieldErrorMessage =>
      GraviaValueConst.requiredFieldErrorMessage;

  @override
  List<String> get countryOptions => GraviaValueConst.addressFormCountries;

  @override
  void initState() {
    super.initState();
    // Six digits typed into the pincode field trigger the best-effort
    // city/state autofill; anything shorter is just typing.
    postalCodeController.addListener(_onPostalCodeChanged);
  }

  @override
  void dispose() {
    postalCodeController.removeListener(_onPostalCodeChanged);
    super.dispose();
  }

  void _onPostalCodeChanged() {
    final pincode = postalCodeController.text.trim();
    if (RegExp(r'^\d{6}$').hasMatch(pincode)) {
      context.read<AddressLookupBloc>().add(
        AddressLookupEvent.pincodeEntered(pincode: pincode),
      );
    }
  }

  /// Opens a radio-list bottom sheet for a bounded picklist field — same
  /// "chip opens a sheet" shape as Category Details' Sort/Price filters.
  void _showOptionPicker({
    required String title,
    required List<String> options,
    required String selected,
    required ValueChanged<String> onSelected,
  }) {
    showGraviaSheet(
      title: title,
      child: RadioOptionsSheetContent<String>(
        options: options,
        labelOf: (option) => option,
        selected: selected,
        onSelected: onSelected,
      ),
    );
  }

  @override
  SystemUiOverlayStyle? overlayStyle(BuildContext context) =>
      BaseScreenState.lightStatusIcons;

  @override
  Widget body(BuildContext context) {
    return BlocConsumer<AddressLookupBloc, AddressLookupState>(
      listener: (context, state) => switch (state) {
        AddressLookupPrefillReady(:final address) => prefill(address),
        AddressLookupPincodeReady(:final info) => prefillPincode(info),
        AddressLookupError(:final message, :final isLocation, :final reason) =>
          showSnackBar(isLocation ? locationFailureMessage(reason) : message),
        _ => null,
      },
      builder: (context, state) => _form(context, state),
    );
  }

  Widget _form(BuildContext context, AddressLookupState lookupState) {
    return Column(
      children: [
        Expanded(
          child: CollapsingHeaderSheet(
            initialHeaderHeight: GraviaDimenConst.headerHeightCompact,
            header: GraviaHeroHeader(
              title: isEditing
                  ? GraviaValueConst.editAddressTitle
                  : GraviaValueConst.addNewAddressLabel,
              onBack: () => context.pop(),
            ),
            body: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Location helper: GPS prefill. Address type-ahead sat
                  // beside it until the Ola Maps proxy behind it was
                  // removed; every replacement needs a billed API key, and
                  // the device geocoder that took over the reverse lookup
                  // does not search. ──
                  if (lookupState is AddressLookupLocating)
                    const SizedBox(
                      height: GraviaTintedButton.height,
                      child: Center(child: LoadingDots()),
                    )
                  else
                    GraviaTintedButton(
                      label: GraviaValueConst.useMyLocationLabel,
                      leadingIcon: Icon(
                        Icons.my_location,
                        size: AppSpacing.lg,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      onTap: () => context.read<AddressLookupBloc>().add(
                        const AddressLookupEvent.locationRequested(),
                      ),
                    ),
                  const SizedBox(height: AppSpacing.lg),
                  _field(
                    GraviaValueConst.nameLabel,
                    nameController,
                    field: AddressField.name,
                    keyboardType: TextInputType.name,
                    hint: GraviaValueConst.nameHint,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _field(
                    GraviaValueConst.phoneNumberLabel,
                    phoneController,
                    field: AddressField.phone,
                    keyboardType: TextInputType.phone,
                    hint: GraviaValueConst.phoneNumberHint,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _field(
                    GraviaValueConst.addressLine1Label,
                    addressLine1Controller,
                    field: AddressField.addressLine1,
                    hint: GraviaValueConst.addressLine1Hint,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _field(
                    GraviaValueConst.addressLine2Label,
                    addressLine2Controller,
                    hint: GraviaValueConst.addressLine2Hint,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _field(
                    GraviaValueConst.landmarkLabel,
                    landmarkController,
                    hint: GraviaValueConst.landmarkHint,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _field(
                    GraviaValueConst.cityLabel,
                    cityController,
                    field: AddressField.city,
                    hint: GraviaValueConst.cityHint,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _field(
                    GraviaValueConst.stateLabel,
                    stateController,
                    hint: GraviaValueConst.stateHint,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  GraviaDropdownField(
                    label: GraviaValueConst.countryLabel,
                    value: country,
                    onTap: () => _showOptionPicker(
                      title: GraviaValueConst.selectCountryTitle,
                      options: countryOptions,
                      selected: country,
                      onSelected: selectCountry,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _field(
                    GraviaValueConst.postalCodeLabel,
                    postalCodeController,
                    field: AddressField.postalCode,
                    keyboardType: TextInputType.number,
                    hint: GraviaValueConst.postalCodeHint,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _field(
                    GraviaValueConst.addressTagLabel,
                    tagController,
                    field: AddressField.tag,
                    hint: GraviaValueConst.addressTagHint,
                  ),
                ],
              ),
            ),
          ),
        ),
        DockedBar(
          child: GraviaPrimaryButton(
            label: isEditing
                ? GraviaValueConst.updateAddressButtonLabel
                : GraviaValueConst.addAddressButtonLabel,
            onTap: submitAddress,
          ),
        ),
      ],
    );
  }

  Widget _field(
    String label,
    TextEditingController controller, {
    AddressField? field,
    TextInputType keyboardType = TextInputType.text,
    String? hint,
  }) {
    final error = field == null ? null : fieldErrors[field];
    return GraviaFormField(
      label: label,
      controller: controller,
      hint: hint,
      keyboardType: keyboardType,
      errorText: error,
      onChanged: field == null ? null : (_) => clearFieldError(field),
    );
  }
}
