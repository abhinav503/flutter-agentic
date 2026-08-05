import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import 'package:core/core/base/base_screen.dart';
import 'package:core/core/mixins/textfield_validations.dart';

import '../../geo/domain/entities/geo_address_entity.dart';
import '../../geo/domain/entities/pincode_info_entity.dart';
import '../domain/entities/address_entity.dart';

/// Only the fields with free-text validation — Country stays a bounded
/// picklist defaulted to its first option, so it can never be empty.
enum AddressField { name, phone, addressLine1, city, postalCode, tag }

/// Everything the Add/Edit Address form does that isn't pack chrome — the
/// controllers seeded from the incoming address, the Country picklist
/// selection, per-field validation, the geo-prefill hooks ("use my
/// location", autocomplete, pincode autofill), and the submit that pops the
/// composed [AddressEntity] back to the caller. Both templates' form screens
/// mix this in and render only their own layout (same shape as
/// [EditProfileForm]), so validation can't drift between packs — name/phone
/// go through core's shared validators ("10 digits" means the same thing as
/// on Edit Profile); the rest are plain required checks, since the backend
/// imposes no format on them.
///
/// City is free text (it used to be a picklist): geo prefill writes real
/// city names no fixed list could contain. State is optional free text —
/// absent on addresses saved before the location feature.
///
/// No BLoC for the field state — every field here is screen-local
/// typed/selected UI state until Save, at which point the caller
/// (`AddressScreen`) dispatches the popped entity into the shared
/// `AddressBloc` via `AddressEvent.saved`. (The geo lookups feeding
/// [prefill] do run through `AddressLookupBloc`, provided by the pack's
/// form page.)
mixin AddressFormFields<T extends BaseScreen>
    on BaseScreenState<T>, TextfieldValidations {
  /// The address being edited, or null when adding — implemented by the
  /// screen as `widget.address`.
  AddressEntity? get address;

  /// The pack's copy for a missing required field.
  String get requiredFieldErrorMessage;

  /// The pack's picklist options — first option is the default for a new
  /// address.
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
  late final cityController = TextEditingController(text: address?.city ?? '');
  late final stateController = TextEditingController(
    text: address?.state ?? '',
  );
  late final postalCodeController = TextEditingController(
    text: address?.postalCode ?? '',
  );
  late final tagController = TextEditingController(text: address?.tag ?? '');

  late String country = address?.country ?? countryOptions.first;

  /// Coordinates the last geo prefill delivered (or the edited address
  /// already carried) — saved onto the entity; hand-typed addresses keep
  /// null.
  double? latitude;
  double? longitude;

  final Map<AddressField, String> fieldErrors = {};

  bool get isEditing => address != null;

  @override
  void initState() {
    super.initState();
    latitude = address?.latitude;
    longitude = address?.longitude;
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    addressLine1Controller.dispose();
    addressLine2Controller.dispose();
    landmarkController.dispose();
    cityController.dispose();
    stateController.dispose();
    postalCodeController.dispose();
    tagController.dispose();
    super.dispose();
  }

  void clearFieldError(AddressField field) {
    if (fieldErrors.containsKey(field)) {
      setState(() => fieldErrors.remove(field));
    }
  }

  void selectCountry(String value) => setState(() => country = value);

  /// Fills the form from a resolved location ("use my location" /
  /// autocomplete pick). Only non-empty parts overwrite, so a partial
  /// resolve never blanks what the shopper already typed.
  void prefill(GeoAddressEntity resolved) {
    setState(() {
      if (resolved.addressLine.isNotEmpty) {
        addressLine1Controller.text = resolved.addressLine;
      }
      if (resolved.city.isNotEmpty) cityController.text = resolved.city;
      if (resolved.state.isNotEmpty) stateController.text = resolved.state;
      if (resolved.postalCode.isNotEmpty) {
        postalCodeController.text = resolved.postalCode;
      }
      if (countryOptions.contains(resolved.country)) {
        country = resolved.country;
      }
      latitude = resolved.latitude;
      longitude = resolved.longitude;
      fieldErrors.clear();
    });
  }

  /// City/state autofill from a typed 6-digit pincode — narrower than
  /// [prefill] on purpose: the pincode says nothing about the street line.
  void prefillPincode(PincodeInfoEntity info) {
    setState(() {
      if (info.city.isNotEmpty) cityController.text = info.city;
      if (info.state.isNotEmpty) stateController.text = info.state;
      if (countryOptions.contains(info.country)) country = info.country;
      fieldErrors.remove(AddressField.city);
    });
  }

  void submitAddress() {
    final name = nameController.text.trim();
    final phone = phoneController.text.trim();
    final addressLine1 = addressLine1Controller.text.trim();
    final city = cityController.text.trim();
    final postalCode = postalCodeController.text.trim();
    final tag = tagController.text.trim();

    final errors = <AddressField, String>{
      AddressField.name: ?validateName(name),
      AddressField.phone: ?validateMobile(phone),
      if (addressLine1.isEmpty)
        AddressField.addressLine1: requiredFieldErrorMessage,
      if (city.isEmpty) AddressField.city: requiredFieldErrorMessage,
      if (postalCode.isEmpty)
        AddressField.postalCode: requiredFieldErrorMessage,
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
        state: stateController.text.trim(),
        country: country,
        postalCode: postalCode,
        tag: tag,
        // Not editable from this form (no spec for a "set as default"
        // toggle) — a new address starts non-default; an edited one keeps
        // whatever it already was.
        isDefault: address?.isDefault ?? false,
        latitude: latitude,
        longitude: longitude,
      ),
    );
  }
}
