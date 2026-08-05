import 'package:core/core/extensions/num_extensions.dart';

import 'package:cordelia/enums/order_status.dart';
// For OrderPlacedAtX.asFilterDate — the order's own compact date form, so
// the card and the filter sheet can't drift into two date formats.
import 'package:cordelia/feature/storefront/orders/domain/entities/order_entity.dart';

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
  static String discountPercentOffLabel(double percentage) =>
      '${percentage.asPercent}% off';

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

  // ── Category details (kit frames `20`/`21`) ──────────────────────────────
  /// The floating pill, and the title of the sheet it opens.
  static const filterLabel = 'Filter';

  /// The filter sheet's two field labels, each doubling as the title of the
  /// picklist sheet that field opens. The options themselves are
  /// `ProductSortOption.label` / `ProductPriceFilter.label` (app-wide
  /// `ValueConst` copy) — shared with gravia, since they name a sort model
  /// both templates run rather than anything this pack draws differently.
  static const sortSheetTitle = 'Sort by';
  static const priceSheetTitle = 'Price';
  static const categoryDetailsEmptyTitle = 'Nothing here';
  static const categoryDetailsEmptySubtitle =
      'No products in this category match those filters.';
  static const categoryDetailsErrorMessage = "Couldn't load this category.";

  // ── Wishlist ─────────────────────────────────────────────────────────────
  /// Titled from the nav tab ([navWishlist]) rather than its own const — the
  /// kit ships no wishlist frame, and a screen whose header disagreed with
  /// the tab that opened it would read as two different places.
  static const wishlistEmptyTitle = 'Nothing saved yet';
  static const wishlistEmptySubtitle =
      'Tap the heart on a product and it will wait for you here.';
  static const wishlistExploreAction = 'Start shopping';

  // ── Product details ──────────────────────────────────────────────────────
  static const productDetailsTitle = 'Product Details';
  static const descriptionsTabLabel = 'Descriptions';
  static const reviewsTabLabel = 'Reviews';
  static const relatedProductsTitle = 'Related Products';
  static const selectSizeLabel = 'Select Size';
  static const productDetailsLoadErrorMessage =
      "Couldn't load this product's details.";
  static String perUnitSuffix(String unit) => '/$unit';

  // ── Add to cart ──────────────────────────────────────────────────────────
  static const addToCart = 'Add To Cart';
  static const addToCartSheetTitle = 'Add To Cart';
  static String addedToCartMessage(String name, int quantity) =>
      'Added $quantity × $name to your cart.';

  /// The Reviews tab (kit screen `23 Review product`). The kit's own
  /// numbers were placeholders until reviews landed; these two formatters
  /// render the real ones in the same shapes the frame drew — "5.0/5.0"
  /// beside a "5 Star" bar row. The tab's review count reads through the
  /// app-level `ValueConst.reviewCountLabel`, since that wording is the
  /// shared reviews feature's, not this pack's.
  static String reviewScoreLabel(double average) =>
      '${average.toStringAsFixed(1)}/5.0';
  static String starRowLabel(int stars) => '$stars Star';

  // ── Cart ─────────────────────────────────────────────────────────────────
  static const myCartTitle = 'My Cart';
  static const couponHint = 'Enter coupon code';
  static const couponRemoveLabel = 'Remove';
  static const couponDetailLabel = 'Coupon';
  static String couponAppliedLabel(String code) => '$code applied';
  static String couponLineLabel(String code) => 'Coupon ($code)';
  static String couponDetailValue(String code, String discount) =>
      '$code (- $discount)';
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
      '$count ${count.plural('item')} | ${total.asPrice}';
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
  static const cityHint = 'e.g. New Delhi';
  static const stateLabel = 'State';
  static const stateHint = 'e.g. Delhi (optional)';
  static const countryLabel = 'Country';
  static const selectCountryTitle = 'Select Country';
  static const postalCodeLabel = 'Postal Code';
  static const postalCodeHint = 'e.g. 62639';
  static const addressTagLabel = 'Tag';
  static const addressTagHint = 'e.g. Home, Office';
  static const addAddressButtonLabel = 'Add Address';
  static const updateAddressButtonLabel = 'Update Address';
  static const requiredFieldErrorMessage = 'This field is required';

  // City stopped being a picklist when geo prefill landed — real city names
  // no fixed list could hold. Country stays bounded; India first, since geo
  // prefill and the pincode lookup are India-centric.
  static const addressFormCountries = <String>[
    'India',
    'United States',
    'Canada',
    'United Kingdom',
    'Australia',
  ];

  // ── My Orders (kit frame `35`) ───────────────────────────────────────────
  static const myOrdersTitle = 'My Orders';
  static const ordersSearchHint = 'What are you looking for...';
  static const ordersFilterAllLabel = 'All';
  static const ordersFilterActiveLabel = 'Active';
  static const ordersFilterCompletedLabel = 'Completed';
  static const ordersFilterCancelledLabel = 'Cancelled';

  /// The card's second line. The kit shows a product *category* there, which
  /// an order doesn't have — an order is a basket, not a product — so it
  /// carries the basket's size and the day it was placed instead: the two
  /// facts that tell two orders of the same store apart at a glance.
  ///
  /// One line rather than two, so the card's three text rows still sit
  /// against its 88 px thumbnail. The compact date form (no weekday, no
  /// time) for the same reason — Track Order's timeline carries the full
  /// stamp for anyone who needs the hour.
  static String orderSummaryLabel(int count, DateTime placedAt) =>
      '$count ${count.plural('item')} · ${placedAt.asFilterDate}';

  /// The order card's status pill. Its own copy rather than gravia's
  /// `GraviaOrderStatusLabelX` wording — and the same four words this
  /// pack's timeline steps use, so a card and the Track Order screen behind
  /// it can't name one status two ways.
  static String orderStatusLabel(OrderStatus status) => switch (status) {
    OrderStatus.pending => orderStepPlacedLabel,
    OrderStatus.inProcess => orderStepOnTheWayLabel,
    OrderStatus.delivered => orderStepDeliveredLabel,
    OrderStatus.cancelled => orderStepCancelledLabel,
  };

  /// The floating Filter pill's sheet. Dates only — the status axis is
  /// already on the screen as the chip row, and asking for it twice lets the
  /// two disagree.
  static const ordersDateRangeLabel = 'Date Range';
  static const ordersAllTimeLabel = 'All time';
  static String ordersDateRangeValue(DateTime from, DateTime to) =>
      '${from.asFilterDate} - ${to.asFilterDate}';
  static const ordersFilterLastWeekLabel = 'Last week';
  static const ordersFilterLastMonthLabel = 'Last month';

  /// Shared by both filter sheets (My Orders' and Category Details'), and
  /// the kit's own wording on frame `21` — "Apply", not gravia's "Apply
  /// Filter".
  static const resetLabel = 'Reset';
  static const applyLabel = 'Apply';

  static const ordersLoadErrorMessage = "Couldn't load your orders.";
  static const ordersEmptyTitle = 'No orders yet';
  static const ordersEmptySubtitle =
      'Your orders from this store will show up here.';
  static const ordersNoResultsTitle = 'Nothing here';
  static const ordersNoResultsSubtitle =
      'No orders match that search or filter.';
  static const orderCancelFailedMessage = "Couldn't cancel that order.";
  static const ordersRefreshFailedMessage = "Couldn't refresh your orders.";

  // ── Track Order (kit frame `36`) ─────────────────────────────────────────
  static const trackOrderTitle = 'Track Order';
  static const trackOrderAction = 'Track Order';
  static const orderDetailsTitle = 'Order Details';
  static const orderIdLabel = 'Order ID';
  static const deliveryOtpLabel = 'Delivery OTP';
  static const paymentTitle = 'Payment';
  static const amountPaidLabel = 'Amount Paid';
  static const paymentIdLabel = 'Payment ID';
  static const refundLabel = 'Refund';
  static const copiedMessage = 'Copied';

  /// Shown in place of a payment id when the order went through the
  /// test-mode payment-less path — there is no gateway reference to quote.
  static const noOnlinePaymentLabel = 'Not paid online';

  /// The shopper-facing refund note; null for [RefundStatus.none], where no
  /// money was ever taken back. This pack's own wording rather than
  /// gravia's `GraviaRefundStatusLabelX`.
  static String? refundStatusLabel(RefundStatus status) => switch (status) {
    RefundStatus.none => null,
    RefundStatus.pending => 'Processing',
    RefundStatus.processed => 'Refunded',
    RefundStatus.failed => 'Refund failed',
  };
  static const orderStatusTitle = 'Order Status';
  static const orderStepPlacedLabel = 'Order Placed';
  static const orderStepOnTheWayLabel = 'On the way';
  static const orderStepDeliveredLabel = 'Delivered';
  static const orderStepCancelledLabel = 'Cancelled';

  /// Shown under a step the order has reached but that predates the server
  /// recording transition times — see `Order.statusHistory` in
  /// `admin/src/lib/types.ts`.
  static const orderStepUndatedLabel = 'Time not recorded';
  static const orderStepPendingLabel = 'Pending';
  static const cancelOrderLabel = 'Cancel Order';
  static const cancelOrderTitle = 'Cancel this order?';
  static const cancelOrderMessage =
      "You'll be refunded if the order was paid for.";
  static const cancelOrderConfirmLabel = 'Cancel Order';

  /// The kit's timeline stamp — "Dec, 20 2025 - 9.30 AM". Its own formatter
  /// rather than `OrderPlacedAtX`, which renders gravia's card format
  /// ("Mon, Mar 9, 2026 at 10:15 AM"); the two packs date the same value
  /// differently, so the format belongs with the pack's copy.
  static String orderStepAt(DateTime at) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final hour = at.hour % 12 == 0 ? 12 : at.hour % 12;
    final minute = at.minute.toString().padLeft(2, '0');
    final period = at.hour < 12 ? 'AM' : 'PM';
    return '${months[at.month - 1]}, ${at.day} ${at.year} - '
        '$hour.$minute $period';
  }

  // ── Cancel / confirm ─────────────────────────────────────────────────────
  static const cancelLabel = 'Cancel';
}
