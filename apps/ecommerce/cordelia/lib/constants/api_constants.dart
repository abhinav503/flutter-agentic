abstract final class ApiConstants {
  static const String baseUrl = 'https://admin-beryl-kappa-44.vercel.app/api';

  /// Store-agnostic — a shopper's identity/profile isn't scoped to one
  /// store, unlike a store-specific catalog/cart/order call.
  static String get usersPath => '$baseUrl/users';

  /// This device's FCM token, filed under the signed-in shopper. POST
  /// registers or refreshes it; DELETE drops it on sign-out.
  static String get userDevicesPath => '$baseUrl/users/devices';

  /// Store discovery — GET (optionally `?q=`) lists/searches every active
  /// store. This app has no single hardcoded storeId (unlike gravia) since
  /// choosing one is the whole point of feature/home.
  static String get appConfigPath => '$baseUrl/app-config';
  static String get storesPath => '$baseUrl/stores';

  static String _storeBase(String storeId) => '$baseUrl/stores/$storeId';

  /// One store by id — public, like discovery. Needed because a notification
  /// tap carries only the store's id, and opening a storefront takes the
  /// whole store (name, template, language, currency).
  static String storePath(String storeId) => _storeBase(storeId);

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

  static String couponValidatePath(String storeId) =>
      '${_storeBase(storeId)}/coupons/validate';

  static String ordersPath(String storeId) => '${_storeBase(storeId)}/orders';

  static String paymentsPath(String storeId) =>
      '${_storeBase(storeId)}/payments';

  static String orderCancelPath(String storeId, String orderId) =>
      '${_storeBase(storeId)}/orders/$orderId/cancel';

  /// The shopper's rating of a delivered order — token-authed, and the
  /// server refuses anything that isn't the caller's own delivered order.
  static String orderReviewPath(String storeId, String orderId) =>
      '${_storeBase(storeId)}/orders/$orderId/review';

  static String favouritesPath(String storeId) =>
      '${_storeBase(storeId)}/favourites';

  /// GET returns this store's notifications merged with CordeliaApps'
  /// platform-wide feed; POST marks ids read for the caller. One path for
  /// both because they are the same list read and acknowledged.
  static String notificationsPath(String storeId) =>
      '${_storeBase(storeId)}/notifications';

  static String categoryProductsPath(String storeId, String categoryId) =>
      '${_storeBase(storeId)}/categories/$categoryId/products';

  static String productDetailsPath(String storeId, String productId) =>
      '${_storeBase(storeId)}/products/$productId';

  /// A product's reviews. GET is public (a rating is part of a product's
  /// public face); POST/DELETE are token-authed and act on the caller's own
  /// review — one path, three verbs.
  static String productReviewsPath(String storeId, String productId) =>
      '${productDetailsPath(storeId, productId)}/reviews';

  /// Reporting someone else's review, and optionally blocking its author.
  /// [reviewUid] is the author's uid — a review's id is who wrote it.
  static String reportReviewPath(
    String storeId,
    String productId,
    String reviewUid,
  ) => '${productReviewsPath(storeId, productId)}/$reviewUid/report';

  /// Store-agnostic like [usersPath]; token-authed (no userId param).
  static String get addressesPath => '$baseUrl/users/addresses';

  static String addressPath(String addressId) =>
      '$baseUrl/users/addresses/$addressId';

  /// Pincode → city/state for the address form — store-agnostic and
  /// token-authed like [addressesPath]; the server proxies India Post so
  /// the app has one code path and web builds dodge CORS.
  ///
  /// Reverse geocoding and place search used to sit beside this against an
  /// Ola Maps proxy. Both are now the device's own geocoder — no key, no
  /// quota, and it works outside India, which Ola does not.
  static String geoPincodePath(String pincode) =>
      '$baseUrl/geo/pincode/$pincode';
}
