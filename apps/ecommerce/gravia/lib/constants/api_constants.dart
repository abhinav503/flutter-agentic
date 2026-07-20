abstract final class ApiConstants {
  static const String baseUrl = 'https://admin-beryl-kappa-44.vercel.app/api';

  /// Hardcoded to the one seeded "Gravia" store until store discovery
  /// (browsing/switching between stores) exists — see the "Missing flows"
  /// and M3 sections of docs/explanation/superapp-ecommerce-plan.md.
  static const String storeId = '4116e313-a173-4f9f-b471-8bc92ab8437d';

  static String get _storeBase => '$baseUrl/stores/$storeId';

  static String get categoriesPath => '$_storeBase/categories';
  static String get popularProductsPath => '$_storeBase/products/popular';
  static String get searchPath => '$_storeBase/search';
  static String get recentSearchesPath => '$_storeBase/search/recent';
  static String get cartPath => '$_storeBase/cart';
  static String get ordersPath => '$_storeBase/orders';

  static String categoryProductsPath(String categoryId) =>
      '$_storeBase/categories/$categoryId/products';

  static String productDetailsPath(String productId) =>
      '$_storeBase/products/$productId';

  /// Store-agnostic — a shopper's profile isn't scoped to one store's data,
  /// unlike everything else in this file.
  static String get usersPath => '$baseUrl/users';
}
