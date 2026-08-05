import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import 'package:core/core/base/base_screen.dart';
import 'package:core/core/mixins/textfield_validations.dart';
import 'package:cordelia/utils/localized_validations.dart';
import 'package:core/core/theme/app_spacing.dart';

import 'package:cordelia/templates/dailymart/constants/dailymart_value_const.dart';
import 'package:cordelia/templates/dailymart/widgets/dailymart_dropdown_field.dart';
import 'package:cordelia/templates/dailymart/widgets/dailymart_form_field.dart';
import 'package:cordelia/templates/dailymart/widgets/dailymart_primary_button.dart';
import 'package:cordelia/templates/dailymart/widgets/dailymart_screen_body.dart';
import 'package:cordelia/templates/dailymart/widgets/dailymart_radio_sheet_content.dart';
import 'package:cordelia/templates/dailymart/widgets/dailymart_sheet.dart';

import '../../../../domain/entities/address_entity.dart';
import '../../../address_form_fields.dart';

/// `dailymart` template's Add/Edit Address form, reached from
/// `AddressScreen`'s floating "Add New Address" CTA and each address card's
/// pencil. [address] decides the mode: null → a new address; non-null → that
/// address, prefilled. All form behaviour lives in [AddressFormFields]; this
/// screen renders only the pack's chrome.
///
/// The kit ships no frame for this screen, so it's composed from the pack's
/// existing form recipe rather than invented: the same
/// header-row → fields → floating-CTA-over-a-fade skeleton as Edit Profile
/// and Change Password (spec sheet §8/§13), with [DailyMartDropdownField]
/// standing in for the two picklists.
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
      DailyMartValueConst.requiredFieldErrorMessage;

  @override
  List<String> get countryOptions => DailyMartValueConst.addressFormCountries;

  /// Opens the pack's radio-list sheet for a bounded picklist — the same
  /// "field opens a sheet" shape Search's Sort control uses.
  void _showOptionPicker({
    required String title,
    required List<String> options,
    required String selected,
    required ValueChanged<String> onSelected,
  }) => showDailyMartSheet<void>(
    title: title,
    child: DailyMartRadioSheetContent<String>(
      options: options,
      labelOf: (option) => option,
      selected: selected,
      onSelected: onSelected,
    ),
  );

  @override
  SystemUiOverlayStyle? overlayStyle(BuildContext context) =>
      BaseScreenState.themedStatusIcons(context);

  @override
  Widget body(BuildContext context) {
    return ColoredBox(
      color: Theme.of(context).colorScheme.surface,
      child: SafeArea(
        bottom: false,
        child: DailyMartScreenBody(
          title: isEditing
              ? DailyMartValueConst.editAddressTitle
              : DailyMartValueConst.addAddressTitle,
          onBack: () => context.pop(),
          gap: AppSpacing.xl2,
          floatingAction: DailyMartPrimaryButton(
            label: isEditing
                ? DailyMartValueConst.updateAddressButtonLabel
                : DailyMartValueConst.addAddressButtonLabel,
            onTap: submitAddress,
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _field(
                DailyMartValueConst.addressNameLabel,
                nameController,
                field: AddressField.name,
                keyboardType: TextInputType.name,
                hint: DailyMartValueConst.addressNameHint,
              ),
              const SizedBox(height: AppSpacing.md),
              _field(
                DailyMartValueConst.phoneNumberLabel,
                phoneController,
                field: AddressField.phone,
                keyboardType: TextInputType.phone,
                hint: DailyMartValueConst.phoneNumberHint,
              ),
              const SizedBox(height: AppSpacing.md),
              _field(
                DailyMartValueConst.addressLine1Label,
                addressLine1Controller,
                field: AddressField.addressLine1,
                hint: DailyMartValueConst.addressLine1Hint,
              ),
              const SizedBox(height: AppSpacing.md),
              _field(
                DailyMartValueConst.addressLine2Label,
                addressLine2Controller,
                hint: DailyMartValueConst.addressLine2Hint,
              ),
              const SizedBox(height: AppSpacing.md),
              _field(
                DailyMartValueConst.landmarkLabel,
                landmarkController,
                hint: DailyMartValueConst.landmarkHint,
              ),
              const SizedBox(height: AppSpacing.md),
              _field(
                DailyMartValueConst.cityLabel,
                cityController,
                field: AddressField.city,
                hint: DailyMartValueConst.cityHint,
              ),
              const SizedBox(height: AppSpacing.md),
              _field(
                DailyMartValueConst.stateLabel,
                stateController,
                hint: DailyMartValueConst.stateHint,
              ),
              const SizedBox(height: AppSpacing.md),
              DailyMartDropdownField(
                label: DailyMartValueConst.countryLabel,
                value: country,
                onTap: () => _showOptionPicker(
                  title: DailyMartValueConst.selectCountryTitle,
                  options: countryOptions,
                  selected: country,
                  onSelected: selectCountry,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              _field(
                DailyMartValueConst.postalCodeLabel,
                postalCodeController,
                field: AddressField.postalCode,
                keyboardType: TextInputType.number,
                hint: DailyMartValueConst.postalCodeHint,
              ),
              const SizedBox(height: AppSpacing.md),
              _field(
                DailyMartValueConst.addressTagLabel,
                tagController,
                field: AddressField.tag,
                hint: DailyMartValueConst.addressTagHint,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _field(
    String label,
    TextEditingController controller, {
    AddressField? field,
    TextInputType keyboardType = TextInputType.text,
    String? hint,
  }) => DailyMartFormField(
    label: label,
    controller: controller,
    hint: hint,
    keyboardType: keyboardType,
    errorText: field == null ? null : fieldErrors[field],
    onChanged: field == null ? null : (_) => clearFieldError(field),
  );
}
