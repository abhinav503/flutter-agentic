part of 'address_lookup_bloc.dart';

@freezed
sealed class AddressLookupState with _$AddressLookupState {
  const factory AddressLookupState.idle() = AddressLookupIdle;

  /// The fix and the geocode are in flight — drives the location button's
  /// spinner.
  const factory AddressLookupState.locating() = AddressLookupLocating;

  /// A structured address is ready — the screen's listener prefills the
  /// form controllers from it.
  const factory AddressLookupState.prefillReady({
    required GeoAddressEntity address,
  }) = AddressLookupPrefillReady;

  /// A pincode resolved — the listener autofills city/state only.
  const factory AddressLookupState.pincodeReady({
    required PincodeInfoEntity info,
  }) = AddressLookupPincodeReady;

  /// [isLocation] picks the pack's own localized copy over [message], which
  /// is technical. Only location can fail loudly now: a pincode miss is
  /// silent by design.
  const factory AddressLookupState.error({
    required String message,
    required bool isLocation,
  }) = AddressLookupError;
}
