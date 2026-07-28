/// Copy used only by the `dailymart` template's storefront screens — scoped
/// here rather than the app-wide `ValueConst` so each template words its own
/// screens (same split as `GraviaValueConst`).
abstract final class DailyMartValueConst {
  // ── Home ─────────────────────────────────────────────────────────────────
  static const topSellerTitle = 'Top Seller🔥';
  static const categoriesTitle = 'Shop by category';
  static const popularProductsTitle = 'Popular Products';
  static const seeAll = 'See all';
  static const searchHint = 'Search for products';
  static const homeLoadErrorMessage = "Couldn't load this store's catalog.";
  static const noLocationSelectedLabel = 'Select a location';

  // ── Promo card ───────────────────────────────────────────────────────────
  static const orderNow = 'Order Now';
  static String promoSubtitle(double discountPercentage) =>
      'Enjoy discounts of up to ${discountPercentage.toStringAsFixed(0)}%\non your order today';

  // ── Product card ─────────────────────────────────────────────────────────
  static String formattedPrice(double price) => '\$${price.toStringAsFixed(2)}';
  static String discountPercentOffLabel(double percentage) =>
      '${percentage.toStringAsFixed(0)}% off';

  /// The kit shows a rating + review count on every card. Neither exists on
  /// `ProductEntity` yet (the admin catalog doesn't collect reviews), so the
  /// card omits the row rather than inventing numbers — see
  /// `DailyMartProductCard.rating`.
  static String ratingLabel(double rating, int reviewCount) =>
      '$rating ($reviewCount)';

  // ── Bottom navigation (kit tab set) ──────────────────────────────────────
  static const navHome = 'Home';
  static const navWishlist = 'Wishlist';
  static const navCart = 'Cart';
  static const navProfile = 'Profile';

  // ── Tabs not yet ported to this template ─────────────────────────────────
  static const comingSoonTitle = 'Coming soon';
  static String comingSoonSubtitle(String tab) =>
      "$tab hasn't been built for the DailyMart storefront yet.";
  static const comingSoonAction = 'Back to Home';
}
