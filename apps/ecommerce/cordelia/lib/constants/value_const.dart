import 'package:core/core/extensions/num_extensions.dart';

import 'package:cordelia/l10n/l10n.dart';

/// App-level copy shared across storefront templates.
///
/// Two tiers since gravia went bilingual: strings a storefront can render
/// (auth pushed over a store, legal, reviews, sort/price filters, payment,
/// account deletion) are getters over [L10n.current] so the store's language
/// applies; strings only ever shown in CordeliaApps' own chrome (splash,
/// onboarding, discovery) stay `const` — the locale is always the app
/// default (English) outside a storefront visit.
abstract final class ValueConst {
  static const appTitle = 'CordeliaApps';

  // ── Splash wordmark — the leading 'C' is the brand icon SVG (see
  // SplashPage), not literal text; this is everything after it.
  static const splashWordmarkText = 'ordelia Apps';

  // ── Onboarding (3-slide first-launch carousel) ────────────────────────────
  static const onboardingTitle1 = 'Discover Stores You\'ll Love';
  static const onboardingSubtitle1 =
      'Browse and shop from a growing collection of stores, all in one app.';
  static const onboardingTitle2 = 'One Login, Every Store';
  static const onboardingSubtitle2 =
      'Sign in once and shop across every store on CordeliaApps.';
  static const onboardingTitle3 = 'Fast, Simple, All in One Place';
  static const onboardingSubtitle3 =
      'Find what you need and check out in just a few taps.';
  static const onboardingNext = 'Next';
  static const onboardingGetStarted = 'Get Started';

  // ── Auth: Login ─────────────────────────────────────────────────────────
  static String get loginTitle => L10n.current.loginTitle;
  static String get loginSubtitle => L10n.current.loginSubtitle;
  static String get emailLabel => L10n.current.emailLabel;
  static String get emailHint => L10n.current.emailHint;
  static String get passwordLabel => L10n.current.passwordLabel;
  static String get passwordHint => L10n.current.passwordHint;
  static String get forgotPasswordLabel => L10n.current.forgotPasswordLabel;

  /// Firebase owns the rest of the reset flow — this confirms the email
  /// left our side, nothing more.
  static String passwordResetEmailSentMessage(String email) =>
      L10n.current.passwordResetEmailSentMessage(email);
  static String get continueLabel => L10n.current.continueLabel;
  static String get orLoginWith => L10n.current.orLoginWith;
  static String get continueWithGoogle => L10n.current.continueWithGoogle;
  static String get continueWithApple => L10n.current.continueWithApple;
  static String get byContinuingAgree => L10n.current.byContinuingAgree;
  static String get termsOfServiceAndPrivacyPolicy =>
      L10n.current.termsOfServiceAndPrivacyPolicy;
  static String get dontHaveAccount => L10n.current.dontHaveAccount;
  static String get signupLink => L10n.current.signupLink;

  // ── Auth: Signup ────────────────────────────────────────────────────────
  static String get signupTitle => L10n.current.signupTitle;
  static String get signupSubtitle => L10n.current.signupSubtitle;
  static String get nameLabel => L10n.current.nameLabel;
  static String get nameHint => L10n.current.nameHint;
  static String get mobileLabel => L10n.current.mobileLabel;
  static String get mobileHint => L10n.current.mobileHint;
  static String get iAgreeLabel => L10n.current.iAgreeLabel;
  static String get termsAndConditionsLink =>
      L10n.current.termsAndConditionsLink;
  static String get mustAgreeToTermsMessage =>
      L10n.current.mustAgreeToTermsMessage;

  // Field-validation messages live in LocalizedValidations (lib/utils/),
  // which overrides core's TextfieldValidations with arb-backed copy.
  static String get authWebUnsupportedMessage =>
      L10n.current.authWebUnsupportedMessage;
  static String get sessionExpiredMessage =>
      L10n.current.sessionExpiredMessage;
  static String get signupButtonLabel => L10n.current.signupButtonLabel;
  static String get alreadyHaveAccount => L10n.current.alreadyHaveAccount;
  static String get loginLink => L10n.current.loginLink;
  static String get comingSoonMessage => L10n.current.comingSoonMessage;

  // ── Payment ────────────────────────────────────────────────────────────
  // App-level, not per-template: the payment gateway sits below the template
  // split (one shared data source serves every storefront), so this copy
  // can't live in a pack's constants without that pack's wording leaking
  // into the others' checkouts.
  static String get paymentCancelledMessage =>
      L10n.current.paymentCancelledMessage;
  static String get paymentFailedMessage => L10n.current.paymentFailedMessage;

  // ── Auth: verify-email sheet ───────────────────────────────────────────
  static String get verifyEmailTitle => L10n.current.verifyEmailTitle;
  static String verifyEmailSubtitle(String email) =>
      L10n.current.verifyEmailSubtitle(email);
  static String get verifyEmailChecking => L10n.current.verifyEmailChecking;
  static String get resendEmailLabel => L10n.current.resendEmailLabel;

  // ── Legal (Terms & Conditions / Privacy Policy) ────────────────────────────
  // T&C body is still placeholder copy (needs a real content pass); the
  // privacy sections are real and translated.
  static String get termsAndConditionsLabel =>
      L10n.current.termsAndConditionsLabel;
  static String get privacyPolicyLabel => L10n.current.privacyPolicyLabel;
  static String get legalLastUpdatedLabel =>
      L10n.current.legalLastUpdatedLabel;
  static String get termsAndConditionsIntro =>
      L10n.current.termsAndConditionsIntro;
  static String get termsAndConditionsHeading =>
      L10n.current.termsAndConditionsHeading;
  static String get termsAndConditionsBody =>
      L10n.current.termsAndConditionsBody;
  static String get privacyPolicyIntro => L10n.current.privacyPolicyIntro;
  static String get privacyPolicySection1Heading =>
      L10n.current.privacyPolicySection1Heading;
  static String get privacyPolicySection1Body =>
      L10n.current.privacyPolicySection1Body;
  static String get privacyPolicySection2Heading =>
      L10n.current.privacyPolicySection2Heading;
  static String get privacyPolicySection2Body =>
      L10n.current.privacyPolicySection2Body;
  static String get privacyPolicySection3Heading =>
      L10n.current.privacyPolicySection3Heading;
  static String get privacyPolicySection3Body =>
      L10n.current.privacyPolicySection3Body;
  static String get privacyPolicySection4Heading =>
      L10n.current.privacyPolicySection4Heading;
  static String get privacyPolicySection4Body =>
      L10n.current.privacyPolicySection4Body;

  // ── Store discovery (feature/home) — app chrome, English-only ──────────
  static const discoveryTitle = 'Find your store';
  static const discoverySearchHint = 'Search stores';
  static const discoveryEmptyTitle = 'No stores found';
  static const discoveryEmptySubtitle =
      'Try a different search, or check back soon as more stores join.';

  // ── Profile ────────────────────────────────────────────────────────────────
  static String get profilePageTitle => L10n.current.profilePageTitle;
  static String get changePasswordLabel => L10n.current.changePasswordLabel;
  static String get myOrdersLabel => L10n.current.myOrdersLabel;
  static String get myAddressLabel => L10n.current.myAddressLabel;
  static String get darkModeLabel => L10n.current.darkModeLabel;
  static String get logoutLabel => L10n.current.logoutLabel;
  static String get logoutTitle => L10n.current.logoutTitle;
  static String get logoutConfirmMessage => L10n.current.logoutConfirmMessage;
  // ── Account deletion — app-level, not per-pack: one shared auth stack
  // serves every storefront, and both app stores require an in-app way to
  // close an account (App Store Review Guideline 5.1.1(v)).
  static String get deleteAccountLabel => L10n.current.deleteAccountLabel;
  static String get deleteAccountTitle => L10n.current.deleteAccountTitle;
  static String get deleteAccountConfirmMessage =>
      L10n.current.deleteAccountConfirmMessage;
  static String get deleteAccountFailedMessage =>
      L10n.current.deleteAccountFailedMessage;

  static String get profileLoadErrorMessage =>
      L10n.current.profileLoadErrorMessage;

  // ── Language row (every pack's Profile) — app-level: the row names the
  // same mechanism everywhere, and the option labels are self-named
  // (English stays "English" in Hindi and vice versa).
  static String get languageLabel => L10n.current.languageSheetTitle;
  static String get languageEnglish => L10n.current.languageEnglish;
  static String get languageHindi => L10n.current.languageHindi;
  static String get languageGerman => L10n.current.languageGerman;
  static String get languageFrench => L10n.current.languageFrench;
  static String get languageSpanish => L10n.current.languageSpanish;
  static String get languageItalian => L10n.current.languageItalian;

  /// Unit suffix for a countable pack ("3 pcs" / "3 Stk.") — see
  /// `ProductUnitType.format`.
  static String unitPiecesLabel(int count) =>
      L10n.current.unitPiecesLabel(count);

  // ── Category Details filters — app-wide, not per-pack: both templates run
  // the same sort model, so the option wording is shared (each pack still
  // titles its own sheet).
  static String get sortRelevanceLabel => L10n.current.sortRelevanceLabel;
  static String get sortPriceLowToHighLabel =>
      L10n.current.sortPriceLowToHighLabel;
  static String get sortPriceHighToLowLabel =>
      L10n.current.sortPriceHighToLowLabel;
  static String get sortRatingHighToLowLabel =>
      L10n.current.sortRatingHighToLowLabel;
  static String get sortDiscountHighToLowLabel =>
      L10n.current.sortDiscountHighToLowLabel;
  static String get priceFilterAllLabel => L10n.current.priceFilterAllLabel;
  // The band edges are passed in already formatted (`asPrice`), so the glyph
  // and separators follow the store's currency and the shopper's locale — the
  // copy owns only the wording around them.
  static String priceFilterUnderLabel(String price) =>
      L10n.current.priceFilterUnderLabel(price);
  static String priceFilterOverLabel(String price) =>
      L10n.current.priceFilterOverLabel(price);
  static String priceFilterRangeLabel(String from, String to) =>
      L10n.current.priceFilterRangeLabel(from, to);

  /// Both operands arrive already locale-formatted (core's `DateTimePartsX`);
  /// this key carries only the connector between them.
  static String orderPlacedAtLabel(String date, String time) =>
      L10n.current.orderPlacedAtLabel(date, time);

  // ── Product reviews — app-level, not per-pack: one shared reviews feature
  // serves every storefront, and the wording describes the *mechanism*
  // (ratings, verified purchases, one review per shopper) rather than any
  // pack's voice. Each template still supplies its own section/sheet titles.
  static String get reviewsSectionTitle => L10n.current.reviewsSectionTitle;
  static String get writeReviewLabel => L10n.current.writeReviewLabel;
  static String get editReviewLabel => L10n.current.editReviewLabel;
  static String get deleteReviewLabel => L10n.current.deleteReviewLabel;
  static String get reviewSheetTitle => L10n.current.reviewSheetTitle;
  static String get reviewRatingPrompt => L10n.current.reviewRatingPrompt;
  static String get reviewTextLabel => L10n.current.reviewTextLabel;
  static String get reviewTextHint => L10n.current.reviewTextHint;
  static String get reviewSubmitLabel => L10n.current.reviewSubmitLabel;
  static String get reviewMissingRatingMessage =>
      L10n.current.reviewMissingRatingMessage;
  static String get reviewDeleteConfirmTitle =>
      L10n.current.reviewDeleteConfirmTitle;
  static String get reviewDeleteConfirmMessage =>
      L10n.current.reviewDeleteConfirmMessage;
  static String get reviewSignedOutMessage =>
      L10n.current.reviewSignedOutMessage;
  static String get verifiedPurchaseLabel =>
      L10n.current.verifiedPurchaseLabel;
  static String get reviewsEmptyTitle => L10n.current.reviewsEmptyTitle;
  static String get reviewsEmptySubtitle => L10n.current.reviewsEmptySubtitle;
  static String get unratedLabel => L10n.current.unratedLabel;

  // ── Order rating — the shopper's verdict on a *delivery*, not on a
  // product. App-level for the same reason product-review copy is: one
  // shared orders stack serves every storefront.
  static String get rateOrderLabel => L10n.current.rateOrderLabel;
  static String get editOrderRatingLabel => L10n.current.editOrderRatingLabel;
  static String get rateOrderSheetTitle => L10n.current.rateOrderSheetTitle;
  static String get rateOrderTextLabel => L10n.current.rateOrderTextLabel;
  static String get rateOrderTextHint => L10n.current.rateOrderTextHint;
  static String get orderRatingNotDeliveredMessage =>
      L10n.current.orderRatingNotDeliveredMessage;
  static String get orderRatingFailedMessage =>
      L10n.current.orderRatingFailedMessage;
  static String get yourRatingLabel => L10n.current.yourRatingLabel;

  /// "4.6 (128)" — the compact form a product card prints beside its stars.
  /// Wordless, so no arb key; the decimal mark still comes from the locale
  /// (`asDecimal`), which is a comma in the European languages.
  static String ratingLabel(double average, int count) =>
      '${average.asDecimal()} ($count)';

  /// "128 reviews" / "1 review".
  static String reviewCountLabel(int count) =>
      L10n.current.reviewCountLabel(count);

  /// The review's age, as a review list shows it ("2 days ago"). Coarse on
  /// purpose: the exact minute a review was written is never what a reader
  /// wants, and a date alone reads as stale for something posted an hour ago.
  static String reviewAgeLabel(DateTime posted, {DateTime? now}) {
    final elapsed = (now ?? DateTime.now()).difference(posted);
    if (elapsed.inMinutes < 1) return L10n.current.reviewAgeJustNow;
    if (elapsed.inHours < 1) {
      return L10n.current.reviewAgeMinutesAgo(elapsed.inMinutes);
    }
    if (elapsed.inDays < 1) {
      return L10n.current.reviewAgeHoursAgo(elapsed.inHours);
    }
    if (elapsed.inDays < 30) {
      return L10n.current.reviewAgeDaysAgo(elapsed.inDays);
    }
    final months = elapsed.inDays ~/ 30;
    if (months < 12) return L10n.current.reviewAgeMonthsAgo(months);
    final years = elapsed.inDays ~/ 365;
    return L10n.current.reviewAgeYearsAgo(years);
  }
}
