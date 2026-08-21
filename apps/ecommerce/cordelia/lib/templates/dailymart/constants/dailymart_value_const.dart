import 'package:core/core/extensions/date_time_extensions.dart';
import 'package:core/core/extensions/num_extensions.dart';

import 'package:cordelia/enums/order_status.dart';
// For OrderPlacedAtX.asFilterDate — the order's own compact date form, so
// the card and the filter sheet can't drift into two date formats.
import 'package:cordelia/feature/storefront/orders/domain/entities/order_entity.dart';
import 'package:cordelia/l10n/l10n.dart';

/// Copy used only by the `dailymart` template's storefront screens — scoped
/// here rather than the app-wide `ValueConst` so each template words its own
/// screens (same split as `GraviaValueConst`).
///
/// Bilingual like gravia: every user-facing string is a getter over
/// [L10n.current] (`dailymart*` keys in `lib/l10n/app_*.arb`), applied per
/// store visit by `StorefrontPage`. Only wordless number/date formatters and
/// data values stay `const`.
abstract final class DailyMartValueConst {
  // ── Home ─────────────────────────────────────────────────────────────────
  static String get topSellerTitle => L10n.current.dailymartTopSellerTitle;
  static String get categoriesTitle => L10n.current.dailymartCategoriesTitle;
  static String get popularProductsTitle =>
      L10n.current.dailymartPopularProductsTitle;
  static String get seeAll => L10n.current.dailymartSeeAll;
  static String get searchHint => L10n.current.dailymartSearchHint;
  static String get homeLoadErrorMessage =>
      L10n.current.dailymartHomeLoadErrorMessage;
  static String get noLocationSelectedLabel =>
      L10n.current.dailymartNoLocationSelectedLabel;

  // ── Notifications ────────────────────────────────────────────────────────
  /// Singular, as the kit titles it.
  static String get notificationsTitle =>
      L10n.current.dailymartNotificationsTitle;
  static String get notificationsLoadErrorMessage =>
      L10n.current.dailymartNotificationsLoadErrorMessage;
  static String get notificationsEmptyTitle =>
      L10n.current.dailymartNotificationsEmptyTitle;
  static String get notificationsEmptySubtitle =>
      L10n.current.dailymartNotificationsEmptySubtitle;

  // ── Promo card ───────────────────────────────────────────────────────────
  static String get orderNow => L10n.current.dailymartOrderNow;
  static String promoSubtitle(double discountPercentage) =>
      L10n.current.dailymartPromoSubtitle(discountPercentage.asPercent);

  // ── Product card ─────────────────────────────────────────────────────────
  static String discountPercentOffLabel(double percentage) =>
      L10n.current.dailymartDiscountPercentOff(percentage.asPercent);

  // ── Bottom navigation (kit tab set) ──────────────────────────────────────
  static String get navHome => L10n.current.dailymartNavHome;
  static String get navWishlist => L10n.current.dailymartNavWishlist;
  static String get navCart => L10n.current.dailymartNavCart;
  static String get navProfile => L10n.current.dailymartNavProfile;

  // ── Search ───────────────────────────────────────────────────────────────
  static String get recentSearchTitle =>
      L10n.current.dailymartRecentSearchTitle;
  static String get recentlyViewedTitle =>
      L10n.current.dailymartRecentlyViewedTitle;
  static String resultsForLabel(String query) =>
      L10n.current.dailymartResultsForLabel(query);

  /// The kit's own wording — "founds", not "found" (screen `20 Search
  /// product [result]`). Reproduced verbatim (in English) so the screen
  /// matches the pack.
  static String resultsCountLabel(int count) =>
      L10n.current.dailymartResultsCountLabel(count);
  static String get searchLoadErrorMessage =>
      L10n.current.dailymartSearchLoadErrorMessage;
  static String get searchResultsErrorMessage =>
      L10n.current.dailymartSearchResultsErrorMessage;
  static String get searchNoResultsTitle =>
      L10n.current.dailymartSearchNoResultsTitle;
  static String searchNoResultsSubtitle(String query) =>
      L10n.current.dailymartSearchNoResultsSubtitle(query);
  static String get categoryBadge => L10n.current.dailymartCategoryBadge;

  // ── Category details (kit frames `20`/`21`) ──────────────────────────────
  /// The floating pill, and the title of the sheet it opens.
  static String get filterLabel => L10n.current.dailymartFilterLabel;

  /// The filter sheet's two field labels, each doubling as the title of the
  /// picklist sheet that field opens. The options themselves are
  /// `ProductSortOption.label` / `ProductPriceFilter.label` (app-wide
  /// `ValueConst` copy) — shared with gravia, since they name a sort model
  /// both templates run rather than anything this pack draws differently.
  static String get sortSheetTitle => L10n.current.dailymartSortSheetTitle;
  static String get priceSheetTitle => L10n.current.dailymartPriceSheetTitle;
  static String get categoryDetailsEmptyTitle =>
      L10n.current.dailymartCategoryDetailsEmptyTitle;
  static String get categoryDetailsEmptySubtitle =>
      L10n.current.dailymartCategoryDetailsEmptySubtitle;
  static String get categoryDetailsErrorMessage =>
      L10n.current.dailymartCategoryDetailsErrorMessage;

  // ── Wishlist ─────────────────────────────────────────────────────────────
  /// Titled from the nav tab ([navWishlist]) rather than its own const — the
  /// kit ships no wishlist frame, and a screen whose header disagreed with
  /// the tab that opened it would read as two different places.
  static String get wishlistEmptyTitle =>
      L10n.current.dailymartWishlistEmptyTitle;
  static String get wishlistEmptySubtitle =>
      L10n.current.dailymartWishlistEmptySubtitle;
  static String get wishlistExploreAction =>
      L10n.current.dailymartWishlistExploreAction;

  // ── Product details ──────────────────────────────────────────────────────
  static String get productDetailsTitle =>
      L10n.current.dailymartProductDetailsTitle;
  static String get descriptionsTabLabel =>
      L10n.current.dailymartDescriptionsTabLabel;
  static String get reviewsTabLabel => L10n.current.dailymartReviewsTabLabel;
  static String get relatedProductsTitle =>
      L10n.current.dailymartRelatedProductsTitle;
  static String get selectSizeLabel => L10n.current.dailymartSelectSizeLabel;
  static String get productDetailsLoadErrorMessage =>
      L10n.current.dailymartProductDetailsLoadErrorMessage;
  // Wordless ('/kg'), so no arb key.
  static String perUnitSuffix(String unit) => '/$unit';

  // ── Add to cart ──────────────────────────────────────────────────────────
  static String get addToCart => L10n.current.dailymartAddToCart;
  static String get addToCartSheetTitle =>
      L10n.current.dailymartAddToCartSheetTitle;
  static String addedToCartMessage(String name, int quantity) =>
      L10n.current.dailymartAddedToCartMessage(quantity, name);

  /// The Reviews tab (kit screen `23 Review product`). The kit's own
  /// numbers were placeholders until reviews landed; these two formatters
  /// render the real ones in the same shapes the frame drew — "5.0/5.0"
  /// beside a "5 Star" bar row. The tab's review count reads through the
  /// app-level `ValueConst.reviewCountLabel`, since that wording is the
  /// shared reviews feature's, not this pack's.
  // Wordless ('5.0/5.0'), so no arb key — but both halves take the locale's
  // decimal mark, so a German store reads '4,6/5,0' rather than mixing marks.
  static String reviewScoreLabel(double average) =>
      '${average.asDecimal()}/${5.asDecimal()}';
  static String starRowLabel(int stars) =>
      L10n.current.dailymartStarRowLabel(stars);

  // ── Cart ─────────────────────────────────────────────────────────────────
  static String get myCartTitle => L10n.current.dailymartMyCartTitle;
  static String get couponHint => L10n.current.dailymartCouponHint;
  static String get couponRemoveLabel =>
      L10n.current.dailymartCouponRemoveLabel;
  static String get couponDetailLabel =>
      L10n.current.dailymartCouponDetailLabel;
  static String couponAppliedLabel(String code) =>
      L10n.current.dailymartCouponApplied(code);
  static String couponLineLabel(String code) =>
      L10n.current.dailymartCouponLine(code);
  // Wordless ('CODE (- ₹50)'), so no arb key.
  static String couponDetailValue(String code, String discount) =>
      '$code (- $discount)';
  static String get subTotalLabel => L10n.current.dailymartSubTotalLabel;
  static String get deliveryLabel => L10n.current.dailymartDeliveryLabel;
  static String get deliveryFreeLabel =>
      L10n.current.dailymartDeliveryFreeLabel;
  static String get discountLabel => L10n.current.dailymartDiscountLabel;
  static String get totalCostLabel => L10n.current.dailymartTotalCostLabel;
  static String get proceedToCheckoutLabel =>
      L10n.current.dailymartProceedToCheckoutLabel;
  static String get cartEmptyTitle => L10n.current.dailymartCartEmptyTitle;
  static String get cartEmptySubtitle =>
      L10n.current.dailymartCartEmptySubtitle;
  static String get cartExploreAction =>
      L10n.current.dailymartCartExploreAction;
  static String get removedFromCartMessage =>
      L10n.current.dailymartRemovedFromCartMessage;

  // ── Checkout (kit frames `29 Checkout` / `34 Order Successfully`) ─────────
  /// One title for both states — the kit keeps the header row identical
  /// across the form and the success frame.
  static String get checkoutTitle => L10n.current.dailymartCheckoutTitle;
  static String get shippingAddressLabel =>
      L10n.current.dailymartShippingAddressLabel;
  static String get orderListLabel => L10n.current.dailymartOrderListLabel;
  static String get continueToPaymentLabel =>
      L10n.current.dailymartContinueToPaymentLabel;

  /// Beside each order line, in the slot the Cart's stepper occupies — the
  /// quantity is fixed by this point, so it reads rather than adjusts.
  // Wordless ('× 2'), so no arb key.
  static String orderLineQuantity(int quantity) => '× $quantity';

  static String get orderPlacedTitle => L10n.current.dailymartOrderPlacedTitle;
  static String get orderPlacedMessage =>
      L10n.current.dailymartOrderPlacedMessage;

  /// The success frame's one CTA. The kit stacks this over an "E-Receipt"
  /// outline button; that half is dropped — there is no receipt document to
  /// open, and a second CTA that only apologises weakens the real one.
  static String get trackOrderLabel => L10n.current.dailymartTrackOrderLabel;

  /// The docked cart status pill on screens pushed outside the shell (the
  /// cart tab itself is the in-shell affordance).
  static String cartSummaryLabel(int count, double total) =>
      L10n.current.dailymartCartSummary(count, total.asPrice);
  static String get viewCartLabel => L10n.current.dailymartViewCartLabel;

  // ── Profile ──────────────────────────────────────────────────────────────
  /// The kit groups the rows under "General" and "Preferencess" — the second
  /// is a kit typo and is not reproduced.
  static String get generalSectionTitle =>
      L10n.current.dailymartGeneralSectionTitle;
  static String get preferencesSectionTitle =>
      L10n.current.dailymartPreferencesSectionTitle;

  /// The row set is gravia's, not the kit's — same titles, same actions,
  /// only the row silhouette is this pack's. The kit's own list offers
  /// Security / Language / Help & Support; Language and Help & Support are
  /// both real rows now (app-level, so their copy is on `ValueConst`), and
  /// Security is the one this app still has nothing behind.
  static String get editProfileLabel => L10n.current.dailymartEditProfileLabel;
  static String get changePasswordLabel =>
      L10n.current.dailymartChangePasswordLabel;
  static String get myOrdersLabel => L10n.current.dailymartMyOrdersLabel;
  static String get myAddressLabel => L10n.current.dailymartMyAddressLabel;
  static String get darkModeLabel => L10n.current.dailymartDarkModeLabel;
  static String get privacyPolicyLabel =>
      L10n.current.dailymartPrivacyPolicyLabel;
  static String get termsAndConditionsLabel =>
      L10n.current.dailymartTermsAndConditionsLabel;
  static String get logoutLabel => L10n.current.dailymartLogoutLabel;
  static String get logoutTitle => L10n.current.dailymartLogoutTitle;
  static String get logoutConfirmMessage =>
      L10n.current.dailymartLogoutConfirmMessage;
  static String get profileLoadErrorMessage =>
      L10n.current.dailymartProfileLoadErrorMessage;

  // ── Edit Profile ─────────────────────────────────────────────────────────
  static String get editProfileTitle => L10n.current.dailymartEditProfileTitle;
  static String get fullNameLabel => L10n.current.dailymartFullNameLabel;
  static String get fullNameHint => L10n.current.dailymartFullNameHint;
  static String get emailLabel => L10n.current.dailymartEmailLabel;
  static String get emailHint => L10n.current.dailymartEmailHint;
  static String get phoneNumberLabel => L10n.current.dailymartPhoneNumberLabel;
  static String get phoneNumberHint => L10n.current.dailymartPhoneNumberHint;

  /// The kit's own CTA wording on this screen.
  static String get saveChangesLabel => L10n.current.dailymartSaveChangesLabel;
  static String get changePhotoTitle => L10n.current.dailymartChangePhotoTitle;
  static String get takePhotoLabel => L10n.current.dailymartTakePhotoLabel;
  static String get chooseFromGalleryLabel =>
      L10n.current.dailymartChooseFromGalleryLabel;
  static String get avatarPickerMobileOnlyMessage =>
      L10n.current.dailymartAvatarPickerMobileOnlyMessage;

  // ── Change Password ──────────────────────────────────────────────────────
  /// The kit's Profile list has no Change Password screen behind its
  /// Security row, so this reuses gravia's wording — only the silhouette
  /// (header row, bordered fields, floating CTA) is this pack's.
  static String get changePasswordTitle =>
      L10n.current.dailymartChangePasswordTitle;
  static String get currentPasswordLabel =>
      L10n.current.dailymartCurrentPasswordLabel;
  static String get currentPasswordHint =>
      L10n.current.dailymartCurrentPasswordHint;
  static String get newPasswordLabel => L10n.current.dailymartNewPasswordLabel;
  static String get newPasswordHint => L10n.current.dailymartNewPasswordHint;
  static String get confirmNewPasswordLabel =>
      L10n.current.dailymartConfirmNewPasswordLabel;
  static String get confirmNewPasswordHint =>
      L10n.current.dailymartConfirmNewPasswordHint;
  static String get updatePasswordButtonLabel =>
      L10n.current.dailymartUpdatePasswordButtonLabel;
  static String get passwordUpdatedMessage =>
      L10n.current.dailymartPasswordUpdatedMessage;

  // ── Select Address ───────────────────────────────────────────────────────
  static String get selectAddressTitle =>
      L10n.current.dailymartSelectAddressTitle;
  static String get addNewAddressLabel =>
      L10n.current.dailymartAddNewAddressLabel;
  static String get addressLoadErrorMessage =>
      L10n.current.dailymartAddressLoadErrorMessage;
  static String get addressSaveFailedMessage =>
      L10n.current.dailymartAddressSaveFailedMessage;
  static String get addressEmptyTitle =>
      L10n.current.dailymartAddressEmptyTitle;
  static String get addressEmptySubtitle =>
      L10n.current.dailymartAddressEmptySubtitle;
  static String get addressDeleteFailedMessage =>
      L10n.current.dailymartAddressDeleteFailedMessage;
  static String get editAddressTooltip =>
      L10n.current.dailymartEditAddressTooltip;
  static String get deleteAddressTitle =>
      L10n.current.dailymartDeleteAddressTitle;
  static String get deleteAddressMessage =>
      L10n.current.dailymartDeleteAddressMessage;
  static String get deleteLabel => L10n.current.dailymartDeleteLabel;

  // ── Add / Edit Address ───────────────────────────────────────────────────
  // Deliberately a second copy of gravia's labels rather than a shared set:
  // pack copy lives with the pack, so this template can reword a field
  // without editing gravia's screens (spec sheet §13).
  static String get addAddressTitle => L10n.current.dailymartAddAddressTitle;
  static String get editAddressTitle => L10n.current.dailymartEditAddressTitle;
  static String get addressNameLabel => L10n.current.dailymartAddressNameLabel;
  static String get addressNameHint => L10n.current.dailymartAddressNameHint;
  static String get addressLine1Label =>
      L10n.current.dailymartAddressLine1Label;
  static String get addressLine1Hint => L10n.current.dailymartAddressLine1Hint;
  static String get addressLine2Label =>
      L10n.current.dailymartAddressLine2Label;
  static String get addressLine2Hint => L10n.current.dailymartAddressLine2Hint;
  static String get landmarkLabel => L10n.current.dailymartLandmarkLabel;
  static String get landmarkHint => L10n.current.dailymartLandmarkHint;
  static String get cityLabel => L10n.current.dailymartCityLabel;
  static String get cityHint => L10n.current.dailymartCityHint;
  static String get stateLabel => L10n.current.dailymartStateLabel;
  static String get stateHint => L10n.current.dailymartStateHint;
  static String get countryLabel => L10n.current.dailymartCountryLabel;
  static String get selectCountryTitle =>
      L10n.current.dailymartSelectCountryTitle;
  static String get postalCodeLabel => L10n.current.dailymartPostalCodeLabel;
  static String get postalCodeHint => L10n.current.dailymartPostalCodeHint;
  static String get addressTagLabel => L10n.current.dailymartAddressTagLabel;
  static String get addressTagHint => L10n.current.dailymartAddressTagHint;
  static String get addAddressButtonLabel =>
      L10n.current.dailymartAddAddressButtonLabel;
  static String get updateAddressButtonLabel =>
      L10n.current.dailymartUpdateAddressButtonLabel;
  static String get requiredFieldErrorMessage =>
      L10n.current.dailymartRequiredFieldErrorMessage;

  // City stopped being a picklist when geo prefill landed — real city names
  // no fixed list could hold. Country stays bounded; India first, since geo
  // prefill and the pincode lookup are India-centric. Data values, not copy
  // — what the picklist stores on the address doc — so locale-independent.
  static const addressFormCountries = <String>[
    'India',
    'United States',
    'Canada',
    'United Kingdom',
    'Australia',
  ];

  // ── My Orders (kit frame `35`) ───────────────────────────────────────────
  static String get myOrdersTitle => L10n.current.dailymartMyOrdersTitle;
  static String get ordersSearchHint => L10n.current.dailymartOrdersSearchHint;
  static String get ordersFilterAllLabel =>
      L10n.current.dailymartOrdersFilterAllLabel;
  static String get ordersFilterActiveLabel =>
      L10n.current.dailymartOrdersFilterActiveLabel;
  static String get ordersFilterCompletedLabel =>
      L10n.current.dailymartOrdersFilterCompletedLabel;
  static String get ordersFilterCancelledLabel =>
      L10n.current.dailymartOrdersFilterCancelledLabel;

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
      L10n.current.dailymartOrderSummaryLabel(count, placedAt.asFilterDate);

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
  static String get ordersDateRangeLabel =>
      L10n.current.dailymartOrdersDateRangeLabel;
  static String get ordersAllTimeLabel =>
      L10n.current.dailymartOrdersAllTimeLabel;
  // Wordless ('Mar 01 - Mar 09'), so no arb key.
  static String ordersDateRangeValue(DateTime from, DateTime to) =>
      '${from.asFilterDate} - ${to.asFilterDate}';
  static String get ordersFilterLastWeekLabel =>
      L10n.current.dailymartOrdersFilterLastWeekLabel;
  static String get ordersFilterLastMonthLabel =>
      L10n.current.dailymartOrdersFilterLastMonthLabel;

  /// Shared by both filter sheets (My Orders' and Category Details'), and
  /// the kit's own wording on frame `21` — "Apply", not gravia's "Apply
  /// Filter".
  static String get resetLabel => L10n.current.dailymartResetLabel;
  static String get applyLabel => L10n.current.dailymartApplyLabel;

  static String get ordersLoadErrorMessage =>
      L10n.current.dailymartOrdersLoadErrorMessage;
  static String get ordersEmptyTitle => L10n.current.dailymartOrdersEmptyTitle;
  static String get ordersEmptySubtitle =>
      L10n.current.dailymartOrdersEmptySubtitle;
  static String get ordersNoResultsTitle =>
      L10n.current.dailymartOrdersNoResultsTitle;
  static String get ordersNoResultsSubtitle =>
      L10n.current.dailymartOrdersNoResultsSubtitle;
  static String get orderCancelFailedMessage =>
      L10n.current.dailymartOrderCancelFailedMessage;
  static String get ordersRefreshFailedMessage =>
      L10n.current.dailymartOrdersRefreshFailedMessage;

  // ── Track Order (kit frame `36`) ─────────────────────────────────────────
  static String get trackOrderTitle => L10n.current.dailymartTrackOrderTitle;
  static String get trackOrderAction => L10n.current.dailymartTrackOrderAction;
  static String get orderDetailsTitle =>
      L10n.current.dailymartOrderDetailsTitle;
  static String get orderIdLabel => L10n.current.dailymartOrderIdLabel;
  static String get deliveryOtpLabel => L10n.current.dailymartDeliveryOtpLabel;
  static String get paymentTitle => L10n.current.dailymartPaymentTitle;
  static String get amountPaidLabel => L10n.current.dailymartAmountPaidLabel;
  static String get paymentIdLabel => L10n.current.dailymartPaymentIdLabel;
  static String get refundLabel => L10n.current.dailymartRefundLabel;
  static String get copiedMessage => L10n.current.dailymartCopiedMessage;

  /// Shown in place of a payment id when the order went through the
  /// test-mode payment-less path — there is no gateway reference to quote.
  static String get noOnlinePaymentLabel =>
      L10n.current.dailymartNoOnlinePaymentLabel;

  /// The shopper-facing refund note; null for [RefundStatus.none], where no
  /// money was ever taken back. This pack's own wording rather than
  /// gravia's `GraviaRefundStatusLabelX`.
  static String? refundStatusLabel(RefundStatus status) => switch (status) {
    RefundStatus.none => null,
    RefundStatus.pending => L10n.current.dailymartRefundPendingLabel,
    RefundStatus.processed => L10n.current.dailymartRefundProcessedLabel,
    RefundStatus.failed => L10n.current.dailymartRefundFailedLabel,
  };
  static String get orderStatusTitle => L10n.current.dailymartOrderStatusTitle;
  static String get orderStepPlacedLabel =>
      L10n.current.dailymartOrderStepPlacedLabel;
  static String get orderStepOnTheWayLabel =>
      L10n.current.dailymartOrderStepOnTheWayLabel;
  static String get orderStepDeliveredLabel =>
      L10n.current.dailymartOrderStepDeliveredLabel;
  static String get orderStepCancelledLabel =>
      L10n.current.dailymartOrderStepCancelledLabel;

  /// Shown under a step the order has reached but that predates the server
  /// recording transition times — see `Order.statusHistory` in
  /// `admin/src/lib/types.ts`.
  static String get orderStepUndatedLabel =>
      L10n.current.dailymartOrderStepUndatedLabel;
  static String get orderStepPendingLabel =>
      L10n.current.dailymartOrderStepPendingLabel;
  static String get cancelOrderLabel => L10n.current.dailymartCancelOrderLabel;
  static String get cancelOrderTitle => L10n.current.dailymartCancelOrderTitle;
  static String get cancelOrderMessage =>
      L10n.current.dailymartCancelOrderMessage;
  static String get cancelOrderConfirmLabel =>
      L10n.current.dailymartCancelOrderConfirmLabel;

  /// The kit's timeline stamp — "Dec, 20 2025 - 9:30 AM". Its own formatter
  /// rather than `OrderPlacedAtX`, which renders gravia's card format
  /// ("Mon, Mar 9, 2026 at 10:15 AM"); the two packs date the same value
  /// differently, so the *arrangement* belongs with the pack's copy.
  ///
  /// The month name and the clock come from the locale, though — the table of
  /// English abbreviations that used to live here was fine while the choice
  /// was English or Hindi (a Devanagari month would have broken the one-script
  /// rule dates follow), but German, French, Spanish and Italian are Latin
  /// script *and* read the clock in 24 hours, so hardcoding "Dec … 9:30 AM"
  /// printed English into a German timeline.
  static String orderStepAt(DateTime at) =>
      '${at.monthAbbr}, ${at.day} ${at.year} - ${at.asTime}';

  // ── Cancel / confirm ─────────────────────────────────────────────────────
  static String get cancelLabel => L10n.current.dailymartCancelLabel;
}
