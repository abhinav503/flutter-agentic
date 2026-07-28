abstract final class ApiConstants {
  static const String baseUrl = 'https://admin-beryl-kappa-44.vercel.app/api';

  /// Store-agnostic — a shopper's identity/profile isn't scoped to one
  /// store, unlike a store-specific catalog/cart/order call.
  static String get usersPath => '$baseUrl/users';

  /// Store discovery — GET (optionally `?q=`) lists/searches every active
  /// store. This app has no single hardcoded storeId (unlike gravia) since
  /// choosing one is the whole point of feature/home.
  static String get storesPath => '$baseUrl/stores';

  static String _storeBase(String storeId) => '$baseUrl/stores/$storeId';

  /// Per-store paths take storeId as a call parameter (not a getter off a
  /// hardcoded constant, unlike gravia's ApiConstants) — this app serves
  /// many stores from one binary, so storeId is only known at the call
  /// site (threaded from ActiveStoreCubit), never fixed per build.
  static String categoriesPath(String storeId) =>
      '${_storeBase(storeId)}/categories';

  static String popularProductsPath(String storeId) =>
      '${_storeBase(storeId)}/products/popular';

  /// Live promo banners for the storefront's home carousel, in admin-set
  /// order — the API filters out hidden ones, so the client shows what it gets.
  static String bannersPath(String storeId) => '${_storeBase(storeId)}/banners';


  static String searchPath(String storeId) => '${_storeBase(storeId)}/search';

  static String recentSearchesPath(String storeId) =>
      '${_storeBase(storeId)}/search/recent';

  static String cartPath(String storeId) => '${_storeBase(storeId)}/cart';

  static String ordersPath(String storeId) => '${_storeBase(storeId)}/orders';

  static String paymentsPath(String storeId) =>
      '${_storeBase(storeId)}/payments';

  static String orderCancelPath(String storeId, String orderId) =>
      '${_storeBase(storeId)}/orders/$orderId/cancel';

  static String favouritesPath(String storeId) =>
      '${_storeBase(storeId)}/favourites';

  static String categoryProductsPath(String storeId, String categoryId) =>
      '${_storeBase(storeId)}/categories/$categoryId/products';

  static String productDetailsPath(String storeId, String productId) =>
      '${_storeBase(storeId)}/products/$productId';

      /// Store-agnostic like [usersPath]; token-authed (no userId param).
  static String get addressesPath => '$baseUrl/users/addresses';

  static String addressPath(String addressId) =>
      '$baseUrl/users/addresses/$addressId';
}
