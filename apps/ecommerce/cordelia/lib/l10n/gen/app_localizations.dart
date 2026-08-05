import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';
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
    Locale('de'),
    Locale('en'),
    Locale('fr'),
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

  /// No description provided for @languageGerman.
  ///
  /// In en, this message translates to:
  /// **'Deutsch'**
  String get languageGerman;

  /// No description provided for @languageFrench.
  ///
  /// In en, this message translates to:
  /// **'Français'**
  String get languageFrench;

  /// Unit suffix for a countable pack ('3 pcs'). German collapses both numbers to 'Stk.', so this is a plural key even though English is the only locale that varies.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{pc} other{pcs}}'**
  String unitPiecesLabel(int count);

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

  /// Price-bucket label. {price} arrives already formatted for the active locale and the store's currency (core's asPrice) — never hardcode a currency glyph in this string.
  ///
  /// In en, this message translates to:
  /// **'Under {price}'**
  String priceFilterUnderLabel(String price);

  /// No description provided for @priceFilterOverLabel.
  ///
  /// In en, this message translates to:
  /// **'Over {price}'**
  String priceFilterOverLabel(String price);

  /// No description provided for @priceFilterRangeLabel.
  ///
  /// In en, this message translates to:
  /// **'{from} - {to}'**
  String priceFilterRangeLabel(String from, String to);

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

  /// Joins an order's date and time. Both arrive already formatted for the active locale (core's DateTimePartsX) — this string owns only the connector, which is not 'at' in every language.
  ///
  /// In en, this message translates to:
  /// **'{date} at {time}'**
  String orderPlacedAtLabel(String date, String time);

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

  /// No description provided for @dailymartTopSellerTitle.
  ///
  /// In en, this message translates to:
  /// **'Top Seller🔥'**
  String get dailymartTopSellerTitle;

  /// No description provided for @dailymartCategoriesTitle.
  ///
  /// In en, this message translates to:
  /// **'Shop by category'**
  String get dailymartCategoriesTitle;

  /// No description provided for @dailymartPopularProductsTitle.
  ///
  /// In en, this message translates to:
  /// **'Popular Products'**
  String get dailymartPopularProductsTitle;

  /// No description provided for @dailymartSeeAll.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get dailymartSeeAll;

  /// No description provided for @dailymartSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search for products'**
  String get dailymartSearchHint;

  /// No description provided for @dailymartHomeLoadErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load this store\'s catalog.'**
  String get dailymartHomeLoadErrorMessage;

  /// No description provided for @dailymartNoLocationSelectedLabel.
  ///
  /// In en, this message translates to:
  /// **'Select a location'**
  String get dailymartNoLocationSelectedLabel;

  /// No description provided for @dailymartNotificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Notification'**
  String get dailymartNotificationsTitle;

  /// No description provided for @dailymartNotificationsLoadErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load your notifications.'**
  String get dailymartNotificationsLoadErrorMessage;

  /// No description provided for @dailymartNotificationsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No notifications yet'**
  String get dailymartNotificationsEmptyTitle;

  /// No description provided for @dailymartNotificationsEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Deals and order updates from this store will show up here.'**
  String get dailymartNotificationsEmptySubtitle;

  /// No description provided for @dailymartOrderNow.
  ///
  /// In en, this message translates to:
  /// **'Order Now'**
  String get dailymartOrderNow;

  /// No description provided for @dailymartPromoSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enjoy discounts of up to {percent}%\non your order today'**
  String dailymartPromoSubtitle(String percent);

  /// No description provided for @dailymartDiscountPercentOff.
  ///
  /// In en, this message translates to:
  /// **'{percent}% off'**
  String dailymartDiscountPercentOff(String percent);

  /// No description provided for @dailymartNavHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get dailymartNavHome;

  /// No description provided for @dailymartNavWishlist.
  ///
  /// In en, this message translates to:
  /// **'Wishlist'**
  String get dailymartNavWishlist;

  /// No description provided for @dailymartNavCart.
  ///
  /// In en, this message translates to:
  /// **'Cart'**
  String get dailymartNavCart;

  /// No description provided for @dailymartNavProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get dailymartNavProfile;

  /// No description provided for @dailymartRecentSearchTitle.
  ///
  /// In en, this message translates to:
  /// **'Recent Search'**
  String get dailymartRecentSearchTitle;

  /// No description provided for @dailymartRecentlyViewedTitle.
  ///
  /// In en, this message translates to:
  /// **'Recently viewed'**
  String get dailymartRecentlyViewedTitle;

  /// No description provided for @dailymartResultsForLabel.
  ///
  /// In en, this message translates to:
  /// **'Result for \"{query}\"'**
  String dailymartResultsForLabel(String query);

  /// No description provided for @dailymartResultsCountLabel.
  ///
  /// In en, this message translates to:
  /// **'{count} founds'**
  String dailymartResultsCountLabel(int count);

  /// No description provided for @dailymartSearchLoadErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load search.'**
  String get dailymartSearchLoadErrorMessage;

  /// No description provided for @dailymartSearchResultsErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t search this store.'**
  String get dailymartSearchResultsErrorMessage;

  /// No description provided for @dailymartSearchNoResultsTitle.
  ///
  /// In en, this message translates to:
  /// **'No results'**
  String get dailymartSearchNoResultsTitle;

  /// No description provided for @dailymartSearchNoResultsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Nothing in this store matches \"{query}\" yet.'**
  String dailymartSearchNoResultsSubtitle(String query);

  /// No description provided for @dailymartCategoryBadge.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get dailymartCategoryBadge;

  /// No description provided for @dailymartFilterLabel.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get dailymartFilterLabel;

  /// No description provided for @dailymartSortSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Sort by'**
  String get dailymartSortSheetTitle;

  /// No description provided for @dailymartPriceSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get dailymartPriceSheetTitle;

  /// No description provided for @dailymartCategoryDetailsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Nothing here'**
  String get dailymartCategoryDetailsEmptyTitle;

  /// No description provided for @dailymartCategoryDetailsEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'No products in this category match those filters.'**
  String get dailymartCategoryDetailsEmptySubtitle;

  /// No description provided for @dailymartCategoryDetailsErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load this category.'**
  String get dailymartCategoryDetailsErrorMessage;

  /// No description provided for @dailymartWishlistEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Nothing saved yet'**
  String get dailymartWishlistEmptyTitle;

  /// No description provided for @dailymartWishlistEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Tap the heart on a product and it will wait for you here.'**
  String get dailymartWishlistEmptySubtitle;

  /// No description provided for @dailymartWishlistExploreAction.
  ///
  /// In en, this message translates to:
  /// **'Start shopping'**
  String get dailymartWishlistExploreAction;

  /// No description provided for @dailymartProductDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Product Details'**
  String get dailymartProductDetailsTitle;

  /// No description provided for @dailymartDescriptionsTabLabel.
  ///
  /// In en, this message translates to:
  /// **'Descriptions'**
  String get dailymartDescriptionsTabLabel;

  /// No description provided for @dailymartReviewsTabLabel.
  ///
  /// In en, this message translates to:
  /// **'Reviews'**
  String get dailymartReviewsTabLabel;

  /// No description provided for @dailymartRelatedProductsTitle.
  ///
  /// In en, this message translates to:
  /// **'Related Products'**
  String get dailymartRelatedProductsTitle;

  /// No description provided for @dailymartSelectSizeLabel.
  ///
  /// In en, this message translates to:
  /// **'Select Size'**
  String get dailymartSelectSizeLabel;

  /// No description provided for @dailymartProductDetailsLoadErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load this product\'s details.'**
  String get dailymartProductDetailsLoadErrorMessage;

  /// No description provided for @dailymartAddToCart.
  ///
  /// In en, this message translates to:
  /// **'Add To Cart'**
  String get dailymartAddToCart;

  /// No description provided for @dailymartAddToCartSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Add To Cart'**
  String get dailymartAddToCartSheetTitle;

  /// No description provided for @dailymartAddedToCartMessage.
  ///
  /// In en, this message translates to:
  /// **'Added {count} × {name} to your cart.'**
  String dailymartAddedToCartMessage(int count, String name);

  /// No description provided for @dailymartStarRowLabel.
  ///
  /// In en, this message translates to:
  /// **'{stars} Star'**
  String dailymartStarRowLabel(int stars);

  /// No description provided for @dailymartMyCartTitle.
  ///
  /// In en, this message translates to:
  /// **'My Cart'**
  String get dailymartMyCartTitle;

  /// No description provided for @dailymartCouponHint.
  ///
  /// In en, this message translates to:
  /// **'Enter coupon code'**
  String get dailymartCouponHint;

  /// No description provided for @dailymartCouponRemoveLabel.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get dailymartCouponRemoveLabel;

  /// No description provided for @dailymartCouponDetailLabel.
  ///
  /// In en, this message translates to:
  /// **'Coupon'**
  String get dailymartCouponDetailLabel;

  /// No description provided for @dailymartCouponApplied.
  ///
  /// In en, this message translates to:
  /// **'{code} applied'**
  String dailymartCouponApplied(String code);

  /// No description provided for @dailymartCouponLine.
  ///
  /// In en, this message translates to:
  /// **'Coupon ({code})'**
  String dailymartCouponLine(String code);

  /// No description provided for @dailymartSubTotalLabel.
  ///
  /// In en, this message translates to:
  /// **'Sub total'**
  String get dailymartSubTotalLabel;

  /// No description provided for @dailymartDeliveryLabel.
  ///
  /// In en, this message translates to:
  /// **'Delivery'**
  String get dailymartDeliveryLabel;

  /// No description provided for @dailymartDeliveryFreeLabel.
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get dailymartDeliveryFreeLabel;

  /// No description provided for @dailymartDiscountLabel.
  ///
  /// In en, this message translates to:
  /// **'Discount'**
  String get dailymartDiscountLabel;

  /// No description provided for @dailymartTotalCostLabel.
  ///
  /// In en, this message translates to:
  /// **'Total cost'**
  String get dailymartTotalCostLabel;

  /// No description provided for @dailymartProceedToCheckoutLabel.
  ///
  /// In en, this message translates to:
  /// **'Proceed to Checkout'**
  String get dailymartProceedToCheckoutLabel;

  /// No description provided for @dailymartCartEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Your cart is empty'**
  String get dailymartCartEmptyTitle;

  /// No description provided for @dailymartCartEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Products you add will show up here, ready to check out.'**
  String get dailymartCartEmptySubtitle;

  /// No description provided for @dailymartCartExploreAction.
  ///
  /// In en, this message translates to:
  /// **'Start shopping'**
  String get dailymartCartExploreAction;

  /// No description provided for @dailymartRemovedFromCartMessage.
  ///
  /// In en, this message translates to:
  /// **'Removed from your cart.'**
  String get dailymartRemovedFromCartMessage;

  /// No description provided for @dailymartCheckoutTitle.
  ///
  /// In en, this message translates to:
  /// **'Checkout'**
  String get dailymartCheckoutTitle;

  /// No description provided for @dailymartShippingAddressLabel.
  ///
  /// In en, this message translates to:
  /// **'Shipping Address'**
  String get dailymartShippingAddressLabel;

  /// No description provided for @dailymartOrderListLabel.
  ///
  /// In en, this message translates to:
  /// **'Order List'**
  String get dailymartOrderListLabel;

  /// No description provided for @dailymartContinueToPaymentLabel.
  ///
  /// In en, this message translates to:
  /// **'Continue to Payment'**
  String get dailymartContinueToPaymentLabel;

  /// No description provided for @dailymartOrderPlacedTitle.
  ///
  /// In en, this message translates to:
  /// **'Payment Successful!'**
  String get dailymartOrderPlacedTitle;

  /// No description provided for @dailymartOrderPlacedMessage.
  ///
  /// In en, this message translates to:
  /// **'Thank you for your purchase! We\'re excited to let you know that your payment has been successfully processed. 🎉'**
  String get dailymartOrderPlacedMessage;

  /// No description provided for @dailymartTrackOrderLabel.
  ///
  /// In en, this message translates to:
  /// **'Track My Order'**
  String get dailymartTrackOrderLabel;

  /// No description provided for @dailymartCartSummary.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{{count} item} other{{count} items}} | {total}'**
  String dailymartCartSummary(int count, String total);

  /// No description provided for @dailymartViewCartLabel.
  ///
  /// In en, this message translates to:
  /// **'View Cart'**
  String get dailymartViewCartLabel;

  /// No description provided for @dailymartGeneralSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get dailymartGeneralSectionTitle;

  /// No description provided for @dailymartPreferencesSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get dailymartPreferencesSectionTitle;

  /// No description provided for @dailymartEditProfileLabel.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get dailymartEditProfileLabel;

  /// No description provided for @dailymartChangePasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get dailymartChangePasswordLabel;

  /// No description provided for @dailymartMyOrdersLabel.
  ///
  /// In en, this message translates to:
  /// **'My Orders'**
  String get dailymartMyOrdersLabel;

  /// No description provided for @dailymartMyAddressLabel.
  ///
  /// In en, this message translates to:
  /// **'My Address'**
  String get dailymartMyAddressLabel;

  /// No description provided for @dailymartDarkModeLabel.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get dailymartDarkModeLabel;

  /// No description provided for @dailymartPrivacyPolicyLabel.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get dailymartPrivacyPolicyLabel;

  /// No description provided for @dailymartTermsAndConditionsLabel.
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions'**
  String get dailymartTermsAndConditionsLabel;

  /// No description provided for @dailymartLogoutLabel.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get dailymartLogoutLabel;

  /// No description provided for @dailymartLogoutTitle.
  ///
  /// In en, this message translates to:
  /// **'Log out?'**
  String get dailymartLogoutTitle;

  /// No description provided for @dailymartLogoutConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'You\'ll need to sign in again to place an order or track one.'**
  String get dailymartLogoutConfirmMessage;

  /// No description provided for @dailymartProfileLoadErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load your profile.'**
  String get dailymartProfileLoadErrorMessage;

  /// No description provided for @dailymartEditProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get dailymartEditProfileTitle;

  /// No description provided for @dailymartFullNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get dailymartFullNameLabel;

  /// No description provided for @dailymartFullNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your full name'**
  String get dailymartFullNameHint;

  /// No description provided for @dailymartEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get dailymartEmailLabel;

  /// No description provided for @dailymartEmailHint.
  ///
  /// In en, this message translates to:
  /// **'you@example.com'**
  String get dailymartEmailHint;

  /// No description provided for @dailymartPhoneNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get dailymartPhoneNumberLabel;

  /// No description provided for @dailymartPhoneNumberHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number'**
  String get dailymartPhoneNumberHint;

  /// No description provided for @dailymartSaveChangesLabel.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get dailymartSaveChangesLabel;

  /// No description provided for @dailymartChangePhotoTitle.
  ///
  /// In en, this message translates to:
  /// **'Change Photo'**
  String get dailymartChangePhotoTitle;

  /// No description provided for @dailymartTakePhotoLabel.
  ///
  /// In en, this message translates to:
  /// **'Take Photo'**
  String get dailymartTakePhotoLabel;

  /// No description provided for @dailymartChooseFromGalleryLabel.
  ///
  /// In en, this message translates to:
  /// **'Choose from Gallery'**
  String get dailymartChooseFromGalleryLabel;

  /// No description provided for @dailymartAvatarPickerMobileOnlyMessage.
  ///
  /// In en, this message translates to:
  /// **'Choosing a photo is only available on mobile.'**
  String get dailymartAvatarPickerMobileOnlyMessage;

  /// No description provided for @dailymartChangePasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get dailymartChangePasswordTitle;

  /// No description provided for @dailymartCurrentPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Current Password'**
  String get dailymartCurrentPasswordLabel;

  /// No description provided for @dailymartCurrentPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your current password'**
  String get dailymartCurrentPasswordHint;

  /// No description provided for @dailymartNewPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get dailymartNewPasswordLabel;

  /// No description provided for @dailymartNewPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your new password'**
  String get dailymartNewPasswordHint;

  /// No description provided for @dailymartConfirmNewPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm New Password'**
  String get dailymartConfirmNewPasswordLabel;

  /// No description provided for @dailymartConfirmNewPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Re-enter your new password'**
  String get dailymartConfirmNewPasswordHint;

  /// No description provided for @dailymartUpdatePasswordButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'Update Password'**
  String get dailymartUpdatePasswordButtonLabel;

  /// No description provided for @dailymartPasswordUpdatedMessage.
  ///
  /// In en, this message translates to:
  /// **'Your password has been updated.'**
  String get dailymartPasswordUpdatedMessage;

  /// No description provided for @dailymartSelectAddressTitle.
  ///
  /// In en, this message translates to:
  /// **'Select Address'**
  String get dailymartSelectAddressTitle;

  /// No description provided for @dailymartAddNewAddressLabel.
  ///
  /// In en, this message translates to:
  /// **'Add New Address'**
  String get dailymartAddNewAddressLabel;

  /// No description provided for @dailymartAddressLoadErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load your addresses.'**
  String get dailymartAddressLoadErrorMessage;

  /// No description provided for @dailymartAddressSaveFailedMessage.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t save that address.'**
  String get dailymartAddressSaveFailedMessage;

  /// No description provided for @dailymartAddressEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No saved addresses'**
  String get dailymartAddressEmptyTitle;

  /// No description provided for @dailymartAddressEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add one to get this store delivering to your door.'**
  String get dailymartAddressEmptySubtitle;

  /// No description provided for @dailymartAddressDeleteFailedMessage.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t delete that address.'**
  String get dailymartAddressDeleteFailedMessage;

  /// No description provided for @dailymartEditAddressTooltip.
  ///
  /// In en, this message translates to:
  /// **'Edit address'**
  String get dailymartEditAddressTooltip;

  /// No description provided for @dailymartDeleteAddressTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete this address?'**
  String get dailymartDeleteAddressTitle;

  /// No description provided for @dailymartDeleteAddressMessage.
  ///
  /// In en, this message translates to:
  /// **'It\'ll be removed from your saved addresses.'**
  String get dailymartDeleteAddressMessage;

  /// No description provided for @dailymartDeleteLabel.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get dailymartDeleteLabel;

  /// No description provided for @dailymartAddAddressTitle.
  ///
  /// In en, this message translates to:
  /// **'Add New Address'**
  String get dailymartAddAddressTitle;

  /// No description provided for @dailymartEditAddressTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Address'**
  String get dailymartEditAddressTitle;

  /// No description provided for @dailymartAddressNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get dailymartAddressNameLabel;

  /// No description provided for @dailymartAddressNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Mark Shelby'**
  String get dailymartAddressNameHint;

  /// No description provided for @dailymartAddressLine1Label.
  ///
  /// In en, this message translates to:
  /// **'Address Line 1'**
  String get dailymartAddressLine1Label;

  /// No description provided for @dailymartAddressLine1Hint.
  ///
  /// In en, this message translates to:
  /// **'House no., street name'**
  String get dailymartAddressLine1Hint;

  /// No description provided for @dailymartAddressLine2Label.
  ///
  /// In en, this message translates to:
  /// **'Address Line 2'**
  String get dailymartAddressLine2Label;

  /// No description provided for @dailymartAddressLine2Hint.
  ///
  /// In en, this message translates to:
  /// **'Apartment, suite, etc. (optional)'**
  String get dailymartAddressLine2Hint;

  /// No description provided for @dailymartLandmarkLabel.
  ///
  /// In en, this message translates to:
  /// **'Landmark'**
  String get dailymartLandmarkLabel;

  /// No description provided for @dailymartLandmarkHint.
  ///
  /// In en, this message translates to:
  /// **'Nearby landmark (optional)'**
  String get dailymartLandmarkHint;

  /// No description provided for @dailymartCityLabel.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get dailymartCityLabel;

  /// No description provided for @dailymartCityHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. New Delhi'**
  String get dailymartCityHint;

  /// No description provided for @dailymartStateLabel.
  ///
  /// In en, this message translates to:
  /// **'State'**
  String get dailymartStateLabel;

  /// No description provided for @dailymartStateHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Delhi (optional)'**
  String get dailymartStateHint;

  /// No description provided for @dailymartCountryLabel.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get dailymartCountryLabel;

  /// No description provided for @dailymartSelectCountryTitle.
  ///
  /// In en, this message translates to:
  /// **'Select Country'**
  String get dailymartSelectCountryTitle;

  /// No description provided for @dailymartPostalCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'Postal Code'**
  String get dailymartPostalCodeLabel;

  /// No description provided for @dailymartPostalCodeHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 62639'**
  String get dailymartPostalCodeHint;

  /// No description provided for @dailymartAddressTagLabel.
  ///
  /// In en, this message translates to:
  /// **'Tag'**
  String get dailymartAddressTagLabel;

  /// No description provided for @dailymartAddressTagHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Home, Office'**
  String get dailymartAddressTagHint;

  /// No description provided for @dailymartAddAddressButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'Add Address'**
  String get dailymartAddAddressButtonLabel;

  /// No description provided for @dailymartUpdateAddressButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'Update Address'**
  String get dailymartUpdateAddressButtonLabel;

  /// No description provided for @dailymartRequiredFieldErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get dailymartRequiredFieldErrorMessage;

  /// No description provided for @dailymartMyOrdersTitle.
  ///
  /// In en, this message translates to:
  /// **'My Orders'**
  String get dailymartMyOrdersTitle;

  /// No description provided for @dailymartOrdersSearchHint.
  ///
  /// In en, this message translates to:
  /// **'What are you looking for...'**
  String get dailymartOrdersSearchHint;

  /// No description provided for @dailymartOrdersFilterAllLabel.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get dailymartOrdersFilterAllLabel;

  /// No description provided for @dailymartOrdersFilterActiveLabel.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get dailymartOrdersFilterActiveLabel;

  /// No description provided for @dailymartOrdersFilterCompletedLabel.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get dailymartOrdersFilterCompletedLabel;

  /// No description provided for @dailymartOrdersFilterCancelledLabel.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get dailymartOrdersFilterCancelledLabel;

  /// No description provided for @dailymartOrderSummaryLabel.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{{count} item} other{{count} items}} · {date}'**
  String dailymartOrderSummaryLabel(int count, String date);

  /// No description provided for @dailymartOrdersDateRangeLabel.
  ///
  /// In en, this message translates to:
  /// **'Date Range'**
  String get dailymartOrdersDateRangeLabel;

  /// No description provided for @dailymartOrdersAllTimeLabel.
  ///
  /// In en, this message translates to:
  /// **'All time'**
  String get dailymartOrdersAllTimeLabel;

  /// No description provided for @dailymartOrdersFilterLastWeekLabel.
  ///
  /// In en, this message translates to:
  /// **'Last week'**
  String get dailymartOrdersFilterLastWeekLabel;

  /// No description provided for @dailymartOrdersFilterLastMonthLabel.
  ///
  /// In en, this message translates to:
  /// **'Last month'**
  String get dailymartOrdersFilterLastMonthLabel;

  /// No description provided for @dailymartResetLabel.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get dailymartResetLabel;

  /// No description provided for @dailymartApplyLabel.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get dailymartApplyLabel;

  /// No description provided for @dailymartOrdersLoadErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load your orders.'**
  String get dailymartOrdersLoadErrorMessage;

  /// No description provided for @dailymartOrdersEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No orders yet'**
  String get dailymartOrdersEmptyTitle;

  /// No description provided for @dailymartOrdersEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your orders from this store will show up here.'**
  String get dailymartOrdersEmptySubtitle;

  /// No description provided for @dailymartOrdersNoResultsTitle.
  ///
  /// In en, this message translates to:
  /// **'Nothing here'**
  String get dailymartOrdersNoResultsTitle;

  /// No description provided for @dailymartOrdersNoResultsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'No orders match that search or filter.'**
  String get dailymartOrdersNoResultsSubtitle;

  /// No description provided for @dailymartOrderCancelFailedMessage.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t cancel that order.'**
  String get dailymartOrderCancelFailedMessage;

  /// No description provided for @dailymartOrdersRefreshFailedMessage.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t refresh your orders.'**
  String get dailymartOrdersRefreshFailedMessage;

  /// No description provided for @dailymartTrackOrderTitle.
  ///
  /// In en, this message translates to:
  /// **'Track Order'**
  String get dailymartTrackOrderTitle;

  /// No description provided for @dailymartTrackOrderAction.
  ///
  /// In en, this message translates to:
  /// **'Track Order'**
  String get dailymartTrackOrderAction;

  /// No description provided for @dailymartOrderDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Order Details'**
  String get dailymartOrderDetailsTitle;

  /// No description provided for @dailymartOrderIdLabel.
  ///
  /// In en, this message translates to:
  /// **'Order ID'**
  String get dailymartOrderIdLabel;

  /// No description provided for @dailymartDeliveryOtpLabel.
  ///
  /// In en, this message translates to:
  /// **'Delivery OTP'**
  String get dailymartDeliveryOtpLabel;

  /// No description provided for @dailymartPaymentTitle.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get dailymartPaymentTitle;

  /// No description provided for @dailymartAmountPaidLabel.
  ///
  /// In en, this message translates to:
  /// **'Amount Paid'**
  String get dailymartAmountPaidLabel;

  /// No description provided for @dailymartPaymentIdLabel.
  ///
  /// In en, this message translates to:
  /// **'Payment ID'**
  String get dailymartPaymentIdLabel;

  /// No description provided for @dailymartRefundLabel.
  ///
  /// In en, this message translates to:
  /// **'Refund'**
  String get dailymartRefundLabel;

  /// No description provided for @dailymartCopiedMessage.
  ///
  /// In en, this message translates to:
  /// **'Copied'**
  String get dailymartCopiedMessage;

  /// No description provided for @dailymartNoOnlinePaymentLabel.
  ///
  /// In en, this message translates to:
  /// **'Not paid online'**
  String get dailymartNoOnlinePaymentLabel;

  /// No description provided for @dailymartRefundPendingLabel.
  ///
  /// In en, this message translates to:
  /// **'Processing'**
  String get dailymartRefundPendingLabel;

  /// No description provided for @dailymartRefundProcessedLabel.
  ///
  /// In en, this message translates to:
  /// **'Refunded'**
  String get dailymartRefundProcessedLabel;

  /// No description provided for @dailymartRefundFailedLabel.
  ///
  /// In en, this message translates to:
  /// **'Refund failed'**
  String get dailymartRefundFailedLabel;

  /// No description provided for @dailymartOrderStatusTitle.
  ///
  /// In en, this message translates to:
  /// **'Order Status'**
  String get dailymartOrderStatusTitle;

  /// No description provided for @dailymartOrderStepPlacedLabel.
  ///
  /// In en, this message translates to:
  /// **'Order Placed'**
  String get dailymartOrderStepPlacedLabel;

  /// No description provided for @dailymartOrderStepOnTheWayLabel.
  ///
  /// In en, this message translates to:
  /// **'On the way'**
  String get dailymartOrderStepOnTheWayLabel;

  /// No description provided for @dailymartOrderStepDeliveredLabel.
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get dailymartOrderStepDeliveredLabel;

  /// No description provided for @dailymartOrderStepCancelledLabel.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get dailymartOrderStepCancelledLabel;

  /// No description provided for @dailymartOrderStepUndatedLabel.
  ///
  /// In en, this message translates to:
  /// **'Time not recorded'**
  String get dailymartOrderStepUndatedLabel;

  /// No description provided for @dailymartOrderStepPendingLabel.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get dailymartOrderStepPendingLabel;

  /// No description provided for @dailymartCancelOrderLabel.
  ///
  /// In en, this message translates to:
  /// **'Cancel Order'**
  String get dailymartCancelOrderLabel;

  /// No description provided for @dailymartCancelOrderTitle.
  ///
  /// In en, this message translates to:
  /// **'Cancel this order?'**
  String get dailymartCancelOrderTitle;

  /// No description provided for @dailymartCancelOrderMessage.
  ///
  /// In en, this message translates to:
  /// **'You\'ll be refunded if the order was paid for.'**
  String get dailymartCancelOrderMessage;

  /// No description provided for @dailymartCancelOrderConfirmLabel.
  ///
  /// In en, this message translates to:
  /// **'Cancel Order'**
  String get dailymartCancelOrderConfirmLabel;

  /// No description provided for @dailymartCancelLabel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get dailymartCancelLabel;

  /// No description provided for @grofastGreeting.
  ///
  /// In en, this message translates to:
  /// **'Hey {name} 👋'**
  String grofastGreeting(String name);

  /// No description provided for @grofastGreetingFallbackName.
  ///
  /// In en, this message translates to:
  /// **'there'**
  String get grofastGreetingFallbackName;

  /// No description provided for @grofastGreetingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Find fresh groceries you want'**
  String get grofastGreetingSubtitle;

  /// No description provided for @grofastSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search fresh groceries'**
  String get grofastSearchHint;

  /// No description provided for @grofastCategoriesTitle.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get grofastCategoriesTitle;

  /// No description provided for @grofastPopularTitle.
  ///
  /// In en, this message translates to:
  /// **'Popular'**
  String get grofastPopularTitle;

  /// No description provided for @grofastSeeAll.
  ///
  /// In en, this message translates to:
  /// **'see all'**
  String get grofastSeeAll;

  /// No description provided for @grofastHomeLoadErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load this store\'s catalog.'**
  String get grofastHomeLoadErrorMessage;

  /// No description provided for @grofastNoLocationSelectedLabel.
  ///
  /// In en, this message translates to:
  /// **'Select a location'**
  String get grofastNoLocationSelectedLabel;

  /// No description provided for @grofastClaimNow.
  ///
  /// In en, this message translates to:
  /// **'claim now'**
  String get grofastClaimNow;

  /// No description provided for @grofastPromoDiscountLabel.
  ///
  /// In en, this message translates to:
  /// **'{percent} off'**
  String grofastPromoDiscountLabel(String percent);

  /// No description provided for @grofastCategoriesLoadErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load categories.'**
  String get grofastCategoriesLoadErrorMessage;

  /// No description provided for @grofastCategoriesEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No categories yet'**
  String get grofastCategoriesEmptyTitle;

  /// No description provided for @grofastCategoriesEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'This store has not published any categories.'**
  String get grofastCategoriesEmptySubtitle;

  /// No description provided for @grofastCategoryProductsTitle.
  ///
  /// In en, this message translates to:
  /// **'All {category}'**
  String grofastCategoryProductsTitle(String category);

  /// No description provided for @grofastCategoryDetailsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Nothing here yet'**
  String get grofastCategoryDetailsEmptyTitle;

  /// No description provided for @grofastCategoryDetailsEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'No products in this category right now.'**
  String get grofastCategoryDetailsEmptySubtitle;

  /// No description provided for @grofastCategoryDetailsErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load this category.'**
  String get grofastCategoryDetailsErrorMessage;

  /// No description provided for @grofastSearchTitle.
  ///
  /// In en, this message translates to:
  /// **'Search Groceries'**
  String get grofastSearchTitle;

  /// No description provided for @grofastRecentSearchTitle.
  ///
  /// In en, this message translates to:
  /// **'Recent Search'**
  String get grofastRecentSearchTitle;

  /// No description provided for @grofastResultsCountLabel.
  ///
  /// In en, this message translates to:
  /// **'Found {count, plural, one{{count} Result} other{{count} Results}}'**
  String grofastResultsCountLabel(int count);

  /// No description provided for @grofastSearchLoadErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load search.'**
  String get grofastSearchLoadErrorMessage;

  /// No description provided for @grofastSearchResultsErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t search this store.'**
  String get grofastSearchResultsErrorMessage;

  /// No description provided for @grofastSearchNoResultsTitle.
  ///
  /// In en, this message translates to:
  /// **'No results'**
  String get grofastSearchNoResultsTitle;

  /// No description provided for @grofastSearchNoResultsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Nothing matched \"{query}\". Try another word.'**
  String grofastSearchNoResultsSubtitle(String query);

  /// No description provided for @grofastSearchIdleTitle.
  ///
  /// In en, this message translates to:
  /// **'What are you shopping for?'**
  String get grofastSearchIdleTitle;

  /// No description provided for @grofastSearchIdleSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Search the whole store by name or category.'**
  String get grofastSearchIdleSubtitle;

  /// No description provided for @grofastSortByTitle.
  ///
  /// In en, this message translates to:
  /// **'Sort By'**
  String get grofastSortByTitle;

  /// No description provided for @grofastPriceTitle.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get grofastPriceTitle;

  /// No description provided for @grofastApplyLabel.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get grofastApplyLabel;

  /// No description provided for @grofastResetLabel.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get grofastResetLabel;

  /// No description provided for @grofastAddToBagTooltip.
  ///
  /// In en, this message translates to:
  /// **'Add to bag'**
  String get grofastAddToBagTooltip;

  /// No description provided for @grofastFavouriteTooltip.
  ///
  /// In en, this message translates to:
  /// **'Save to wishlist'**
  String get grofastFavouriteTooltip;

  /// No description provided for @grofastDecreaseQuantityLabel.
  ///
  /// In en, this message translates to:
  /// **'Decrease quantity'**
  String get grofastDecreaseQuantityLabel;

  /// No description provided for @grofastIncreaseQuantityLabel.
  ///
  /// In en, this message translates to:
  /// **'Increase quantity'**
  String get grofastIncreaseQuantityLabel;

  /// No description provided for @grofastProductDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Product Details'**
  String get grofastProductDetailsTitle;

  /// No description provided for @grofastDescriptionTitle.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get grofastDescriptionTitle;

  /// No description provided for @grofastSelectSizeTitle.
  ///
  /// In en, this message translates to:
  /// **'Select Size'**
  String get grofastSelectSizeTitle;

  /// No description provided for @grofastAddToBag.
  ///
  /// In en, this message translates to:
  /// **'Add to bag'**
  String get grofastAddToBag;

  /// No description provided for @grofastProductDetailsLoadErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load this product right now.'**
  String get grofastProductDetailsLoadErrorMessage;

  /// No description provided for @grofastAddedToBagMessage.
  ///
  /// In en, this message translates to:
  /// **'Added {count} × {name} to your bag.'**
  String grofastAddedToBagMessage(int count, String name);

  /// No description provided for @grofastNoDescriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'No description for this product yet.'**
  String get grofastNoDescriptionLabel;

  /// No description provided for @grofastBagTitle.
  ///
  /// In en, this message translates to:
  /// **'My Bag'**
  String get grofastBagTitle;

  /// No description provided for @grofastBagItemCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{{count} item} other{{count} items}}'**
  String grofastBagItemCount(int count);

  /// No description provided for @grofastPromoCodeHint.
  ///
  /// In en, this message translates to:
  /// **'Add Promo Code'**
  String get grofastPromoCodeHint;

  /// No description provided for @grofastPromoApplyLabel.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get grofastPromoApplyLabel;

  /// No description provided for @grofastPromoRemoveLabel.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get grofastPromoRemoveLabel;

  /// No description provided for @grofastCouponDetailLabel.
  ///
  /// In en, this message translates to:
  /// **'Coupon'**
  String get grofastCouponDetailLabel;

  /// No description provided for @grofastPromoApplied.
  ///
  /// In en, this message translates to:
  /// **'{code} applied'**
  String grofastPromoApplied(String code);

  /// No description provided for @grofastCouponLine.
  ///
  /// In en, this message translates to:
  /// **'Coupon ({code})'**
  String grofastCouponLine(String code);

  /// No description provided for @grofastPromoComingSoonMessage.
  ///
  /// In en, this message translates to:
  /// **'Promo codes are coming soon.'**
  String get grofastPromoComingSoonMessage;

  /// No description provided for @grofastTotalLabel.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get grofastTotalLabel;

  /// No description provided for @grofastSubtotalLabel.
  ///
  /// In en, this message translates to:
  /// **'Subtotal'**
  String get grofastSubtotalLabel;

  /// No description provided for @grofastDiscountLabel.
  ///
  /// In en, this message translates to:
  /// **'Discount'**
  String get grofastDiscountLabel;

  /// No description provided for @grofastProceedToCheckoutLabel.
  ///
  /// In en, this message translates to:
  /// **'Proceed To Checkout'**
  String get grofastProceedToCheckoutLabel;

  /// No description provided for @grofastBagEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Your bag is empty'**
  String get grofastBagEmptyTitle;

  /// No description provided for @grofastBagEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add some fresh groceries and they will show up here.'**
  String get grofastBagEmptySubtitle;

  /// No description provided for @grofastBagExploreAction.
  ///
  /// In en, this message translates to:
  /// **'Start shopping'**
  String get grofastBagExploreAction;

  /// No description provided for @grofastRemovedFromBagMessage.
  ///
  /// In en, this message translates to:
  /// **'Removed from your bag.'**
  String get grofastRemovedFromBagMessage;

  /// No description provided for @grofastCheckoutTitle.
  ///
  /// In en, this message translates to:
  /// **'Checkout'**
  String get grofastCheckoutTitle;

  /// No description provided for @grofastItemsTitle.
  ///
  /// In en, this message translates to:
  /// **'Items'**
  String get grofastItemsTitle;

  /// No description provided for @grofastDeliveryAddressTitle.
  ///
  /// In en, this message translates to:
  /// **'Delievery Address'**
  String get grofastDeliveryAddressTitle;

  /// No description provided for @grofastAddNewLabel.
  ///
  /// In en, this message translates to:
  /// **'add new'**
  String get grofastAddNewLabel;

  /// No description provided for @grofastChangeAddressLabel.
  ///
  /// In en, this message translates to:
  /// **'change'**
  String get grofastChangeAddressLabel;

  /// No description provided for @grofastNoAddressSelectedLabel.
  ///
  /// In en, this message translates to:
  /// **'Choose where to deliver'**
  String get grofastNoAddressSelectedLabel;

  /// No description provided for @grofastConfirmOrderLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm Order'**
  String get grofastConfirmOrderLabel;

  /// No description provided for @grofastOrderPlacedTitle.
  ///
  /// In en, this message translates to:
  /// **'Success!'**
  String get grofastOrderPlacedTitle;

  /// No description provided for @grofastOrderPlacedMessage.
  ///
  /// In en, this message translates to:
  /// **'You have successfully created your order.'**
  String get grofastOrderPlacedMessage;

  /// No description provided for @grofastBrowseHomeLabel.
  ///
  /// In en, this message translates to:
  /// **'Browse Home'**
  String get grofastBrowseHomeLabel;

  /// No description provided for @grofastNavHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get grofastNavHome;

  /// No description provided for @grofastNavCategories.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get grofastNavCategories;

  /// No description provided for @grofastNavBag.
  ///
  /// In en, this message translates to:
  /// **'Bag'**
  String get grofastNavBag;

  /// No description provided for @grofastNavAccount.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get grofastNavAccount;

  /// No description provided for @grofastProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get grofastProfileTitle;

  /// No description provided for @grofastNotificationTileLabel.
  ///
  /// In en, this message translates to:
  /// **'Notification'**
  String get grofastNotificationTileLabel;

  /// No description provided for @grofastOrdersTileLabel.
  ///
  /// In en, this message translates to:
  /// **'My Orders'**
  String get grofastOrdersTileLabel;

  /// No description provided for @grofastWishlistTileLabel.
  ///
  /// In en, this message translates to:
  /// **'Wishlist'**
  String get grofastWishlistTileLabel;

  /// No description provided for @grofastMyProfileLabel.
  ///
  /// In en, this message translates to:
  /// **'My Profile'**
  String get grofastMyProfileLabel;

  /// No description provided for @grofastChangePasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get grofastChangePasswordLabel;

  /// No description provided for @grofastDarkModeLabel.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get grofastDarkModeLabel;

  /// No description provided for @grofastMyAddressLabel.
  ///
  /// In en, this message translates to:
  /// **'My Address'**
  String get grofastMyAddressLabel;

  /// No description provided for @grofastPrivacyPolicyLabel.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get grofastPrivacyPolicyLabel;

  /// No description provided for @grofastTermsAndConditionsLabel.
  ///
  /// In en, this message translates to:
  /// **'Term and Condition'**
  String get grofastTermsAndConditionsLabel;

  /// No description provided for @grofastLogOutLabel.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get grofastLogOutLabel;

  /// No description provided for @grofastLogOutTitle.
  ///
  /// In en, this message translates to:
  /// **'Log out?'**
  String get grofastLogOutTitle;

  /// No description provided for @grofastLogOutConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'You\'ll need to sign in again to place an order.'**
  String get grofastLogOutConfirmMessage;

  /// No description provided for @grofastProfileLoadErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load your profile.'**
  String get grofastProfileLoadErrorMessage;

  /// No description provided for @grofastProfileNameFallback.
  ///
  /// In en, this message translates to:
  /// **'Your account'**
  String get grofastProfileNameFallback;

  /// No description provided for @grofastEditProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'My Profile'**
  String get grofastEditProfileTitle;

  /// No description provided for @grofastFullNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get grofastFullNameLabel;

  /// No description provided for @grofastFullNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your full name'**
  String get grofastFullNameHint;

  /// No description provided for @grofastEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get grofastEmailLabel;

  /// No description provided for @grofastEmailHint.
  ///
  /// In en, this message translates to:
  /// **'you@example.com'**
  String get grofastEmailHint;

  /// No description provided for @grofastPhoneNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get grofastPhoneNumberLabel;

  /// No description provided for @grofastPhoneNumberHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number'**
  String get grofastPhoneNumberHint;

  /// No description provided for @grofastSaveChangesLabel.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get grofastSaveChangesLabel;

  /// No description provided for @grofastChangePhotoTitle.
  ///
  /// In en, this message translates to:
  /// **'Change Photo'**
  String get grofastChangePhotoTitle;

  /// No description provided for @grofastTakePhotoLabel.
  ///
  /// In en, this message translates to:
  /// **'Take Photo'**
  String get grofastTakePhotoLabel;

  /// No description provided for @grofastChooseFromGalleryLabel.
  ///
  /// In en, this message translates to:
  /// **'Choose from Gallery'**
  String get grofastChooseFromGalleryLabel;

  /// No description provided for @grofastAvatarPickerMobileOnlyMessage.
  ///
  /// In en, this message translates to:
  /// **'Photo picking is only available on mobile.'**
  String get grofastAvatarPickerMobileOnlyMessage;

  /// No description provided for @grofastProfileUpdatedMessage.
  ///
  /// In en, this message translates to:
  /// **'Your profile has been updated.'**
  String get grofastProfileUpdatedMessage;

  /// No description provided for @grofastChangePasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get grofastChangePasswordTitle;

  /// No description provided for @grofastCurrentPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Current Password'**
  String get grofastCurrentPasswordLabel;

  /// No description provided for @grofastCurrentPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your current password'**
  String get grofastCurrentPasswordHint;

  /// No description provided for @grofastNewPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get grofastNewPasswordLabel;

  /// No description provided for @grofastNewPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your new password'**
  String get grofastNewPasswordHint;

  /// No description provided for @grofastConfirmNewPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm New Password'**
  String get grofastConfirmNewPasswordLabel;

  /// No description provided for @grofastConfirmNewPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Re-enter your new password'**
  String get grofastConfirmNewPasswordHint;

  /// No description provided for @grofastUpdatePasswordButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'Update Password'**
  String get grofastUpdatePasswordButtonLabel;

  /// No description provided for @grofastPasswordUpdatedMessage.
  ///
  /// In en, this message translates to:
  /// **'Your password has been updated.'**
  String get grofastPasswordUpdatedMessage;

  /// No description provided for @grofastWishlistTitle.
  ///
  /// In en, this message translates to:
  /// **'Wishlist'**
  String get grofastWishlistTitle;

  /// No description provided for @grofastWishlistEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Nothing saved yet'**
  String get grofastWishlistEmptyTitle;

  /// No description provided for @grofastWishlistEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Tap the heart on anything you want to keep for later.'**
  String get grofastWishlistEmptySubtitle;

  /// No description provided for @grofastWishlistExploreAction.
  ///
  /// In en, this message translates to:
  /// **'Start shopping'**
  String get grofastWishlistExploreAction;

  /// No description provided for @grofastNotificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Notification'**
  String get grofastNotificationsTitle;

  /// No description provided for @grofastNotificationsFilterAllLabel.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get grofastNotificationsFilterAllLabel;

  /// No description provided for @grofastNotificationsSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search your Notification'**
  String get grofastNotificationsSearchHint;

  /// No description provided for @grofastNotificationsNowTitle.
  ///
  /// In en, this message translates to:
  /// **'Now'**
  String get grofastNotificationsNowTitle;

  /// No description provided for @grofastNotificationsPastTitle.
  ///
  /// In en, this message translates to:
  /// **'Past'**
  String get grofastNotificationsPastTitle;

  /// No description provided for @grofastNotificationsLoadErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load your notifications.'**
  String get grofastNotificationsLoadErrorMessage;

  /// No description provided for @grofastNotificationsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No notifications yet'**
  String get grofastNotificationsEmptyTitle;

  /// No description provided for @grofastNotificationsEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'We\'ll let you know when something happens with your orders.'**
  String get grofastNotificationsEmptySubtitle;

  /// No description provided for @grofastNotificationsNoResultsTitle.
  ///
  /// In en, this message translates to:
  /// **'Nothing here'**
  String get grofastNotificationsNoResultsTitle;

  /// No description provided for @grofastNotificationsNoResultsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'No notification matches \"{query}\".'**
  String grofastNotificationsNoResultsSubtitle(String query);

  /// No description provided for @grofastSelectAddressTitle.
  ///
  /// In en, this message translates to:
  /// **'Select Location'**
  String get grofastSelectAddressTitle;

  /// No description provided for @grofastAddNewAddressLabel.
  ///
  /// In en, this message translates to:
  /// **'Add New Address'**
  String get grofastAddNewAddressLabel;

  /// No description provided for @grofastAddressLoadErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load your addresses.'**
  String get grofastAddressLoadErrorMessage;

  /// No description provided for @grofastAddressEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No saved addresses'**
  String get grofastAddressEmptyTitle;

  /// No description provided for @grofastAddressEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add one so we know where to bring your groceries.'**
  String get grofastAddressEmptySubtitle;

  /// No description provided for @grofastAddressSaveFailedMessage.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t save that address.'**
  String get grofastAddressSaveFailedMessage;

  /// No description provided for @grofastAddressDeleteFailedMessage.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t delete that address.'**
  String get grofastAddressDeleteFailedMessage;

  /// No description provided for @grofastEditAddressTooltip.
  ///
  /// In en, this message translates to:
  /// **'Edit address'**
  String get grofastEditAddressTooltip;

  /// No description provided for @grofastDeleteAddressTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete this address?'**
  String get grofastDeleteAddressTitle;

  /// No description provided for @grofastDeleteAddressMessage.
  ///
  /// In en, this message translates to:
  /// **'It will be removed from your saved locations. This can\'t be undone.'**
  String get grofastDeleteAddressMessage;

  /// No description provided for @grofastDeleteLabel.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get grofastDeleteLabel;

  /// No description provided for @grofastCancelLabel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get grofastCancelLabel;

  /// No description provided for @grofastAddAddressTitle.
  ///
  /// In en, this message translates to:
  /// **'Add New Address'**
  String get grofastAddAddressTitle;

  /// No description provided for @grofastEditAddressTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Address'**
  String get grofastEditAddressTitle;

  /// No description provided for @grofastAddressNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get grofastAddressNameLabel;

  /// No description provided for @grofastAddressNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Yona Angela'**
  String get grofastAddressNameHint;

  /// No description provided for @grofastAddressLine1Label.
  ///
  /// In en, this message translates to:
  /// **'Address Line 1'**
  String get grofastAddressLine1Label;

  /// No description provided for @grofastAddressLine1Hint.
  ///
  /// In en, this message translates to:
  /// **'House no., street name'**
  String get grofastAddressLine1Hint;

  /// No description provided for @grofastAddressLine2Label.
  ///
  /// In en, this message translates to:
  /// **'Address Line 2'**
  String get grofastAddressLine2Label;

  /// No description provided for @grofastAddressLine2Hint.
  ///
  /// In en, this message translates to:
  /// **'Apartment, suite, etc. (optional)'**
  String get grofastAddressLine2Hint;

  /// No description provided for @grofastLandmarkLabel.
  ///
  /// In en, this message translates to:
  /// **'Landmark'**
  String get grofastLandmarkLabel;

  /// No description provided for @grofastLandmarkHint.
  ///
  /// In en, this message translates to:
  /// **'Nearby landmark (optional)'**
  String get grofastLandmarkHint;

  /// No description provided for @grofastCityLabel.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get grofastCityLabel;

  /// No description provided for @grofastCityHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Bengaluru'**
  String get grofastCityHint;

  /// No description provided for @grofastStateLabel.
  ///
  /// In en, this message translates to:
  /// **'State'**
  String get grofastStateLabel;

  /// No description provided for @grofastStateHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Karnataka (optional)'**
  String get grofastStateHint;

  /// No description provided for @grofastCountryLabel.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get grofastCountryLabel;

  /// No description provided for @grofastSelectCountryTitle.
  ///
  /// In en, this message translates to:
  /// **'Select Country'**
  String get grofastSelectCountryTitle;

  /// No description provided for @grofastPostalCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'Postal Code'**
  String get grofastPostalCodeLabel;

  /// No description provided for @grofastPostalCodeHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 62639'**
  String get grofastPostalCodeHint;

  /// No description provided for @grofastAddressTagLabel.
  ///
  /// In en, this message translates to:
  /// **'Tag'**
  String get grofastAddressTagLabel;

  /// No description provided for @grofastAddressTagHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Home, Office'**
  String get grofastAddressTagHint;

  /// No description provided for @grofastMobileLabel.
  ///
  /// In en, this message translates to:
  /// **'Mobile Number'**
  String get grofastMobileLabel;

  /// No description provided for @grofastMobileHint.
  ///
  /// In en, this message translates to:
  /// **'Where we can reach you'**
  String get grofastMobileHint;

  /// No description provided for @grofastAddAddressButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'Add Address'**
  String get grofastAddAddressButtonLabel;

  /// No description provided for @grofastUpdateAddressButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'Update Address'**
  String get grofastUpdateAddressButtonLabel;

  /// No description provided for @grofastRequiredFieldErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get grofastRequiredFieldErrorMessage;

  /// No description provided for @grofastMyOrdersTitle.
  ///
  /// In en, this message translates to:
  /// **'My Orders'**
  String get grofastMyOrdersTitle;

  /// No description provided for @grofastOrdersSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search your orders'**
  String get grofastOrdersSearchHint;

  /// No description provided for @grofastOrdersFilterAllLabel.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get grofastOrdersFilterAllLabel;

  /// No description provided for @grofastOrdersFilterActiveLabel.
  ///
  /// In en, this message translates to:
  /// **'On Delivery'**
  String get grofastOrdersFilterActiveLabel;

  /// No description provided for @grofastOrdersFilterCompletedLabel.
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get grofastOrdersFilterCompletedLabel;

  /// No description provided for @grofastOrdersFilterCancelledLabel.
  ///
  /// In en, this message translates to:
  /// **'Canceled'**
  String get grofastOrdersFilterCancelledLabel;

  /// No description provided for @grofastOrdersDateFilterTitle.
  ///
  /// In en, this message translates to:
  /// **'Filter by date'**
  String get grofastOrdersDateFilterTitle;

  /// No description provided for @grofastOrdersDateRangeLabel.
  ///
  /// In en, this message translates to:
  /// **'Date Range'**
  String get grofastOrdersDateRangeLabel;

  /// No description provided for @grofastOrdersAllTimeLabel.
  ///
  /// In en, this message translates to:
  /// **'All time'**
  String get grofastOrdersAllTimeLabel;

  /// No description provided for @grofastOrdersFilterLastWeekLabel.
  ///
  /// In en, this message translates to:
  /// **'Last week'**
  String get grofastOrdersFilterLastWeekLabel;

  /// No description provided for @grofastOrdersFilterLastMonthLabel.
  ///
  /// In en, this message translates to:
  /// **'Last month'**
  String get grofastOrdersFilterLastMonthLabel;

  /// No description provided for @grofastOrdersLoadErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load your orders.'**
  String get grofastOrdersLoadErrorMessage;

  /// No description provided for @grofastOrdersRefreshFailedMessage.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t refresh your orders.'**
  String get grofastOrdersRefreshFailedMessage;

  /// No description provided for @grofastOrdersEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No orders yet'**
  String get grofastOrdersEmptyTitle;

  /// No description provided for @grofastOrdersEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your orders will show up here once you place one.'**
  String get grofastOrdersEmptySubtitle;

  /// No description provided for @grofastOrdersNoResultsTitle.
  ///
  /// In en, this message translates to:
  /// **'Nothing here'**
  String get grofastOrdersNoResultsTitle;

  /// No description provided for @grofastOrdersNoResultsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'No order matches those filters. Try widening them.'**
  String get grofastOrdersNoResultsSubtitle;

  /// No description provided for @grofastOrderNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Order {date}'**
  String grofastOrderNumberLabel(String date);

  /// No description provided for @grofastOrderItemCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{{count} item} other{{count} items}}'**
  String grofastOrderItemCount(int count);

  /// No description provided for @grofastOrderDeliveredLine.
  ///
  /// In en, this message translates to:
  /// **'Delivered to {label}'**
  String grofastOrderDeliveredLine(String label);

  /// No description provided for @grofastOrderDeliveringLine.
  ///
  /// In en, this message translates to:
  /// **'Delivering to {label}'**
  String grofastOrderDeliveringLine(String label);

  /// No description provided for @grofastOrderCancelledLine.
  ///
  /// In en, this message translates to:
  /// **'This order was cancelled'**
  String get grofastOrderCancelledLine;

  /// No description provided for @grofastTrackOrderTitle.
  ///
  /// In en, this message translates to:
  /// **'Track Order'**
  String get grofastTrackOrderTitle;

  /// No description provided for @grofastOrderDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Order Detail'**
  String get grofastOrderDetailTitle;

  /// No description provided for @grofastCopyTooltip.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get grofastCopyTooltip;

  /// No description provided for @grofastCopiedMessage.
  ///
  /// In en, this message translates to:
  /// **'{label} copied.'**
  String grofastCopiedMessage(String label);

  /// No description provided for @grofastTrackingDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Tracking Detail'**
  String get grofastTrackingDetailTitle;

  /// No description provided for @grofastOrderStatusLabel.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get grofastOrderStatusLabel;

  /// No description provided for @grofastPurchaseDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Purchase Date'**
  String get grofastPurchaseDateLabel;

  /// No description provided for @grofastOrderIdLabel.
  ///
  /// In en, this message translates to:
  /// **'Order ID'**
  String get grofastOrderIdLabel;

  /// No description provided for @grofastDeliveryOtpLabel.
  ///
  /// In en, this message translates to:
  /// **'Delivery OTP'**
  String get grofastDeliveryOtpLabel;

  /// No description provided for @grofastPaymentIdLabel.
  ///
  /// In en, this message translates to:
  /// **'Payment ID'**
  String get grofastPaymentIdLabel;

  /// No description provided for @grofastAmountPaidLabel.
  ///
  /// In en, this message translates to:
  /// **'Amount Paid'**
  String get grofastAmountPaidLabel;

  /// No description provided for @grofastNoOnlinePaymentLabel.
  ///
  /// In en, this message translates to:
  /// **'Not paid online'**
  String get grofastNoOnlinePaymentLabel;

  /// No description provided for @grofastRefundLabel.
  ///
  /// In en, this message translates to:
  /// **'Refund'**
  String get grofastRefundLabel;

  /// No description provided for @grofastOrderReceivedLabel.
  ///
  /// In en, this message translates to:
  /// **'Order Received'**
  String get grofastOrderReceivedLabel;

  /// No description provided for @grofastCancelOrderLabel.
  ///
  /// In en, this message translates to:
  /// **'Cancel Order'**
  String get grofastCancelOrderLabel;

  /// No description provided for @grofastCancelOrderTitle.
  ///
  /// In en, this message translates to:
  /// **'Cancel this order?'**
  String get grofastCancelOrderTitle;

  /// No description provided for @grofastCancelOrderMessage.
  ///
  /// In en, this message translates to:
  /// **'We\'ll refund anything you paid. This can\'t be undone.'**
  String get grofastCancelOrderMessage;

  /// No description provided for @grofastCancelOrderConfirmLabel.
  ///
  /// In en, this message translates to:
  /// **'Cancel Order'**
  String get grofastCancelOrderConfirmLabel;

  /// No description provided for @grofastOrderCancelFailedMessage.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t cancel that order.'**
  String get grofastOrderCancelFailedMessage;

  /// No description provided for @grofastOrderStepUndatedLabel.
  ///
  /// In en, this message translates to:
  /// **'Time not recorded'**
  String get grofastOrderStepUndatedLabel;

  /// No description provided for @grofastOrderStepPendingLabel.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get grofastOrderStepPendingLabel;

  /// No description provided for @grofastStatusPlacedLabel.
  ///
  /// In en, this message translates to:
  /// **'Order Placed'**
  String get grofastStatusPlacedLabel;

  /// No description provided for @grofastStatusOnDeliveryLabel.
  ///
  /// In en, this message translates to:
  /// **'On Delivery'**
  String get grofastStatusOnDeliveryLabel;

  /// No description provided for @grofastStatusDeliveredLabel.
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get grofastStatusDeliveredLabel;

  /// No description provided for @grofastStatusCancelledLabel.
  ///
  /// In en, this message translates to:
  /// **'Canceled'**
  String get grofastStatusCancelledLabel;

  /// No description provided for @grofastRefundPendingLabel.
  ///
  /// In en, this message translates to:
  /// **'Refund on its way'**
  String get grofastRefundPendingLabel;

  /// No description provided for @grofastRefundProcessedLabel.
  ///
  /// In en, this message translates to:
  /// **'Refunded'**
  String get grofastRefundProcessedLabel;

  /// No description provided for @grofastRefundFailedLabel.
  ///
  /// In en, this message translates to:
  /// **'Refund failed'**
  String get grofastRefundFailedLabel;

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
      <String>['de', 'en', 'fr', 'hi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
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
