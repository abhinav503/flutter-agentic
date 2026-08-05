import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('hi'),
  ];

  /// No description provided for @languageSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageSheetTitle;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageHindi.
  ///
  /// In en, this message translates to:
  /// **'हिन्दी'**
  String get languageHindi;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome To CordeliaApps'**
  String get loginTitle;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Log in to your account using email or social networks'**
  String get loginSubtitle;

  /// No description provided for @emailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get emailLabel;

  /// No description provided for @emailHint.
  ///
  /// In en, this message translates to:
  /// **'you@example.com'**
  String get emailHint;

  /// No description provided for @passwordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordLabel;

  /// No description provided for @passwordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get passwordHint;

  /// No description provided for @forgotPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPasswordLabel;

  /// No description provided for @passwordResetEmailSentMessage.
  ///
  /// In en, this message translates to:
  /// **'Password reset link sent to {email}'**
  String passwordResetEmailSentMessage(String email);

  /// No description provided for @continueLabel.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueLabel;

  /// No description provided for @orLoginWith.
  ///
  /// In en, this message translates to:
  /// **'Or Login with'**
  String get orLoginWith;

  /// No description provided for @continueWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get continueWithGoogle;

  /// No description provided for @continueWithApple.
  ///
  /// In en, this message translates to:
  /// **'Continue with Apple'**
  String get continueWithApple;

  /// No description provided for @byContinuingAgree.
  ///
  /// In en, this message translates to:
  /// **'By continuing, you agree to our'**
  String get byContinuingAgree;

  /// No description provided for @termsOfServiceAndPrivacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service & Privacy Policy'**
  String get termsOfServiceAndPrivacyPolicy;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? '**
  String get dontHaveAccount;

  /// No description provided for @signupLink.
  ///
  /// In en, this message translates to:
  /// **'Signup'**
  String get signupLink;

  /// No description provided for @signupTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign Up Your Account'**
  String get signupTitle;

  /// No description provided for @signupSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your information below'**
  String get signupSubtitle;

  /// No description provided for @nameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get nameLabel;

  /// No description provided for @nameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Mark Shelby'**
  String get nameHint;

  /// No description provided for @mobileLabel.
  ///
  /// In en, this message translates to:
  /// **'Mobile Number'**
  String get mobileLabel;

  /// No description provided for @mobileHint.
  ///
  /// In en, this message translates to:
  /// **'(303) 555-0105'**
  String get mobileHint;

  /// No description provided for @iAgreeLabel.
  ///
  /// In en, this message translates to:
  /// **'I Agree '**
  String get iAgreeLabel;

  /// No description provided for @termsAndConditionsLink.
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions'**
  String get termsAndConditionsLink;

  /// No description provided for @mustAgreeToTermsMessage.
  ///
  /// In en, this message translates to:
  /// **'Please agree to the Terms & Conditions to continue.'**
  String get mustAgreeToTermsMessage;

  /// No description provided for @authWebUnsupportedMessage.
  ///
  /// In en, this message translates to:
  /// **'Sign-in is only available on mobile.'**
  String get authWebUnsupportedMessage;

  /// No description provided for @sessionExpiredMessage.
  ///
  /// In en, this message translates to:
  /// **'Your session has expired. Please sign in again.'**
  String get sessionExpiredMessage;

  /// No description provided for @signupButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'Signup'**
  String get signupButtonLabel;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get alreadyHaveAccount;

  /// No description provided for @loginLink.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginLink;

  /// No description provided for @comingSoonMessage.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get comingSoonMessage;

  /// No description provided for @paymentCancelledMessage.
  ///
  /// In en, this message translates to:
  /// **'Payment cancelled'**
  String get paymentCancelledMessage;

  /// No description provided for @paymentFailedMessage.
  ///
  /// In en, this message translates to:
  /// **'Payment could not be completed. Please try again.'**
  String get paymentFailedMessage;

  /// No description provided for @verifyEmailTitle.
  ///
  /// In en, this message translates to:
  /// **'Verify Your Email'**
  String get verifyEmailTitle;

  /// No description provided for @verifyEmailSubtitle.
  ///
  /// In en, this message translates to:
  /// **'We\'ve sent a verification link to {email}. Open it, then come back here — this will update automatically.'**
  String verifyEmailSubtitle(String email);

  /// No description provided for @verifyEmailChecking.
  ///
  /// In en, this message translates to:
  /// **'Checking…'**
  String get verifyEmailChecking;

  /// No description provided for @resendEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Resend email'**
  String get resendEmailLabel;

  /// No description provided for @termsAndConditionsLabel.
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions'**
  String get termsAndConditionsLabel;

  /// No description provided for @privacyPolicyLabel.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicyLabel;

  /// No description provided for @legalLastUpdatedLabel.
  ///
  /// In en, this message translates to:
  /// **'Last update: Mar 09, 2026'**
  String get legalLastUpdatedLabel;

  /// No description provided for @termsAndConditionsIntro.
  ///
  /// In en, this message translates to:
  /// **'Please read these terms of service, carefully before using our app operated by us.'**
  String get termsAndConditionsIntro;

  /// No description provided for @termsAndConditionsHeading.
  ///
  /// In en, this message translates to:
  /// **'Conditions of Uses'**
  String get termsAndConditionsHeading;

  /// No description provided for @termsAndConditionsBody.
  ///
  /// In en, this message translates to:
  /// **'It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using \'Content here, content here\', making it look like readable English. Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a search for \'lorem ipsum\' will uncover many web sites still in their infancy. Various versions have evolved over the years, sometimes by accident, sometimes on purpose (injected humour and the like).'**
  String get termsAndConditionsBody;

  /// No description provided for @privacyPolicyIntro.
  ///
  /// In en, this message translates to:
  /// **'Please read these privacy policy, carefully before using our app operated by us.'**
  String get privacyPolicyIntro;

  /// No description provided for @privacyPolicySection1Heading.
  ///
  /// In en, this message translates to:
  /// **'1. Information Collection'**
  String get privacyPolicySection1Heading;

  /// No description provided for @privacyPolicySection1Body.
  ///
  /// In en, this message translates to:
  /// **'We collect essential information to enhance your experience. This includes details you provide directly, such as account data, as well as information gathered through usage analytics and cookies.'**
  String get privacyPolicySection1Body;

  /// No description provided for @privacyPolicySection2Heading.
  ///
  /// In en, this message translates to:
  /// **'2. Information Usage'**
  String get privacyPolicySection2Heading;

  /// No description provided for @privacyPolicySection2Body.
  ///
  /// In en, this message translates to:
  /// **'The information collected is used to improve our services, provide personalized recommendations, and ensure a seamless experience. We do not share your data without your explicit consent.'**
  String get privacyPolicySection2Body;

  /// No description provided for @privacyPolicySection3Heading.
  ///
  /// In en, this message translates to:
  /// **'3. Information Setting'**
  String get privacyPolicySection3Heading;

  /// No description provided for @privacyPolicySection3Body.
  ///
  /// In en, this message translates to:
  /// **'You have full control over your data. Manage your privacy preferences, update personal details, and customize your settings to match your needs.'**
  String get privacyPolicySection3Body;

  /// No description provided for @privacyPolicySection4Heading.
  ///
  /// In en, this message translates to:
  /// **'4. Security Measures'**
  String get privacyPolicySection4Heading;

  /// No description provided for @privacyPolicySection4Body.
  ///
  /// In en, this message translates to:
  /// **'We prioritize your data\'s safety with advanced security protocols, encryption methods, and regular audits to protect against unauthorized access or breaches.'**
  String get privacyPolicySection4Body;

  /// No description provided for @profilePageTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profilePageTitle;

  /// No description provided for @changePasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePasswordLabel;

  /// No description provided for @myOrdersLabel.
  ///
  /// In en, this message translates to:
  /// **'My Orders'**
  String get myOrdersLabel;

  /// No description provided for @myAddressLabel.
  ///
  /// In en, this message translates to:
  /// **'My Address'**
  String get myAddressLabel;

  /// No description provided for @darkModeLabel.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkModeLabel;

  /// No description provided for @logoutLabel.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logoutLabel;

  /// No description provided for @logoutTitle.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logoutTitle;

  /// No description provided for @logoutConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out?'**
  String get logoutConfirmMessage;

  /// No description provided for @deleteAccountLabel.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccountLabel;

  /// No description provided for @deleteAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete your account?'**
  String get deleteAccountTitle;

  /// No description provided for @deleteAccountConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'This permanently deletes your profile, addresses, cart, wishlist and reviews across every store. Orders you have already placed stay with those stores as their sales records. This cannot be undone.'**
  String get deleteAccountConfirmMessage;

  /// No description provided for @deleteAccountFailedMessage.
  ///
  /// In en, this message translates to:
  /// **'Could not delete your account. Please try again.'**
  String get deleteAccountFailedMessage;

  /// No description provided for @profileLoadErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong loading your profile.'**
  String get profileLoadErrorMessage;

  /// No description provided for @sortRelevanceLabel.
  ///
  /// In en, this message translates to:
  /// **'Relevance'**
  String get sortRelevanceLabel;

  /// No description provided for @sortPriceLowToHighLabel.
  ///
  /// In en, this message translates to:
  /// **'Price (Low to High)'**
  String get sortPriceLowToHighLabel;

  /// No description provided for @sortPriceHighToLowLabel.
  ///
  /// In en, this message translates to:
  /// **'Price (High to Low)'**
  String get sortPriceHighToLowLabel;

  /// No description provided for @sortRatingHighToLowLabel.
  ///
  /// In en, this message translates to:
  /// **'Rating (High to Low)'**
  String get sortRatingHighToLowLabel;

  /// No description provided for @sortDiscountHighToLowLabel.
  ///
  /// In en, this message translates to:
  /// **'Discount (High to Low)'**
  String get sortDiscountHighToLowLabel;

  /// No description provided for @priceFilterAllLabel.
  ///
  /// In en, this message translates to:
  /// **'All Prices'**
  String get priceFilterAllLabel;

  /// No description provided for @priceFilterUnder100Label.
  ///
  /// In en, this message translates to:
  /// **'Under ₹100'**
  String get priceFilterUnder100Label;

  /// No description provided for @priceFilter100To250Label.
  ///
  /// In en, this message translates to:
  /// **'₹100 - ₹250'**
  String get priceFilter100To250Label;

  /// No description provided for @priceFilter250To500Label.
  ///
  /// In en, this message translates to:
  /// **'₹250 - ₹500'**
  String get priceFilter250To500Label;

  /// No description provided for @priceFilterOver500Label.
  ///
  /// In en, this message translates to:
  /// **'Over ₹500'**
  String get priceFilterOver500Label;

  /// No description provided for @reviewsSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Ratings & Reviews'**
  String get reviewsSectionTitle;

  /// No description provided for @writeReviewLabel.
  ///
  /// In en, this message translates to:
  /// **'Write a review'**
  String get writeReviewLabel;

  /// No description provided for @editReviewLabel.
  ///
  /// In en, this message translates to:
  /// **'Edit your review'**
  String get editReviewLabel;

  /// No description provided for @deleteReviewLabel.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteReviewLabel;

  /// No description provided for @reviewSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Rate this product'**
  String get reviewSheetTitle;

  /// No description provided for @reviewRatingPrompt.
  ///
  /// In en, this message translates to:
  /// **'How many stars?'**
  String get reviewRatingPrompt;

  /// No description provided for @reviewTextLabel.
  ///
  /// In en, this message translates to:
  /// **'Your review'**
  String get reviewTextLabel;

  /// No description provided for @reviewTextHint.
  ///
  /// In en, this message translates to:
  /// **'Tell other shoppers what you thought…'**
  String get reviewTextHint;

  /// No description provided for @reviewSubmitLabel.
  ///
  /// In en, this message translates to:
  /// **'Submit review'**
  String get reviewSubmitLabel;

  /// No description provided for @reviewMissingRatingMessage.
  ///
  /// In en, this message translates to:
  /// **'Pick a star rating first.'**
  String get reviewMissingRatingMessage;

  /// No description provided for @reviewDeleteConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete your review?'**
  String get reviewDeleteConfirmTitle;

  /// No description provided for @reviewDeleteConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'This removes your rating from the product\'s average. You can write a new one any time.'**
  String get reviewDeleteConfirmMessage;

  /// No description provided for @reviewSignedOutMessage.
  ///
  /// In en, this message translates to:
  /// **'Sign in to review this product.'**
  String get reviewSignedOutMessage;

  /// No description provided for @verifiedPurchaseLabel.
  ///
  /// In en, this message translates to:
  /// **'Verified purchase'**
  String get verifiedPurchaseLabel;

  /// No description provided for @reviewsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No reviews yet'**
  String get reviewsEmptyTitle;

  /// No description provided for @reviewsEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Be the first to rate this product and help other shoppers decide.'**
  String get reviewsEmptySubtitle;

  /// No description provided for @unratedLabel.
  ///
  /// In en, this message translates to:
  /// **'No ratings yet'**
  String get unratedLabel;

  /// No description provided for @rateOrderLabel.
  ///
  /// In en, this message translates to:
  /// **'Rate Order'**
  String get rateOrderLabel;

  /// No description provided for @editOrderRatingLabel.
  ///
  /// In en, this message translates to:
  /// **'Edit Rating'**
  String get editOrderRatingLabel;

  /// No description provided for @rateOrderSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'How was this order?'**
  String get rateOrderSheetTitle;

  /// No description provided for @rateOrderTextLabel.
  ///
  /// In en, this message translates to:
  /// **'Your feedback'**
  String get rateOrderTextLabel;

  /// No description provided for @rateOrderTextHint.
  ///
  /// In en, this message translates to:
  /// **'How was the delivery?'**
  String get rateOrderTextHint;

  /// No description provided for @orderRatingNotDeliveredMessage.
  ///
  /// In en, this message translates to:
  /// **'You can rate an order once it has been delivered.'**
  String get orderRatingNotDeliveredMessage;

  /// No description provided for @orderRatingFailedMessage.
  ///
  /// In en, this message translates to:
  /// **'Could not save your rating. Please try again.'**
  String get orderRatingFailedMessage;

  /// No description provided for @yourRatingLabel.
  ///
  /// In en, this message translates to:
  /// **'Your rating'**
  String get yourRatingLabel;

  /// No description provided for @reviewCountLabel.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{{count} review} other{{count} reviews}}'**
  String reviewCountLabel(int count);

  /// No description provided for @reviewAgeJustNow.
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get reviewAgeJustNow;

  /// No description provided for @reviewAgeMinutesAgo.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{{count} minute ago} other{{count} minutes ago}}'**
  String reviewAgeMinutesAgo(int count);

  /// No description provided for @reviewAgeHoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{{count} hour ago} other{{count} hours ago}}'**
  String reviewAgeHoursAgo(int count);

  /// No description provided for @reviewAgeDaysAgo.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{{count} day ago} other{{count} days ago}}'**
  String reviewAgeDaysAgo(int count);

  /// No description provided for @reviewAgeMonthsAgo.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{{count} month ago} other{{count} months ago}}'**
  String reviewAgeMonthsAgo(int count);

  /// No description provided for @reviewAgeYearsAgo.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{{count} year ago} other{{count} years ago}}'**
  String reviewAgeYearsAgo(int count);

  /// No description provided for @graviaCategoriesTitle.
  ///
  /// In en, this message translates to:
  /// **'All Categories'**
  String get graviaCategoriesTitle;

  /// No description provided for @graviaSeeAll.
  ///
  /// In en, this message translates to:
  /// **'See All'**
  String get graviaSeeAll;

  /// No description provided for @graviaPopularItemsTitle.
  ///
  /// In en, this message translates to:
  /// **'Popular Items'**
  String get graviaPopularItemsTitle;

  /// No description provided for @graviaHomeLoadErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load this store\'s catalog.'**
  String get graviaHomeLoadErrorMessage;

  /// No description provided for @graviaCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get graviaCancel;

  /// No description provided for @graviaDiscountPercentOff.
  ///
  /// In en, this message translates to:
  /// **'{percent}% OFF'**
  String graviaDiscountPercentOff(String percent);

  /// No description provided for @graviaAddToCart.
  ///
  /// In en, this message translates to:
  /// **'Add To Cart'**
  String get graviaAddToCart;

  /// No description provided for @graviaAddToCartSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Add to Cart'**
  String get graviaAddToCartSheetTitle;

  /// No description provided for @graviaDeleteLabel.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get graviaDeleteLabel;

  /// No description provided for @graviaDeleteAddressTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Address'**
  String get graviaDeleteAddressTitle;

  /// No description provided for @graviaDeleteAddressConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this address? This action cannot be undone.'**
  String get graviaDeleteAddressConfirmMessage;

  /// No description provided for @graviaClearCartTitle.
  ///
  /// In en, this message translates to:
  /// **'Clear Cart'**
  String get graviaClearCartTitle;

  /// No description provided for @graviaClearCartConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove all items from your cart?'**
  String get graviaClearCartConfirmMessage;

  /// No description provided for @graviaClearCartConfirmLabel.
  ///
  /// In en, this message translates to:
  /// **'Clear Cart'**
  String get graviaClearCartConfirmLabel;

  /// No description provided for @graviaOrderPlacedTitle.
  ///
  /// In en, this message translates to:
  /// **'Order Placed Successfully'**
  String get graviaOrderPlacedTitle;

  /// No description provided for @graviaOrderPlacedSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Thank you for your order you can track your delivery in the order section'**
  String get graviaOrderPlacedSubtitle;

  /// No description provided for @graviaTrackYourOrderLabel.
  ///
  /// In en, this message translates to:
  /// **'Track Your Order'**
  String get graviaTrackYourOrderLabel;

  /// No description provided for @graviaSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get graviaSearchHint;

  /// No description provided for @graviaNavHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get graviaNavHome;

  /// No description provided for @graviaNavCategories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get graviaNavCategories;

  /// No description provided for @graviaNavFavourite.
  ///
  /// In en, this message translates to:
  /// **'Favourite'**
  String get graviaNavFavourite;

  /// No description provided for @graviaNavOrders.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get graviaNavOrders;

  /// No description provided for @graviaNavProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get graviaNavProfile;

  /// No description provided for @graviaRecentSearchTitle.
  ///
  /// In en, this message translates to:
  /// **'Recent Search'**
  String get graviaRecentSearchTitle;

  /// No description provided for @graviaSearchLoadErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong loading search.'**
  String get graviaSearchLoadErrorMessage;

  /// No description provided for @graviaSearchResultsErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong searching.'**
  String get graviaSearchResultsErrorMessage;

  /// No description provided for @graviaSearchCategoryBadge.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get graviaSearchCategoryBadge;

  /// No description provided for @graviaSearchNoResultsTitle.
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get graviaSearchNoResultsTitle;

  /// No description provided for @graviaSearchNoResultsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Nothing matches \"{query}\". Try a different keyword.'**
  String graviaSearchNoResultsSubtitle(String query);

  /// No description provided for @graviaProductDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Product Details'**
  String get graviaProductDetailsTitle;

  /// No description provided for @graviaSelectQtyLabel.
  ///
  /// In en, this message translates to:
  /// **'Select QTY'**
  String get graviaSelectQtyLabel;

  /// No description provided for @graviaKeyInformationTitle.
  ///
  /// In en, this message translates to:
  /// **'Key Information'**
  String get graviaKeyInformationTitle;

  /// No description provided for @graviaReadMore.
  ///
  /// In en, this message translates to:
  /// **'Read More'**
  String get graviaReadMore;

  /// No description provided for @graviaReadLess.
  ///
  /// In en, this message translates to:
  /// **'Read Less'**
  String get graviaReadLess;

  /// No description provided for @graviaSimilarProductsTitle.
  ///
  /// In en, this message translates to:
  /// **'Similar Products'**
  String get graviaSimilarProductsTitle;

  /// No description provided for @graviaProductDetailsLoadErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong loading this product.'**
  String get graviaProductDetailsLoadErrorMessage;

  /// No description provided for @graviaAddToCartWithPrice.
  ///
  /// In en, this message translates to:
  /// **'Add to Cart ({price})'**
  String graviaAddToCartWithPrice(String price);

  /// No description provided for @graviaCategoriesPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get graviaCategoriesPageTitle;

  /// No description provided for @graviaCategoriesLoadErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong loading categories.'**
  String get graviaCategoriesLoadErrorMessage;

  /// No description provided for @graviaCategoriesRefreshFailedMessage.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t refresh — showing your last loaded categories.'**
  String get graviaCategoriesRefreshFailedMessage;

  /// No description provided for @graviaSortLabel.
  ///
  /// In en, this message translates to:
  /// **'Sort'**
  String get graviaSortLabel;

  /// No description provided for @graviaPriceLabel.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get graviaPriceLabel;

  /// No description provided for @graviaSortBySheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Sort by'**
  String get graviaSortBySheetTitle;

  /// No description provided for @graviaPriceSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get graviaPriceSheetTitle;

  /// No description provided for @graviaCategoryDetailsEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'No products match these filters.'**
  String get graviaCategoryDetailsEmptyMessage;

  /// No description provided for @graviaSelectAddressTitle.
  ///
  /// In en, this message translates to:
  /// **'Select Address'**
  String get graviaSelectAddressTitle;

  /// No description provided for @graviaAddNewAddressLabel.
  ///
  /// In en, this message translates to:
  /// **'Add New Address'**
  String get graviaAddNewAddressLabel;

  /// No description provided for @graviaDefaultAddressSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Default Address'**
  String get graviaDefaultAddressSectionTitle;

  /// No description provided for @graviaOtherAddressSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Other Address'**
  String get graviaOtherAddressSectionTitle;

  /// No description provided for @graviaEditLabel.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get graviaEditLabel;

  /// No description provided for @graviaAddressLoadErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong loading your addresses.'**
  String get graviaAddressLoadErrorMessage;

  /// No description provided for @graviaAddressSaveFailedMessage.
  ///
  /// In en, this message translates to:
  /// **'Could not save the address. Please try again.'**
  String get graviaAddressSaveFailedMessage;

  /// No description provided for @graviaAddressDeleteFailedMessage.
  ///
  /// In en, this message translates to:
  /// **'Could not delete the address. Please try again.'**
  String get graviaAddressDeleteFailedMessage;

  /// No description provided for @graviaAddressEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No saved addresses'**
  String get graviaAddressEmptyTitle;

  /// No description provided for @graviaAddressEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add your first delivery address to get started.'**
  String get graviaAddressEmptySubtitle;

  /// No description provided for @graviaEditAddressTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Address'**
  String get graviaEditAddressTitle;

  /// No description provided for @graviaNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get graviaNameLabel;

  /// No description provided for @graviaNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Mark Shelby'**
  String get graviaNameHint;

  /// No description provided for @graviaPhoneNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get graviaPhoneNumberLabel;

  /// No description provided for @graviaPhoneNumberHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. (303) 555-0105'**
  String get graviaPhoneNumberHint;

  /// No description provided for @graviaAddressLine1Label.
  ///
  /// In en, this message translates to:
  /// **'Address Line 1'**
  String get graviaAddressLine1Label;

  /// No description provided for @graviaAddressLine1Hint.
  ///
  /// In en, this message translates to:
  /// **'House no., street name'**
  String get graviaAddressLine1Hint;

  /// No description provided for @graviaAddressLine2Label.
  ///
  /// In en, this message translates to:
  /// **'Address Line 2'**
  String get graviaAddressLine2Label;

  /// No description provided for @graviaAddressLine2Hint.
  ///
  /// In en, this message translates to:
  /// **'Apartment, suite, etc. (optional)'**
  String get graviaAddressLine2Hint;

  /// No description provided for @graviaLandmarkLabel.
  ///
  /// In en, this message translates to:
  /// **'Landmark'**
  String get graviaLandmarkLabel;

  /// No description provided for @graviaLandmarkHint.
  ///
  /// In en, this message translates to:
  /// **'Nearby landmark (optional)'**
  String get graviaLandmarkHint;

  /// No description provided for @graviaCityLabel.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get graviaCityLabel;

  /// No description provided for @graviaCityHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. New Delhi'**
  String get graviaCityHint;

  /// No description provided for @graviaStateLabel.
  ///
  /// In en, this message translates to:
  /// **'State'**
  String get graviaStateLabel;

  /// No description provided for @graviaStateHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Delhi (optional)'**
  String get graviaStateHint;

  /// No description provided for @graviaCountryLabel.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get graviaCountryLabel;

  /// No description provided for @graviaSelectCountryTitle.
  ///
  /// In en, this message translates to:
  /// **'Select Country'**
  String get graviaSelectCountryTitle;

  /// No description provided for @graviaPostalCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'Postal Code'**
  String get graviaPostalCodeLabel;

  /// No description provided for @graviaPostalCodeHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 62639'**
  String get graviaPostalCodeHint;

  /// No description provided for @graviaAddressTagLabel.
  ///
  /// In en, this message translates to:
  /// **'Tag'**
  String get graviaAddressTagLabel;

  /// No description provided for @graviaAddressTagHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Home, Office'**
  String get graviaAddressTagHint;

  /// No description provided for @graviaAddAddressButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'Add Address'**
  String get graviaAddAddressButtonLabel;

  /// No description provided for @graviaUpdateAddressButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'Update Address'**
  String get graviaUpdateAddressButtonLabel;

  /// No description provided for @graviaRequiredFieldErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get graviaRequiredFieldErrorMessage;

  /// No description provided for @graviaUseMyLocationLabel.
  ///
  /// In en, this message translates to:
  /// **'Use my location'**
  String get graviaUseMyLocationLabel;

  /// No description provided for @graviaLocationUnavailableMessage.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t get your location. Check location permission and try again.'**
  String get graviaLocationUnavailableMessage;

  /// No description provided for @graviaAddressSearchLabel.
  ///
  /// In en, this message translates to:
  /// **'Search Address'**
  String get graviaAddressSearchLabel;

  /// No description provided for @graviaAddressSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search area, street, landmark…'**
  String get graviaAddressSearchHint;

  /// No description provided for @graviaProfilePageTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get graviaProfilePageTitle;

  /// No description provided for @graviaChangePasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get graviaChangePasswordLabel;

  /// No description provided for @graviaMyOrdersLabel.
  ///
  /// In en, this message translates to:
  /// **'My Orders'**
  String get graviaMyOrdersLabel;

  /// No description provided for @graviaMyAddressLabel.
  ///
  /// In en, this message translates to:
  /// **'My Address'**
  String get graviaMyAddressLabel;

  /// No description provided for @graviaDarkModeLabel.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get graviaDarkModeLabel;

  /// No description provided for @graviaPrivacyPolicyLabel.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get graviaPrivacyPolicyLabel;

  /// No description provided for @graviaTermsAndConditionsLabel.
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions'**
  String get graviaTermsAndConditionsLabel;

  /// No description provided for @graviaLogoutLabel.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get graviaLogoutLabel;

  /// No description provided for @graviaLogoutTitle.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get graviaLogoutTitle;

  /// No description provided for @graviaLogoutConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out?'**
  String get graviaLogoutConfirmMessage;

  /// No description provided for @graviaProfileLoadErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong loading your profile.'**
  String get graviaProfileLoadErrorMessage;

  /// No description provided for @graviaEditProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get graviaEditProfileTitle;

  /// No description provided for @graviaEmailAddressLabel.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get graviaEmailAddressLabel;

  /// No description provided for @graviaEmailAddressHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. mark.shelby@example.com'**
  String get graviaEmailAddressHint;

  /// No description provided for @graviaMobileNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Mobile Number'**
  String get graviaMobileNumberLabel;

  /// No description provided for @graviaUpdateProfileButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get graviaUpdateProfileButtonLabel;

  /// No description provided for @graviaChangePhotoTitle.
  ///
  /// In en, this message translates to:
  /// **'Change Photo'**
  String get graviaChangePhotoTitle;

  /// No description provided for @graviaTakePhotoLabel.
  ///
  /// In en, this message translates to:
  /// **'Take Photo'**
  String get graviaTakePhotoLabel;

  /// No description provided for @graviaChooseFromGalleryLabel.
  ///
  /// In en, this message translates to:
  /// **'Choose from Gallery'**
  String get graviaChooseFromGalleryLabel;

  /// No description provided for @graviaAvatarPickerMobileOnlyMessage.
  ///
  /// In en, this message translates to:
  /// **'Changing your photo is only available on mobile'**
  String get graviaAvatarPickerMobileOnlyMessage;

  /// No description provided for @graviaChangePasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get graviaChangePasswordTitle;

  /// No description provided for @graviaCurrentPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Current Password'**
  String get graviaCurrentPasswordLabel;

  /// No description provided for @graviaCurrentPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your current password'**
  String get graviaCurrentPasswordHint;

  /// No description provided for @graviaNewPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get graviaNewPasswordLabel;

  /// No description provided for @graviaNewPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your new password'**
  String get graviaNewPasswordHint;

  /// No description provided for @graviaConfirmNewPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm New Password'**
  String get graviaConfirmNewPasswordLabel;

  /// No description provided for @graviaConfirmNewPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Re-enter your new password'**
  String get graviaConfirmNewPasswordHint;

  /// No description provided for @graviaUpdatePasswordButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'Update Password'**
  String get graviaUpdatePasswordButtonLabel;

  /// No description provided for @graviaPasswordUpdatedMessage.
  ///
  /// In en, this message translates to:
  /// **'Your password has been updated.'**
  String get graviaPasswordUpdatedMessage;

  /// No description provided for @graviaMyCartTitle.
  ///
  /// In en, this message translates to:
  /// **'My Cart'**
  String get graviaMyCartTitle;

  /// No description provided for @graviaBeforeYouCheckoutTitle.
  ///
  /// In en, this message translates to:
  /// **'Before you Checkout'**
  String get graviaBeforeYouCheckoutTitle;

  /// No description provided for @graviaCouponCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'Coupon Code'**
  String get graviaCouponCodeLabel;

  /// No description provided for @graviaApplyLabel.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get graviaApplyLabel;

  /// No description provided for @graviaCouponRemoveLabel.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get graviaCouponRemoveLabel;

  /// No description provided for @graviaCouponApplied.
  ///
  /// In en, this message translates to:
  /// **'{code} applied'**
  String graviaCouponApplied(String code);

  /// No description provided for @graviaCouponLine.
  ///
  /// In en, this message translates to:
  /// **'Coupon ({code})'**
  String graviaCouponLine(String code);

  /// No description provided for @graviaItemTotalLabel.
  ///
  /// In en, this message translates to:
  /// **'Item Total'**
  String get graviaItemTotalLabel;

  /// No description provided for @graviaDiscountLabel.
  ///
  /// In en, this message translates to:
  /// **'Discount'**
  String get graviaDiscountLabel;

  /// No description provided for @graviaDeliveryLabel.
  ///
  /// In en, this message translates to:
  /// **'Delivery'**
  String get graviaDeliveryLabel;

  /// No description provided for @graviaDeliveryFreeLabel.
  ///
  /// In en, this message translates to:
  /// **'FREE'**
  String get graviaDeliveryFreeLabel;

  /// No description provided for @graviaGrandTotalLabel.
  ///
  /// In en, this message translates to:
  /// **'Grand Total'**
  String get graviaGrandTotalLabel;

  /// No description provided for @graviaProceedToCheckoutLabel.
  ///
  /// In en, this message translates to:
  /// **'Proceed to Checkout'**
  String get graviaProceedToCheckoutLabel;

  /// No description provided for @graviaCartEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Your cart is empty'**
  String get graviaCartEmptyTitle;

  /// No description provided for @graviaCartEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add items to get started.'**
  String get graviaCartEmptySubtitle;

  /// No description provided for @graviaCartBarTitle.
  ///
  /// In en, this message translates to:
  /// **'See more products'**
  String get graviaCartBarTitle;

  /// No description provided for @graviaExploreLabel.
  ///
  /// In en, this message translates to:
  /// **'Explore'**
  String get graviaExploreLabel;

  /// No description provided for @graviaCheckoutLabel.
  ///
  /// In en, this message translates to:
  /// **'Checkout'**
  String get graviaCheckoutLabel;

  /// No description provided for @graviaCartSummary.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{{count} item} other{{count} items}} | {total}'**
  String graviaCartSummary(int count, String total);

  /// No description provided for @graviaOrdersPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get graviaOrdersPageTitle;

  /// No description provided for @graviaUpcomingTabLabel.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get graviaUpcomingTabLabel;

  /// No description provided for @graviaPastTabLabel.
  ///
  /// In en, this message translates to:
  /// **'Past'**
  String get graviaPastTabLabel;

  /// No description provided for @graviaPendingStatusLabel.
  ///
  /// In en, this message translates to:
  /// **'Order Placed'**
  String get graviaPendingStatusLabel;

  /// No description provided for @graviaInProcessStatusLabel.
  ///
  /// In en, this message translates to:
  /// **'On the way'**
  String get graviaInProcessStatusLabel;

  /// No description provided for @graviaDeliveredStatusLabel.
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get graviaDeliveredStatusLabel;

  /// No description provided for @graviaCancelledStatusLabel.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get graviaCancelledStatusLabel;

  /// No description provided for @graviaDeliveryOtpLabel.
  ///
  /// In en, this message translates to:
  /// **'Delivery OTP'**
  String get graviaDeliveryOtpLabel;

  /// No description provided for @graviaCancelOrderLabel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get graviaCancelOrderLabel;

  /// No description provided for @graviaTrackOrderLabel.
  ///
  /// In en, this message translates to:
  /// **'Track Order'**
  String get graviaTrackOrderLabel;

  /// No description provided for @graviaViewDetailsLabel.
  ///
  /// In en, this message translates to:
  /// **'View Details'**
  String get graviaViewDetailsLabel;

  /// No description provided for @graviaWriteReviewLabel.
  ///
  /// In en, this message translates to:
  /// **'Write A Review'**
  String get graviaWriteReviewLabel;

  /// No description provided for @graviaRefundPendingLabel.
  ///
  /// In en, this message translates to:
  /// **'Refund processing'**
  String get graviaRefundPendingLabel;

  /// No description provided for @graviaRefundProcessedLabel.
  ///
  /// In en, this message translates to:
  /// **'Refunded'**
  String get graviaRefundProcessedLabel;

  /// No description provided for @graviaRefundFailedLabel.
  ///
  /// In en, this message translates to:
  /// **'Refund failed'**
  String get graviaRefundFailedLabel;

  /// No description provided for @graviaCancelOrderConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Cancel this order?'**
  String get graviaCancelOrderConfirmTitle;

  /// No description provided for @graviaCancelOrderConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'This will cancel your order. If you paid, you\'ll be refunded in full.'**
  String get graviaCancelOrderConfirmBody;

  /// No description provided for @graviaCancelOrderConfirmCta.
  ///
  /// In en, this message translates to:
  /// **'Cancel Order'**
  String get graviaCancelOrderConfirmCta;

  /// No description provided for @graviaCancelOrderDismissCta.
  ///
  /// In en, this message translates to:
  /// **'Keep Order'**
  String get graviaCancelOrderDismissCta;

  /// No description provided for @graviaCancelFailedMessage.
  ///
  /// In en, this message translates to:
  /// **'Could not cancel the order. Please try again.'**
  String get graviaCancelFailedMessage;

  /// No description provided for @graviaOrdersLoadErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong loading your orders.'**
  String get graviaOrdersLoadErrorMessage;

  /// No description provided for @graviaOrdersRefreshFailedMessage.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t refresh — showing your last loaded orders.'**
  String get graviaOrdersRefreshFailedMessage;

  /// No description provided for @graviaTrackOrderTitle.
  ///
  /// In en, this message translates to:
  /// **'Track Order'**
  String get graviaTrackOrderTitle;

  /// No description provided for @graviaOrderStatusTitle.
  ///
  /// In en, this message translates to:
  /// **'Order Status'**
  String get graviaOrderStatusTitle;

  /// No description provided for @graviaOrderItemsTitle.
  ///
  /// In en, this message translates to:
  /// **'Items'**
  String get graviaOrderItemsTitle;

  /// No description provided for @graviaOrderSummaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Summary'**
  String get graviaOrderSummaryTitle;

  /// No description provided for @graviaOrderDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Order Details'**
  String get graviaOrderDetailsTitle;

  /// No description provided for @graviaDeliveryAddressTitle.
  ///
  /// In en, this message translates to:
  /// **'Delivery Address'**
  String get graviaDeliveryAddressTitle;

  /// No description provided for @graviaOrderIdLabel.
  ///
  /// In en, this message translates to:
  /// **'Order ID'**
  String get graviaOrderIdLabel;

  /// No description provided for @graviaOrderPlacedOnLabel.
  ///
  /// In en, this message translates to:
  /// **'Placed on'**
  String get graviaOrderPlacedOnLabel;

  /// No description provided for @graviaPaymentIdLabel.
  ///
  /// In en, this message translates to:
  /// **'Payment ID'**
  String get graviaPaymentIdLabel;

  /// No description provided for @graviaNoOnlinePaymentLabel.
  ///
  /// In en, this message translates to:
  /// **'No online payment'**
  String get graviaNoOnlinePaymentLabel;

  /// No description provided for @graviaRefundLabel.
  ///
  /// In en, this message translates to:
  /// **'Refund'**
  String get graviaRefundLabel;

  /// No description provided for @graviaCopiedMessage.
  ///
  /// In en, this message translates to:
  /// **'Copied'**
  String get graviaCopiedMessage;

  /// No description provided for @graviaOrderTotalLabel.
  ///
  /// In en, this message translates to:
  /// **'Total Paid'**
  String get graviaOrderTotalLabel;

  /// No description provided for @graviaOrderStepPlacedLabel.
  ///
  /// In en, this message translates to:
  /// **'Order Placed'**
  String get graviaOrderStepPlacedLabel;

  /// No description provided for @graviaOrderStepOnTheWayLabel.
  ///
  /// In en, this message translates to:
  /// **'On the way'**
  String get graviaOrderStepOnTheWayLabel;

  /// No description provided for @graviaOrderStepDeliveredLabel.
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get graviaOrderStepDeliveredLabel;

  /// No description provided for @graviaOrderStepCancelledLabel.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get graviaOrderStepCancelledLabel;

  /// No description provided for @graviaOrderStepUndatedLabel.
  ///
  /// In en, this message translates to:
  /// **'Time not recorded'**
  String get graviaOrderStepUndatedLabel;

  /// No description provided for @graviaOrdersEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No orders yet'**
  String get graviaOrdersEmptyTitle;

  /// No description provided for @graviaOrdersEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your past and active orders will show up here.'**
  String get graviaOrdersEmptySubtitle;

  /// No description provided for @graviaFilterSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get graviaFilterSheetTitle;

  /// No description provided for @graviaFilterReasonHeading.
  ///
  /// In en, this message translates to:
  /// **'Select a Reason'**
  String get graviaFilterReasonHeading;

  /// No description provided for @graviaFilterLastWeekLabel.
  ///
  /// In en, this message translates to:
  /// **'Last Week'**
  String get graviaFilterLastWeekLabel;

  /// No description provided for @graviaFilterLastMonthLabel.
  ///
  /// In en, this message translates to:
  /// **'Last Month'**
  String get graviaFilterLastMonthLabel;

  /// No description provided for @graviaFilterStatusLabel.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get graviaFilterStatusLabel;

  /// No description provided for @graviaFilterDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get graviaFilterDateLabel;

  /// No description provided for @graviaFilterAllStatusesLabel.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get graviaFilterAllStatusesLabel;

  /// No description provided for @graviaApplyFilterLabel.
  ///
  /// In en, this message translates to:
  /// **'Apply Filter'**
  String get graviaApplyFilterLabel;

  /// No description provided for @graviaFavouritePageTitle.
  ///
  /// In en, this message translates to:
  /// **'Favourite'**
  String get graviaFavouritePageTitle;

  /// No description provided for @graviaFavouriteEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No favourites yet'**
  String get graviaFavouriteEmptyTitle;

  /// No description provided for @graviaFavouriteEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Tap the heart on a product to keep it here.'**
  String get graviaFavouriteEmptySubtitle;

  /// No description provided for @graviaAddedToCartMessage.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{{name} added to cart} other{{count} × {name} added to cart}}'**
  String graviaAddedToCartMessage(int count, String name);

  /// No description provided for @graviaDeliveryLocationLabel.
  ///
  /// In en, this message translates to:
  /// **'Delivery Location'**
  String get graviaDeliveryLocationLabel;

  /// No description provided for @graviaNoLocationSelectedLabel.
  ///
  /// In en, this message translates to:
  /// **'No Location selected'**
  String get graviaNoLocationSelectedLabel;

  /// No description provided for @graviaNotificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get graviaNotificationsTitle;

  /// No description provided for @graviaNotificationsLoadErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong loading your notifications.'**
  String get graviaNotificationsLoadErrorMessage;

  /// No description provided for @graviaNotificationsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No notifications yet'**
  String get graviaNotificationsEmptyTitle;

  /// No description provided for @graviaNotificationsEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Updates about your orders and account will show up here.'**
  String get graviaNotificationsEmptySubtitle;

  /// No description provided for @validationNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your name.'**
  String get validationNameRequired;

  /// No description provided for @validationEmailRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email address.'**
  String get validationEmailRequired;

  /// No description provided for @validationEmailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address.'**
  String get validationEmailInvalid;

  /// No description provided for @validationMobileRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your mobile number.'**
  String get validationMobileRequired;

  /// No description provided for @validationMobileInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid mobile number.'**
  String get validationMobileInvalid;

  /// No description provided for @validationPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your password.'**
  String get validationPasswordRequired;

  /// No description provided for @validationWeakPassword.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters.'**
  String get validationWeakPassword;

  /// No description provided for @validationConfirmPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Please confirm your new password.'**
  String get validationConfirmPasswordRequired;

  /// No description provided for @validationPasswordsDontMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match.'**
  String get validationPasswordsDontMatch;

  /// No description provided for @retryButton.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retryButton;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'hi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'hi':
      return AppLocalizationsHi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
