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
  String get languageGerman => 'Deutsch';

  @override
  String get languageFrench => 'Français';

  @override
  String get languageSpanish => 'Español';

  @override
  String get languageItalian => 'Italiano';

  @override
  String unitPiecesLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'pcs',
      one: 'pc',
    );
    return '$_temp0';
  }

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
  String get deliveryUnavailableMessage =>
      'This store doesn\'t deliver to the address you picked.';

  @override
  String get paymentCancelledMessage => 'Payment cancelled';

  @override
  String couponMinOrderMessage(String price) {
    return 'Your order is below this coupon\'s minimum of $price';
  }

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
  String get legalLastUpdatedLabel => 'Last update: Aug 06, 2026';

  @override
  String get termsAndConditionsIntro =>
      'These terms apply whenever you use the CordeliaApps shopping app. Please read them before you order — creating an account or placing an order means you accept them.';

  @override
  String get termsAndConditionsSection1Heading => '1. Who We Are';

  @override
  String get termsAndConditionsSection1Body =>
      'CordeliaApps builds and operates this shopping app. We are based in India and work with stores in India, the United Kingdom, the United States and across Europe, so the app is available in several languages and shows prices in each store\'s own currency. Where a translation differs from the English version, the English version is the one we go by.';

  @override
  String get termsAndConditionsSection2Heading =>
      '2. Our Role — Who You Buy From';

  @override
  String get termsAndConditionsSection2Body =>
      'CordeliaApps is the platform, not the shop. Every product you see is listed, priced, sold and delivered by the individual store you are browsing, and your purchase agreement is with that store. We are not the seller and we do not take payment for the goods, so questions about an order, a product or a refund are handled by the store, with the app as the place you reach them.';

  @override
  String get termsAndConditionsSection3Heading => '3. Your Account';

  @override
  String get termsAndConditionsSection3Body =>
      'You need an account to order. Give accurate details, verify your email address, and keep your password to yourself — anything done through your account is treated as done by you. You can delete your account at any time from your profile. Your past orders stay with the stores that fulfilled them, because those are the stores\' own business records.';

  @override
  String get termsAndConditionsSection4Heading => '4. Orders and Payment';

  @override
  String get termsAndConditionsSection4Body =>
      'Placing an order is an offer to buy from the store. The store may decline it — for example if an item has sold out or cannot be delivered to your address — and will refund you in full if it does. Prices are set by the store in its own currency and include applicable taxes unless the store says otherwise. Payment is taken by the store\'s payment provider and settles to the store; CordeliaApps never holds your money.';

  @override
  String get termsAndConditionsSection5Heading =>
      '5. Delivery, Cancellations and Refunds';

  @override
  String get termsAndConditionsSection5Body =>
      'The store fulfils and delivers your order, and any delivery time shown is an estimate rather than a promise. You can cancel an order in the app until it is dispatched, and the store refunds it to the payment method you used. Where a refund is due for any other reason, the store issues it. None of this reduces the rights your local law gives you.';

  @override
  String get termsAndConditionsSection6Heading =>
      '6. Product Information and Reviews';

  @override
  String get termsAndConditionsSection6Body =>
      'Stores write their own product names, descriptions, images and prices, so that information comes from the store rather than from us. Mistakes can happen, and a store may correct an error or cancel and refund an affected order. If you post a review it must reflect your own experience — you keep ownership of what you write and allow us and the store to show it in the app. We may remove content that is false, offensive or breaks these terms.';

  @override
  String get termsAndConditionsSection7Heading => '7. Acceptable Use';

  @override
  String get termsAndConditionsSection7Body =>
      'Use the app for shopping and nothing else. Do not place fraudulent orders, create accounts that are not yours, collect data from the app automatically, interfere with how it works, or use it for anything unlawful. We may suspend or close an account that does.';

  @override
  String get termsAndConditionsSection8Heading =>
      '8. Availability and Our Responsibility';

  @override
  String get termsAndConditionsSection8Body =>
      'We work to keep the app running well, but we cannot promise it will always be available or free of faults, and we may change or withdraw features. We are responsible for the app itself. We are not responsible for the goods a store sells, for the accuracy of what a store publishes, or for how a store handles your order. Nothing here limits any liability the law does not allow us to limit.';

  @override
  String get termsAndConditionsSection9Heading =>
      '9. Governing Law and Your Local Rights';

  @override
  String get termsAndConditionsSection9Body =>
      'These terms are governed by the laws of India and the courts of India have jurisdiction. Because we serve shoppers in other countries, this does not take away the protection of mandatory consumer law where you live. If you are a consumer in the United Kingdom or the European Union you keep your local statutory rights, including any right to withdraw from a purchase within the period your law allows.';

  @override
  String get termsAndConditionsSection10Heading => '10. Changes and Contact';

  @override
  String get termsAndConditionsSection10Body =>
      'We update these terms as the app changes, and the date at the top of this page shows when they last changed. Continuing to use the app after a change means you accept the updated terms. If anything here is unclear, or you need help with an order, write to us at support@cordeliaapps.com.';

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
  String priceFilterUnderLabel(String price) {
    return 'Under $price';
  }

  @override
  String priceFilterOverLabel(String price) {
    return 'Over $price';
  }

  @override
  String priceFilterRangeLabel(String from, String to) {
    return '$from - $to';
  }

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
  String get outOfStockLabel => 'Out of Stock';

  @override
  String onlyNLeftLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Only $count left',
      one: 'Only 1 left',
    );
    return '$_temp0';
  }

  @override
  String get cartUnavailableItemsMessage =>
      'Some items in your cart are no longer available. Update your cart to continue.';

  @override
  String productSoldOutMessage(String name) {
    return '$name just sold out. Update your cart to continue.';
  }

  @override
  String productStockReducedMessage(String name) {
    return 'There isn\'t enough $name left. Update your cart to continue.';
  }

  @override
  String get checkoutFailedMessage => 'Your order couldn\'t be placed.';

  @override
  String get paymentRefundedNote => 'Your payment has been refunded.';

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
  String orderPlacedAtLabel(String date, String time) {
    return '$date at $time';
  }

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
  String get dailymartTopSellerTitle => 'Top Seller🔥';

  @override
  String get dailymartCategoriesTitle => 'Shop by category';

  @override
  String get dailymartPopularProductsTitle => 'Popular Products';

  @override
  String get dailymartSeeAll => 'See all';

  @override
  String get dailymartSearchHint => 'Search for products';

  @override
  String get dailymartHomeLoadErrorMessage =>
      'Couldn\'t load this store\'s catalog.';

  @override
  String get dailymartNoLocationSelectedLabel => 'Select a location';

  @override
  String get dailymartNotificationsTitle => 'Notification';

  @override
  String get dailymartNotificationsLoadErrorMessage =>
      'Couldn\'t load your notifications.';

  @override
  String get dailymartNotificationsEmptyTitle => 'No notifications yet';

  @override
  String get dailymartNotificationsEmptySubtitle =>
      'Deals and order updates from this store will show up here.';

  @override
  String get dailymartOrderNow => 'Order Now';

  @override
  String dailymartPromoSubtitle(String percent) {
    return 'Enjoy discounts of up to $percent%\non your order today';
  }

  @override
  String dailymartDiscountPercentOff(String percent) {
    return '$percent% off';
  }

  @override
  String get dailymartNavHome => 'Home';

  @override
  String get dailymartNavWishlist => 'Wishlist';

  @override
  String get dailymartNavCart => 'Cart';

  @override
  String get dailymartNavProfile => 'Profile';

  @override
  String get dailymartRecentSearchTitle => 'Recent Search';

  @override
  String get dailymartRecentlyViewedTitle => 'Recently viewed';

  @override
  String dailymartResultsForLabel(String query) {
    return 'Result for \"$query\"';
  }

  @override
  String dailymartResultsCountLabel(int count) {
    return '$count founds';
  }

  @override
  String get dailymartSearchLoadErrorMessage => 'Couldn\'t load search.';

  @override
  String get dailymartSearchResultsErrorMessage =>
      'Couldn\'t search this store.';

  @override
  String get dailymartSearchNoResultsTitle => 'No results';

  @override
  String dailymartSearchNoResultsSubtitle(String query) {
    return 'Nothing in this store matches \"$query\" yet.';
  }

  @override
  String get dailymartCategoryBadge => 'Category';

  @override
  String get dailymartFilterLabel => 'Filter';

  @override
  String get dailymartSortSheetTitle => 'Sort by';

  @override
  String get dailymartPriceSheetTitle => 'Price';

  @override
  String get dailymartCategoryDetailsEmptyTitle => 'Nothing here';

  @override
  String get dailymartCategoryDetailsEmptySubtitle =>
      'No products in this category match those filters.';

  @override
  String get dailymartCategoryDetailsErrorMessage =>
      'Couldn\'t load this category.';

  @override
  String get dailymartWishlistEmptyTitle => 'Nothing saved yet';

  @override
  String get dailymartWishlistEmptySubtitle =>
      'Tap the heart on a product and it will wait for you here.';

  @override
  String get dailymartWishlistExploreAction => 'Start shopping';

  @override
  String get dailymartProductDetailsTitle => 'Product Details';

  @override
  String get dailymartDescriptionsTabLabel => 'Descriptions';

  @override
  String get dailymartReviewsTabLabel => 'Reviews';

  @override
  String get dailymartRelatedProductsTitle => 'Related Products';

  @override
  String get dailymartSelectSizeLabel => 'Select Size';

  @override
  String get dailymartProductDetailsLoadErrorMessage =>
      'Couldn\'t load this product\'s details.';

  @override
  String get dailymartAddToCart => 'Add To Cart';

  @override
  String get dailymartAddToCartSheetTitle => 'Add To Cart';

  @override
  String dailymartAddedToCartMessage(int count, String name) {
    return 'Added $count × $name to your cart.';
  }

  @override
  String dailymartStarRowLabel(int stars) {
    return '$stars Star';
  }

  @override
  String get dailymartMyCartTitle => 'My Cart';

  @override
  String get dailymartCouponHint => 'Enter coupon code';

  @override
  String get dailymartCouponRemoveLabel => 'Remove';

  @override
  String get dailymartCouponDetailLabel => 'Coupon';

  @override
  String dailymartCouponApplied(String code) {
    return '$code applied';
  }

  @override
  String dailymartCouponLine(String code) {
    return 'Coupon ($code)';
  }

  @override
  String get dailymartSubTotalLabel => 'Sub total';

  @override
  String get dailymartDeliveryLabel => 'Delivery';

  @override
  String get dailymartDeliveryFreeLabel => 'Free';

  @override
  String get dailymartDiscountLabel => 'Discount';

  @override
  String get dailymartTotalCostLabel => 'Total cost';

  @override
  String get dailymartProceedToCheckoutLabel => 'Proceed to Checkout';

  @override
  String get dailymartCartEmptyTitle => 'Your cart is empty';

  @override
  String get dailymartCartEmptySubtitle =>
      'Products you add will show up here, ready to check out.';

  @override
  String get dailymartCartExploreAction => 'Start shopping';

  @override
  String get dailymartRemovedFromCartMessage => 'Removed from your cart.';

  @override
  String get dailymartCheckoutTitle => 'Checkout';

  @override
  String get dailymartShippingAddressLabel => 'Shipping Address';

  @override
  String get dailymartOrderListLabel => 'Order List';

  @override
  String get dailymartContinueToPaymentLabel => 'Continue to Payment';

  @override
  String get dailymartOrderPlacedTitle => 'Payment Successful!';

  @override
  String get dailymartOrderPlacedMessage =>
      'Thank you for your purchase! We\'re excited to let you know that your payment has been successfully processed. 🎉';

  @override
  String get dailymartTrackOrderLabel => 'Track My Order';

  @override
  String dailymartCartSummary(int count, String total) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items',
      one: '$count item',
    );
    return '$_temp0 | $total';
  }

  @override
  String get dailymartViewCartLabel => 'View Cart';

  @override
  String get dailymartGeneralSectionTitle => 'General';

  @override
  String get dailymartPreferencesSectionTitle => 'Preferences';

  @override
  String get dailymartEditProfileLabel => 'Edit Profile';

  @override
  String get dailymartChangePasswordLabel => 'Change Password';

  @override
  String get dailymartMyOrdersLabel => 'My Orders';

  @override
  String get dailymartMyAddressLabel => 'My Address';

  @override
  String get dailymartDarkModeLabel => 'Dark Mode';

  @override
  String get dailymartPrivacyPolicyLabel => 'Privacy Policy';

  @override
  String get dailymartTermsAndConditionsLabel => 'Terms & Conditions';

  @override
  String get dailymartLogoutLabel => 'Logout';

  @override
  String get dailymartLogoutTitle => 'Log out?';

  @override
  String get dailymartLogoutConfirmMessage =>
      'You\'ll need to sign in again to place an order or track one.';

  @override
  String get dailymartProfileLoadErrorMessage => 'Couldn\'t load your profile.';

  @override
  String get dailymartEditProfileTitle => 'Edit Profile';

  @override
  String get dailymartFullNameLabel => 'Full Name';

  @override
  String get dailymartFullNameHint => 'Enter your full name';

  @override
  String get dailymartEmailLabel => 'Email';

  @override
  String get dailymartEmailHint => 'you@example.com';

  @override
  String get dailymartPhoneNumberLabel => 'Phone Number';

  @override
  String get dailymartPhoneNumberHint => 'Enter your phone number';

  @override
  String get dailymartSaveChangesLabel => 'Save Changes';

  @override
  String get dailymartChangePhotoTitle => 'Change Photo';

  @override
  String get dailymartTakePhotoLabel => 'Take Photo';

  @override
  String get dailymartChooseFromGalleryLabel => 'Choose from Gallery';

  @override
  String get dailymartAvatarPickerMobileOnlyMessage =>
      'Choosing a photo is only available on mobile.';

  @override
  String get dailymartChangePasswordTitle => 'Change Password';

  @override
  String get dailymartCurrentPasswordLabel => 'Current Password';

  @override
  String get dailymartCurrentPasswordHint => 'Enter your current password';

  @override
  String get dailymartNewPasswordLabel => 'New Password';

  @override
  String get dailymartNewPasswordHint => 'Enter your new password';

  @override
  String get dailymartConfirmNewPasswordLabel => 'Confirm New Password';

  @override
  String get dailymartConfirmNewPasswordHint => 'Re-enter your new password';

  @override
  String get dailymartUpdatePasswordButtonLabel => 'Update Password';

  @override
  String get dailymartPasswordUpdatedMessage =>
      'Your password has been updated.';

  @override
  String get dailymartSelectAddressTitle => 'Select Address';

  @override
  String get dailymartAddNewAddressLabel => 'Add New Address';

  @override
  String get dailymartAddressLoadErrorMessage =>
      'Couldn\'t load your addresses.';

  @override
  String get dailymartAddressSaveFailedMessage =>
      'Couldn\'t save that address.';

  @override
  String get dailymartAddressEmptyTitle => 'No saved addresses';

  @override
  String get dailymartAddressEmptySubtitle =>
      'Add one to get this store delivering to your door.';

  @override
  String get dailymartAddressDeleteFailedMessage =>
      'Couldn\'t delete that address.';

  @override
  String get dailymartEditAddressTooltip => 'Edit address';

  @override
  String get dailymartDeleteAddressTitle => 'Delete this address?';

  @override
  String get dailymartDeleteAddressMessage =>
      'It\'ll be removed from your saved addresses.';

  @override
  String get dailymartDeleteLabel => 'Delete';

  @override
  String get dailymartAddAddressTitle => 'Add New Address';

  @override
  String get dailymartEditAddressTitle => 'Edit Address';

  @override
  String get dailymartAddressNameLabel => 'Name';

  @override
  String get dailymartAddressNameHint => 'e.g. Mark Shelby';

  @override
  String get dailymartAddressLine1Label => 'Address Line 1';

  @override
  String get dailymartAddressLine1Hint => 'House no., street name';

  @override
  String get dailymartAddressLine2Label => 'Address Line 2';

  @override
  String get dailymartAddressLine2Hint => 'Apartment, suite, etc. (optional)';

  @override
  String get dailymartLandmarkLabel => 'Landmark';

  @override
  String get dailymartLandmarkHint => 'Nearby landmark (optional)';

  @override
  String get dailymartCityLabel => 'City';

  @override
  String get dailymartCityHint => 'e.g. New Delhi';

  @override
  String get dailymartStateLabel => 'State';

  @override
  String get dailymartStateHint => 'e.g. Delhi (optional)';

  @override
  String get dailymartCountryLabel => 'Country';

  @override
  String get dailymartSelectCountryTitle => 'Select Country';

  @override
  String get dailymartPostalCodeLabel => 'Postal Code';

  @override
  String get dailymartPostalCodeHint => 'e.g. 62639';

  @override
  String get dailymartAddressTagLabel => 'Tag';

  @override
  String get dailymartAddressTagHint => 'e.g. Home, Office';

  @override
  String get dailymartAddAddressButtonLabel => 'Add Address';

  @override
  String get dailymartUpdateAddressButtonLabel => 'Update Address';

  @override
  String get dailymartRequiredFieldErrorMessage => 'This field is required';

  @override
  String get dailymartMyOrdersTitle => 'My Orders';

  @override
  String get dailymartOrdersSearchHint => 'What are you looking for...';

  @override
  String get dailymartOrdersFilterAllLabel => 'All';

  @override
  String get dailymartOrdersFilterActiveLabel => 'Active';

  @override
  String get dailymartOrdersFilterCompletedLabel => 'Completed';

  @override
  String get dailymartOrdersFilterCancelledLabel => 'Cancelled';

  @override
  String dailymartOrderSummaryLabel(int count, String date) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items',
      one: '$count item',
    );
    return '$_temp0 · $date';
  }

  @override
  String get dailymartOrdersDateRangeLabel => 'Date Range';

  @override
  String get dailymartOrdersAllTimeLabel => 'All time';

  @override
  String get dailymartOrdersFilterLastWeekLabel => 'Last week';

  @override
  String get dailymartOrdersFilterLastMonthLabel => 'Last month';

  @override
  String get dailymartResetLabel => 'Reset';

  @override
  String get dailymartApplyLabel => 'Apply';

  @override
  String get dailymartOrdersLoadErrorMessage => 'Couldn\'t load your orders.';

  @override
  String get dailymartOrdersEmptyTitle => 'No orders yet';

  @override
  String get dailymartOrdersEmptySubtitle =>
      'Your orders from this store will show up here.';

  @override
  String get dailymartOrdersNoResultsTitle => 'Nothing here';

  @override
  String get dailymartOrdersNoResultsSubtitle =>
      'No orders match that search or filter.';

  @override
  String get dailymartOrderCancelFailedMessage =>
      'Couldn\'t cancel that order.';

  @override
  String get dailymartOrdersRefreshFailedMessage =>
      'Couldn\'t refresh your orders.';

  @override
  String get dailymartTrackOrderTitle => 'Track Order';

  @override
  String get dailymartTrackOrderAction => 'Track Order';

  @override
  String get dailymartOrderDetailsTitle => 'Order Details';

  @override
  String get dailymartOrderIdLabel => 'Order ID';

  @override
  String get dailymartDeliveryOtpLabel => 'Delivery OTP';

  @override
  String get dailymartPaymentTitle => 'Payment';

  @override
  String get dailymartAmountPaidLabel => 'Amount Paid';

  @override
  String get dailymartPaymentIdLabel => 'Payment ID';

  @override
  String get dailymartRefundLabel => 'Refund';

  @override
  String get dailymartCopiedMessage => 'Copied';

  @override
  String get dailymartNoOnlinePaymentLabel => 'Not paid online';

  @override
  String get dailymartRefundPendingLabel => 'Processing';

  @override
  String get dailymartRefundProcessedLabel => 'Refunded';

  @override
  String get dailymartRefundFailedLabel => 'Refund failed';

  @override
  String get dailymartOrderStatusTitle => 'Order Status';

  @override
  String get dailymartOrderStepPlacedLabel => 'Order Placed';

  @override
  String get dailymartOrderStepOnTheWayLabel => 'On the way';

  @override
  String get dailymartOrderStepDeliveredLabel => 'Delivered';

  @override
  String get dailymartOrderStepCancelledLabel => 'Cancelled';

  @override
  String get dailymartOrderStepUndatedLabel => 'Time not recorded';

  @override
  String get dailymartOrderStepPendingLabel => 'Pending';

  @override
  String get dailymartCancelOrderLabel => 'Cancel Order';

  @override
  String get dailymartCancelOrderTitle => 'Cancel this order?';

  @override
  String get dailymartCancelOrderMessage =>
      'You\'ll be refunded if the order was paid for.';

  @override
  String get dailymartCancelOrderConfirmLabel => 'Cancel Order';

  @override
  String get dailymartCancelLabel => 'Cancel';

  @override
  String grofastGreeting(String name) {
    return 'Hey $name 👋';
  }

  @override
  String get grofastGreetingFallbackName => 'there';

  @override
  String get grofastGreetingSubtitle => 'Find fresh groceries you want';

  @override
  String get grofastSearchHint => 'Search fresh groceries';

  @override
  String get grofastCategoriesTitle => 'Categories';

  @override
  String get grofastPopularTitle => 'Popular';

  @override
  String get grofastSeeAll => 'see all';

  @override
  String get grofastHomeLoadErrorMessage =>
      'Couldn\'t load this store\'s catalog.';

  @override
  String get grofastNoLocationSelectedLabel => 'Select a location';

  @override
  String get grofastClaimNow => 'claim now';

  @override
  String grofastPromoDiscountLabel(String percent) {
    return '$percent off';
  }

  @override
  String get grofastCategoriesLoadErrorMessage => 'Couldn\'t load categories.';

  @override
  String get grofastCategoriesEmptyTitle => 'No categories yet';

  @override
  String get grofastCategoriesEmptySubtitle =>
      'This store has not published any categories.';

  @override
  String grofastCategoryProductsTitle(String category) {
    return 'All $category';
  }

  @override
  String get grofastCategoryDetailsEmptyTitle => 'Nothing here yet';

  @override
  String get grofastCategoryDetailsEmptySubtitle =>
      'No products in this category right now.';

  @override
  String get grofastCategoryDetailsErrorMessage =>
      'Couldn\'t load this category.';

  @override
  String get grofastSearchTitle => 'Search Groceries';

  @override
  String get grofastRecentSearchTitle => 'Recent Search';

  @override
  String grofastResultsCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Results',
      one: '$count Result',
    );
    return 'Found $_temp0';
  }

  @override
  String get grofastSearchLoadErrorMessage => 'Couldn\'t load search.';

  @override
  String get grofastSearchResultsErrorMessage => 'Couldn\'t search this store.';

  @override
  String get grofastSearchNoResultsTitle => 'No results';

  @override
  String grofastSearchNoResultsSubtitle(String query) {
    return 'Nothing matched \"$query\". Try another word.';
  }

  @override
  String get grofastSearchIdleTitle => 'What are you shopping for?';

  @override
  String get grofastSearchIdleSubtitle =>
      'Search the whole store by name or category.';

  @override
  String get grofastSortByTitle => 'Sort By';

  @override
  String get grofastPriceTitle => 'Price';

  @override
  String get grofastApplyLabel => 'Apply';

  @override
  String get grofastResetLabel => 'Reset';

  @override
  String get grofastAddToBagTooltip => 'Add to bag';

  @override
  String get grofastFavouriteTooltip => 'Save to wishlist';

  @override
  String get grofastDecreaseQuantityLabel => 'Decrease quantity';

  @override
  String get grofastIncreaseQuantityLabel => 'Increase quantity';

  @override
  String get grofastProductDetailsTitle => 'Product Details';

  @override
  String get grofastDescriptionTitle => 'Description';

  @override
  String get grofastSelectSizeTitle => 'Select Size';

  @override
  String get grofastAddToBag => 'Add to bag';

  @override
  String get grofastProductDetailsLoadErrorMessage =>
      'Couldn\'t load this product right now.';

  @override
  String grofastAddedToBagMessage(int count, String name) {
    return 'Added $count × $name to your bag.';
  }

  @override
  String get grofastNoDescriptionLabel =>
      'No description for this product yet.';

  @override
  String get grofastBagTitle => 'My Bag';

  @override
  String grofastBagItemCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items',
      one: '$count item',
    );
    return '$_temp0';
  }

  @override
  String get grofastPromoCodeHint => 'Add Promo Code';

  @override
  String get grofastPromoApplyLabel => 'Apply';

  @override
  String get grofastPromoRemoveLabel => 'Remove';

  @override
  String get grofastCouponDetailLabel => 'Coupon';

  @override
  String grofastPromoApplied(String code) {
    return '$code applied';
  }

  @override
  String grofastCouponLine(String code) {
    return 'Coupon ($code)';
  }

  @override
  String get grofastPromoComingSoonMessage => 'Promo codes are coming soon.';

  @override
  String get grofastTotalLabel => 'Total';

  @override
  String get grofastSubtotalLabel => 'Subtotal';

  @override
  String get grofastDeliveryLabel => 'Delivery';

  @override
  String get grofastDeliveryFreeLabel => 'Free';

  @override
  String get grofastDiscountLabel => 'Discount';

  @override
  String get grofastProceedToCheckoutLabel => 'Proceed To Checkout';

  @override
  String get grofastBagEmptyTitle => 'Your bag is empty';

  @override
  String get grofastBagEmptySubtitle =>
      'Add some fresh groceries and they will show up here.';

  @override
  String get grofastBagExploreAction => 'Start shopping';

  @override
  String get grofastRemovedFromBagMessage => 'Removed from your bag.';

  @override
  String get grofastCheckoutTitle => 'Checkout';

  @override
  String get grofastItemsTitle => 'Items';

  @override
  String get grofastDeliveryAddressTitle => 'Delivery Address';

  @override
  String get grofastAddNewLabel => 'add new';

  @override
  String get grofastChangeAddressLabel => 'change';

  @override
  String get grofastNoAddressSelectedLabel => 'Choose where to deliver';

  @override
  String get grofastConfirmOrderLabel => 'Confirm Order';

  @override
  String get grofastOrderPlacedTitle => 'Success!';

  @override
  String get grofastOrderPlacedMessage =>
      'You have successfully created your order.';

  @override
  String get grofastBrowseHomeLabel => 'Browse Home';

  @override
  String get grofastNavHome => 'Home';

  @override
  String get grofastNavCategories => 'Category';

  @override
  String get grofastNavBag => 'Bag';

  @override
  String get grofastNavAccount => 'Account';

  @override
  String get grofastProfileTitle => 'Profile';

  @override
  String get grofastNotificationTileLabel => 'Notification';

  @override
  String get grofastOrdersTileLabel => 'My Orders';

  @override
  String get grofastWishlistTileLabel => 'Wishlist';

  @override
  String get grofastMyProfileLabel => 'My Profile';

  @override
  String get grofastChangePasswordLabel => 'Change Password';

  @override
  String get grofastDarkModeLabel => 'Dark Mode';

  @override
  String get grofastMyAddressLabel => 'My Address';

  @override
  String get grofastPrivacyPolicyLabel => 'Privacy Policy';

  @override
  String get grofastTermsAndConditionsLabel => 'Term and Condition';

  @override
  String get grofastLogOutLabel => 'Log Out';

  @override
  String get grofastLogOutTitle => 'Log out?';

  @override
  String get grofastLogOutConfirmMessage =>
      'You\'ll need to sign in again to place an order.';

  @override
  String get grofastProfileLoadErrorMessage => 'Couldn\'t load your profile.';

  @override
  String get grofastProfileNameFallback => 'Your account';

  @override
  String get grofastEditProfileTitle => 'My Profile';

  @override
  String get grofastFullNameLabel => 'Full Name';

  @override
  String get grofastFullNameHint => 'Enter your full name';

  @override
  String get grofastEmailLabel => 'Email';

  @override
  String get grofastEmailHint => 'you@example.com';

  @override
  String get grofastPhoneNumberLabel => 'Phone Number';

  @override
  String get grofastPhoneNumberHint => 'Enter your phone number';

  @override
  String get grofastSaveChangesLabel => 'Save Changes';

  @override
  String get grofastChangePhotoTitle => 'Change Photo';

  @override
  String get grofastTakePhotoLabel => 'Take Photo';

  @override
  String get grofastChooseFromGalleryLabel => 'Choose from Gallery';

  @override
  String get grofastAvatarPickerMobileOnlyMessage =>
      'Photo picking is only available on mobile.';

  @override
  String get grofastProfileUpdatedMessage => 'Your profile has been updated.';

  @override
  String get grofastChangePasswordTitle => 'Change Password';

  @override
  String get grofastCurrentPasswordLabel => 'Current Password';

  @override
  String get grofastCurrentPasswordHint => 'Enter your current password';

  @override
  String get grofastNewPasswordLabel => 'New Password';

  @override
  String get grofastNewPasswordHint => 'Enter your new password';

  @override
  String get grofastConfirmNewPasswordLabel => 'Confirm New Password';

  @override
  String get grofastConfirmNewPasswordHint => 'Re-enter your new password';

  @override
  String get grofastUpdatePasswordButtonLabel => 'Update Password';

  @override
  String get grofastPasswordUpdatedMessage => 'Your password has been updated.';

  @override
  String get grofastWishlistTitle => 'Wishlist';

  @override
  String get grofastWishlistEmptyTitle => 'Nothing saved yet';

  @override
  String get grofastWishlistEmptySubtitle =>
      'Tap the heart on anything you want to keep for later.';

  @override
  String get grofastWishlistExploreAction => 'Start shopping';

  @override
  String get grofastNotificationsTitle => 'Notification';

  @override
  String get grofastNotificationsFilterAllLabel => 'All';

  @override
  String get grofastNotificationsSearchHint => 'Search your Notification';

  @override
  String get grofastNotificationsNowTitle => 'Now';

  @override
  String get grofastNotificationsPastTitle => 'Past';

  @override
  String get grofastNotificationsLoadErrorMessage =>
      'Couldn\'t load your notifications.';

  @override
  String get grofastNotificationsEmptyTitle => 'No notifications yet';

  @override
  String get grofastNotificationsEmptySubtitle =>
      'We\'ll let you know when something happens with your orders.';

  @override
  String get grofastNotificationsNoResultsTitle => 'Nothing here';

  @override
  String grofastNotificationsNoResultsSubtitle(String query) {
    return 'No notification matches \"$query\".';
  }

  @override
  String get grofastSelectAddressTitle => 'Select Location';

  @override
  String get grofastAddNewAddressLabel => 'Add New Address';

  @override
  String get grofastAddressLoadErrorMessage => 'Couldn\'t load your addresses.';

  @override
  String get grofastAddressEmptyTitle => 'No saved addresses';

  @override
  String get grofastAddressEmptySubtitle =>
      'Add one so we know where to bring your groceries.';

  @override
  String get grofastAddressSaveFailedMessage => 'Couldn\'t save that address.';

  @override
  String get grofastAddressDeleteFailedMessage =>
      'Couldn\'t delete that address.';

  @override
  String get grofastEditAddressTooltip => 'Edit address';

  @override
  String get grofastDeleteAddressTitle => 'Delete this address?';

  @override
  String get grofastDeleteAddressMessage =>
      'It will be removed from your saved locations. This can\'t be undone.';

  @override
  String get grofastDeleteLabel => 'Delete';

  @override
  String get grofastCancelLabel => 'Cancel';

  @override
  String get grofastAddAddressTitle => 'Add New Address';

  @override
  String get grofastEditAddressTitle => 'Edit Address';

  @override
  String get grofastAddressNameLabel => 'Name';

  @override
  String get grofastAddressNameHint => 'e.g. Yona Angela';

  @override
  String get grofastAddressLine1Label => 'Address Line 1';

  @override
  String get grofastAddressLine1Hint => 'House no., street name';

  @override
  String get grofastAddressLine2Label => 'Address Line 2';

  @override
  String get grofastAddressLine2Hint => 'Apartment, suite, etc. (optional)';

  @override
  String get grofastLandmarkLabel => 'Landmark';

  @override
  String get grofastLandmarkHint => 'Nearby landmark (optional)';

  @override
  String get grofastCityLabel => 'City';

  @override
  String get grofastCityHint => 'e.g. Bengaluru';

  @override
  String get grofastStateLabel => 'State';

  @override
  String get grofastStateHint => 'e.g. Karnataka (optional)';

  @override
  String get grofastCountryLabel => 'Country';

  @override
  String get grofastSelectCountryTitle => 'Select Country';

  @override
  String get grofastPostalCodeLabel => 'Postal Code';

  @override
  String get grofastPostalCodeHint => 'e.g. 62639';

  @override
  String get grofastAddressTagLabel => 'Tag';

  @override
  String get grofastAddressTagHint => 'e.g. Home, Office';

  @override
  String get grofastMobileLabel => 'Mobile Number';

  @override
  String get grofastMobileHint => 'Where we can reach you';

  @override
  String get grofastAddAddressButtonLabel => 'Add Address';

  @override
  String get grofastUpdateAddressButtonLabel => 'Update Address';

  @override
  String get grofastRequiredFieldErrorMessage => 'This field is required';

  @override
  String get grofastMyOrdersTitle => 'My Orders';

  @override
  String get grofastOrdersSearchHint => 'Search your orders';

  @override
  String get grofastOrdersFilterAllLabel => 'All';

  @override
  String get grofastOrdersFilterActiveLabel => 'On Delivery';

  @override
  String get grofastOrdersFilterCompletedLabel => 'Delivered';

  @override
  String get grofastOrdersFilterCancelledLabel => 'Canceled';

  @override
  String get grofastOrdersDateFilterTitle => 'Filter by date';

  @override
  String get grofastOrdersDateRangeLabel => 'Date Range';

  @override
  String get grofastOrdersAllTimeLabel => 'All time';

  @override
  String get grofastOrdersFilterLastWeekLabel => 'Last week';

  @override
  String get grofastOrdersFilterLastMonthLabel => 'Last month';

  @override
  String get grofastOrdersLoadErrorMessage => 'Couldn\'t load your orders.';

  @override
  String get grofastOrdersRefreshFailedMessage =>
      'Couldn\'t refresh your orders.';

  @override
  String get grofastOrdersEmptyTitle => 'No orders yet';

  @override
  String get grofastOrdersEmptySubtitle =>
      'Your orders will show up here once you place one.';

  @override
  String get grofastOrdersNoResultsTitle => 'Nothing here';

  @override
  String get grofastOrdersNoResultsSubtitle =>
      'No order matches those filters. Try widening them.';

  @override
  String grofastOrderNumberLabel(String date) {
    return 'Order $date';
  }

  @override
  String grofastOrderItemCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items',
      one: '$count item',
    );
    return '$_temp0';
  }

  @override
  String grofastOrderDeliveredLine(String label) {
    return 'Delivered to $label';
  }

  @override
  String grofastOrderDeliveringLine(String label) {
    return 'Delivering to $label';
  }

  @override
  String get grofastOrderCancelledLine => 'This order was cancelled';

  @override
  String get grofastTrackOrderTitle => 'Track Order';

  @override
  String get grofastOrderDetailTitle => 'Order Detail';

  @override
  String get grofastCopyTooltip => 'Copy';

  @override
  String grofastCopiedMessage(String label) {
    return '$label copied.';
  }

  @override
  String get grofastTrackingDetailTitle => 'Tracking Detail';

  @override
  String get grofastOrderStatusLabel => 'Status';

  @override
  String get grofastPurchaseDateLabel => 'Purchase Date';

  @override
  String get grofastOrderIdLabel => 'Order ID';

  @override
  String get grofastDeliveryOtpLabel => 'Delivery OTP';

  @override
  String get grofastPaymentIdLabel => 'Payment ID';

  @override
  String get grofastAmountPaidLabel => 'Amount Paid';

  @override
  String get grofastNoOnlinePaymentLabel => 'Not paid online';

  @override
  String get grofastRefundLabel => 'Refund';

  @override
  String get grofastOrderReceivedLabel => 'Order Received';

  @override
  String get grofastCancelOrderLabel => 'Cancel Order';

  @override
  String get grofastCancelOrderTitle => 'Cancel this order?';

  @override
  String get grofastCancelOrderMessage =>
      'We\'ll refund anything you paid. This can\'t be undone.';

  @override
  String get grofastCancelOrderConfirmLabel => 'Cancel Order';

  @override
  String get grofastOrderCancelFailedMessage => 'Couldn\'t cancel that order.';

  @override
  String get grofastOrderStepUndatedLabel => 'Time not recorded';

  @override
  String get grofastOrderStepPendingLabel => 'Pending';

  @override
  String get grofastStatusPlacedLabel => 'Order Placed';

  @override
  String get grofastStatusOnDeliveryLabel => 'On Delivery';

  @override
  String get grofastStatusDeliveredLabel => 'Delivered';

  @override
  String get grofastStatusCancelledLabel => 'Canceled';

  @override
  String get grofastRefundPendingLabel => 'Refund on its way';

  @override
  String get grofastRefundProcessedLabel => 'Refunded';

  @override
  String get grofastRefundFailedLabel => 'Refund failed';

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

  @override
  String get notificationsSectionToday => 'Today';

  @override
  String get notificationsSectionYesterday => 'Yesterday';

  @override
  String get notificationsSectionEarlier => 'Earlier';

  @override
  String get notificationsPermissionTitle => 'Notifications are off';

  @override
  String get notificationsPermissionSubtitle =>
      'Turn them on to get order updates and offers from this store.';

  @override
  String get notificationsPermissionCta => 'Enable notifications';

  @override
  String get notificationsPermissionBlockedMessage =>
      'Notifications are blocked for CordeliaApps. Turn them on in your device settings.';
}
