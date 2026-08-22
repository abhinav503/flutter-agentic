import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import 'package:core/core/base/base_page.dart';
import 'package:core/core/base/base_screen.dart';
import 'package:core/core/mixins/textfield_validations.dart';
import 'package:cordelia/utils/localized_validations.dart';
import 'package:core/core/theme/app_spacing.dart';

import 'package:cordelia/feature/storefront/address/domain/entities/address_entity.dart';
import 'package:cordelia/feature/storefront/address/presentation/address_form_fields.dart';
import 'package:cordelia/templates/grofast/constants/grofast_value_const.dart';
import 'package:cordelia/templates/grofast/widgets/grofast_form_field.dart';
import 'package:cordelia/templates/grofast/widgets/grofast_options_sheet_content.dart';
import 'package:cordelia/templates/grofast/widgets/grofast_primary_button.dart';
import 'package:cordelia/templates/grofast/widgets/grofast_screen_body.dart';
import 'package:cordelia/templates/grofast/widgets/grofast_sheet.dart';

/// `grofast` template's Add/Edit Address form. All form behaviour lives in
/// [AddressFormFields]; this page renders only the pack's chrome.
///
/// No bloc of its own — it pops with the composed entity and Select Address's
/// [AddressBloc] does the saving, so the two can't both own the write.
///
/// The kit ships no address form (its `129:1458` frame is the picker alone),
/// so the layout is the pack's Edit Profile recipe: stacked labelled fields
/// with the City/Country pair as sheet-opening picklists, and the CTA
/// floating over the bottom fade (spec sheet §11).
class AddressFormPage extends BasePage {
  final AddressEntity? address;

  const AddressFormPage({super.key, this.address});

  @override
  State<AddressFormPage> createState() => _AddressFormPageState();
}

class _AddressFormPageState extends BasePageState<AddressFormPage>
    with ChromelessPage {
  @override
  Widget buildBody(BuildContext context) =>
      _AddressFormScreen(address: widget.address);
}

class _AddressFormScreen extends BaseScreen {
  final AddressEntity? address;

  const _AddressFormScreen({this.address});

  @override
  State<_AddressFormScreen> createState() => _AddressFormScreenState();
}

class _AddressFormScreenState extends BaseScreenState<_AddressFormScreen>
    with TextfieldValidations, LocalizedValidations, AddressFormFields {
  @override
  AddressEntity? get address => widget.address;

  @override
  String get requiredFieldErrorMessage =>
      GrofastValueConst.requiredFieldErrorMessage;

  @override
  List<String> get countryOptions => GrofastValueConst.addressFormCountries;

  Future<void> _pickCountry() => showGrofastSheet<void>(
    title: GrofastValueConst.selectCountryTitle,
    child: GrofastOptionsSheetContent<String>(
      options: countryOptions,
      selected: country,
      labelOf: (value) => value,
      onSelected: selectCountry,
    ),
  );

  @override
  SystemUiOverlayStyle? overlayStyle(BuildContext context) =>
      BaseScreenState.themedStatusIcons(context);

  @override
  Widget body(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: GrofastScreenBody(
        title: isEditing
            ? GrofastValueConst.editAddressTitle
            : GrofastValueConst.addAddressTitle,
        onBack: () => context.pop(),
        gap: AppSpacing.xl4,
        floatingAction: GrofastPrimaryButton(
          label: isEditing
              ? GrofastValueConst.updateAddressButtonLabel
              : GrofastValueConst.addAddressButtonLabel,
          onTap: submitAddress,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _field(
              GrofastValueConst.addressNameLabel,
              nameController,
              field: AddressField.name,
              hint: GrofastValueConst.addressNameHint,
              keyboardType: TextInputType.name,
            ),
            const SizedBox(height: AppSpacing.lg),
            _field(
              GrofastValueConst.mobileLabel,
              phoneController,
              field: AddressField.phone,
              hint: GrofastValueConst.mobileHint,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: AppSpacing.lg),
            _field(
              GrofastValueConst.addressLine1Label,
              addressLine1Controller,
              field: AddressField.addressLine1,
              hint: GrofastValueConst.addressLine1Hint,
            ),
            const SizedBox(height: AppSpacing.lg),
            GrofastFormField(
              label: GrofastValueConst.addressLine2Label,
              controller: addressLine2Controller,
              hint: GrofastValueConst.addressLine2Hint,
            ),
            const SizedBox(height: AppSpacing.lg),
            GrofastFormField(
              label: GrofastValueConst.landmarkLabel,
              controller: landmarkController,
              hint: GrofastValueConst.landmarkHint,
            ),
            const SizedBox(height: AppSpacing.lg),
            _field(
              GrofastValueConst.cityLabel,
              cityController,
              field: AddressField.city,
              hint: GrofastValueConst.cityHint,
            ),
            const SizedBox(height: AppSpacing.lg),
            GrofastFormField(
              label: GrofastValueConst.stateLabel,
              controller: stateController,
              hint: GrofastValueConst.stateHint,
            ),
            const SizedBox(height: AppSpacing.lg),
            GrofastDropdownField(
              label: GrofastValueConst.countryLabel,
              hint: GrofastValueConst.selectCountryTitle,
              value: country,
              onTap: _pickCountry,
            ),
            const SizedBox(height: AppSpacing.lg),
            _field(
              GrofastValueConst.postalCodeLabel,
              postalCodeController,
              field: AddressField.postalCode,
              hint: GrofastValueConst.postalCodeHint,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: AppSpacing.lg),
            _field(
              GrofastValueConst.addressTagLabel,
              tagController,
              field: AddressField.tag,
              hint: GrofastValueConst.addressTagHint,
            ),
          ],
        ),
      ),
    );
  }

  Widget _field(
    String label,
    TextEditingController controller, {
    required AddressField field,
    String? hint,
    TextInputType keyboardType = TextInputType.text,
  }) => GrofastFormField(
    label: label,
    controller: controller,
    hint: hint,
    keyboardType: keyboardType,
    errorText: fieldErrors[field],
    onChanged: (_) => clearFieldError(field),
  );
}
