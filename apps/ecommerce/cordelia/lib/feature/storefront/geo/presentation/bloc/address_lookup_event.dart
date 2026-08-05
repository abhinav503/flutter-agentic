part of 'address_lookup_bloc.dart';

@freezed
sealed class AddressLookupEvent with _$AddressLookupEvent {
  /// "Use my location" tapped — GPS → reverse geocode → prefill.
  const factory AddressLookupEvent.locationRequested() =
      AddressLookupLocationRequested;

  /// The address search field's text changed (debounced type-ahead).
  const factory AddressLookupEvent.queryChanged({required String query}) =
      AddressLookupQueryChanged;

  /// A type-ahead suggestion picked — resolves to a structured prefill.
  const factory AddressLookupEvent.suggestionSelected({
    required PlaceSuggestionEntity suggestion,
  }) = AddressLookupSuggestionSelected;

  /// Six digits typed into the postal-code field — best-effort city/state
  /// autofill; unknown pincodes stay silent.
  const factory AddressLookupEvent.pincodeEntered({required String pincode}) =
      AddressLookupPincodeEntered;
}
