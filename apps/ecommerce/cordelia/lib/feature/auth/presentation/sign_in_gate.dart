import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:core/core/auth/auth_session.dart';

import 'package:cordelia/constants/app_routes.dart';
import 'package:cordelia/di/injection_container.dart';
import 'package:cordelia/feature/storefront/active_store/presentation/cubit/active_store_cubit.dart';
import 'package:cordelia/feature/storefront/cart/presentation/cubit/cart_cubit.dart';
import 'package:cordelia/feature/storefront/favourites/presentation/cubit/favourites_cubit.dart';
import 'package:cordelia/feature/storefront/home/domain/entities/product_entity.dart';
import 'package:cordelia/feature/storefront/reviews/presentation/bloc/product_reviews_bloc.dart';

/// The account gate every signed-in-only action runs through.
///
/// The app browses without an account — discovery, a store's home, its
/// categories, products, search and the reviews on them all render for a
/// signed-out shopper, and their data sources send no token (or an optional
/// one). What needs an account is anything that *writes* something owned by
/// a person: a bag, a wishlist, an order, a profile, a review.
///
/// Those call [requireSignIn] and act only if it resolves true. Login is
/// **pushed**, not `go`-ne to, so returning is the navigator popping — the
/// shopper lands back on the exact product they were looking at rather than
/// on discovery, and no return-path has to be encoded in a route.
extension SignInGateX on BuildContext {
  bool get isSignedIn => sl<AuthSession>().isSignedIn;

  /// True if the shopper has an account by the time this resolves — already
  /// signed in, or signed in through the pushed Login flow. False means they
  /// backed out, and the caller must do nothing.
  Future<bool> requireSignIn() async {
    if (isSignedIn) return true;

    final signedIn = await push<bool>(AppRoutes.login) ?? false;
    if (!signedIn || !mounted) return signedIn;

    // A shell mounted while signed out skipped its cart/favourites
    // hydration, so this is where that debt is paid. Without it the first
    // add-to-cart would persist a one-item cart over whatever the shopper
    // already had on the server.
    final storeId = read<ActiveStoreCubit>().state?.storeId;
    if (storeId != null) {
      read<CartCubit>().hydrate(storeId);
      read<FavouritesCubit>().hydrate(storeId);
    }
    // The profile needs no nudge from here: `ProfileBloc` follows
    // `FirebaseAuthService.authStateChanges` itself. It used to be told,
    // and that only worked when the gate happened to be called from below
    // its provider — which the gated Profile tab, called from the shell's
    // own page context, is not.
    _refreshReviews();
    return true;
  }

  /// Reviews were seeded from the product-details payload, which was fetched
  /// without a token and so knows nothing about who this account has
  /// blocked. Re-fetching is the only way those authors disappear; the bloc
  /// ignores a re-seed by design, so the gate asks for the fetch.
  ///
  /// Guarded because there isn't always one above: only a screen showing
  /// reviews (Product Details) provides this bloc, and a gate fires from
  /// plenty of screens that don't.
  void _refreshReviews() {
    try {
      read<ProductReviewsBloc>().add(const ProductReviewsEvent.refreshed());
    } on ProviderNotFoundException {
      // Not on a screen that shows reviews.
    }
  }
}

/// The two storefront writes a guest is most likely to reach for, each
/// wrapped in [SignInGateX.requireSignIn] once so the thirty-odd call sites
/// across three templates can't each forget it.
///
/// Deliberately not a change inside the cubits: a cubit cannot navigate, and
/// a gate that silently dropped the action would leave a tapped **+** doing
/// nothing at all.
extension GuestActionsX on BuildContext {
  /// Mirrors `CartCubit.addToCart`, size variant and all — a details CTA
  /// adds the selected pack, a card's quick-add adds the base one.
  /// True when the line actually went in. Callers that confirm with a
  /// snackbar must wait for it — announcing "Added to cart" and *then*
  /// opening Login is how the gate first shipped, and it reads as the app
  /// losing the thing it just promised.
  Future<bool> addToCartOrSignIn(
    ProductEntity product,
    int quantity, {
    double? sizeValue,
    double? unitPrice,
    double? originalUnitPrice,
  }) async {
    if (!await requireSignIn() || !mounted) return false;
    // Zero means the line was already holding everything that's left, so
    // there is nothing to confirm — see `CartCubit.addToCart`.
    return read<CartCubit>().addToCart(
          product,
          quantity,
          sizeValue: sizeValue,
          unitPrice: unitPrice,
          originalUnitPrice: originalUnitPrice,
        ) >
        0;
  }

  /// A route that only means something with an account behind it — the bag,
  /// the notification centre, an order history. Reached from surfaces a
  /// guest can be standing on (a store's home, a floating cart pill), so
  /// the gate lives at the push rather than inside each destination.
  Future<void> pushIfSignedIn(String route, {Object? extra}) async {
    if (await requireSignIn() && mounted) push(route, extra: extra);
  }

  Future<bool> toggleFavouriteOrSignIn(ProductEntity product) async {
    if (!await requireSignIn() || !mounted) return false;
    read<FavouritesCubit>().toggle(product);
    return true;
  }
}
