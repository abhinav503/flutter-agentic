import 'package:core/core/extensions/num_extensions.dart';

// RefundStatus ships beside OrderStatus — one file, two axes of the same
// lifecycle.
import 'package:cordelia/enums/order_status.dart';
// For OrderPlacedAtX.asFilterDate — the order's own compact date form, so the
// card and the filter sheet can't drift into two date formats.
import 'package:cordelia/feature/storefront/orders/domain/entities/order_entity.dart';

/// Copy used only by the `grofast` template's storefront screens — scoped here
/// rather than the app-wide `ValueConst` so each template words its own
/// screens (same split as `GraviaValueConst` / `DailyMartValueConst`).
///
/// The voice is the kit's: lowercase inline links ("see all", "add new"),
/// grocery nouns ("bag", not "cart"), and sentence-case section headers.
abstract final class GrofastValueConst {
  // ── Home ─────────────────────────────────────────────────────────────────
  static String greeting(String name) => 'Hey $name 👋';
  static const greetingFallbackName = 'there';
  static const greetingSubtitle = 'Find fresh groceries you want';
  static const searchHint = 'Search fresh groceries';
  static const categoriesTitle = 'Categories';
  static const popularTitle = 'Popular';
  static const seeAll = 'see all';
  static const homeLoadErrorMessage = "Couldn't load this store's catalog.";
  static const noLocationSelectedLabel = 'Select a location';
  static const claimNow = 'claim now';
  static String promoDiscountLabel(double percentage) =>
      '${percentage.asPercent} off';

  // ── Categories ───────────────────────────────────────────────────────────
  static const categoriesLoadErrorMessage = "Couldn't load categories.";
  static const categoriesEmptyTitle = 'No categories yet';
  static const categoriesEmptySubtitle =
      'This store has not published any categories.';

  // ── Category details ─────────────────────────────────────────────────────
  static String categoryProductsTitle(String category) => 'All $category';
  static const categoryDetailsEmptyTitle = 'Nothing here yet';
  static const categoryDetailsEmptySubtitle =
      'No products in this category right now.';
  static const categoryDetailsErrorMessage = "Couldn't load this category.";

  // ── Search ───────────────────────────────────────────────────────────────
  static const searchTitle = 'Search Groceries';
  static const recentSearchTitle = 'Recent Search';
  static String resultsCountLabel(int count) =>
      'Found $count ${count.plural('Result')}';
  static const searchLoadErrorMessage = "Couldn't load search.";
  static const searchResultsErrorMessage = "Couldn't search this store.";
  static const searchNoResultsTitle = 'No results';
  static String searchNoResultsSubtitle(String query) =>
      'Nothing matched "$query". Try another word.';
  static const searchIdleTitle = 'What are you shopping for?';
  static const searchIdleSubtitle =
      'Search the whole store by name or category.';

  // ── Filter sheet (search + category details) ─────────────────────────────
  static const sortByTitle = 'Sort By';
  static const priceTitle = 'Price';
  static const applyLabel = 'Apply';
  static const resetLabel = 'Reset';

  // ── Product card / grid ──────────────────────────────────────────────────
  static String perUnitSuffix(String unit) => '/$unit';
  static const addToBagTooltip = 'Add to bag';
  static const favouriteTooltip = 'Save to wishlist';
  static const decreaseQuantityLabel = 'Decrease quantity';
  static const increaseQuantityLabel = 'Increase quantity';

  // ── Product details ──────────────────────────────────────────────────────
  static const productDetailsTitle = 'Product Details';
  static const descriptionTitle = 'Description';
  static const selectSizeTitle = 'Select Size';
  static const addToBag = 'Add to bag';
  static const productDetailsLoadErrorMessage =
      "Couldn't load this product right now.";
  static String addedToBagMessage(String name, int quantity) =>
      'Added $quantity × $name to your bag.';
  static const noDescriptionLabel = 'No description for this product yet.';

  /// **Placeholder**, the pack's only invented copy — same reasoning as
  /// dailymart's `staticRatingLabel`: the kit sets a rating badge beside the
  /// category on this screen, but no rating exists on `ProductEntity` (the
  /// admin catalog collects no reviews), so the badge renders the kit's own
  /// number. When reviews land, take the value off the entity and delete
  /// this; the badge's geometry does not change.
  static const staticRatingLabel = '4.7';

  // ── Bag (cart) ───────────────────────────────────────────────────────────
  static const bagTitle = 'My Bag';
  static String bagItemCount(int count) => '$count ${count.plural('item')}';
  static const promoCodeHint = 'Add Promo Code';
  static const promoApplyLabel = 'Apply';
  static const promoComingSoonMessage = 'Promo codes are coming soon.';
  static const totalLabel = 'Total';
  static const subtotalLabel = 'Subtotal';
  static const discountLabel = 'Discount';
  static const proceedToCheckoutLabel = 'Proceed To Checkout';
  static const bagEmptyTitle = 'Your bag is empty';
  static const bagEmptySubtitle =
      'Add some fresh groceries and they will show up here.';
  static const bagExploreAction = 'Start shopping';
  static const removedFromBagMessage = 'Removed from your bag.';

  // ── Checkout ─────────────────────────────────────────────────────────────
  static const checkoutTitle = 'Checkout';
  static const itemsTitle = 'Items';
  static const deliveryAddressTitle = 'Delievery Address';
  static const addNewLabel = 'add new';
  static const changeAddressLabel = 'change';
  static const noAddressSelectedLabel = 'Choose where to deliver';
  static const confirmOrderLabel = 'Confirm Order';
  static String orderLineQuantity(int quantity) => '× $quantity';

  // ── Order confirmed ──────────────────────────────────────────────────────
  static const orderPlacedTitle = 'Success!';
  static const orderPlacedMessage = 'You have successfully created your order.';
  static const browseHomeLabel = 'Browse Home';

  // ── Bottom nav ───────────────────────────────────────────────────────────
  static const navHome = 'Home';
  static const navCategories = 'Category';
  static const navBag = 'Bag';
  static const navAccount = 'Account';

  // ── Profile ──────────────────────────────────────────────────────────────
  static const profileTitle = 'Profile';
  static const notificationTileLabel = 'Notification';
  static const ordersTileLabel = 'My Orders';
  static const wishlistTileLabel = 'Wishlist';
  static const myProfileLabel = 'My Profile';
  static const changePasswordLabel = 'Change Password';
  static const darkModeLabel = 'Dark Mode';
  static const myAddressLabel = 'My Address';
  static const privacyPolicyLabel = 'Privacy Policy';
  static const termsAndConditionsLabel = 'Term and Condition';
  static const logOutLabel = 'Log Out';
  static const logOutTitle = 'Log out?';
  static const logOutConfirmMessage =
      "You'll need to sign in again to place an order.";
  static const profileLoadErrorMessage = "Couldn't load your profile.";
  static const profileNameFallback = 'Your account';

  // ── Edit profile ─────────────────────────────────────────────────────────
  static const editProfileTitle = 'My Profile';
  static const fullNameLabel = 'Full Name';
  static const fullNameHint = 'Enter your full name';
  static const emailLabel = 'Email';
  static const emailHint = 'you@example.com';
  static const phoneNumberLabel = 'Phone Number';
  static const phoneNumberHint = 'Enter your phone number';
  static const saveChangesLabel = 'Save Changes';
  static const changePhotoTitle = 'Change Photo';
  static const takePhotoLabel = 'Take Photo';
  static const chooseFromGalleryLabel = 'Choose from Gallery';
  static const avatarPickerMobileOnlyMessage =
      'Photo picking is only available on mobile.';
  static const profileUpdatedMessage = 'Your profile has been updated.';

  // ── Change password ──────────────────────────────────────────────────────
  static const changePasswordTitle = 'Change Password';
  static const currentPasswordLabel = 'Current Password';
  static const currentPasswordHint = 'Enter your current password';
  static const newPasswordLabel = 'New Password';
  static const newPasswordHint = 'Enter your new password';
  static const confirmNewPasswordLabel = 'Confirm New Password';
  static const confirmNewPasswordHint = 'Re-enter your new password';
  static const updatePasswordButtonLabel = 'Update Password';
  static const passwordUpdatedMessage = 'Your password has been updated.';

  // ── Wishlist ─────────────────────────────────────────────────────────────
  static const wishlistTitle = 'Wishlist';
  static const wishlistEmptyTitle = 'Nothing saved yet';
  static const wishlistEmptySubtitle =
      'Tap the heart on anything you want to keep for later.';
  static const wishlistExploreAction = 'Start shopping';

  // ── Notifications ────────────────────────────────────────────────────────
  static const notificationsTitle = 'Notification';
  static const notificationsFilterAllLabel = 'All';
  static const notificationsSearchHint = 'Search your Notification';
  static const notificationsNowTitle = 'Now';
  static const notificationsPastTitle = 'Past';
  static const notificationsLoadErrorMessage =
      "Couldn't load your notifications.";
  static const notificationsEmptyTitle = 'No notifications yet';
  static const notificationsEmptySubtitle =
      "We'll let you know when something happens with your orders.";
  static const notificationsNoResultsTitle = 'Nothing here';
  static String notificationsNoResultsSubtitle(String query) =>
      'No notification matches "$query".';

  // ── Select address ───────────────────────────────────────────────────────
  static const selectAddressTitle = 'Select Location';
  static const addNewAddressLabel = 'Add New Address';
  static const addressLoadErrorMessage = "Couldn't load your addresses.";
  static const addressEmptyTitle = 'No saved addresses';
  static const addressEmptySubtitle =
      'Add one so we know where to bring your groceries.';
  static const addressSaveFailedMessage = "Couldn't save that address.";
  static const addressDeleteFailedMessage = "Couldn't delete that address.";
  static const editAddressTooltip = 'Edit address';
  static const deleteAddressTitle = 'Delete this address?';
  static const deleteAddressMessage =
      "It will be removed from your saved locations. This can't be undone.";
  static const deleteLabel = 'Delete';
  static const cancelLabel = 'Cancel';

  // ── Address form ─────────────────────────────────────────────────────────
  static const addAddressTitle = 'Add New Address';
  static const editAddressTitle = 'Edit Address';
  static const addressNameLabel = 'Name';
  static const addressNameHint = 'e.g. Yona Angela';
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
  static const mobileLabel = 'Mobile Number';
  static const mobileHint = 'Where we can reach you';
  static const addAddressButtonLabel = 'Add Address';
  static const updateAddressButtonLabel = 'Update Address';
  static const requiredFieldErrorMessage = 'This field is required';

  /// The picklists behind the City / Country fields. Same shape as the other
  /// packs': the backend stores free text, so these are a convenience list,
  /// not an enum.
  static const addressFormCities = <String>[
    'Bengaluru',
    'Chennai',
    'Delhi',
    'Hyderabad',
    'Jakarta',
    'Kolkata',
    'Mumbai',
    'Pune',
  ];

  static const addressFormCountries = <String>['India', 'Indonesia'];

  // ── My Orders ────────────────────────────────────────────────────────────
  static const myOrdersTitle = 'My Orders';
  static const ordersSearchHint = 'Search your orders';
  static const ordersFilterAllLabel = 'All';
  static const ordersFilterActiveLabel = 'On Delivery';
  static const ordersFilterCompletedLabel = 'Delivered';
  static const ordersFilterCancelledLabel = 'Canceled';

  /// The filter square's sheet. Dates only — the status axis is already on
  /// the screen as the chip row, and asking for it twice lets the two
  /// disagree (same call as dailymart's sheet).
  static const ordersDateFilterTitle = 'Filter by date';
  static const ordersDateRangeLabel = 'Date Range';
  static const ordersAllTimeLabel = 'All time';
  static String ordersDateRangeValue(DateTime from, DateTime to) =>
      '${from.asFilterDate} - ${to.asFilterDate}';
  static const ordersFilterLastWeekLabel = 'Last week';
  static const ordersFilterLastMonthLabel = 'Last month';
  static const ordersLoadErrorMessage = "Couldn't load your orders.";
  static const ordersRefreshFailedMessage = "Couldn't refresh your orders.";
  static const ordersEmptyTitle = 'No orders yet';
  static const ordersEmptySubtitle =
      'Your orders will show up here once you place one.';
  static const ordersNoResultsTitle = 'Nothing here';
  static const ordersNoResultsSubtitle =
      'No order matches those filters. Try widening them.';
  static String orderNumberLabel(DateTime placedAt) =>
      'Order ${placedAt.asFilterDate}';
  static String orderItemCount(int count) => '$count ${count.plural('item')}';

  /// The order card's bottom line (the kit's "Delivered to Yona's Home"),
  /// tensed by where the order actually is.
  static String orderDeliveryLine(String addressLabel, bool delivered) =>
      '${delivered ? 'Delivered' : 'Delivering'} to $addressLabel';
  static const orderCancelledLine = 'This order was cancelled';

  // ── Order tracking ───────────────────────────────────────────────────────
  static const trackOrderTitle = 'Track Order';
  static const orderDetailTitle = 'Order Detail';
  static const copyTooltip = 'Copy';
  static String copiedMessage(String label) => '$label copied.';
  static const trackingDetailTitle = 'Tracking Detail';
  static const orderStatusLabel = 'Status';
  static const purchaseDateLabel = 'Purchase Date';
  static const orderIdLabel = 'Order ID';
  static const deliveryOtpLabel = 'Delivery OTP';
  static const paymentIdLabel = 'Payment ID';
  static const amountPaidLabel = 'Amount Paid';
  static const noOnlinePaymentLabel = 'Not paid online';
  static const refundLabel = 'Refund';
  static const orderReceivedLabel = 'Order Received';
  static const cancelOrderLabel = 'Cancel Order';
  static const cancelOrderTitle = 'Cancel this order?';
  static const cancelOrderMessage =
      "We'll refund anything you paid. This can't be undone.";
  static const cancelOrderConfirmLabel = 'Cancel Order';
  static const orderCancelFailedMessage = "Couldn't cancel that order.";
  static const orderStepUndatedLabel = 'Time not recorded';
  static const orderStepPendingLabel = 'Pending';

  static String orderStatusName(OrderStatus status) => switch (status) {
    OrderStatus.pending => 'Order Placed',
    OrderStatus.inProcess => 'On Delivery',
    OrderStatus.delivered => 'Delivered',
    OrderStatus.cancelled => 'Canceled',
  };

  static String? refundStatusLabel(RefundStatus status) => switch (status) {
    RefundStatus.none => null,
    RefundStatus.pending => 'Refund on its way',
    RefundStatus.processed => 'Refunded',
    RefundStatus.failed => 'Refund failed',
  };
}
