import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import 'package:core/core/base/base_screen.dart';
import 'package:core/core/mixins/textfield_validations.dart';
import 'package:core/core/theme/app_spacing.dart';

import 'package:cordelia/templates/dailymart/constants/dailymart_dimen_const.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_value_const.dart';
import 'package:cordelia/templates/dailymart/widgets/dailymart_bottom_fade.dart';
import 'package:cordelia/templates/dailymart/widgets/dailymart_dropdown_field.dart';
import 'package:cordelia/templates/dailymart/widgets/dailymart_form_field.dart';
import 'package:cordelia/templates/dailymart/widgets/dailymart_header_row.dart';
import 'package:cordelia/templates/dailymart/widgets/dailymart_primary_button.dart';
import 'package:cordelia/templates/dailymart/widgets/dailymart_radio_sheet_content.dart';
import 'package:cordelia/templates/dailymart/widgets/dailymart_sheet.dart';

import '../../../../domain/entities/address_entity.dart';

/// Only the fields with free-text validation — City/Country are bounded
/// picklists defaulted to their first option, so they can never be empty.
enum _AddressField { name, phone, addressLine1, postalCode, tag }

/// `dailymart` template's Add/Edit Address form, reached from
/// `AddressScreen`'s floating "Add New Address" CTA and each address card's
/// pencil. [address] decides the mode: null → a new address; non-null → that
/// address, prefilled.
///
/// The kit ships no frame for this screen, so it's composed from the pack's
/// existing form recipe rather than invented: the same
/// header-row → fields → floating-CTA-over-a-fade skeleton as Edit Profile
/// and Change Password (spec sheet §8/§13), with [DailyMartDropdownField]
/// standing in for the two picklists.
///
/// No BLoC of its own — every field here is screen-local typed/selected UI
/// state until Save, at which point the composed [AddressEntity] is popped
/// back to `AddressScreen`, which dispatches it into the shared
/// `AddressBloc` via `AddressEvent.saved`. Same "push, await the pop, react"
/// shape gravia's form uses.
class AddressFormScreen extends BaseScreen {
  final AddressEntity? address;

  const AddressFormScreen({super.key, this.address});

  @override
  State<AddressFormScreen> createState() => _AddressFormScreenState();
}

class _AddressFormScreenState extends BaseScreenState<AddressFormScreen>
    with TextfieldValidations {
  late final _nameController = TextEditingController(
    text: widget.address?.name ?? '',
  );
  late final _phoneController = TextEditingController(
    text: widget.address?.phone ?? '',
  );
  late final _addressLine1Controller = TextEditingController(
    text: widget.address?.addressLine1 ?? '',
  );
  late final _addressLine2Controller = TextEditingController(
    text: widget.address?.addressLine2 ?? '',
  );
  late final _landmarkController = TextEditingController(
    text: widget.address?.landmark ?? '',
  );
  late final _postalCodeController = TextEditingController(
    text: widget.address?.postalCode ?? '',
  );
  late final _tagController = TextEditingController(
    text: widget.address?.tag ?? '',
  );

  late String _city =
      widget.address?.city ?? DailyMartValueConst.addressFormCities.first;
  late String _country =
      widget.address?.country ?? DailyMartValueConst.addressFormCountries.first;

  final Map<_AddressField, String> _errors = {};

  bool get _isEditing => widget.address != null;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressLine1Controller.dispose();
    _addressLine2Controller.dispose();
    _landmarkController.dispose();
    _postalCodeController.dispose();
    _tagController.dispose();
    super.dispose();
  }

  void _clearError(_AddressField field) {
    if (_errors.containsKey(field)) setState(() => _errors.remove(field));
  }

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

  void _submit() {
    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();
    final addressLine1 = _addressLine1Controller.text.trim();
    final postalCode = _postalCodeController.text.trim();
    final tag = _tagController.text.trim();

    final errors = <_AddressField, String>{
      // Name/phone reuse core's shared validators (same as Edit Profile, so
      // "10 digits" means the same thing on both forms); the rest are plain
      // required checks — the backend imposes no format on them.
      _AddressField.name: ?validateName(name),
      _AddressField.phone: ?validateMobile(phone),
      if (addressLine1.isEmpty)
        _AddressField.addressLine1:
            DailyMartValueConst.requiredFieldErrorMessage,
      if (postalCode.isEmpty)
        _AddressField.postalCode: DailyMartValueConst.requiredFieldErrorMessage,
      if (tag.isEmpty)
        _AddressField.tag: DailyMartValueConst.requiredFieldErrorMessage,
    };

    if (errors.isNotEmpty) {
      setState(() {
        _errors
          ..clear()
          ..addAll(errors);
      });
      return;
    }

    context.pop(
      AddressEntity(
        // Empty for a new address — the server assigns the real id; the
        // existing id when editing, so the bloc updates in place.
        id: widget.address?.id ?? '',
        name: name,
        phone: phone,
        addressLine1: addressLine1,
        addressLine2: _addressLine2Controller.text.trim(),
        landmark: _landmarkController.text.trim(),
        city: _city,
        country: _country,
        postalCode: postalCode,
        tag: tag,
        // Not editable from this form (the kit draws no "set as default"
        // toggle) — a new address starts non-default; an edited one keeps
        // whatever it already was.
        isDefault: widget.address?.isDefault ?? false,
      ),
    );
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
          // short form ends the stack early and the positioned fade + CTA pin
          // to the content's bottom edge, not the device's.
          fit: StackFit.expand,
          children: [
            SingleChildScrollView(
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
                    title: _isEditing
                        ? DailyMartValueConst.editAddressTitle
                        : DailyMartValueConst.addAddressTitle,
                    onBack: () => context.pop(),
                  ),
                  const SizedBox(height: AppSpacing.xl2),
                  _field(
                    DailyMartValueConst.addressNameLabel,
                    _nameController,
                    field: _AddressField.name,
                    keyboardType: TextInputType.name,
                    hint: DailyMartValueConst.addressNameHint,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _field(
                    DailyMartValueConst.phoneNumberLabel,
                    _phoneController,
                    field: _AddressField.phone,
                    keyboardType: TextInputType.phone,
                    hint: DailyMartValueConst.phoneNumberHint,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _field(
                    DailyMartValueConst.addressLine1Label,
                    _addressLine1Controller,
                    field: _AddressField.addressLine1,
                    hint: DailyMartValueConst.addressLine1Hint,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _field(
                    DailyMartValueConst.addressLine2Label,
                    _addressLine2Controller,
                    hint: DailyMartValueConst.addressLine2Hint,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _field(
                    DailyMartValueConst.landmarkLabel,
                    _landmarkController,
                    hint: DailyMartValueConst.landmarkHint,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  DailyMartDropdownField(
                    label: DailyMartValueConst.cityLabel,
                    value: _city,
                    onTap: () => _showOptionPicker(
                      title: DailyMartValueConst.selectCityTitle,
                      options: DailyMartValueConst.addressFormCities,
                      selected: _city,
                      onSelected: (city) => setState(() => _city = city),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  DailyMartDropdownField(
                    label: DailyMartValueConst.countryLabel,
                    value: _country,
                    onTap: () => _showOptionPicker(
                      title: DailyMartValueConst.selectCountryTitle,
                      options: DailyMartValueConst.addressFormCountries,
                      selected: _country,
                      onSelected: (country) =>
                          setState(() => _country = country),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _field(
                    DailyMartValueConst.postalCodeLabel,
                    _postalCodeController,
                    field: _AddressField.postalCode,
                    keyboardType: TextInputType.number,
                    hint: DailyMartValueConst.postalCodeHint,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _field(
                    DailyMartValueConst.addressTagLabel,
                    _tagController,
                    field: _AddressField.tag,
                    hint: DailyMartValueConst.addressTagHint,
                  ),
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
                label: _isEditing
                    ? DailyMartValueConst.updateAddressButtonLabel
                    : DailyMartValueConst.addAddressButtonLabel,
                onTap: _submit,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _field(
    String label,
    TextEditingController controller, {
    _AddressField? field,
    TextInputType keyboardType = TextInputType.text,
    String? hint,
  }) => DailyMartFormField(
    label: label,
    controller: controller,
    hint: hint,
    keyboardType: keyboardType,
    errorText: field == null ? null : _errors[field],
    onChanged: field == null ? null : (_) => _clearError(field),
  );
}
