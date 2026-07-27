/// Copy used only by the `gravia` template's storefront screens — scoped
/// here rather than the app-wide `ValueConst` so a second template can have
/// its own wording without touching this one.
abstract final class GraviaValueConst {
  // ── Home ─────────────────────────────────────────────────────────────────
  static const categoriesTitle = 'All Categories';
  static const seeAll = 'See All';
  static const popularItemsTitle = 'Popular Items';
  static const homeLoadErrorMessage = "Couldn't load this store's catalog.";

  // ── Shared sheet chrome / actions (gravia_sheet.dart, action pair) ───────
  static const cancel = 'Cancel';

  // ── Product card (GraviaProductCard, shared across screens) ──────────────
  static String formattedPrice(double price) => '\$${price.toStringAsFixed(2)}';
  static String discountPercentLabel(double percentage) =>
      '${percentage.toStringAsFixed(0)}%';
  static String discountPercentOffLabel(double percentage) =>
      '${percentage.toStringAsFixed(0)}% OFF';
  static const addToCart = 'Add To Cart';
  static const addToCartSheetTitle = 'Add to Cart';

  // ── Delete-address confirm sheet ──────────────────────────────────────────
  static const deleteLabel = 'Delete';
  static const deleteAddressTitle = 'Delete Address';
  static const deleteAddressConfirmMessage =
      'Are you sure you want to delete this address? This action cannot be undone.';

  // ── Clear-cart confirm sheet ──────────────────────────────────────────────
  static const clearCartTitle = 'Clear Cart';
  static const clearCartConfirmMessage =
      'Are you sure you want to remove all items from your cart?';
  static const clearCartConfirmLabel = 'Clear Cart';

  // ── Order Placed (checkout confirmation sheet) ────────────────────────────
  static const orderPlacedTitle = 'Order Placed Successfully';
  static const orderPlacedSubtitle =
      'Thank you for your order you can track your delivery in the order section';
  static const trackYourOrderLabel = 'Track Your Order';

  // ── Search ───────────────────────────────────────────────────────────────
  static const searchHint = 'Search';

  // ── Bottom navigation (kit tab set) ───────────────────────────────────────
  static const navHome = 'Home';
  static const navCategories = 'Categories';
  static const navFavourite = 'Favourite';
  static const navOrders = 'Orders';
  static const navProfile = 'Profile';

  // ── Search ─────────────────────────────────────────────────────────────────
  static const recentSearchTitle = 'Recent Search';
  static const searchLoadErrorMessage = 'Something went wrong loading search.';
  static const searchResultsErrorMessage = 'Something went wrong searching.';
  static const searchCategoryBadge = 'Category';
  static const searchNoResultsTitle = 'No results found';
  static String searchNoResultsSubtitle(String query) =>
      'Nothing matches "$query". Try a different keyword.';

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
  static const categoriesRefreshFailedMessage =
      "Couldn't refresh — showing your last loaded categories.";

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
  static const addressLoadErrorMessage =
      'Something went wrong loading your addresses.';
  static const addressSaveFailedMessage =
      'Could not save the address. Please try again.';
  static const addressDeleteFailedMessage =
      'Could not delete the address. Please try again.';
  static const addressEmptyTitle = 'No saved addresses';
  static const addressEmptySubtitle =
      'Add your first delivery address to get started.';

  // ── Add/Edit Address ───────────────────────────────────────────────────────
  static const editAddressTitle = 'Edit Address';
  static const nameLabel = 'Name';
  static const nameHint = 'e.g. Mark Shelby';
  static const phoneNumberLabel = 'Phone Number';
  static const phoneNumberHint = 'e.g. (303) 555-0105';
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

  // ── Profile ────────────────────────────────────────────────────────────────
  static const profilePageTitle = 'Profile';
  static const changePasswordLabel = 'Change Password';
  static const myOrdersLabel = 'My Orders';
  static const myAddressLabel = 'My Address';
  static const darkModeLabel = 'Dark Mode';
  static const privacyPolicyLabel = 'Privacy Policy';
  static const termsAndConditionsLabel = 'Terms & Conditions';
  static const logoutLabel = 'Logout';
  static const logoutTitle = 'Logout';
  static const logoutConfirmMessage = 'Are you sure you want to log out?';
  static const profileLoadErrorMessage =
      'Something went wrong loading your profile.';

  // ── Edit Profile ───────────────────────────────────────────────────────────
  static const editProfileTitle = 'Edit Profile';
  static const emailAddressLabel = 'Email Address';
  static const emailAddressHint = 'e.g. mark.shelby@example.com';
  static const mobileNumberLabel = 'Mobile Number';
  static const updateProfileButtonLabel = 'Update';
  static const changePhotoTitle = 'Change Photo';
  static const takePhotoLabel = 'Take Photo';
  static const chooseFromGalleryLabel = 'Choose from Gallery';
  static const avatarPickerMobileOnlyMessage =
      'Changing your photo is only available on mobile';

  // ── Change Password ──────────────────────────────────────────────────────
  static const changePasswordTitle = 'Change Password';
  static const currentPasswordLabel = 'Current Password';
  static const currentPasswordHint = 'Enter your current password';
  static const newPasswordLabel = 'New Password';
  static const newPasswordHint = 'Enter your new password';
  static const confirmNewPasswordLabel = 'Confirm New Password';
  static const confirmNewPasswordHint = 'Re-enter your new password';
  static const updatePasswordButtonLabel = 'Update Password';
  static const passwordUpdatedMessage = 'Your password has been updated.';

  // ── Cart ───────────────────────────────────────────────────────────────────
  static const myCartTitle = 'My Cart';
  static const beforeYouCheckoutTitle = 'Before you Checkout';
  static const couponCodeLabel = 'Coupon Code';
  static const applyLabel = 'Apply';
  static const itemTotalLabel = 'Item Total';
  static const discountLabel = 'Discount';
  static const deliveryLabel = 'Delivery';
  static const deliveryFreeLabel = 'FREE';
  static const grandTotalLabel = 'Grand Total';
  static const proceedToCheckoutLabel = 'Proceed to Checkout';
  static const cartEmptyTitle = 'Your cart is empty';
  static const cartEmptySubtitle = 'Add items to get started.';
  static const cartBarTitle = 'See more products';
  static const exploreLabel = 'Explore';
  static const checkoutLabel = 'Checkout';
  static String cartSummaryLabel(int itemCount, double total) =>
      '$itemCount item${itemCount > 1 ? 's' : ''} | \$${total.toStringAsFixed(2)}';

  // ── Payment (provider-agnostic copy) ─────────────────────────────────────
  static const paymentCancelledMessage = 'Payment cancelled';
  static const paymentFailedMessage =
      'Payment could not be completed. Please try again.';

  // ── Orders ─────────────────────────────────────────────────────────────────
  static const ordersPageTitle = 'Orders';
  static const upcomingTabLabel = 'Upcoming';
  static const pastTabLabel = 'Past';
  static const pendingStatusLabel = 'Order Placed';
  static const inProcessStatusLabel = 'On the way';
  static const deliveredStatusLabel = 'Delivered';
  static const cancelledStatusLabel = 'Cancelled';
  static const deliveryOtpLabel = 'Delivery OTP';
  static const cancelOrderLabel = 'Cancel';
  static const trackOrderLabel = 'Track Order';
  static const viewDetailsLabel = 'View Details';
  static const writeReviewLabel = 'Write A Review';

  // Refund state shown on a cancelled order card. No label for RefundStatus.none
  // — an unpaid/test order had no money to return, so nothing is shown.
  static const refundPendingLabel = 'Refund processing';
  static const refundProcessedLabel = 'Refunded';
  static const refundFailedLabel = 'Refund failed';

  // Cancel confirmation + outcome.
  static const cancelOrderConfirmTitle = 'Cancel this order?';
  static const cancelOrderConfirmBody =
      'This will cancel your order. If you paid, you\'ll be refunded in full.';
  static const cancelOrderConfirmCta = 'Cancel Order';
  static const cancelOrderDismissCta = 'Keep Order';
  static const cancelFailedMessage =
      'Could not cancel the order. Please try again.';
  static String weightQuantityLabel(String weight, int quantity) =>
      '$weight × $quantity';
  static const ordersLoadErrorMessage =
      'Something went wrong loading your orders.';
  static const ordersRefreshFailedMessage =
      "Couldn't refresh — showing your last loaded orders.";
  static const ordersEmptyTitle = 'No orders yet';
  static const ordersEmptySubtitle =
      'Your past and active orders will show up here.';
  static const filterSheetTitle = 'Filter';
  static const filterReasonHeading = 'Select a Reason';
  static const filterLastWeekLabel = 'Last Week';
  static const filterLastMonthLabel = 'Last Month';
  static const filterStatusLabel = 'Status';
  static const filterDateLabel = 'Date';
  static const filterAllStatusesLabel = 'All';
  static const applyFilterLabel = 'Apply Filter';
  static String filterDateRangeLabel(String from, String to) => '$from - $to';

  // ── Favourite tab ───────────────────────────────────────────────────────
  static const favouritePageTitle = 'Favourite';
  static const favouriteEmptyTitle = 'No favourites yet';
  static const favouriteEmptySubtitle =
      'Tap the heart on a product to keep it here.';

  static String addedToCartMessage(String productName, int quantity) =>
      quantity > 1
      ? '$quantity × $productName added to cart'
      : '$productName added to cart';

  static const deliveryLocationLabel = 'Delivery Location';
  static const noLocationSelectedLabel = 'No Location selected';

  // ── Notifications ──────────────────────────────────────────────────────────
  static const notificationsTitle = 'Notifications';
  static const notificationsLoadErrorMessage =
      'Something went wrong loading your notifications.';
  static const notificationsEmptyTitle = 'No notifications yet';
  static const notificationsEmptySubtitle =
      'Updates about your orders and account will show up here.';

  // ── Splash wordmark (black type; the middle glyph is the brand SVG) ──────
  static const splashWordmarkLeft = 'GR';
  static const splashWordmarkRight = 'VIA';
}
