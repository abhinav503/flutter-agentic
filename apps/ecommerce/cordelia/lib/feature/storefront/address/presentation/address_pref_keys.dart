/// `SharedPreferenceService` key for the id of the address the shopper last
/// confirmed — read back by `AddressBloc` to pre-select the same address next
/// time, and by a Home header (via [kSelectedAddressLabelPrefKey]) to know
/// whether any address has ever been picked at all.
const kSelectedAddressIdPrefKey = 'selected_address_id';

/// The confirmed address's display line, persisted alongside its id so Home
/// can show it without re-fetching the address list.
const kSelectedAddressLabelPrefKey = 'selected_address_label';
