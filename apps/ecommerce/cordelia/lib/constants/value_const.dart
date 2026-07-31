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
  static const loginTitle = 'Welcome To CordeliaApps';
  static const loginSubtitle =
      'Log in to your account using email or social networks';
  static const emailLabel = 'Email Address';
  static const emailHint = 'you@example.com';
  static const passwordLabel = 'Password';
  static const passwordHint = 'Enter your password';
  static const forgotPasswordLabel = 'Forgot Password?';

  /// Firebase owns the rest of the reset flow — this confirms the email
  /// left our side, nothing more.
  static String passwordResetEmailSentMessage(String email) =>
      'Password reset link sent to $email';
  static const continueLabel = 'Continue';
  static const orLoginWith = 'Or Login with';
  static const continueWithGoogle = 'Continue with Google';
  static const continueWithApple = 'Continue with Apple';
  static const byContinuingAgree = 'By continuing, you agree to our';
  static const termsOfServiceAndPrivacyPolicy =
      'Terms of Service & Privacy Policy';
  static const dontHaveAccount = "Don't have an account? ";
  static const signupLink = 'Signup';

  // ── Auth: Signup ────────────────────────────────────────────────────────
  static const signupTitle = 'Sign Up Your Account';
  static const signupSubtitle = 'Enter your information below';
  static const nameLabel = 'Name';
  static const nameHint = 'e.g. Mark Shelby';
  static const mobileLabel = 'Mobile Number';
  static const mobileHint = '(303) 555-0105';
  static const iAgreeLabel = 'I Agree ';
  static const termsAndConditionsLink = 'Terms & Conditions';
  static const mustAgreeToTermsMessage =
      'Please agree to the Terms & Conditions to continue.';

  // Field-validation messages live in CoreConst (used by core's
  // TextfieldValidations mixin), not here.
  static const authWebUnsupportedMessage =
      'Sign-in is only available on mobile.';
  static const sessionExpiredMessage =
      'Your session has expired. Please sign in again.';
  static const signupButtonLabel = 'Signup';
  static const alreadyHaveAccount = 'Already have an account? ';
  static const loginLink = 'Login';
  static const comingSoonMessage = 'Coming soon';

  // ── Payment ────────────────────────────────────────────────────────────
  // App-level, not per-template: the payment gateway sits below the template
  // split (one shared data source serves every storefront), so this copy
  // can't live in a pack's constants without that pack's wording leaking
  // into the others' checkouts.
  static const paymentCancelledMessage = 'Payment cancelled';
  static const paymentFailedMessage =
      'Payment could not be completed. Please try again.';

  // ── Auth: verify-email sheet ───────────────────────────────────────────
  static const verifyEmailTitle = 'Verify Your Email';
  static String verifyEmailSubtitle(String email) =>
      "We've sent a verification link to $email. Open it, then come back "
      'here — this will update automatically.';
  static const verifyEmailChecking = 'Checking…';
  static const resendEmailLabel = 'Resend email';

  // ── Legal (Terms & Conditions / Privacy Policy) ────────────────────────────
  // Placeholder copy (matches gravia's own placeholder text) — needs a real
  // content pass before shipping, not yet written.
  static const termsAndConditionsLabel = 'Terms & Conditions';
  static const privacyPolicyLabel = 'Privacy Policy';
  static const legalLastUpdatedLabel = 'Last update: Mar 09, 2026';
  static const termsAndConditionsIntro =
      'Please read these terms of service, carefully before using our app '
      'operated by us.';
  static const termsAndConditionsHeading = 'Conditions of Uses';
  static const termsAndConditionsBody =
      'It is a long established fact that a reader will be distracted by the '
      'readable content of a page when looking at its layout. The point of '
      'using Lorem Ipsum is that it has a more-or-less normal distribution of '
      "letters, as opposed to using 'Content here, content here', making it "
      'look like readable English. Many desktop publishing packages and web '
      "page editors now use Lorem Ipsum as their default model text, and a "
      "search for 'lorem ipsum' will uncover many web sites still in their "
      'infancy. Various versions have evolved over the years, sometimes by '
      'accident, sometimes on purpose (injected humour and the like).';
  static const privacyPolicyIntro =
      'Please read these privacy policy, carefully before using our app '
      'operated by us.';
  // Real copy (not lorem) — the DailyMart kit's Privacy & Policy frame is a
  // run of numbered sections, so the document needs enough of them to read
  // as one; gravia renders the same list under its own header.
  static const privacyPolicySection1Heading = '1. Information Collection';
  static const privacyPolicySection1Body =
      'We collect essential information to enhance your experience. This '
      'includes details you provide directly, such as account data, as well '
      'as information gathered through usage analytics and cookies.';
  static const privacyPolicySection2Heading = '2. Information Usage';
  static const privacyPolicySection2Body =
      'The information collected is used to improve our services, provide '
      'personalized recommendations, and ensure a seamless experience. We do '
      'not share your data without your explicit consent.';
  static const privacyPolicySection3Heading = '3. Information Setting';
  static const privacyPolicySection3Body =
      'You have full control over your data. Manage your privacy '
      'preferences, update personal details, and customize your settings to '
      'match your needs.';
  static const privacyPolicySection4Heading = '4. Security Measures';
  static const privacyPolicySection4Body =
      "We prioritize your data's safety with advanced security protocols, "
      'encryption methods, and regular audits to protect against '
      'unauthorized access or breaches.';

  // ── Store discovery (feature/home) ─────────────────────────────────────
  static const discoveryTitle = 'Find your store';
  static const discoverySearchHint = 'Search stores';
  static const discoveryEmptyTitle = 'No stores found';
  static const discoveryEmptySubtitle =
      'Try a different search, or check back soon as more stores join.';

  // ── Profile ────────────────────────────────────────────────────────────────
  static const profilePageTitle = 'Profile';
  static const changePasswordLabel = 'Change Password';
  static const myOrdersLabel = 'My Orders';
  static const myAddressLabel = 'My Address';
  static const darkModeLabel = 'Dark Mode';
  static const logoutLabel = 'Logout';
  static const logoutTitle = 'Logout';
  static const logoutConfirmMessage = 'Are you sure you want to log out?';
  static const profileLoadErrorMessage =
      'Something went wrong loading your profile.';

  // ── Category Details filters — app-wide, not per-pack: both templates run
  // the same sort model, so the option wording is shared (each pack still
  // titles its own sheet).
  static const sortRelevanceLabel = 'Relevance';
  static const sortPriceLowToHighLabel = 'Price (Low to High)';
  static const sortPriceHighToLowLabel = 'Price (High to Low)';
  static const sortRatingHighToLowLabel = 'Rating (High to Low)';
  static const sortDiscountHighToLowLabel = 'Discount (High to Low)';
  static const priceFilterAllLabel = 'All Prices';
  static const priceFilterUnder5Label = 'Under \$5';
  static const priceFilter5To10Label = '\$5 - \$10';
  static const priceFilter10To20Label = '\$10 - \$20';
  static const priceFilterOver20Label = 'Over \$20';
}
