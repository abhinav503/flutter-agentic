import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import 'package:core/core/services/shared_pref_service/shared_preference_service.dart';

import 'package:cordelia/constants/app_routes.dart';
import 'package:cordelia/feature/storefront/address/presentation/address_pref_keys.dart';

/// The "selected delivery address" label a storefront Home header shows —
/// read from prefs on mount, refreshed after the Select Address screen pops.
/// Every template's Home repeats this identical trio, so it lives once here
/// beside the address feature that owns the pref key.
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
}
