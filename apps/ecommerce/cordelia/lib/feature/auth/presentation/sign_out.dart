import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:core/core/services/shared_pref_service/shared_preference_service.dart';

import 'package:cordelia/constants/app_routes.dart';
import 'package:cordelia/feature/auth/presentation/bloc/auth_bloc.dart'
    show kPendingEmailVerificationPrefKey;
import 'package:cordelia/feature/storefront/address/presentation/address_pref_keys.dart';
import 'package:cordelia/feature/storefront/cart/presentation/cubit/cart_cubit.dart';
import 'package:cordelia/feature/storefront/cart/presentation/cubit/coupon_cubit.dart';
import 'package:cordelia/feature/home/presentation/recent_stores_prefs.dart';
import 'package:cordelia/feature/storefront/favourites/presentation/cubit/favourites_cubit.dart';
import 'package:cordelia/services/firebase_auth_service.dart';
import 'package:cordelia/services/user_profile_cache_service.dart';

/// Everything on this device that belonged to the account that just went
/// away — the cached profile, the stores they visited, the bag, the coupon,
/// the wishlist, and the delivery address a Home header prints.
///
/// Shared by the two ways a session ends, because they must forget the same
/// things. Sign-out always did; expiry only cleared the profile cache, which
/// stopped being survivable when the app started browsing without an
/// account: the shopper stays on screen afterwards, so anything left behind
/// is the previous account's data shown to whoever is holding the phone.
///
/// The address prefs are new to both paths. Nothing cleared them before, so
/// signing in as a second account on one device inherited the first's
/// delivery address in the header.
Future<void> forgetAccountLocalState(BuildContext context) async {
  await UserProfileCacheService.instance.clear();
  await clearRecentStores();
  // Defensive — a session that ended cleanly has already cleared this, but a
  // stale flag would wrongly reopen the verify sheet for the next account
  // signing in on this device.
  await SharedPreferenceService.instance.setBool(
    kPendingEmailVerificationPrefKey,
    false,
  );
  await SharedPreferenceService.instance.remove(kSelectedAddressIdPrefKey);
  await SharedPreferenceService.instance.remove(kSelectedAddressLabelPrefKey);
  if (!context.mounted) return;
  context.read<CartCubit>().reset();
  context.read<CouponCubit>().reset();
  context.read<FavouritesCubit>().reset();
}

/// The full sign-out sequence, shared by every template's Profile screen:
/// Firebase sign-out, [forgetAccountLocalState], then back to discovery.
///
/// Discovery rather than Login: signing out drops the shopper to the
/// browsing tier the app now opens on, not out of the app. Login is what
/// they meet again at the first gated action.
Future<void> signOutAndReturnToDiscovery(BuildContext context) async {
  await FirebaseAuthService.instance.signOut();
  if (!context.mounted) return;
  await forgetAccountLocalState(context);
  if (!context.mounted) return;
  context.go(AppRoutes.discovery);
}
