import 'package:core/core/extensions/num_extensions.dart';

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

  // ── Notifications ────────────────────────────────────────────────────────
  /// Singular, as the kit titles it.
  static const notificationsTitle = 'Notification';
  static const notificationsLoadErrorMessage =
      "Couldn't load your notifications.";
  static const notificationsEmptyTitle = 'No notifications yet';
  static const notificationsEmptySubtitle =
      'Deals and order updates from this store will show up here.';

  // ── Promo card ───────────────────────────────────────────────────────────
  static const orderNow = 'Order Now';
  static String promoSubtitle(double discountPercentage) =>
      'Enjoy discounts of up to ${discountPercentage.asPercent}%\non your order today';

  // ── Product card ─────────────────────────────────────────────────────────
  static String formattedPrice(double price) => price.asPrice;
  static String discountPercentOffLabel(double percentage) =>
      '${percentage.asPercent}% off';

  /// **Placeholder.** The kit shows a rating + review count on every card and
  /// the layout is built around that row, but neither value exists on
  /// `ProductEntity` yet (the admin catalog doesn't collect reviews) — so
  /// every card renders the kit's own numbers verbatim.
  ///
  /// This is the one piece of invented copy in the pack. When reviews land,
  /// replace it with a `ratingLabel(rating, reviewCount)` formatter and take
  /// the values off the entity; the row's geometry does not change.
  static const staticRatingLabel = '4.9 (345)';

  // ── Bottom navigation (kit tab set) ──────────────────────────────────────
  static const navHome = 'Home';
  static const navWishlist = 'Wishlist';
  static const navCart = 'Cart';
  static const navProfile = 'Profile';

  // ── Search ───────────────────────────────────────────────────────────────
  static const recentSearchTitle = 'Recent Search';
  static const recentlyViewedTitle = 'Recently viewed';
  static String resultsForLabel(String query) => 'Result for "$query"';

  /// The kit's own wording — "founds", not "found" (screen `20 Search
  /// product [result]`). Reproduced verbatim so the screen matches the pack.
  static String resultsCountLabel(int count) => '$count founds';
  static const searchLoadErrorMessage = "Couldn't load search.";
  static const searchResultsErrorMessage = "Couldn't search this store.";
  static const searchNoResultsTitle = 'No results';
  static String searchNoResultsSubtitle(String query) =>
      'Nothing in this store matches "$query" yet.';
  static const categoryBadge = 'Category';
  static const filterLabel = 'Filter';
  static const sortSheetTitle = 'Sort by';
  static const sortRelevance = 'Recommended';
  static const sortPriceLowToHigh = 'Price: Low to High';
  static const sortPriceHighToLow = 'Price: High to Low';
  static const sortNameAtoZ = 'Name: A to Z';

  // ── Product details ──────────────────────────────────────────────────────
  static const productDetailsTitle = 'Product Details';
  static const descriptionsTabLabel = 'Descriptions';
  static const reviewsTabLabel = 'Reviews';
  static const relatedProductsTitle = 'Related Products';
  static const productDetailsLoadErrorMessage =
      "Couldn't load this product's details.";
  static String perUnitSuffix(String unit) => '/$unit';

  // ── Add to cart ──────────────────────────────────────────────────────────
  static const addToCart = 'Add To Cart';
  static const addToCartSheetTitle = 'Add To Cart';
  static String addedToCartMessage(String name, int quantity) =>
      'Added $quantity × $name to your cart.';

  /// The static Reviews tab (kit screen `23 Review product`) — the store
  /// backend collects no reviews yet, so the whole tab renders the kit's own
  /// copy verbatim, same policy as [staticRatingLabel].
  static const staticReviewScore = '5.0/5.0';
  static const staticReviewCount = '1.53K Reviews';
  static String starRowLabel(int stars) => '$stars Star';
  static const staticReviewerName = 'Shane Watson';
  static const staticReviewAge = '1 day ago';
  static const staticReviewText =
      'It is a long established fact that a reader will be distracted by the '
      'readable content of a page when looking at its layout.';
  static const staticReviewLikes = '135';
  static const staticReviewDislikes = '10';

  // ── Cart ─────────────────────────────────────────────────────────────────
  static const myCartTitle = 'My Cart';
  static const couponLabel = 'BLACKFRIDAY';
  static const subTotalLabel = 'Sub total';
  static const deliveryLabel = 'Delivery';
  static const deliveryFreeLabel = 'Free';
  static const discountLabel = 'Discount';
  static const totalCostLabel = 'Total cost';
  static const proceedToCheckoutLabel = 'Proceed to Checkout';
  static const cartEmptyTitle = 'Your cart is empty';
  static const cartEmptySubtitle =
      'Products you add will show up here, ready to check out.';
  static const cartExploreAction = 'Start shopping';
  static const removedFromCartMessage = 'Removed from your cart.';

  // ── Checkout (kit frames `29 Checkout` / `34 Order Successfully`) ─────────
  /// One title for both states — the kit keeps the header row identical
  /// across the form and the success frame.
  static const checkoutTitle = 'Checkout';
  static const shippingAddressLabel = 'Shipping Address';
  static const orderListLabel = 'Order List';
  static const continueToPaymentLabel = 'Continue to Payment';

  /// Beside each order line, in the slot the Cart's stepper occupies — the
  /// quantity is fixed by this point, so it reads rather than adjusts.
  static String orderLineQuantity(int quantity) => '× $quantity';

  static const orderPlacedTitle = 'Payment Successful!';
  static const orderPlacedMessage =
      "Thank you for your purchase! We're excited to let you know that your "
      'payment has been successfully processed. 🎉';
  /// The success frame's one CTA. The kit stacks this over an "E-Receipt"
  /// outline button; that half is dropped — there is no receipt document to
  /// open, and a second CTA that only apologises weakens the real one.
  static const trackOrderLabel = 'Track My Order';

  /// The docked cart status pill on screens pushed outside the shell (the
  /// cart tab itself is the in-shell affordance).
  static String cartSummaryLabel(int count, double total) =>
      '$count ${count.plural('item')} | ${formattedPrice(total)}';
  static const viewCartLabel = 'View Cart';

  // ── Profile ──────────────────────────────────────────────────────────────
  /// The kit groups the rows under "General" and "Preferencess" — the second
  /// is a kit typo and is not reproduced.
  static const generalSectionTitle = 'General';
  static const preferencesSectionTitle = 'Preferences';

  /// The row set is gravia's, not the kit's — same titles, same actions,
  /// only the row silhouette is this pack's (the kit's own list offers
  /// Security / Language / Help & Support, none of which this app has).
  static const editProfileLabel = 'Edit Profile';
  static const changePasswordLabel = 'Change Password';
  static const myOrdersLabel = 'My Orders';
  static const myAddressLabel = 'My Address';
  static const darkModeLabel = 'Dark Mode';
  static const privacyPolicyLabel = 'Privacy Policy';
  static const termsAndConditionsLabel = 'Terms & Conditions';
  static const logoutLabel = 'Logout';
  static const logoutTitle = 'Log out?';
  static const logoutConfirmMessage =
      "You'll need to sign in again to place an order or track one.";
  static const profileLoadErrorMessage = "Couldn't load your profile.";

  // ── Edit Profile ─────────────────────────────────────────────────────────
  static const editProfileTitle = 'Edit Profile';
  static const fullNameLabel = 'Full Name';
  static const fullNameHint = 'Enter your full name';
  static const emailLabel = 'Email';
  static const emailHint = 'you@example.com';
  static const phoneNumberLabel = 'Phone Number';
  static const phoneNumberHint = 'Enter your phone number';

  /// The kit's own CTA wording on this screen.
  static const saveChangesLabel = 'Save Changes';
  static const changePhotoTitle = 'Change Photo';
  static const takePhotoLabel = 'Take Photo';
  static const chooseFromGalleryLabel = 'Choose from Gallery';
  static const avatarPickerMobileOnlyMessage =
      'Choosing a photo is only available on mobile.';

  // ── Change Password ──────────────────────────────────────────────────────
  /// The kit's Profile list has no Change Password screen behind its
  /// Security row, so this reuses gravia's wording — only the silhouette
  /// (header row, bordered fields, floating CTA) is this pack's.
  static const changePasswordTitle = 'Change Password';
  static const currentPasswordLabel = 'Current Password';
  static const currentPasswordHint = 'Enter your current password';
  static const newPasswordLabel = 'New Password';
  static const newPasswordHint = 'Enter your new password';
  static const confirmNewPasswordLabel = 'Confirm New Password';
  static const confirmNewPasswordHint = 'Re-enter your new password';
  static const updatePasswordButtonLabel = 'Update Password';
  static const passwordUpdatedMessage = 'Your password has been updated.';

  // ── Select Address ───────────────────────────────────────────────────────
  static const selectAddressTitle = 'Select Address';
  static const addNewAddressLabel = 'Add New Address';
  static const addressLoadErrorMessage = "Couldn't load your addresses.";
  static const addressSaveFailedMessage = "Couldn't save that address.";
  static const addressEmptyTitle = 'No saved addresses';
  static const addressEmptySubtitle =
      'Add one to get this store delivering to your door.';
  static const addressDeleteFailedMessage = "Couldn't delete that address.";
  static const editAddressTooltip = 'Edit address';
  static const deleteAddressTitle = 'Delete this address?';
  static const deleteAddressMessage =
      "It'll be removed from your saved addresses.";
  static const deleteLabel = 'Delete';

  // ── Add / Edit Address ───────────────────────────────────────────────────
  // Deliberately a second copy of gravia's labels rather than a shared set:
  // pack copy lives with the pack, so this template can reword a field
  // without editing gravia's screens (spec sheet §13).
  static const addAddressTitle = 'Add New Address';
  static const editAddressTitle = 'Edit Address';
  static const addressNameLabel = 'Name';
  static const addressNameHint = 'e.g. Mark Shelby';
  static const addressLine1Label = 'Address Line 1';
  static const addressLine1Hint = 'House no., street name';
  static const addressLine2Label = 'Address Line 2';
  static const addressLine2Hint = 'Apartment, suite, etc. (optional)';
  static const landmarkLabel = 'Landmark';
  static const landmarkHint = 'Nearby landmark (optional)';
  static const cityLabel = 'City';
  static const selectCityTitle = 'Select City';
  static const countryLabel = 'Country';
  static const selectCountryTitle = 'Select Country';
  static const postalCodeLabel = 'Postal Code';
  static const postalCodeHint = 'e.g. 62639';
  static const addressTagLabel = 'Tag';
  static const addressTagHint = 'e.g. Home, Office';
  static const addAddressButtonLabel = 'Add Address';
  static const updateAddressButtonLabel = 'Update Address';
  static const requiredFieldErrorMessage = 'This field is required';

  static const addressFormCities = <String>[
    'Richardson',
    'Allentown',
    'San Jose',
    'New York',
    'Los Angeles',
    'Chicago',
    'Houston',
  ];
  static const addressFormCountries = <String>[
    'United States',
    'Canada',
    'United Kingdom',
    'Australia',
    'India',
  ];

  // ── Cancel / confirm ─────────────────────────────────────────────────────
  static const cancelLabel = 'Cancel';

  // ── Tabs not yet ported to this template ─────────────────────────────────
  static const comingSoonTitle = 'Coming soon';
  static String comingSoonSubtitle(String tab) =>
      "$tab hasn't been built for the DailyMart storefront yet.";
  static const comingSoonAction = 'Back to Home';
}
