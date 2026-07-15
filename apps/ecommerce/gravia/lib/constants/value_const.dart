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
  static const noLocationSelectedLabel = 'No Location selected';
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

  // ── Categories ─────────────────────────────────────────────────────────────
  static const categoriesPageTitle = 'Categories';
  static const categoriesLoadErrorMessage =
      'Something went wrong loading categories.';

  // ── Category Details ───────────────────────────────────────────────────────
  static const sortLabel = 'Sort';
  static const priceLabel = 'Price';
  static const sortBySheetTitle = 'Sort by';
  static const priceSheetTitle = 'Price';
  static const categoryDetailsEmptyMessage = 'No products match these filters.';

  // ── Select Address ─────────────────────────────────────────────────────────
  static const selectAddressTitle = 'Select Address';
  static const addNewAddressLabel = 'Add New Address';
  static const defaultAddressSectionTitle = 'Default Address';
  static const otherAddressSectionTitle = 'Other Address';
  static const editLabel = 'Edit';
  static const deleteLabel = 'Delete';
  static const addressLoadErrorMessage =
      'Something went wrong loading your addresses.';

  // ── Profile ────────────────────────────────────────────────────────────────
  static const profilePageTitle = 'Profile';
  static const changePasswordLabel = 'Change Password';
  static const myOrdersLabel = 'My Orders';
  static const myCardsLabel = 'My Cards';
  static const myAddressLabel = 'My Address';
  static const darkModeLabel = 'Dark Mode';
  static const privacyPolicyLabel = 'Privacy Policy';
  static const termsAndConditionsLabel = 'Terms & Conditions';
  static const logoutLabel = 'Logout';
  static const profileLoadErrorMessage =
      'Something went wrong loading your profile.';

  // ── Placeholder tabs (removed as real screens land) ───────────────────────
  static const favouriteEmptyTitle = 'No favourites yet';
  static const favouriteEmptySubtitle =
      'Tap the heart on a product to keep it here.';
  static const ordersEmptyTitle = 'No orders yet';
  static const ordersEmptySubtitle =
      'Your past and active orders will show up here.';
}
