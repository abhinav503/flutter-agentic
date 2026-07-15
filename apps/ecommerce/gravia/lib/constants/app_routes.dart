abstract final class AppRoutes {
  static const splash = '/';
  static const onboarding = '/onboarding';
  static const home = '/home';
  static const search = '/search';

  /// Route pattern registered with GoRouter (`:id` path param).
  static const productDetails = '/product-details/:id';

  /// Concrete path for navigating to a specific product — use this with
  /// `context.push`/`context.go`, not [productDetails] (that's the pattern).
  static String productDetailsPath(String id) => '/product-details/$id';
}
