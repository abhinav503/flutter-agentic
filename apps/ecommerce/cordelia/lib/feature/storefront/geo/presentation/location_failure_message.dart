import 'package:core/core/services/location/location_service.dart';

import 'package:cordelia/constants/value_const.dart';

/// What to tell the shopper when the device wouldn't say where it is.
///
/// One mapping for the whole app: the storefront header asks
/// `LocationService` directly and the address form asks it through
/// `AddressLookupBloc`, and a shopper who sees "Location is switched off" on
/// one must not see "Couldn't get your location" on the other for the same
/// switch. A null [reason] is the fourth case — a fix the geocoder had no
/// name for, which is not a failure of the device.
String locationFailureMessage(
  LocationFailureReason? reason,
) => switch (reason) {
  LocationFailureReason.serviceDisabled => ValueConst.locationServiceOffMessage,
  LocationFailureReason.permissionDenied =>
    ValueConst.locationPermissionDeniedMessage,
  LocationFailureReason.unavailable => ValueConst.locationUnavailableMessage,
  null => ValueConst.locationNoAddressMessage,
};
