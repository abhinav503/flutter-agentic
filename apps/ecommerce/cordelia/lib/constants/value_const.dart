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
  static const privacyPolicyHeading = 'Privacy Policy';
  static const privacyPolicyBody =
      'There are many variations of passages of Lorem Ipsum available, but '
      'the majority have suffered alteration in some form, by injected '
      "humour, or randomised words which don't look even slightly "
      'believable.\n\n'
      'If you are going to use a passage of Lorem Ipsum, you need to be sure '
      "there isn't anything embarrassing hidden in the middle of text. All "
      'the Lorem Ipsum generators on the Internet tend to repeat predefined '
      'chunks as necessary, making this the first true generator on the '
      'Internet. It uses a dictionary of over 200 Latin words, combined with '
      'a handful of model sentence structures, to generate Lorem Ipsum which '
      'looks reasonable.\n\n'
      'The generated Lorem Ipsum is therefore always free from repetition, '
      'injected humour, or non-characteristic words etc.';

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
}
