// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get languageSheetTitle => 'Language';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageHindi => 'हिन्दी';

  @override
  String get loginTitle => 'Welcome To CordeliaApps';

  @override
  String get loginSubtitle =>
      'Log in to your account using email or social networks';

  @override
  String get emailLabel => 'Email Address';

  @override
  String get emailHint => 'you@example.com';

  @override
  String get passwordLabel => 'Password';

  @override
  String get passwordHint => 'Enter your password';

  @override
  String get forgotPasswordLabel => 'Forgot Password?';

  @override
  String passwordResetEmailSentMessage(String email) {
    return 'Password reset link sent to $email';
  }

  @override
  String get continueLabel => 'Continue';

  @override
  String get orLoginWith => 'Or Login with';

  @override
  String get continueWithGoogle => 'Continue with Google';

  @override
  String get continueWithApple => 'Continue with Apple';

  @override
  String get byContinuingAgree => 'By continuing, you agree to our';

  @override
  String get termsOfServiceAndPrivacyPolicy =>
      'Terms of Service & Privacy Policy';

  @override
  String get dontHaveAccount => 'Don\'t have an account? ';

  @override
  String get signupLink => 'Signup';

  @override
  String get signupTitle => 'Sign Up Your Account';

  @override
  String get signupSubtitle => 'Enter your information below';

  @override
  String get nameLabel => 'Name';

  @override
  String get nameHint => 'e.g. Mark Shelby';

  @override
  String get mobileLabel => 'Mobile Number';

  @override
  String get mobileHint => '(303) 555-0105';

  @override
  String get iAgreeLabel => 'I Agree ';

  @override
  String get termsAndConditionsLink => 'Terms & Conditions';

  @override
  String get mustAgreeToTermsMessage =>
      'Please agree to the Terms & Conditions to continue.';

  @override
  String get authWebUnsupportedMessage =>
      'Sign-in is only available on mobile.';

  @override
  String get sessionExpiredMessage =>
      'Your session has expired. Please sign in again.';

  @override
  String get signupButtonLabel => 'Signup';

  @override
  String get alreadyHaveAccount => 'Already have an account? ';

  @override
  String get loginLink => 'Login';

  @override
  String get comingSoonMessage => 'Coming soon';

  @override
  String get paymentCancelledMessage => 'Payment cancelled';

  @override
  String get paymentFailedMessage =>
      'Payment could not be completed. Please try again.';

  @override
  String get verifyEmailTitle => 'Verify Your Email';

  @override
  String verifyEmailSubtitle(String email) {
    return 'We\'ve sent a verification link to $email. Open it, then come back here — this will update automatically.';
  }

  @override
  String get verifyEmailChecking => 'Checking…';

  @override
  String get resendEmailLabel => 'Resend email';

  @override
  String get termsAndConditionsLabel => 'Terms & Conditions';

  @override
  String get privacyPolicyLabel => 'Privacy Policy';

  @override
  String get legalLastUpdatedLabel => 'Last update: Mar 09, 2026';

  @override
  String get termsAndConditionsIntro =>
      'Please read these terms of service, carefully before using our app operated by us.';

  @override
  String get termsAndConditionsHeading => 'Conditions of Uses';

  @override
  String get termsAndConditionsBody =>
      'It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using \'Content here, content here\', making it look like readable English. Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a search for \'lorem ipsum\' will uncover many web sites still in their infancy. Various versions have evolved over the years, sometimes by accident, sometimes on purpose (injected humour and the like).';

  @override
  String get privacyPolicyIntro =>
      'Please read these privacy policy, carefully before using our app operated by us.';

  @override
  String get privacyPolicySection1Heading => '1. Information Collection';

  @override
  String get privacyPolicySection1Body =>
      'We collect essential information to enhance your experience. This includes details you provide directly, such as account data, as well as information gathered through usage analytics and cookies.';

  @override
  String get privacyPolicySection2Heading => '2. Information Usage';

  @override
  String get privacyPolicySection2Body =>
      'The information collected is used to improve our services, provide personalized recommendations, and ensure a seamless experience. We do not share your data without your explicit consent.';

  @override
  String get privacyPolicySection3Heading => '3. Information Setting';

  @override
  String get privacyPolicySection3Body =>
      'You have full control over your data. Manage your privacy preferences, update personal details, and customize your settings to match your needs.';

  @override
  String get privacyPolicySection4Heading => '4. Security Measures';

  @override
  String get privacyPolicySection4Body =>
      'We prioritize your data\'s safety with advanced security protocols, encryption methods, and regular audits to protect against unauthorized access or breaches.';

  @override
  String get profilePageTitle => 'Profile';

  @override
  String get changePasswordLabel => 'Change Password';

  @override
  String get myOrdersLabel => 'My Orders';

  @override
  String get myAddressLabel => 'My Address';

  @override
  String get darkModeLabel => 'Dark Mode';

  @override
  String get logoutLabel => 'Logout';

  @override
  String get logoutTitle => 'Logout';

  @override
  String get logoutConfirmMessage => 'Are you sure you want to log out?';

  @override
  String get deleteAccountLabel => 'Delete Account';

  @override
  String get deleteAccountTitle => 'Delete your account?';

  @override
  String get deleteAccountConfirmMessage =>
      'This permanently deletes your profile, addresses, cart, wishlist and reviews across every store. Orders you have already placed stay with those stores as their sales records. This cannot be undone.';

  @override
  String get deleteAccountFailedMessage =>
      'Could not delete your account. Please try again.';

  @override
  String get profileLoadErrorMessage =>
      'Something went wrong loading your profile.';

  @override
  String get sortRelevanceLabel => 'Relevance';

  @override
  String get sortPriceLowToHighLabel => 'Price (Low to High)';

  @override
  String get sortPriceHighToLowLabel => 'Price (High to Low)';

  @override
  String get sortRatingHighToLowLabel => 'Rating (High to Low)';

  @override
  String get sortDiscountHighToLowLabel => 'Discount (High to Low)';

  @override
  String get priceFilterAllLabel => 'All Prices';

  @override
  String get priceFilterUnder100Label => 'Under ₹100';

  @override
  String get priceFilter100To250Label => '₹100 - ₹250';

  @override
  String get priceFilter250To500Label => '₹250 - ₹500';

  @override
  String get priceFilterOver500Label => 'Over ₹500';

  @override
  String get reviewsSectionTitle => 'Ratings & Reviews';

  @override
  String get writeReviewLabel => 'Write a review';

  @override
  String get editReviewLabel => 'Edit your review';

  @override
  String get deleteReviewLabel => 'Delete';

  @override
  String get reviewSheetTitle => 'Rate this product';

  @override
  String get reviewRatingPrompt => 'How many stars?';

  @override
  String get reviewTextLabel => 'Your review';

  @override
  String get reviewTextHint => 'Tell other shoppers what you thought…';

  @override
  String get reviewSubmitLabel => 'Submit review';

  @override
  String get reviewMissingRatingMessage => 'Pick a star rating first.';

  @override
  String get reviewDeleteConfirmTitle => 'Delete your review?';

  @override
  String get reviewDeleteConfirmMessage =>
      'This removes your rating from the product\'s average. You can write a new one any time.';

  @override
  String get reviewSignedOutMessage => 'Sign in to review this product.';

  @override
  String get verifiedPurchaseLabel => 'Verified purchase';

  @override
  String get reviewsEmptyTitle => 'No reviews yet';

  @override
  String get reviewsEmptySubtitle =>
      'Be the first to rate this product and help other shoppers decide.';

  @override
  String get unratedLabel => 'No ratings yet';

  @override
  String get rateOrderLabel => 'Rate Order';

  @override
  String get editOrderRatingLabel => 'Edit Rating';

  @override
  String get rateOrderSheetTitle => 'How was this order?';

  @override
  String get rateOrderTextLabel => 'Your feedback';

  @override
  String get rateOrderTextHint => 'How was the delivery?';

  @override
  String get orderRatingNotDeliveredMessage =>
      'You can rate an order once it has been delivered.';

  @override
  String get orderRatingFailedMessage =>
      'Could not save your rating. Please try again.';

  @override
  String get yourRatingLabel => 'Your rating';

  @override
  String reviewCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count reviews',
      one: '$count review',
    );
    return '$_temp0';
  }

  @override
  String get reviewAgeJustNow => 'Just now';

  @override
  String reviewAgeMinutesAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minutes ago',
      one: '$count minute ago',
    );
    return '$_temp0';
  }

  @override
  String reviewAgeHoursAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hours ago',
      one: '$count hour ago',
    );
    return '$_temp0';
  }

  @override
  String reviewAgeDaysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days ago',
      one: '$count day ago',
    );
    return '$_temp0';
  }

  @override
  String reviewAgeMonthsAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count months ago',
      one: '$count month ago',
    );
    return '$_temp0';
  }

  @override
  String reviewAgeYearsAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count years ago',
      one: '$count year ago',
    );
    return '$_temp0';
  }

  @override
  String get graviaCategoriesTitle => 'All Categories';

  @override
  String get graviaSeeAll => 'See All';

  @override
  String get graviaPopularItemsTitle => 'Popular Items';

  @override
  String get graviaHomeLoadErrorMessage =>
      'Couldn\'t load this store\'s catalog.';

  @override
  String get graviaCancel => 'Cancel';

  @override
  String graviaDiscountPercentOff(String percent) {
    return '$percent% OFF';
  }

  @override
  String get graviaAddToCart => 'Add To Cart';

  @override
  String get graviaAddToCartSheetTitle => 'Add to Cart';

  @override
  String get graviaDeleteLabel => 'Delete';

  @override
  String get graviaDeleteAddressTitle => 'Delete Address';

  @override
  String get graviaDeleteAddressConfirmMessage =>
      'Are you sure you want to delete this address? This action cannot be undone.';

  @override
  String get graviaClearCartTitle => 'Clear Cart';

  @override
  String get graviaClearCartConfirmMessage =>
      'Are you sure you want to remove all items from your cart?';

  @override
  String get graviaClearCartConfirmLabel => 'Clear Cart';

  @override
  String get graviaOrderPlacedTitle => 'Order Placed Successfully';

  @override
  String get graviaOrderPlacedSubtitle =>
      'Thank you for your order you can track your delivery in the order section';

  @override
  String get graviaTrackYourOrderLabel => 'Track Your Order';

  @override
  String get graviaSearchHint => 'Search';

  @override
  String get graviaNavHome => 'Home';

  @override
  String get graviaNavCategories => 'Categories';

  @override
  String get graviaNavFavourite => 'Favourite';

  @override
  String get graviaNavOrders => 'Orders';

  @override
  String get graviaNavProfile => 'Profile';

  @override
  String get graviaRecentSearchTitle => 'Recent Search';

  @override
  String get graviaSearchLoadErrorMessage =>
      'Something went wrong loading search.';

  @override
  String get graviaSearchResultsErrorMessage =>
      'Something went wrong searching.';

  @override
  String get graviaSearchCategoryBadge => 'Category';

  @override
  String get graviaSearchNoResultsTitle => 'No results found';

  @override
  String graviaSearchNoResultsSubtitle(String query) {
    return 'Nothing matches \"$query\". Try a different keyword.';
  }

  @override
  String get graviaProductDetailsTitle => 'Product Details';

  @override
  String get graviaSelectQtyLabel => 'Select QTY';

  @override
  String get graviaKeyInformationTitle => 'Key Information';

  @override
  String get graviaReadMore => 'Read More';

  @override
  String get graviaReadLess => 'Read Less';

  @override
  String get graviaSimilarProductsTitle => 'Similar Products';

  @override
  String get graviaProductDetailsLoadErrorMessage =>
      'Something went wrong loading this product.';

  @override
  String graviaAddToCartWithPrice(String price) {
    return 'Add to Cart ($price)';
  }

  @override
  String get graviaCategoriesPageTitle => 'Categories';

  @override
  String get graviaCategoriesLoadErrorMessage =>
      'Something went wrong loading categories.';

  @override
  String get graviaCategoriesRefreshFailedMessage =>
      'Couldn\'t refresh — showing your last loaded categories.';

  @override
  String get graviaSortLabel => 'Sort';

  @override
  String get graviaPriceLabel => 'Price';

  @override
  String get graviaSortBySheetTitle => 'Sort by';

  @override
  String get graviaPriceSheetTitle => 'Price';

  @override
  String get graviaCategoryDetailsEmptyMessage =>
      'No products match these filters.';

  @override
  String get graviaSelectAddressTitle => 'Select Address';

  @override
  String get graviaAddNewAddressLabel => 'Add New Address';

  @override
  String get graviaDefaultAddressSectionTitle => 'Default Address';

  @override
  String get graviaOtherAddressSectionTitle => 'Other Address';

  @override
  String get graviaEditLabel => 'Edit';

  @override
  String get graviaAddressLoadErrorMessage =>
      'Something went wrong loading your addresses.';

  @override
  String get graviaAddressSaveFailedMessage =>
      'Could not save the address. Please try again.';

  @override
  String get graviaAddressDeleteFailedMessage =>
      'Could not delete the address. Please try again.';

  @override
  String get graviaAddressEmptyTitle => 'No saved addresses';

  @override
  String get graviaAddressEmptySubtitle =>
      'Add your first delivery address to get started.';

  @override
  String get graviaEditAddressTitle => 'Edit Address';

  @override
  String get graviaNameLabel => 'Name';

  @override
  String get graviaNameHint => 'e.g. Mark Shelby';

  @override
  String get graviaPhoneNumberLabel => 'Phone Number';

  @override
  String get graviaPhoneNumberHint => 'e.g. (303) 555-0105';

  @override
  String get graviaAddressLine1Label => 'Address Line 1';

  @override
  String get graviaAddressLine1Hint => 'House no., street name';

  @override
  String get graviaAddressLine2Label => 'Address Line 2';

  @override
  String get graviaAddressLine2Hint => 'Apartment, suite, etc. (optional)';

  @override
  String get graviaLandmarkLabel => 'Landmark';

  @override
  String get graviaLandmarkHint => 'Nearby landmark (optional)';

  @override
  String get graviaCityLabel => 'City';

  @override
  String get graviaCityHint => 'e.g. New Delhi';

  @override
  String get graviaStateLabel => 'State';

  @override
  String get graviaStateHint => 'e.g. Delhi (optional)';

  @override
  String get graviaCountryLabel => 'Country';

  @override
  String get graviaSelectCountryTitle => 'Select Country';

  @override
  String get graviaPostalCodeLabel => 'Postal Code';

  @override
  String get graviaPostalCodeHint => 'e.g. 62639';

  @override
  String get graviaAddressTagLabel => 'Tag';

  @override
  String get graviaAddressTagHint => 'e.g. Home, Office';

  @override
  String get graviaAddAddressButtonLabel => 'Add Address';

  @override
  String get graviaUpdateAddressButtonLabel => 'Update Address';

  @override
  String get graviaRequiredFieldErrorMessage => 'This field is required';

  @override
  String get graviaUseMyLocationLabel => 'Use my location';

  @override
  String get graviaLocationUnavailableMessage =>
      'Couldn\'t get your location. Check location permission and try again.';

  @override
  String get graviaAddressSearchLabel => 'Search Address';

  @override
  String get graviaAddressSearchHint => 'Search area, street, landmark…';

  @override
  String get graviaProfilePageTitle => 'Profile';

  @override
  String get graviaChangePasswordLabel => 'Change Password';

  @override
  String get graviaMyOrdersLabel => 'My Orders';

  @override
  String get graviaMyAddressLabel => 'My Address';

  @override
  String get graviaDarkModeLabel => 'Dark Mode';

  @override
  String get graviaPrivacyPolicyLabel => 'Privacy Policy';

  @override
  String get graviaTermsAndConditionsLabel => 'Terms & Conditions';

  @override
  String get graviaLogoutLabel => 'Logout';

  @override
  String get graviaLogoutTitle => 'Logout';

  @override
  String get graviaLogoutConfirmMessage => 'Are you sure you want to log out?';

  @override
  String get graviaProfileLoadErrorMessage =>
      'Something went wrong loading your profile.';

  @override
  String get graviaEditProfileTitle => 'Edit Profile';

  @override
  String get graviaEmailAddressLabel => 'Email Address';

  @override
  String get graviaEmailAddressHint => 'e.g. mark.shelby@example.com';

  @override
  String get graviaMobileNumberLabel => 'Mobile Number';

  @override
  String get graviaUpdateProfileButtonLabel => 'Update';

  @override
  String get graviaChangePhotoTitle => 'Change Photo';

  @override
  String get graviaTakePhotoLabel => 'Take Photo';

  @override
  String get graviaChooseFromGalleryLabel => 'Choose from Gallery';

  @override
  String get graviaAvatarPickerMobileOnlyMessage =>
      'Changing your photo is only available on mobile';

  @override
  String get graviaChangePasswordTitle => 'Change Password';

  @override
  String get graviaCurrentPasswordLabel => 'Current Password';

  @override
  String get graviaCurrentPasswordHint => 'Enter your current password';

  @override
  String get graviaNewPasswordLabel => 'New Password';

  @override
  String get graviaNewPasswordHint => 'Enter your new password';

  @override
  String get graviaConfirmNewPasswordLabel => 'Confirm New Password';

  @override
  String get graviaConfirmNewPasswordHint => 'Re-enter your new password';

  @override
  String get graviaUpdatePasswordButtonLabel => 'Update Password';

  @override
  String get graviaPasswordUpdatedMessage => 'Your password has been updated.';

  @override
  String get graviaMyCartTitle => 'My Cart';

  @override
  String get graviaBeforeYouCheckoutTitle => 'Before you Checkout';

  @override
  String get graviaCouponCodeLabel => 'Coupon Code';

  @override
  String get graviaApplyLabel => 'Apply';

  @override
  String get graviaCouponRemoveLabel => 'Remove';

  @override
  String graviaCouponApplied(String code) {
    return '$code applied';
  }

  @override
  String graviaCouponLine(String code) {
    return 'Coupon ($code)';
  }

  @override
  String get graviaItemTotalLabel => 'Item Total';

  @override
  String get graviaDiscountLabel => 'Discount';

  @override
  String get graviaDeliveryLabel => 'Delivery';

  @override
  String get graviaDeliveryFreeLabel => 'FREE';

  @override
  String get graviaGrandTotalLabel => 'Grand Total';

  @override
  String get graviaProceedToCheckoutLabel => 'Proceed to Checkout';

  @override
  String get graviaCartEmptyTitle => 'Your cart is empty';

  @override
  String get graviaCartEmptySubtitle => 'Add items to get started.';

  @override
  String get graviaCartBarTitle => 'See more products';

  @override
  String get graviaExploreLabel => 'Explore';

  @override
  String get graviaCheckoutLabel => 'Checkout';

  @override
  String graviaCartSummary(int count, String total) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items',
      one: '$count item',
    );
    return '$_temp0 | $total';
  }

  @override
  String get graviaOrdersPageTitle => 'Orders';

  @override
  String get graviaUpcomingTabLabel => 'Upcoming';

  @override
  String get graviaPastTabLabel => 'Past';

  @override
  String get graviaPendingStatusLabel => 'Order Placed';

  @override
  String get graviaInProcessStatusLabel => 'On the way';

  @override
  String get graviaDeliveredStatusLabel => 'Delivered';

  @override
  String get graviaCancelledStatusLabel => 'Cancelled';

  @override
  String get graviaDeliveryOtpLabel => 'Delivery OTP';

  @override
  String get graviaCancelOrderLabel => 'Cancel';

  @override
  String get graviaTrackOrderLabel => 'Track Order';

  @override
  String get graviaViewDetailsLabel => 'View Details';

  @override
  String get graviaWriteReviewLabel => 'Write A Review';

  @override
  String get graviaRefundPendingLabel => 'Refund processing';

  @override
  String get graviaRefundProcessedLabel => 'Refunded';

  @override
  String get graviaRefundFailedLabel => 'Refund failed';

  @override
  String get graviaCancelOrderConfirmTitle => 'Cancel this order?';

  @override
  String get graviaCancelOrderConfirmBody =>
      'This will cancel your order. If you paid, you\'ll be refunded in full.';

  @override
  String get graviaCancelOrderConfirmCta => 'Cancel Order';

  @override
  String get graviaCancelOrderDismissCta => 'Keep Order';

  @override
  String get graviaCancelFailedMessage =>
      'Could not cancel the order. Please try again.';

  @override
  String get graviaOrdersLoadErrorMessage =>
      'Something went wrong loading your orders.';

  @override
  String get graviaOrdersRefreshFailedMessage =>
      'Couldn\'t refresh — showing your last loaded orders.';

  @override
  String get graviaTrackOrderTitle => 'Track Order';

  @override
  String get graviaOrderStatusTitle => 'Order Status';

  @override
  String get graviaOrderItemsTitle => 'Items';

  @override
  String get graviaOrderSummaryTitle => 'Summary';

  @override
  String get graviaOrderDetailsTitle => 'Order Details';

  @override
  String get graviaDeliveryAddressTitle => 'Delivery Address';

  @override
  String get graviaOrderIdLabel => 'Order ID';

  @override
  String get graviaOrderPlacedOnLabel => 'Placed on';

  @override
  String get graviaPaymentIdLabel => 'Payment ID';

  @override
  String get graviaNoOnlinePaymentLabel => 'No online payment';

  @override
  String get graviaRefundLabel => 'Refund';

  @override
  String get graviaCopiedMessage => 'Copied';

  @override
  String get graviaOrderTotalLabel => 'Total Paid';

  @override
  String get graviaOrderStepPlacedLabel => 'Order Placed';

  @override
  String get graviaOrderStepOnTheWayLabel => 'On the way';

  @override
  String get graviaOrderStepDeliveredLabel => 'Delivered';

  @override
  String get graviaOrderStepCancelledLabel => 'Cancelled';

  @override
  String get graviaOrderStepUndatedLabel => 'Time not recorded';

  @override
  String get graviaOrdersEmptyTitle => 'No orders yet';

  @override
  String get graviaOrdersEmptySubtitle =>
      'Your past and active orders will show up here.';

  @override
  String get graviaFilterSheetTitle => 'Filter';

  @override
  String get graviaFilterReasonHeading => 'Select a Reason';

  @override
  String get graviaFilterLastWeekLabel => 'Last Week';

  @override
  String get graviaFilterLastMonthLabel => 'Last Month';

  @override
  String get graviaFilterStatusLabel => 'Status';

  @override
  String get graviaFilterDateLabel => 'Date';

  @override
  String get graviaFilterAllStatusesLabel => 'All';

  @override
  String get graviaApplyFilterLabel => 'Apply Filter';

  @override
  String get graviaFavouritePageTitle => 'Favourite';

  @override
  String get graviaFavouriteEmptyTitle => 'No favourites yet';

  @override
  String get graviaFavouriteEmptySubtitle =>
      'Tap the heart on a product to keep it here.';

  @override
  String graviaAddedToCartMessage(int count, String name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count × $name added to cart',
      one: '$name added to cart',
    );
    return '$_temp0';
  }

  @override
  String get graviaDeliveryLocationLabel => 'Delivery Location';

  @override
  String get graviaNoLocationSelectedLabel => 'No Location selected';

  @override
  String get graviaNotificationsTitle => 'Notifications';

  @override
  String get graviaNotificationsLoadErrorMessage =>
      'Something went wrong loading your notifications.';

  @override
  String get graviaNotificationsEmptyTitle => 'No notifications yet';

  @override
  String get graviaNotificationsEmptySubtitle =>
      'Updates about your orders and account will show up here.';

  @override
  String get validationNameRequired => 'Please enter your name.';

  @override
  String get validationEmailRequired => 'Please enter your email address.';

  @override
  String get validationEmailInvalid => 'Enter a valid email address.';

  @override
  String get validationMobileRequired => 'Please enter your mobile number.';

  @override
  String get validationMobileInvalid => 'Enter a valid mobile number.';

  @override
  String get validationPasswordRequired => 'Please enter your password.';

  @override
  String get validationWeakPassword =>
      'Password must be at least 6 characters.';

  @override
  String get validationConfirmPasswordRequired =>
      'Please confirm your new password.';

  @override
  String get validationPasswordsDontMatch => 'Passwords do not match.';

  @override
  String get retryButton => 'Retry';
}
