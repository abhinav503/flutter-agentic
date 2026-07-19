abstract final class AppRoutes {
  static const splash = '/';
  static const onboarding = '/onboarding';
  static const login = '/login';
  static const signup = '/signup';
  static const home = '/home';
  static const search = '/search';
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
  static const notifications = '/notifications';
  static const termsAndConditions = '/terms-and-conditions';
  static const privacyPolicy = '/privacy-policy';

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
