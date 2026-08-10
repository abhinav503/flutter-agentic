// RefundStatus ships beside OrderStatus — one file, two axes of the same
// lifecycle.
import 'package:cordelia/enums/order_status.dart';
// For OrderPlacedAtX.asFilterDate — the order's own compact date form, so the
// card and the filter sheet can't drift into two date formats.
import 'package:cordelia/feature/storefront/orders/domain/entities/order_entity.dart';
import 'package:cordelia/l10n/l10n.dart';
import 'package:core/core/extensions/num_extensions.dart';

/// Copy used only by the `grofast` template's storefront screens — scoped here
/// rather than the app-wide `ValueConst` so each template words its own
/// screens (same split as `GraviaValueConst` / `DailyMartValueConst`).
///
/// The voice is the kit's: lowercase inline links ("see all", "add new"),
/// grocery nouns ("bag", not "cart"), and sentence-case section headers.
///
/// Bilingual like gravia: every user-facing string is a getter over
/// [L10n.current] (`grofast*` keys in `lib/l10n/app_*.arb`), applied per
/// store visit by `StorefrontPage`. Only wordless number/date formatters and
/// data values stay `const`.
abstract final class GrofastValueConst {
  // ── Home ─────────────────────────────────────────────────────────────────
  static String greeting(String name) => L10n.current.grofastGreeting(name);
  static String get greetingFallbackName =>
      L10n.current.grofastGreetingFallbackName;
  static String get greetingSubtitle => L10n.current.grofastGreetingSubtitle;
  static String get searchHint => L10n.current.grofastSearchHint;
  static String get categoriesTitle => L10n.current.grofastCategoriesTitle;
  static String get popularTitle => L10n.current.grofastPopularTitle;
  static String get seeAll => L10n.current.grofastSeeAll;
  static String get homeLoadErrorMessage =>
      L10n.current.grofastHomeLoadErrorMessage;
  static String get noLocationSelectedLabel =>
      L10n.current.grofastNoLocationSelectedLabel;
  static String get claimNow => L10n.current.grofastClaimNow;
  static String promoDiscountLabel(double percentage) =>
      L10n.current.grofastPromoDiscountLabel(percentage.asPercent);

  // ── Categories ───────────────────────────────────────────────────────────
  static String get categoriesLoadErrorMessage =>
      L10n.current.grofastCategoriesLoadErrorMessage;
  static String get categoriesEmptyTitle =>
      L10n.current.grofastCategoriesEmptyTitle;
  static String get categoriesEmptySubtitle =>
      L10n.current.grofastCategoriesEmptySubtitle;

  // ── Category details ─────────────────────────────────────────────────────
  static String categoryProductsTitle(String category) =>
      L10n.current.grofastCategoryProductsTitle(category);
  static String get categoryDetailsEmptyTitle =>
      L10n.current.grofastCategoryDetailsEmptyTitle;
  static String get categoryDetailsEmptySubtitle =>
      L10n.current.grofastCategoryDetailsEmptySubtitle;
  static String get categoryDetailsErrorMessage =>
      L10n.current.grofastCategoryDetailsErrorMessage;

  // ── Search ───────────────────────────────────────────────────────────────
  static String get searchTitle => L10n.current.grofastSearchTitle;
  static String get recentSearchTitle => L10n.current.grofastRecentSearchTitle;
  static String resultsCountLabel(int count) =>
      L10n.current.grofastResultsCountLabel(count);
  static String get searchLoadErrorMessage =>
      L10n.current.grofastSearchLoadErrorMessage;
  static String get searchResultsErrorMessage =>
      L10n.current.grofastSearchResultsErrorMessage;
  static String get searchNoResultsTitle =>
      L10n.current.grofastSearchNoResultsTitle;
  static String searchNoResultsSubtitle(String query) =>
      L10n.current.grofastSearchNoResultsSubtitle(query);
  static String get searchIdleTitle => L10n.current.grofastSearchIdleTitle;
  static String get searchIdleSubtitle =>
      L10n.current.grofastSearchIdleSubtitle;

  // ── Filter sheet (search + category details) ─────────────────────────────
  static String get sortByTitle => L10n.current.grofastSortByTitle;
  static String get priceTitle => L10n.current.grofastPriceTitle;
  static String get applyLabel => L10n.current.grofastApplyLabel;
  static String get resetLabel => L10n.current.grofastResetLabel;

  // ── Product card / grid ──────────────────────────────────────────────────
  // Wordless ('/kg'), so no arb key.
  static String perUnitSuffix(String unit) => '/$unit';
  static String get addToBagTooltip => L10n.current.grofastAddToBagTooltip;
  static String get favouriteTooltip => L10n.current.grofastFavouriteTooltip;
  static String get decreaseQuantityLabel =>
      L10n.current.grofastDecreaseQuantityLabel;
  static String get increaseQuantityLabel =>
      L10n.current.grofastIncreaseQuantityLabel;

  // ── Product details ──────────────────────────────────────────────────────
  static String get productDetailsTitle =>
      L10n.current.grofastProductDetailsTitle;
  static String get descriptionTitle => L10n.current.grofastDescriptionTitle;
  static String get selectSizeTitle => L10n.current.grofastSelectSizeTitle;
  static String get addToBag => L10n.current.grofastAddToBag;
  static String get productDetailsLoadErrorMessage =>
      L10n.current.grofastProductDetailsLoadErrorMessage;
  static String addedToBagMessage(String name, int quantity) =>
      L10n.current.grofastAddedToBagMessage(quantity, name);
  static String get noDescriptionLabel =>
      L10n.current.grofastNoDescriptionLabel;

  // ── Bag (cart) ───────────────────────────────────────────────────────────
  static String get bagTitle => L10n.current.grofastBagTitle;
  static String bagItemCount(int count) =>
      L10n.current.grofastBagItemCount(count);
  static String get promoCodeHint => L10n.current.grofastPromoCodeHint;
  static String get promoApplyLabel => L10n.current.grofastPromoApplyLabel;
  static String get promoRemoveLabel => L10n.current.grofastPromoRemoveLabel;
  static String get couponDetailLabel => L10n.current.grofastCouponDetailLabel;
  static String promoAppliedLabel(String code) =>
      L10n.current.grofastPromoApplied(code);
  static String couponLineLabel(String code) =>
      L10n.current.grofastCouponLine(code);
  // Wordless ('CODE (- ₹50)'), so no arb key.
  static String couponDetailValue(String code, String discount) =>
      '$code (- $discount)';
  static String get promoComingSoonMessage =>
      L10n.current.grofastPromoComingSoonMessage;
  static String get totalLabel => L10n.current.grofastTotalLabel;
  static String get subtotalLabel => L10n.current.grofastSubtotalLabel;
  static String get deliveryLabel => L10n.current.grofastDeliveryLabel;
  static String get deliveryFreeLabel => L10n.current.grofastDeliveryFreeLabel;
  static String get discountLabel => L10n.current.grofastDiscountLabel;
  static String get proceedToCheckoutLabel =>
      L10n.current.grofastProceedToCheckoutLabel;
  static String get bagEmptyTitle => L10n.current.grofastBagEmptyTitle;
  static String get bagEmptySubtitle => L10n.current.grofastBagEmptySubtitle;
  static String get bagExploreAction => L10n.current.grofastBagExploreAction;
  static String get removedFromBagMessage =>
      L10n.current.grofastRemovedFromBagMessage;

  // ── Checkout ─────────────────────────────────────────────────────────────
  static String get checkoutTitle => L10n.current.grofastCheckoutTitle;
  static String get itemsTitle => L10n.current.grofastItemsTitle;
  static String get deliveryAddressTitle =>
      L10n.current.grofastDeliveryAddressTitle;
  static String get addNewLabel => L10n.current.grofastAddNewLabel;
  static String get changeAddressLabel =>
      L10n.current.grofastChangeAddressLabel;
  static String get noAddressSelectedLabel =>
      L10n.current.grofastNoAddressSelectedLabel;
  static String get confirmOrderLabel => L10n.current.grofastConfirmOrderLabel;
  // Wordless ('× 2'), so no arb key.
  static String orderLineQuantity(int quantity) => '× $quantity';

  // ── Order confirmed ──────────────────────────────────────────────────────
  static String get orderPlacedTitle => L10n.current.grofastOrderPlacedTitle;
  static String get orderPlacedMessage =>
      L10n.current.grofastOrderPlacedMessage;
  static String get browseHomeLabel => L10n.current.grofastBrowseHomeLabel;

  // ── Bottom nav ───────────────────────────────────────────────────────────
  static String get navHome => L10n.current.grofastNavHome;
  static String get navCategories => L10n.current.grofastNavCategories;
  static String get navBag => L10n.current.grofastNavBag;
  static String get navAccount => L10n.current.grofastNavAccount;

  // ── Profile ──────────────────────────────────────────────────────────────
  static String get profileTitle => L10n.current.grofastProfileTitle;
  static String get notificationTileLabel =>
      L10n.current.grofastNotificationTileLabel;
  static String get ordersTileLabel => L10n.current.grofastOrdersTileLabel;
  static String get wishlistTileLabel => L10n.current.grofastWishlistTileLabel;
  static String get myProfileLabel => L10n.current.grofastMyProfileLabel;
  static String get changePasswordLabel =>
      L10n.current.grofastChangePasswordLabel;
  static String get darkModeLabel => L10n.current.grofastDarkModeLabel;
  static String get myAddressLabel => L10n.current.grofastMyAddressLabel;
  static String get privacyPolicyLabel =>
      L10n.current.grofastPrivacyPolicyLabel;
  static String get termsAndConditionsLabel =>
      L10n.current.grofastTermsAndConditionsLabel;
  static String get logOutLabel => L10n.current.grofastLogOutLabel;
  static String get logOutTitle => L10n.current.grofastLogOutTitle;
  static String get logOutConfirmMessage =>
      L10n.current.grofastLogOutConfirmMessage;
  static String get profileLoadErrorMessage =>
      L10n.current.grofastProfileLoadErrorMessage;
  static String get profileNameFallback =>
      L10n.current.grofastProfileNameFallback;

  // ── Edit profile ─────────────────────────────────────────────────────────
  static String get editProfileTitle => L10n.current.grofastEditProfileTitle;
  static String get fullNameLabel => L10n.current.grofastFullNameLabel;
  static String get fullNameHint => L10n.current.grofastFullNameHint;
  static String get emailLabel => L10n.current.grofastEmailLabel;
  static String get emailHint => L10n.current.grofastEmailHint;
  static String get phoneNumberLabel => L10n.current.grofastPhoneNumberLabel;
  static String get phoneNumberHint => L10n.current.grofastPhoneNumberHint;
  static String get saveChangesLabel => L10n.current.grofastSaveChangesLabel;
  static String get changePhotoTitle => L10n.current.grofastChangePhotoTitle;
  static String get takePhotoLabel => L10n.current.grofastTakePhotoLabel;
  static String get chooseFromGalleryLabel =>
      L10n.current.grofastChooseFromGalleryLabel;
  static String get avatarPickerMobileOnlyMessage =>
      L10n.current.grofastAvatarPickerMobileOnlyMessage;
  static String get profileUpdatedMessage =>
      L10n.current.grofastProfileUpdatedMessage;

  // ── Change password ──────────────────────────────────────────────────────
  static String get changePasswordTitle =>
      L10n.current.grofastChangePasswordTitle;
  static String get currentPasswordLabel =>
      L10n.current.grofastCurrentPasswordLabel;
  static String get currentPasswordHint =>
      L10n.current.grofastCurrentPasswordHint;
  static String get newPasswordLabel => L10n.current.grofastNewPasswordLabel;
  static String get newPasswordHint => L10n.current.grofastNewPasswordHint;
  static String get confirmNewPasswordLabel =>
      L10n.current.grofastConfirmNewPasswordLabel;
  static String get confirmNewPasswordHint =>
      L10n.current.grofastConfirmNewPasswordHint;
  static String get updatePasswordButtonLabel =>
      L10n.current.grofastUpdatePasswordButtonLabel;
  static String get passwordUpdatedMessage =>
      L10n.current.grofastPasswordUpdatedMessage;

  // ── Wishlist ─────────────────────────────────────────────────────────────
  static String get wishlistTitle => L10n.current.grofastWishlistTitle;
  static String get wishlistEmptyTitle =>
      L10n.current.grofastWishlistEmptyTitle;
  static String get wishlistEmptySubtitle =>
      L10n.current.grofastWishlistEmptySubtitle;
  static String get wishlistExploreAction =>
      L10n.current.grofastWishlistExploreAction;

  // ── Notifications ────────────────────────────────────────────────────────
  static String get notificationsTitle =>
      L10n.current.grofastNotificationsTitle;
  static String get notificationsFilterAllLabel =>
      L10n.current.grofastNotificationsFilterAllLabel;
  static String get notificationsSearchHint =>
      L10n.current.grofastNotificationsSearchHint;
  static String get notificationsNowTitle =>
      L10n.current.grofastNotificationsNowTitle;
  static String get notificationsPastTitle =>
      L10n.current.grofastNotificationsPastTitle;
  static String get notificationsLoadErrorMessage =>
      L10n.current.grofastNotificationsLoadErrorMessage;
  static String get notificationsEmptyTitle =>
      L10n.current.grofastNotificationsEmptyTitle;
  static String get notificationsEmptySubtitle =>
      L10n.current.grofastNotificationsEmptySubtitle;
  static String get notificationsNoResultsTitle =>
      L10n.current.grofastNotificationsNoResultsTitle;
  static String notificationsNoResultsSubtitle(String query) =>
      L10n.current.grofastNotificationsNoResultsSubtitle(query);

  // ── Select address ───────────────────────────────────────────────────────
  static String get selectAddressTitle =>
      L10n.current.grofastSelectAddressTitle;
  static String get addNewAddressLabel =>
      L10n.current.grofastAddNewAddressLabel;
  static String get addressLoadErrorMessage =>
      L10n.current.grofastAddressLoadErrorMessage;
  static String get addressEmptyTitle => L10n.current.grofastAddressEmptyTitle;
  static String get addressEmptySubtitle =>
      L10n.current.grofastAddressEmptySubtitle;
  static String get addressSaveFailedMessage =>
      L10n.current.grofastAddressSaveFailedMessage;
  static String get addressDeleteFailedMessage =>
      L10n.current.grofastAddressDeleteFailedMessage;
  static String get editAddressTooltip =>
      L10n.current.grofastEditAddressTooltip;
  static String get deleteAddressTitle =>
      L10n.current.grofastDeleteAddressTitle;
  static String get deleteAddressMessage =>
      L10n.current.grofastDeleteAddressMessage;
  static String get deleteLabel => L10n.current.grofastDeleteLabel;
  static String get cancelLabel => L10n.current.grofastCancelLabel;

  // ── Address form ─────────────────────────────────────────────────────────
  static String get addAddressTitle => L10n.current.grofastAddAddressTitle;
  static String get editAddressTitle => L10n.current.grofastEditAddressTitle;
  static String get addressNameLabel => L10n.current.grofastAddressNameLabel;
  static String get addressNameHint => L10n.current.grofastAddressNameHint;
  static String get addressLine1Label => L10n.current.grofastAddressLine1Label;
  static String get addressLine1Hint => L10n.current.grofastAddressLine1Hint;
  static String get addressLine2Label => L10n.current.grofastAddressLine2Label;
  static String get addressLine2Hint => L10n.current.grofastAddressLine2Hint;
  static String get landmarkLabel => L10n.current.grofastLandmarkLabel;
  static String get landmarkHint => L10n.current.grofastLandmarkHint;
  static String get cityLabel => L10n.current.grofastCityLabel;
  static String get cityHint => L10n.current.grofastCityHint;
  static String get stateLabel => L10n.current.grofastStateLabel;
  static String get stateHint => L10n.current.grofastStateHint;
  static String get countryLabel => L10n.current.grofastCountryLabel;
  static String get selectCountryTitle =>
      L10n.current.grofastSelectCountryTitle;
  static String get postalCodeLabel => L10n.current.grofastPostalCodeLabel;
  static String get postalCodeHint => L10n.current.grofastPostalCodeHint;
  static String get addressTagLabel => L10n.current.grofastAddressTagLabel;
  static String get addressTagHint => L10n.current.grofastAddressTagHint;
  static String get mobileLabel => L10n.current.grofastMobileLabel;
  static String get mobileHint => L10n.current.grofastMobileHint;
  static String get addAddressButtonLabel =>
      L10n.current.grofastAddAddressButtonLabel;
  static String get updateAddressButtonLabel =>
      L10n.current.grofastUpdateAddressButtonLabel;
  static String get requiredFieldErrorMessage =>
      L10n.current.grofastRequiredFieldErrorMessage;

  /// The picklist behind the Country field (City is free text since geo
  /// prefill landed): the backend stores free text, so this is a
  /// convenience list, not an enum. Data values, not copy —
  /// locale-independent.
  static const addressFormCountries = <String>['India', 'Indonesia'];

  // ── My Orders ────────────────────────────────────────────────────────────
  static String get myOrdersTitle => L10n.current.grofastMyOrdersTitle;
  static String get ordersSearchHint => L10n.current.grofastOrdersSearchHint;
  static String get ordersFilterAllLabel =>
      L10n.current.grofastOrdersFilterAllLabel;
  static String get ordersFilterActiveLabel =>
      L10n.current.grofastOrdersFilterActiveLabel;
  static String get ordersFilterCompletedLabel =>
      L10n.current.grofastOrdersFilterCompletedLabel;
  static String get ordersFilterCancelledLabel =>
      L10n.current.grofastOrdersFilterCancelledLabel;

  /// The filter square's sheet. Dates only — the status axis is already on
  /// the screen as the chip row, and asking for it twice lets the two
  /// disagree (same call as dailymart's sheet).
  static String get ordersDateFilterTitle =>
      L10n.current.grofastOrdersDateFilterTitle;
  static String get ordersDateRangeLabel =>
      L10n.current.grofastOrdersDateRangeLabel;
  static String get ordersAllTimeLabel =>
      L10n.current.grofastOrdersAllTimeLabel;
  // Wordless ('Mar 01 - Mar 09'), so no arb key.
  static String ordersDateRangeValue(DateTime from, DateTime to) =>
      '${from.asFilterDate} - ${to.asFilterDate}';
  static String get ordersFilterLastWeekLabel =>
      L10n.current.grofastOrdersFilterLastWeekLabel;
  static String get ordersFilterLastMonthLabel =>
      L10n.current.grofastOrdersFilterLastMonthLabel;
  static String get ordersLoadErrorMessage =>
      L10n.current.grofastOrdersLoadErrorMessage;
  static String get ordersRefreshFailedMessage =>
      L10n.current.grofastOrdersRefreshFailedMessage;
  static String get ordersEmptyTitle => L10n.current.grofastOrdersEmptyTitle;
  static String get ordersEmptySubtitle =>
      L10n.current.grofastOrdersEmptySubtitle;
  static String get ordersNoResultsTitle =>
      L10n.current.grofastOrdersNoResultsTitle;
  static String get ordersNoResultsSubtitle =>
      L10n.current.grofastOrdersNoResultsSubtitle;
  static String orderNumberLabel(DateTime placedAt) =>
      L10n.current.grofastOrderNumberLabel(placedAt.asFilterDate);
  static String orderItemCount(int count) =>
      L10n.current.grofastOrderItemCount(count);

  /// The order card's bottom line (the kit's "Delivered to Yona's Home"),
  /// tensed by where the order actually is.
  static String orderDeliveryLine(String addressLabel, bool delivered) =>
      delivered
      ? L10n.current.grofastOrderDeliveredLine(addressLabel)
      : L10n.current.grofastOrderDeliveringLine(addressLabel);
  static String get orderCancelledLine =>
      L10n.current.grofastOrderCancelledLine;

  // ── Order tracking ───────────────────────────────────────────────────────
  static String get trackOrderTitle => L10n.current.grofastTrackOrderTitle;
  static String get orderDetailTitle => L10n.current.grofastOrderDetailTitle;
  static String get copyTooltip => L10n.current.grofastCopyTooltip;
  static String copiedMessage(String label) =>
      L10n.current.grofastCopiedMessage(label);
  static String get trackingDetailTitle =>
      L10n.current.grofastTrackingDetailTitle;
  static String get orderStatusLabel => L10n.current.grofastOrderStatusLabel;
  static String get purchaseDateLabel => L10n.current.grofastPurchaseDateLabel;
  static String get orderIdLabel => L10n.current.grofastOrderIdLabel;
  static String get deliveryOtpLabel => L10n.current.grofastDeliveryOtpLabel;
  static String get paymentIdLabel => L10n.current.grofastPaymentIdLabel;
  static String get amountPaidLabel => L10n.current.grofastAmountPaidLabel;
  static String get noOnlinePaymentLabel =>
      L10n.current.grofastNoOnlinePaymentLabel;
  static String get refundLabel => L10n.current.grofastRefundLabel;
  static String get orderReceivedLabel =>
      L10n.current.grofastOrderReceivedLabel;
  static String get cancelOrderLabel => L10n.current.grofastCancelOrderLabel;
  static String get cancelOrderTitle => L10n.current.grofastCancelOrderTitle;
  static String get cancelOrderMessage =>
      L10n.current.grofastCancelOrderMessage;
  static String get cancelOrderConfirmLabel =>
      L10n.current.grofastCancelOrderConfirmLabel;
  static String get orderCancelFailedMessage =>
      L10n.current.grofastOrderCancelFailedMessage;
  static String get orderStepUndatedLabel =>
      L10n.current.grofastOrderStepUndatedLabel;
  static String get orderStepPendingLabel =>
      L10n.current.grofastOrderStepPendingLabel;

  static String orderStatusName(OrderStatus status) => switch (status) {
    OrderStatus.pending => L10n.current.grofastStatusPlacedLabel,
    OrderStatus.inProcess => L10n.current.grofastStatusOnDeliveryLabel,
    OrderStatus.delivered => L10n.current.grofastStatusDeliveredLabel,
    OrderStatus.cancelled => L10n.current.grofastStatusCancelledLabel,
  };

  static String? refundStatusLabel(RefundStatus status) => switch (status) {
    RefundStatus.none => null,
    RefundStatus.pending => L10n.current.grofastRefundPendingLabel,
    RefundStatus.processed => L10n.current.grofastRefundProcessedLabel,
    RefundStatus.failed => L10n.current.grofastRefundFailedLabel,
  };
}
