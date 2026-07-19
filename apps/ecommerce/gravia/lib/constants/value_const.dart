abstract final class ValueConst {
  static const appTitle = 'Gravia';

  // ── Splash wordmark (black type; the middle glyph is the brand SVG) ──────
  static const splashWordmarkLeft = 'GR';
  static const splashWordmarkRight = 'VIA';

  // ── Bottom navigation (kit tab set) ───────────────────────────────────────
  static const navHome = 'Home';
  static const navCategories = 'Categories';
  static const navFavourite = 'Favourite';
  static const navOrders = 'Orders';
  static const navProfile = 'Profile';

  // ── Onboarding (3-slide first-launch carousel) ────────────────────────────
  static const onboardingTitle1 =
      'Fresh Groceries Delivered Right to Your Doorstep';
  static const onboardingSubtitle1 =
      'Shop fresh fruits, vegetables, and daily essentials anytime.';
  static const onboardingTitle2 = 'Everything You Need in Just a Few Taps';
  static const onboardingSubtitle2 =
      'Browse categories, add to cart, and order in seconds.';
  static const onboardingTitle3 = 'Fast and Reliable Grocery Delivery';
  static const onboardingSubtitle3 =
      'Get your groceries delivered quickly and safely.';
  static const onboardingNext = 'Next';
  static const onboardingGetStarted = 'Get Started';

  // ── Home (storefront) ──────────────────────────────────────────────────────
  static const deliveryLocationLabel = 'Delivery Location';
  static const noLocationSelectedLabel = 'No Location selected';
  static const searchHint = 'Search';
  static const allCategoriesTitle = 'All Categories';
  static const popularItemsTitle = 'Popular Items';
  static const seeAll = 'See All';
  static const addToCart = 'Add To Cart';
  static const addToCartSheetTitle = 'Add to Cart';
  static const cancel = 'Cancel';
  static const comingSoonMessage = 'Coming soon';
  static const homeLoadErrorMessage =
      'Something went wrong loading the storefront.';
  static String addedToCartMessage(String productName, int quantity) =>
      quantity > 1
      ? '$quantity × $productName added to cart'
      : '$productName added to cart';

  // ── Product card (GraviaProductCard, shared across screens) ───────────────
  static String formattedPrice(double price) => '\$${price.toStringAsFixed(2)}';
  static String discountPercentLabel(double percentage) =>
      '${percentage.toStringAsFixed(0)}%';
  static String discountPercentOffLabel(double percentage) =>
      '${percentage.toStringAsFixed(0)}% OFF';

  // ── Search ─────────────────────────────────────────────────────────────────
  static const recentSearchTitle = 'Recent Search';
  static const searchLoadErrorMessage = 'Something went wrong loading search.';

  // ── Product Details ────────────────────────────────────────────────────────
  static const productDetailsTitle = 'Product Details';
  static const selectQtyLabel = 'Select QTY';
  static const keyInformationTitle = 'Key Information';
  static const readMore = 'Read More';
  static const readLess = 'Read Less';
  static const similarProductsTitle = 'Similar Products';
  static const productDetailsLoadErrorMessage =
      'Something went wrong loading this product.';
  static String addToCartWithPrice(double price) =>
      'Add to Cart (\$${price.toStringAsFixed(2)})';

  // ── Categories ─────────────────────────────────────────────────────────────
  static const categoriesPageTitle = 'Categories';
  static const categoriesLoadErrorMessage =
      'Something went wrong loading categories.';

  // ── Category Details ───────────────────────────────────────────────────────
  static const sortLabel = 'Sort';
  static const priceLabel = 'Price';
  static const sortBySheetTitle = 'Sort by';
  static const priceSheetTitle = 'Price';
  static const categoryDetailsEmptyMessage = 'No products match these filters.';

  // ── Select Address ─────────────────────────────────────────────────────────
  static const selectAddressTitle = 'Select Address';
  static const addNewAddressLabel = 'Add New Address';
  static const defaultAddressSectionTitle = 'Default Address';
  static const otherAddressSectionTitle = 'Other Address';
  static const editLabel = 'Edit';
  static const deleteLabel = 'Delete';
  static const addressLoadErrorMessage =
      'Something went wrong loading your addresses.';

  // ── Add/Edit Address ───────────────────────────────────────────────────────
  static const editAddressTitle = 'Edit Address';
  static const nameLabel = 'Name';
  static const nameHint = 'e.g. Mark Shelby';
  static const phoneNumberLabel = 'Phone Number';
  static const phoneNumberHint = 'e.g. (303) 555-0105';
  static const addressLine1Label = 'Address Line 1';
  static const addressLine1Hint = 'House no., street name';
  static const addressLine2Label = 'Address Line 2';
  static const addressLine2Hint = 'Apartment, suite, etc. (optional)';
  static const landmarkLabel = 'Landmark';
  static const landmarkHint = 'Nearby landmark (optional)';
  static const cityLabel = 'City';
  static const selectCityTitle = 'Select City';
  static const countryLabel = 'Country';
  static const selectCountryTitle = 'Select Country';
  static const postalCodeLabel = 'Postal Code';
  static const postalCodeHint = 'e.g. 62639';
  static const addressTagLabel = 'Tag';
  static const addressTagHint = 'e.g. Home, Office';
  static const addAddressButtonLabel = 'Add Address';
  static const updateAddressButtonLabel = 'Update Address';
  static const requiredFieldErrorMessage = 'This field is required';

  static const addressFormCities = <String>[
    'Richardson',
    'Allentown',
    'San Jose',
    'New York',
    'Los Angeles',
    'Chicago',
    'Houston',
  ];
  static const addressFormCountries = <String>[
    'United States',
    'Canada',
    'United Kingdom',
    'Australia',
    'India',
  ];

  // ── Profile ────────────────────────────────────────────────────────────────
  static const profilePageTitle = 'Profile';
  static const changePasswordLabel = 'Change Password';
  static const myOrdersLabel = 'My Orders';
  static const myAddressLabel = 'My Address';
  static const darkModeLabel = 'Dark Mode';
  static const privacyPolicyLabel = 'Privacy Policy';
  static const termsAndConditionsLabel = 'Terms & Conditions';
  static const logoutLabel = 'Logout';
  static const profileLoadErrorMessage =
      'Something went wrong loading your profile.';

  // ── Edit Profile ───────────────────────────────────────────────────────────
  static const editProfileTitle = 'Edit Profile';
  static const emailAddressLabel = 'Email Address';
  static const emailAddressHint = 'e.g. mark.shelby@example.com';
  static const mobileNumberLabel = 'Mobile Number';
  static const updateProfileButtonLabel = 'Update';
  static const changePhotoTitle = 'Change Photo';
  static const takePhotoLabel = 'Take Photo';
  static const chooseFromGalleryLabel = 'Choose from Gallery';
  static const avatarPickerMobileOnlyMessage =
      'Changing your photo is only available on mobile';

  // ── Cart ───────────────────────────────────────────────────────────────────
  static const myCartTitle = 'My Cart';
  static const beforeYouCheckoutTitle = 'Before you Checkout';
  static const couponCodeLabel = 'Coupon Code';
  static const applyLabel = 'Apply';
  static const itemTotalLabel = 'Item Total';
  static const discountLabel = 'Discount';
  static const deliveryLabel = 'Delivery';
  static const deliveryFreeLabel = 'FREE';
  static const grandTotalLabel = 'Grand Total';
  static const proceedToCheckoutLabel = 'Proceed to Checkout';
  static const cartEmptyTitle = 'Your cart is empty';
  static const cartEmptySubtitle = 'Add items to get started.';
  static const cartBarTitle = 'See more products';
  static const exploreLabel = 'Explore';
  static const checkoutLabel = 'Checkout';
  static String cartSummaryLabel(int itemCount, double total) =>
      '$itemCount item${itemCount > 1 ? 's' : ''} | \$${total.toStringAsFixed(2)}';

  // ── Order Placed (checkout confirmation sheet) ────────────────────────────
  static const orderPlacedTitle = 'Order Placed Successfully';
  static const orderPlacedSubtitle =
      'Thank you for your order you can track your delivery in the order section';
  static const trackYourOrderLabel = 'Track Your Order';

  // ── Orders ─────────────────────────────────────────────────────────────────
  static const ordersPageTitle = 'Orders';
  static const upcomingTabLabel = 'Upcoming';
  static const pastTabLabel = 'Past';
  static const inProcessStatusLabel = 'In Process';
  static const deliveredStatusLabel = 'Delivered';
  static const cancelledStatusLabel = 'Cancelled';
  static const deliveryOtpLabel = 'Delivery OTP';
  static const cancelOrderLabel = 'Cancel';
  static const trackOrderLabel = 'Track Order';
  static const viewDetailsLabel = 'View Details';
  static const writeReviewLabel = 'Write A Review';
  static String weightQuantityLabel(String weight, int quantity) =>
      '$weight × $quantity';
  static const ordersLoadErrorMessage =
      'Something went wrong loading your orders.';
  static const ordersEmptyTitle = 'No orders yet';
  static const ordersEmptySubtitle =
      'Your past and active orders will show up here.';
  static const filterSheetTitle = 'Filter';
  static const filterReasonHeading = 'Select a Reason';
  static const filterLastWeekLabel = 'Last Week';
  static const filterLastMonthLabel = 'Last Month';
  static const filterStatusLabel = 'Status';
  static const filterDateLabel = 'Date';
  static const filterAllStatusesLabel = 'All';
  static const applyFilterLabel = 'Apply Filter';
  static String filterDateRangeLabel(String from, String to) => '$from - $to';

  // ── Notifications ──────────────────────────────────────────────────────────
  static const notificationsTitle = 'Notifications';
  static const notificationsLoadErrorMessage =
      'Something went wrong loading your notifications.';
  static const notificationsEmptyTitle = 'No notifications yet';
  static const notificationsEmptySubtitle =
      'Updates about your orders and account will show up here.';

  // ── Legal (Terms & Conditions / Privacy Policy) ────────────────────────────
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

  // ── Placeholder tabs (removed as real screens land) ───────────────────────
  static const favouriteEmptyTitle = 'No favourites yet';
  static const favouriteEmptySubtitle =
      'Tap the heart on a product to keep it here.';

  // ── Auth: Login ─────────────────────────────────────────────────────────
  static const loginTitle = 'Welcome To Gravia';
  static const loginSubtitle =
      'Log in to your account using email or social networks';
  static const emailLabel = 'Email Address';
  static const emailHint = 'you@example.com';
  static const passwordLabel = 'Password';
  static const passwordHint = 'Enter your password';
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
  static const mobileLabel = 'Mobile Number';
  static const mobileHint = '(303) 555-0105';
  static const iAgreeLabel = 'I Agree ';
  static const termsAndConditionsLink = 'Terms & Conditions';
  static const weakPasswordErrorMessage =
      'Password must be at least 6 characters.';
  static const mustAgreeToTermsMessage =
      'Please agree to the Terms & Conditions to continue.';

  // ── Auth: field validation (TextfieldValidations) ──────────────────────
  static const nameRequiredErrorMessage = 'Please enter your name.';
  static const emailRequiredErrorMessage = 'Please enter your email address.';
  static const emailInvalidErrorMessage = 'Enter a valid email address.';
  static const mobileRequiredErrorMessage = 'Please enter your mobile number.';
  static const mobileInvalidErrorMessage = 'Enter a valid mobile number.';
  static const passwordRequiredErrorMessage = 'Please enter your password.';
  static const authWebUnsupportedMessage =
      'Sign-in is only available on mobile.';
  static const signupButtonLabel = 'Signup';
  static const alreadyHaveAccount = 'Already have an account? ';
  static const loginLink = 'Login';

  // ── Auth: verify-email sheet ───────────────────────────────────────────
  static const verifyEmailTitle = 'Verify Your Email';
  static String verifyEmailSubtitle(String email) =>
      "We've sent a verification link to $email. Open it, then come back "
      'here — this will update automatically.';
  static const verifyEmailChecking = 'Checking…';
  static const resendEmailLabel = 'Resend email';
  static const resendEmailSentMessage = 'Verification email sent again.';
}
