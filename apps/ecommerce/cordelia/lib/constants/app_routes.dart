abstract final class AppRoutes {
  static const splash = '/';
  static const discovery = '/discovery';
  static const onboarding = '/onboarding';
  static const login = '/login';
  static const signup = '/signup';
  static const search = '/search';

  /// Nested under [discovery] so `context.go(storefront, …)` — the shell
  /// tab-jump mechanism — rebuilds the stack with Discovery beneath it.
  /// Navigate with `extra: StorefrontRouteArgs(…)`.
  static const storefront = '/discovery/storefront';

  /// The sub-path segment registered on the nested GoRoute (relative to
  /// [discovery]) — use [storefront] for navigation.
  static const storefrontSubPath = 'storefront';
  static const termsAndConditions = '/terms-and-conditions';
  static const privacyPolicy = '/privacy-policy';
  static const selectAddress = '/select-address';

  /// The address being edited travels via GoRouter's `extra` (a full
  /// address entity, not just an id) — Select Address already holds the
  /// whole list in memory, so re-fetching by id would be redundant, and
  /// `null` (Add New Address) has no id to encode in the path anyway.
  static const addressForm = '/address-form';

  /// The current profile travels via GoRouter's `extra` — same reasoning as
  /// [addressForm]. Unlike Address, there's no "add" case: a profile always
  /// exists, so `extra` is never null here.
  static const editProfile = '/edit-profile';
  static const changePassword = '/change-password';
  static const cart = '/cart';

  /// The chosen delivery address travels via GoRouter's `extra` — the Cart
  /// gates on Select Address before pushing, so Checkout never opens without
  /// one and never has to re-fetch the list to find it.
  ///
  /// `dailymart` only: `gravia` has no checkout frame yet and still runs the
  /// flow inline from its Cart screen, so this route needs no template
  /// switch until that changes.
  static const checkout = '/checkout';
  static const notifications = '/notifications';

  /// `grofast` only: that template reaches its wishlist as a pushed route off
  /// Profile (as its kit does), while `gravia` and `dailymart` both give it a
  /// nav tab and so never need a route for it.
  static const wishlist = '/wishlist';

  /// `dailymart` only, same reasoning as [checkout]: gravia reaches its
  /// orders through a shell tab, so there is no gravia page to switch to
  /// until that changes.
  static const orders = '/orders';

  /// The order being tracked travels via GoRouter's `extra` — My Orders
  /// already holds the whole list in memory, so re-fetching one by id would
  /// be redundant. `dailymart` only, same as [orders].
  static const trackOrder = '/track-order';

  /// Route pattern registered with GoRouter (`:id` path param).
  static const productDetails = '/product-details/:id';

  /// Concrete path for navigating to a specific product — use this with
  /// `context.push`/`context.go`, not [productDetails] (that's the pattern).
  static String productDetailsPath(String id) => '/product-details/$id';

  /// Route pattern registered with GoRouter (`:id` path param). The
  /// category's display name travels as a query param — GoRouter path
  /// params can't carry a value with spaces/punctuation cleanly, and the
  /// name is display-only (the mock data source ignores it, keying only on
  /// id) so a query param is the right fit, not the route pattern itself.
  static const categoryDetails = '/category-details/:id';

  /// Concrete path for navigating to a specific category — use this with
  /// `context.push`/`context.go`, not [categoryDetails] (that's the pattern).
  static String categoryDetailsPath(String id, String name) =>
      '/category-details/$id?name=${Uri.encodeQueryComponent(name)}';
}
