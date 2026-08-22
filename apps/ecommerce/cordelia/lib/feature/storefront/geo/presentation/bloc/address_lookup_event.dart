part of 'address_lookup_bloc.dart';

@freezed
sealed class AddressLookupEvent with _$AddressLookupEvent {
  /// "Use my location" tapped — GPS → the device's geocoder → prefill.
  const factory AddressLookupEvent.locationRequested() =
      AddressLookupLocationRequested;

  /// Six digits typed into the postal-code field — best-effort city/state
  /// autofill; unknown pincodes stay silent.
  const factory AddressLookupEvent.pincodeEntered({required String pincode}) =
      AddressLookupPincodeEntered;
}
