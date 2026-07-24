abstract final class ApiConstants {
  static const String baseUrl = 'https://admin-beryl-kappa-44.vercel.app/api';

  /// Store-agnostic — a shopper's identity/profile isn't scoped to one
  /// store, unlike a store-specific catalog/cart/order call.
  static String get usersPath => '$baseUrl/users';

  /// Store discovery — GET (optionally `?q=`) lists/searches every active
  /// store. This app has no single hardcoded storeId (unlike gravia) since
  /// choosing one is the whole point of feature/home.
  static String get storesPath => '$baseUrl/stores';
}
