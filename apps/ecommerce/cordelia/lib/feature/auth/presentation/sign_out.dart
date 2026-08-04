import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:core/core/services/shared_pref_service/shared_preference_service.dart';

import 'package:cordelia/constants/app_routes.dart';
import 'package:cordelia/feature/auth/presentation/bloc/auth_bloc.dart'
    show kPendingEmailVerificationPrefKey;
import 'package:cordelia/feature/storefront/cart/presentation/cubit/cart_cubit.dart';
import 'package:cordelia/feature/storefront/cart/presentation/cubit/coupon_cubit.dart';
import 'package:cordelia/feature/storefront/favourites/presentation/cubit/favourites_cubit.dart';
import 'package:cordelia/services/firebase_auth_service.dart';
import 'package:cordelia/services/user_profile_cache_service.dart';

/// The full sign-out sequence, shared by both templates' Profile screens:
/// Firebase sign-out, local profile-cache clear, verify-sheet flag reset,
/// per-account cubit resets, then back to Login.
Future<void> signOutAndReturnToLogin(BuildContext context) async {
  await FirebaseAuthService.instance.signOut();
  await UserProfileCacheService.instance.clear();
  // Defensive — Profile is only reachable once AuthAuthenticated has fired,
  // which already clears this key, but a stale flag here would wrongly
  // reopen the verify sheet for the next account signing in on this device.
  await SharedPreferenceService.instance.setBool(
    kPendingEmailVerificationPrefKey,
    false,
  );
  if (!context.mounted) return;
  context.read<CartCubit>().reset();
  context.read<CouponCubit>().reset();
  context.read<FavouritesCubit>().reset();
  context.go(AppRoutes.login);
}
