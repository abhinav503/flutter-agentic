import 'package:core/core/extensions/num_extensions.dart';

import 'package:cordelia/l10n/l10n.dart';

/// Copy used only by the `gravia` template's storefront screens — scoped
/// here rather than the app-wide `ValueConst` so a second template can have
/// its own wording without touching this one.
///
/// Gravia is the (first) bilingual template: every user-facing string here
/// is a getter over [L10n.current] (`gravia*` keys in `lib/l10n/app_*.arb`),
/// so the store's language — applied by `StorefrontPage` — restyles the copy
/// the same way its theme config restyles the chrome. Only brand marks and
/// wordless number formats stay `const`.
abstract final class GraviaValueConst {
  // ── Home ─────────────────────────────────────────────────────────────────
  static String get categoriesTitle => L10n.current.graviaCategoriesTitle;
  static String get seeAll => L10n.current.graviaSeeAll;
  static String get popularItemsTitle => L10n.current.graviaPopularItemsTitle;
  static String get homeLoadErrorMessage =>
      L10n.current.graviaHomeLoadErrorMessage;

  // ── Shared sheet chrome / actions (gravia_sheet.dart, action pair) ───────
  static String get cancel => L10n.current.graviaCancel;

  // ── Product card (GraviaProductCard, shared across screens) ──────────────
  // Wordless (digits + '%'), so no arb key — locale can't change it.
  static String discountPercentLabel(double percentage) =>
      '${percentage.asPercent}%';
  static String discountPercentOffLabel(double percentage) =>
      L10n.current.graviaDiscountPercentOff(percentage.asPercent);
  static String get addToCart => L10n.current.graviaAddToCart;
  static String get addToCartSheetTitle =>
      L10n.current.graviaAddToCartSheetTitle;

  // ── Delete-address confirm sheet ──────────────────────────────────────────
  static String get deleteLabel => L10n.current.graviaDeleteLabel;
  static String get deleteAddressTitle => L10n.current.graviaDeleteAddressTitle;
  static String get deleteAddressConfirmMessage =>
      L10n.current.graviaDeleteAddressConfirmMessage;

  // ── Clear-cart confirm sheet ──────────────────────────────────────────────
  static String get clearCartTitle => L10n.current.graviaClearCartTitle;
  static String get clearCartConfirmMessage =>
      L10n.current.graviaClearCartConfirmMessage;
  static String get clearCartConfirmLabel =>
      L10n.current.graviaClearCartConfirmLabel;

  // ── Order Placed (checkout confirmation sheet) ────────────────────────────
  static String get orderPlacedTitle => L10n.current.graviaOrderPlacedTitle;
  static String get orderPlacedSubtitle =>
      L10n.current.graviaOrderPlacedSubtitle;
  static String get trackYourOrderLabel =>
      L10n.current.graviaTrackYourOrderLabel;

  // ── Search ───────────────────────────────────────────────────────────────
  static String get searchHint => L10n.current.graviaSearchHint;

  // ── Bottom navigation (kit tab set) ───────────────────────────────────────
  static String get navHome => L10n.current.graviaNavHome;
  static String get navCategories => L10n.current.graviaNavCategories;
  static String get navFavourite => L10n.current.graviaNavFavourite;
  static String get navOrders => L10n.current.graviaNavOrders;
  static String get navProfile => L10n.current.graviaNavProfile;

  // ── Search ─────────────────────────────────────────────────────────────────
  static String get recentSearchTitle => L10n.current.graviaRecentSearchTitle;
  static String get searchLoadErrorMessage =>
      L10n.current.graviaSearchLoadErrorMessage;
  static String get searchResultsErrorMessage =>
      L10n.current.graviaSearchResultsErrorMessage;
  static String get searchCategoryBadge =>
      L10n.current.graviaSearchCategoryBadge;
  static String get searchNoResultsTitle =>
      L10n.current.graviaSearchNoResultsTitle;
  static String searchNoResultsSubtitle(String query) =>
      L10n.current.graviaSearchNoResultsSubtitle(query);

  // ── Product Details ────────────────────────────────────────────────────────
  static String get productDetailsTitle =>
      L10n.current.graviaProductDetailsTitle;
  static String get selectQtyLabel => L10n.current.graviaSelectQtyLabel;
  static String get keyInformationTitle =>
      L10n.current.graviaKeyInformationTitle;
  static String get readMore => L10n.current.graviaReadMore;
  static String get readLess => L10n.current.graviaReadLess;
  static String get similarProductsTitle =>
      L10n.current.graviaSimilarProductsTitle;
  static String get productDetailsLoadErrorMessage =>
      L10n.current.graviaProductDetailsLoadErrorMessage;
  static String addToCartWithPrice(double price) =>
      L10n.current.graviaAddToCartWithPrice(price.asPrice);

  // ── Categories ─────────────────────────────────────────────────────────────
  static String get categoriesPageTitle =>
      L10n.current.graviaCategoriesPageTitle;
  static String get categoriesLoadErrorMessage =>
      L10n.current.graviaCategoriesLoadErrorMessage;
  static String get categoriesRefreshFailedMessage =>
      L10n.current.graviaCategoriesRefreshFailedMessage;

  // ── Category Details ───────────────────────────────────────────────────────
  static String get sortLabel => L10n.current.graviaSortLabel;
  static String get priceLabel => L10n.current.graviaPriceLabel;
  static String get sortBySheetTitle => L10n.current.graviaSortBySheetTitle;
  static String get priceSheetTitle => L10n.current.graviaPriceSheetTitle;
  static String get categoryDetailsEmptyMessage =>
      L10n.current.graviaCategoryDetailsEmptyMessage;

  // ── Select Address ─────────────────────────────────────────────────────────
  static String get selectAddressTitle => L10n.current.graviaSelectAddressTitle;
  static String get addNewAddressLabel => L10n.current.graviaAddNewAddressLabel;
  static String get defaultAddressSectionTitle =>
      L10n.current.graviaDefaultAddressSectionTitle;
  static String get otherAddressSectionTitle =>
      L10n.current.graviaOtherAddressSectionTitle;
  static String get editLabel => L10n.current.graviaEditLabel;
  static String get addressLoadErrorMessage =>
      L10n.current.graviaAddressLoadErrorMessage;
  static String get addressSaveFailedMessage =>
      L10n.current.graviaAddressSaveFailedMessage;
  static String get addressDeleteFailedMessage =>
      L10n.current.graviaAddressDeleteFailedMessage;
  static String get addressEmptyTitle => L10n.current.graviaAddressEmptyTitle;
  static String get addressEmptySubtitle =>
      L10n.current.graviaAddressEmptySubtitle;

  // ── Add/Edit Address ───────────────────────────────────────────────────────
  static String get editAddressTitle => L10n.current.graviaEditAddressTitle;
  static String get nameLabel => L10n.current.graviaNameLabel;
  static String get nameHint => L10n.current.graviaNameHint;
  static String get phoneNumberLabel => L10n.current.graviaPhoneNumberLabel;
  static String get phoneNumberHint => L10n.current.graviaPhoneNumberHint;
  static String get addressLine1Label => L10n.current.graviaAddressLine1Label;
  static String get addressLine1Hint => L10n.current.graviaAddressLine1Hint;
  static String get addressLine2Label => L10n.current.graviaAddressLine2Label;
  static String get addressLine2Hint => L10n.current.graviaAddressLine2Hint;
  static String get landmarkLabel => L10n.current.graviaLandmarkLabel;
  static String get landmarkHint => L10n.current.graviaLandmarkHint;
  static String get cityLabel => L10n.current.graviaCityLabel;
  static String get cityHint => L10n.current.graviaCityHint;
  static String get stateLabel => L10n.current.graviaStateLabel;
  static String get stateHint => L10n.current.graviaStateHint;
  static String get countryLabel => L10n.current.graviaCountryLabel;
  static String get selectCountryTitle => L10n.current.graviaSelectCountryTitle;
  static String get postalCodeLabel => L10n.current.graviaPostalCodeLabel;
  static String get postalCodeHint => L10n.current.graviaPostalCodeHint;
  static String get addressTagLabel => L10n.current.graviaAddressTagLabel;
  static String get addressTagHint => L10n.current.graviaAddressTagHint;
  static String get addAddressButtonLabel =>
      L10n.current.graviaAddAddressButtonLabel;
  static String get updateAddressButtonLabel =>
      L10n.current.graviaUpdateAddressButtonLabel;
  static String get requiredFieldErrorMessage =>
      L10n.current.graviaRequiredFieldErrorMessage;
  static String get useMyLocationLabel => L10n.current.graviaUseMyLocationLabel;
  static String get locationUnavailableMessage =>
      L10n.current.graviaLocationUnavailableMessage;

  // Data values, not copy — what the picklist stores on the address doc, so
  // they stay locale-independent English. (City stopped being a picklist
  // when geo prefill landed — real city names no fixed list could hold.)
  static const addressFormCountries = <String>[
    'India',
    'United States',
    'Canada',
    'United Kingdom',
    'Australia',
  ];

  // ── Profile ────────────────────────────────────────────────────────────────
  static String get profilePageTitle => L10n.current.graviaProfilePageTitle;
  static String get changePasswordLabel =>
      L10n.current.graviaChangePasswordLabel;
  static String get myOrdersLabel => L10n.current.graviaMyOrdersLabel;
  static String get myAddressLabel => L10n.current.graviaMyAddressLabel;
  static String get darkModeLabel => L10n.current.graviaDarkModeLabel;
  static String get privacyPolicyLabel => L10n.current.graviaPrivacyPolicyLabel;
  static String get termsAndConditionsLabel =>
      L10n.current.graviaTermsAndConditionsLabel;
  static String get logoutLabel => L10n.current.graviaLogoutLabel;
  static String get logoutTitle => L10n.current.graviaLogoutTitle;
  static String get logoutConfirmMessage =>
      L10n.current.graviaLogoutConfirmMessage;
  static String get profileLoadErrorMessage =>
      L10n.current.graviaProfileLoadErrorMessage;

  // ── Language (Profile row + picker sheet) ─────────────────────────────────
  static String get languageLabel => L10n.current.languageSheetTitle;
  static String get languageEnglish => L10n.current.languageEnglish;
  static String get languageHindi => L10n.current.languageHindi;

  // ── Edit Profile ───────────────────────────────────────────────────────────
  static String get editProfileTitle => L10n.current.graviaEditProfileTitle;
  static String get emailAddressLabel => L10n.current.graviaEmailAddressLabel;
  static String get emailAddressHint => L10n.current.graviaEmailAddressHint;
  static String get mobileNumberLabel => L10n.current.graviaMobileNumberLabel;
  static String get updateProfileButtonLabel =>
      L10n.current.graviaUpdateProfileButtonLabel;
  static String get changePhotoTitle => L10n.current.graviaChangePhotoTitle;
  static String get takePhotoLabel => L10n.current.graviaTakePhotoLabel;
  static String get chooseFromGalleryLabel =>
      L10n.current.graviaChooseFromGalleryLabel;
  static String get avatarPickerMobileOnlyMessage =>
      L10n.current.graviaAvatarPickerMobileOnlyMessage;

  // ── Change Password ──────────────────────────────────────────────────────
  static String get changePasswordTitle =>
      L10n.current.graviaChangePasswordTitle;
  static String get currentPasswordLabel =>
      L10n.current.graviaCurrentPasswordLabel;
  static String get currentPasswordHint =>
      L10n.current.graviaCurrentPasswordHint;
  static String get newPasswordLabel => L10n.current.graviaNewPasswordLabel;
  static String get newPasswordHint => L10n.current.graviaNewPasswordHint;
  static String get confirmNewPasswordLabel =>
      L10n.current.graviaConfirmNewPasswordLabel;
  static String get confirmNewPasswordHint =>
      L10n.current.graviaConfirmNewPasswordHint;
  static String get updatePasswordButtonLabel =>
      L10n.current.graviaUpdatePasswordButtonLabel;
  static String get passwordUpdatedMessage =>
      L10n.current.graviaPasswordUpdatedMessage;

  // ── Cart ───────────────────────────────────────────────────────────────────
  static String get myCartTitle => L10n.current.graviaMyCartTitle;
  static String get beforeYouCheckoutTitle =>
      L10n.current.graviaBeforeYouCheckoutTitle;
  static String get couponCodeLabel => L10n.current.graviaCouponCodeLabel;
  static String get applyLabel => L10n.current.graviaApplyLabel;
  static String get couponRemoveLabel => L10n.current.graviaCouponRemoveLabel;
  static String couponAppliedLabel(String code) =>
      L10n.current.graviaCouponApplied(code);
  static String couponLineLabel(String code) =>
      L10n.current.graviaCouponLine(code);
  static String get itemTotalLabel => L10n.current.graviaItemTotalLabel;
  static String get discountLabel => L10n.current.graviaDiscountLabel;
  static String get deliveryLabel => L10n.current.graviaDeliveryLabel;
  static String get deliveryFreeLabel => L10n.current.graviaDeliveryFreeLabel;
  static String get grandTotalLabel => L10n.current.graviaGrandTotalLabel;
  static String get proceedToCheckoutLabel =>
      L10n.current.graviaProceedToCheckoutLabel;
  static String get cartEmptyTitle => L10n.current.graviaCartEmptyTitle;
  static String get cartEmptySubtitle => L10n.current.graviaCartEmptySubtitle;
  static String get cartBarTitle => L10n.current.graviaCartBarTitle;
  static String get exploreLabel => L10n.current.graviaExploreLabel;
  static String get checkoutLabel => L10n.current.graviaCheckoutLabel;
  static String cartSummaryLabel(int itemCount, double total) =>
      L10n.current.graviaCartSummary(itemCount, total.asPrice);

  // ── Orders ─────────────────────────────────────────────────────────────────
  static String get ordersPageTitle => L10n.current.graviaOrdersPageTitle;
  static String get upcomingTabLabel => L10n.current.graviaUpcomingTabLabel;
  static String get pastTabLabel => L10n.current.graviaPastTabLabel;
  static String get pendingStatusLabel => L10n.current.graviaPendingStatusLabel;
  static String get inProcessStatusLabel =>
      L10n.current.graviaInProcessStatusLabel;
  static String get deliveredStatusLabel =>
      L10n.current.graviaDeliveredStatusLabel;
  static String get cancelledStatusLabel =>
      L10n.current.graviaCancelledStatusLabel;
  static String get deliveryOtpLabel => L10n.current.graviaDeliveryOtpLabel;
  static String get cancelOrderLabel => L10n.current.graviaCancelOrderLabel;
  static String get trackOrderLabel => L10n.current.graviaTrackOrderLabel;
  static String get viewDetailsLabel => L10n.current.graviaViewDetailsLabel;
  static String get writeReviewLabel => L10n.current.graviaWriteReviewLabel;

  // Refund state shown on a cancelled order card. No label for RefundStatus.none
  // — an unpaid/test order had no money to return, so nothing is shown.
  static String get refundPendingLabel => L10n.current.graviaRefundPendingLabel;
  static String get refundProcessedLabel =>
      L10n.current.graviaRefundProcessedLabel;
  static String get refundFailedLabel => L10n.current.graviaRefundFailedLabel;

  // Cancel confirmation + outcome.
  static String get cancelOrderConfirmTitle =>
      L10n.current.graviaCancelOrderConfirmTitle;
  static String get cancelOrderConfirmBody =>
      L10n.current.graviaCancelOrderConfirmBody;
  static String get cancelOrderConfirmCta =>
      L10n.current.graviaCancelOrderConfirmCta;
  static String get cancelOrderDismissCta =>
      L10n.current.graviaCancelOrderDismissCta;
  static String get cancelFailedMessage =>
      L10n.current.graviaCancelFailedMessage;
  // Wordless ('500g × 2'), so no arb key.
  static String weightQuantityLabel(String weight, int quantity) =>
      '$weight × $quantity';
  static String get ordersLoadErrorMessage =>
      L10n.current.graviaOrdersLoadErrorMessage;
  static String get ordersRefreshFailedMessage =>
      L10n.current.graviaOrdersRefreshFailedMessage;
  // ── Track Order ────────────────────────────────────────────────────────
  static String get trackOrderTitle => L10n.current.graviaTrackOrderTitle;
  static String get orderStatusTitle => L10n.current.graviaOrderStatusTitle;
  static String get orderItemsTitle => L10n.current.graviaOrderItemsTitle;
  static String get orderSummaryTitle => L10n.current.graviaOrderSummaryTitle;
  static String get orderDetailsTitle => L10n.current.graviaOrderDetailsTitle;
  static String get deliveryAddressTitle =>
      L10n.current.graviaDeliveryAddressTitle;
  static String get orderIdLabel => L10n.current.graviaOrderIdLabel;
  static String get orderPlacedOnLabel => L10n.current.graviaOrderPlacedOnLabel;
  static String get paymentIdLabel => L10n.current.graviaPaymentIdLabel;
  static String get noOnlinePaymentLabel =>
      L10n.current.graviaNoOnlinePaymentLabel;
  static String get refundLabel => L10n.current.graviaRefundLabel;
  static String get copiedMessage => L10n.current.graviaCopiedMessage;
  static String get orderTotalLabel => L10n.current.graviaOrderTotalLabel;

  /// The timeline's steps. The backend has three real statuses, so these are
  /// the three it can date — see `GraviaOrderStatusTimeline`.
  static String get orderStepPlacedLabel =>
      L10n.current.graviaOrderStepPlacedLabel;
  static String get orderStepOnTheWayLabel =>
      L10n.current.graviaOrderStepOnTheWayLabel;
  static String get orderStepDeliveredLabel =>
      L10n.current.graviaOrderStepDeliveredLabel;
  static String get orderStepCancelledLabel =>
      L10n.current.graviaOrderStepCancelledLabel;
  static String get orderStepUndatedLabel =>
      L10n.current.graviaOrderStepUndatedLabel;

  static String get ordersEmptyTitle => L10n.current.graviaOrdersEmptyTitle;
  static String get ordersEmptySubtitle =>
      L10n.current.graviaOrdersEmptySubtitle;
  static String get filterSheetTitle => L10n.current.graviaFilterSheetTitle;
  static String get filterReasonHeading =>
      L10n.current.graviaFilterReasonHeading;
  static String get filterLastWeekLabel =>
      L10n.current.graviaFilterLastWeekLabel;
  static String get filterLastMonthLabel =>
      L10n.current.graviaFilterLastMonthLabel;
  static String get filterStatusLabel => L10n.current.graviaFilterStatusLabel;
  static String get filterDateLabel => L10n.current.graviaFilterDateLabel;
  static String get filterAllStatusesLabel =>
      L10n.current.graviaFilterAllStatusesLabel;
  static String get applyFilterLabel => L10n.current.graviaApplyFilterLabel;
  // Wordless ('Mar 01 - Mar 09'), so no arb key.
  static String filterDateRangeLabel(String from, String to) => '$from - $to';

  // ── Favourite tab ───────────────────────────────────────────────────────
  static String get favouritePageTitle => L10n.current.graviaFavouritePageTitle;
  static String get favouriteEmptyTitle =>
      L10n.current.graviaFavouriteEmptyTitle;
  static String get favouriteEmptySubtitle =>
      L10n.current.graviaFavouriteEmptySubtitle;

  static String addedToCartMessage(String productName, int quantity) =>
      L10n.current.graviaAddedToCartMessage(quantity, productName);

  static String get deliveryLocationLabel =>
      L10n.current.graviaDeliveryLocationLabel;
  static String get noLocationSelectedLabel =>
      L10n.current.graviaNoLocationSelectedLabel;

  // ── Notifications ──────────────────────────────────────────────────────────
  static String get notificationsTitle => L10n.current.graviaNotificationsTitle;
  static String get notificationsLoadErrorMessage =>
      L10n.current.graviaNotificationsLoadErrorMessage;
  static String get notificationsEmptyTitle =>
      L10n.current.graviaNotificationsEmptyTitle;
  static String get notificationsEmptySubtitle =>
      L10n.current.graviaNotificationsEmptySubtitle;

  // ── Splash wordmark (black type; the middle glyph is the brand SVG) ──────
  // Brand marks, not copy — locale-independent.
  static const splashWordmarkLeft = 'GR';
  static const splashWordmarkRight = 'VIA';
}
