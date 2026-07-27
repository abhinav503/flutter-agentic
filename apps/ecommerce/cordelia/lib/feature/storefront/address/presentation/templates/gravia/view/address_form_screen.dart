import 'package:cordelia/templates/gravia/constants/gravia_value_const.dart';
import 'package:cordelia/templates/gravia/widgets/gravia_dropdown_field.dart';
import 'package:cordelia/templates/gravia/widgets/gravia_sheet.dart';
import 'package:cordelia/templates/gravia/widgets/radio_options_sheet_content.dart';
import 'package:cordelia/widgets/cordelia_form_field.dart';
import 'package:cordelia/widgets/cordelia_hero_header.dart';
import 'package:cordelia/widgets/cordelia_primary_button.dart';
import 'package:core/core/ui/blocks/docked_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import 'package:core/core/base/base_screen.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/blocks/collapsing_header_sheet.dart';

import '../../../../domain/entities/address_entity.dart';

/// Only the fields with free-text validation — City/Country are bounded
/// picklists defaulted to their first option, so they can never be empty.
enum _AddressField { name, phone, addressLine1, postalCode, tag }

/// Add/Edit Address form, reached from AddressScreen's "Add New Address"
/// button and each AddressCard's Edit action. [address] decides the mode:
/// null → a new address; non-null → that address, prefilled. Either way the
/// result is popped back to the caller as an [AddressEntity] — AddressScreen
/// dispatches it into the shared AddressBloc via `AddressEvent.saved`, the
/// same "push, await the pop, react" shape as
/// `HomeScreen._openSelectAddress`. No BLoC of its own: every field here is
/// screen-local typed/selected UI state until Save, the same carve-out
/// `ProductDetailsScreen` uses for its quantity/size selection.
class AddressFormScreen extends BaseScreen {
  final AddressEntity? address;

  const AddressFormScreen({super.key, this.address});

  @override
  State<AddressFormScreen> createState() => _AddressFormScreenState();
}

class _AddressFormScreenState extends BaseScreenState<AddressFormScreen> {
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
      widget.address?.city ?? GraviaValueConst.addressFormCities.first;
  late String _country =
      widget.address?.country ?? GraviaValueConst.addressFormCountries.first;

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
        onSelected: (option) {
          onSelected(option);
          context.pop();
        },
      ),
    );
  }

  void _submit() {
    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();
    final addressLine1 = _addressLine1Controller.text.trim();
    final postalCode = _postalCodeController.text.trim();
    final tag = _tagController.text.trim();

    final errors = <_AddressField, String>{
      if (name.isEmpty)
        _AddressField.name: GraviaValueConst.requiredFieldErrorMessage,
      if (phone.isEmpty)
        _AddressField.phone: GraviaValueConst.requiredFieldErrorMessage,
      if (addressLine1.isEmpty)
        _AddressField.addressLine1: GraviaValueConst.requiredFieldErrorMessage,
      if (postalCode.isEmpty)
        _AddressField.postalCode: GraviaValueConst.requiredFieldErrorMessage,
      if (tag.isEmpty) _AddressField.tag: GraviaValueConst.requiredFieldErrorMessage,
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
        // Not editable from this form (no spec for a "set as default"
        // toggle) — a new address starts non-default; an edited one keeps
        // whatever it already was.
        isDefault: widget.address?.isDefault ?? false,
      ),
    );
  }

  @override
  Widget body(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Column(
        children: [
          Expanded(
            child: CollapsingHeaderSheet(
              initialHeaderHeight: 110,
              header: CordeliaHeroHeader(
                title: _isEditing
                    ? GraviaValueConst.editAddressTitle
                    : GraviaValueConst.addNewAddressLabel,
                onBack: () => context.pop(),
              ),
              body: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _field(
                      GraviaValueConst.nameLabel,
                      _nameController,
                      field: _AddressField.name,
                      keyboardType: TextInputType.name,
                      hint: GraviaValueConst.nameHint,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    _field(
                      GraviaValueConst.phoneNumberLabel,
                      _phoneController,
                      field: _AddressField.phone,
                      keyboardType: TextInputType.phone,
                      hint: GraviaValueConst.phoneNumberHint,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    _field(
                      GraviaValueConst.addressLine1Label,
                      _addressLine1Controller,
                      field: _AddressField.addressLine1,
                      hint: GraviaValueConst.addressLine1Hint,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    _field(
                      GraviaValueConst.addressLine2Label,
                      _addressLine2Controller,
                      hint: GraviaValueConst.addressLine2Hint,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    _field(
                      GraviaValueConst.landmarkLabel,
                      _landmarkController,
                      hint: GraviaValueConst.landmarkHint,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    GraviaDropdownField(
                      label: GraviaValueConst.cityLabel,
                      value: _city,
                      onTap: () => _showOptionPicker(
                        title: GraviaValueConst.selectCityTitle,
                        options: GraviaValueConst.addressFormCities,
                        selected: _city,
                        onSelected: (city) => setState(() => _city = city),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    GraviaDropdownField(
                      label: GraviaValueConst.countryLabel,
                      value: _country,
                      onTap: () => _showOptionPicker(
                        title: GraviaValueConst.selectCountryTitle,
                        options: GraviaValueConst.addressFormCountries,
                        selected: _country,
                        onSelected: (country) =>
                            setState(() => _country = country),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    _field(
                      GraviaValueConst.postalCodeLabel,
                      _postalCodeController,
                      field: _AddressField.postalCode,
                      keyboardType: TextInputType.number,
                      hint: GraviaValueConst.postalCodeHint,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    _field(
                      GraviaValueConst.addressTagLabel,
                      _tagController,
                      field: _AddressField.tag,
                      hint: GraviaValueConst.addressTagHint,
                    ),
                  ],
                ),
              ),
            ),
          ),
          DockedBar(
            child: CordeliaPrimaryButton(
              label: _isEditing
                  ? GraviaValueConst.updateAddressButtonLabel
                  : GraviaValueConst.addAddressButtonLabel,
              onTap: _submit,
            ),
          ),
        ],
      ),
    );
  }

  Widget _field(
    String label,
    TextEditingController controller, {
    _AddressField? field,
    TextInputType keyboardType = TextInputType.text,
    String? hint,
  }) {
    final error = field == null ? null : _errors[field];
    return CordeliaFormField(
      label: label,
      controller: controller,
      hint: hint,
      keyboardType: keyboardType,
      errorText: error,
      onChanged: field == null ? null : (_) => _clearError(field),
    );
  }
}
