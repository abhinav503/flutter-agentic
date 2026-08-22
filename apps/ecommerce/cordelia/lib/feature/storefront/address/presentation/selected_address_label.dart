import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import 'package:core/core/services/location/location_service.dart';
import 'package:core/core/services/shared_pref_service/shared_preference_service.dart';

import 'package:cordelia/constants/app_routes.dart';
import 'package:cordelia/constants/value_const.dart';
import 'package:cordelia/feature/auth/presentation/sign_in_gate.dart';
import 'package:cordelia/feature/storefront/address/presentation/address_pref_keys.dart';
import 'package:cordelia/feature/storefront/geo/presentation/location_failure_message.dart';

/// The "selected delivery address" label a storefront Home header shows —
/// read from prefs on mount, refreshed after the Select Address screen pops.
/// Every template's Home repeats this identical trio, so it lives once here
/// beside the address feature that owns the pref key.
///
/// Tapping it means two different things, because a guest has no addresses
/// to pick from: signed in it opens Select Address, signed out it asks the
/// device where you are and prints the postcode. The second is not a
/// delivery address and is never saved as one — it answers "does this store
/// deliver near me?" before the shopper has committed to anything.
mixin SelectedAddressLabelState<T extends StatefulWidget> on State<T> {
  /// `null` until an address has ever been selected — callers supply their
  /// own pack-worded fallback copy.
  String? selectedAddressLabel;

  @override
  void initState() {
    super.initState();
    loadSelectedAddressLabel();
  }

  void loadSelectedAddressLabel() {
    selectedAddressLabel = SharedPreferenceService.instance.getString(
      kSelectedAddressLabelPrefKey,
    );
  }

  /// Pushes Select Address and re-reads the label once it pops.
  Future<void> openSelectAddress() async {
    await context.push(AppRoutes.selectAddress);
    if (!mounted) return;
    setState(loadSelectedAddressLabel);
  }

  /// The signed-in branch — the pack's own way of choosing an address.
  /// Defaults to the routed Select Address page; grofast overrides it with
  /// the sheet its kit draws.
  Future<void> openAddressPicker() => openSelectAddress();

  /// What a Home header's location row should do when tapped.
  Future<void> onLocationTapped() =>
      context.isSignedIn ? openAddressPicker() : _showNearbyPostcode();

  /// The permission prompt happens here, on a tap — never at launch. An
  /// unasked-for location dialog on first open is one of the surest ways to
  /// lose an install, and the answer is only worth having once someone has
  /// shown interest by reaching for it.
  ///
  /// Resolved on the device's own geocoder (see [LocationService]), so it
  /// needs no account, no key and no server — which is the whole reason a
  /// guest can use it.
  Future<void> _showNearbyPostcode() async {
    setState(() => locatingNearby = true);
    final result = await LocationService.instance.currentPlace();
    if (!mounted) return;

    switch (result) {
      case LocationSuccess(:final postalCode, :final locality)
          when postalCode.isNotEmpty || locality.isNotEmpty:
        setState(() {
          locatingNearby = false;
          // Held in state, not in the address prefs: this is a hint about
          // where the phone is, not an address the shopper confirmed, and
          // writing it to kSelectedAddressLabelPrefKey would make checkout
          // think one had been chosen.
          nearbyLabel = [
            if (locality.isNotEmpty) locality,
            if (postalCode.isNotEmpty) postalCode,
          ].join(' ');
        });
      case LocationSuccess():
        // A fix with no name behind it — the geocoder had nothing, which is
        // ordinary on a device with no network or no Play services.
        setState(() => locatingNearby = false);
        showLocationMessage(locationFailureMessage(null));
      case LocationUnavailable(:final reason):
        setState(() => locatingNearby = false);
        showLocationMessage(locationFailureMessage(reason));
    }
  }

  /// True while the device is being asked. Surfaced through
  /// [headerLocationLabel] rather than as a per-pack spinner: the row is
  /// already a line of text, and swapping its words needs no new chrome in
  /// any template. A 15-second GPS timeout with no feedback at all reads as
  /// a dead tap.
  bool locatingNearby = false;

  /// The postcode line resolved from the device, or null until one is.
  /// Ranks below a confirmed address: a shopper who has chosen where to
  /// deliver should not see it replaced by wherever they are standing.
  String? nearbyLabel;

  /// The label a header prints: "locating" while the device is being asked,
  /// then a confirmed address, then a located postcode, and finally null for
  /// the pack's own "no location" copy.
  String? get headerLocationLabel => locatingNearby
      ? ValueConst.locationLocatingLabel
      : selectedAddressLabel ?? nearbyLabel;

  /// How this screen surfaces a failure — every host is a `BaseScreenState`,
  /// so this is its `showSnackBar`.
  void showLocationMessage(String message);
}
