import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import 'package:core/core/base/base_screen.dart';
import 'package:core/core/mixins/textfield_validations.dart';

import '../domain/entities/address_entity.dart';

/// Only the fields with free-text validation — City/Country are bounded
/// picklists defaulted to their first option, so they can never be empty.
enum AddressField { name, phone, addressLine1, postalCode, tag }

/// Everything the Add/Edit Address form does that isn't pack chrome — the
/// seven controllers seeded from the incoming address, the City/Country
/// picklist selections, per-field validation, and the submit that pops the
/// composed [AddressEntity] back to the caller. Both templates' form screens
/// mix this in and render only their own layout (same shape as
/// [EditProfileForm]), so validation can't drift between packs — name/phone
/// go through core's shared validators ("10 digits" means the same thing as
/// on Edit Profile); the rest are plain required checks, since the backend
/// imposes no format on them.
///
/// No BLoC — every field here is screen-local typed/selected UI state until
/// Save, at which point the caller (`AddressScreen`) dispatches the popped
/// entity into the shared `AddressBloc` via `AddressEvent.saved`.
mixin AddressFormFields<T extends BaseScreen>
    on BaseScreenState<T>, TextfieldValidations {
  /// The address being edited, or null when adding — implemented by the
  /// screen as `widget.address`.
  AddressEntity? get address;

  /// The pack's copy for a missing required field.
  String get requiredFieldErrorMessage;

  /// The pack's picklist options — first option is the default for a new
  /// address.
  List<String> get cityOptions;
  List<String> get countryOptions;

  late final nameController = TextEditingController(text: address?.name ?? '');
  late final phoneController = TextEditingController(
    text: address?.phone ?? '',
  );
  late final addressLine1Controller = TextEditingController(
    text: address?.addressLine1 ?? '',
  );
  late final addressLine2Controller = TextEditingController(
    text: address?.addressLine2 ?? '',
  );
  late final landmarkController = TextEditingController(
    text: address?.landmark ?? '',
  );
  late final postalCodeController = TextEditingController(
    text: address?.postalCode ?? '',
  );
  late final tagController = TextEditingController(text: address?.tag ?? '');

  late String city = address?.city ?? cityOptions.first;
  late String country = address?.country ?? countryOptions.first;

  final Map<AddressField, String> fieldErrors = {};

  bool get isEditing => address != null;

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    addressLine1Controller.dispose();
    addressLine2Controller.dispose();
    landmarkController.dispose();
    postalCodeController.dispose();
    tagController.dispose();
    super.dispose();
  }

  void clearFieldError(AddressField field) {
    if (fieldErrors.containsKey(field)) {
      setState(() => fieldErrors.remove(field));
    }
  }

  void selectCity(String value) => setState(() => city = value);

  void selectCountry(String value) => setState(() => country = value);

  void submitAddress() {
    final name = nameController.text.trim();
    final phone = phoneController.text.trim();
    final addressLine1 = addressLine1Controller.text.trim();
    final postalCode = postalCodeController.text.trim();
    final tag = tagController.text.trim();

    final errors = <AddressField, String>{
      AddressField.name: ?validateName(name),
      AddressField.phone: ?validateMobile(phone),
      if (addressLine1.isEmpty)
        AddressField.addressLine1: requiredFieldErrorMessage,
      if (postalCode.isEmpty) AddressField.postalCode: requiredFieldErrorMessage,
      if (tag.isEmpty) AddressField.tag: requiredFieldErrorMessage,
    };

    if (errors.isNotEmpty) {
      setState(() {
        fieldErrors
          ..clear()
          ..addAll(errors);
      });
      return;
    }

    context.pop(
      AddressEntity(
        // Empty for a new address — the server assigns the real id; the
        // existing id when editing, so the bloc updates in place.
        id: address?.id ?? '',
        name: name,
        phone: phone,
        addressLine1: addressLine1,
        addressLine2: addressLine2Controller.text.trim(),
        landmark: landmarkController.text.trim(),
        city: city,
        country: country,
        postalCode: postalCode,
        tag: tag,
        // Not editable from this form (no spec for a "set as default"
        // toggle) — a new address starts non-default; an edited one keeps
        // whatever it already was.
        isDefault: address?.isDefault ?? false,
      ),
    );
  }
}
