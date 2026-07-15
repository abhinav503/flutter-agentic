abstract final class ValueConst {
  static const appTitle = 'Gravia';

  // ── Splash wordmark (black type; the middle glyph is the brand SVG) ──────
  static const splashWordmarkLeft = 'GR';
  static const splashWordmarkRight = 'VIA';

  // ── Bottom navigation (kit tab set) ───────────────────────────────────────
  static const navHome = 'Home';
  static const navCategories = 'Categories';
  static const navFavourite = 'Favourite';
  static const navOrders = 'Orders';
  static const navProfile = 'Profile';

  // ── Onboarding (3-slide first-launch carousel) ────────────────────────────
  static const onboardingTitle1 =
      'Fresh Groceries Delivered Right to Your Doorstep';
  static const onboardingSubtitle1 =
      'Shop fresh fruits, vegetables, and daily essentials anytime.';
  static const onboardingTitle2 = 'Everything You Need in Just a Few Taps';
  static const onboardingSubtitle2 =
      'Browse categories, add to cart, and order in seconds.';
  static const onboardingTitle3 = 'Fast and Reliable Grocery Delivery';
  static const onboardingSubtitle3 =
      'Get your groceries delivered quickly and safely.';
  static const onboardingNext = 'Next';
  static const onboardingGetStarted = 'Get Started';

  // ── Home (storefront) ──────────────────────────────────────────────────────
  static const deliveryLocationLabel = 'Delivery Location';
  static const deliveryLocationAddress =
      'Ranchview Dr. Richardson, California 62639';
  static const searchHint = 'Search';
  static const allCategoriesTitle = 'All Categories';
  static const popularItemsTitle = 'Popular Items';
  static const seeAll = 'See All';
  static const addToCart = 'Add To Cart';
  static const addToCartSheetTitle = 'Add to Cart';
  static const cancel = 'Cancel';
  static const comingSoonMessage = 'Coming soon';
  static const homeLoadErrorMessage =
      'Something went wrong loading the storefront.';
  static String addedToCartMessage(String productName, int quantity) =>
      quantity > 1
          ? '$quantity × $productName added to cart'
          : '$productName added to cart';

  // ── Search ─────────────────────────────────────────────────────────────────
  static const recentSearchTitle = 'Recent Search';
  static const searchLoadErrorMessage =
      'Something went wrong loading search.';

  // ── Product Details ────────────────────────────────────────────────────────
  static const productDetailsTitle = 'Product Details';
  static const selectQtyLabel = 'Select QTY';
  static const keyInformationTitle = 'Key Information';
  static const readMore = 'Read More';
  static const readLess = 'Read Less';
  static const similarProductsTitle = 'Similar Products';
  static const productDetailsLoadErrorMessage =
      'Something went wrong loading this product.';
  static String addToCartWithPrice(double price) =>
      'Add to Cart (\$${price.toStringAsFixed(2)})';

  // ── Placeholder tabs (removed as real screens land) ───────────────────────
  static const categoriesComingTitle = 'Categories coming soon';
  static const categoriesComingSubtitle =
      'Browse every aisle from one place.';
  static const favouriteEmptyTitle = 'No favourites yet';
  static const favouriteEmptySubtitle =
      'Tap the heart on a product to keep it here.';
  static const ordersEmptyTitle = 'No orders yet';
  static const ordersEmptySubtitle =
      'Your past and active orders will show up here.';
  static const profileComingTitle = 'Profile coming soon';
  static const profileComingSubtitle =
      'Addresses, payment, and settings will live here.';
}
