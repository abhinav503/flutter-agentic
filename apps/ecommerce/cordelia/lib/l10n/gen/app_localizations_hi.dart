// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get languageSheetTitle => 'भाषा';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageHindi => 'हिन्दी';

  @override
  String get loginTitle => 'CordeliaApps में आपका स्वागत है';

  @override
  String get loginSubtitle =>
      'ईमेल या सोशल नेटवर्क से अपने खाते में लॉग इन करें';

  @override
  String get emailLabel => 'ईमेल पता';

  @override
  String get emailHint => 'you@example.com';

  @override
  String get passwordLabel => 'पासवर्ड';

  @override
  String get passwordHint => 'अपना पासवर्ड दर्ज करें';

  @override
  String get forgotPasswordLabel => 'पासवर्ड भूल गए?';

  @override
  String passwordResetEmailSentMessage(String email) {
    return 'पासवर्ड रीसेट लिंक $email पर भेज दिया गया है';
  }

  @override
  String get continueLabel => 'आगे बढ़ें';

  @override
  String get orLoginWith => 'या इससे लॉग इन करें';

  @override
  String get continueWithGoogle => 'Google से जारी रखें';

  @override
  String get continueWithApple => 'Apple से जारी रखें';

  @override
  String get byContinuingAgree => 'जारी रखने पर, आप सहमत होते हैं हमारी';

  @override
  String get termsOfServiceAndPrivacyPolicy =>
      'सेवा की शर्तें और गोपनीयता नीति';

  @override
  String get dontHaveAccount => 'खाता नहीं है? ';

  @override
  String get signupLink => 'साइन अप करें';

  @override
  String get signupTitle => 'अपना खाता बनाएँ';

  @override
  String get signupSubtitle => 'नीचे अपनी जानकारी दर्ज करें';

  @override
  String get nameLabel => 'नाम';

  @override
  String get nameHint => 'जैसे: राहुल शर्मा';

  @override
  String get mobileLabel => 'मोबाइल नंबर';

  @override
  String get mobileHint => '98765 43210';

  @override
  String get iAgreeLabel => 'मैं सहमत हूँ ';

  @override
  String get termsAndConditionsLink => 'नियम और शर्तें';

  @override
  String get mustAgreeToTermsMessage =>
      'आगे बढ़ने के लिए कृपया नियम और शर्तों से सहमति दें।';

  @override
  String get authWebUnsupportedMessage => 'साइन-इन केवल मोबाइल पर उपलब्ध है।';

  @override
  String get sessionExpiredMessage =>
      'आपका सत्र समाप्त हो गया है। कृपया दोबारा साइन इन करें।';

  @override
  String get signupButtonLabel => 'साइन अप करें';

  @override
  String get alreadyHaveAccount => 'पहले से खाता है? ';

  @override
  String get loginLink => 'लॉग इन करें';

  @override
  String get comingSoonMessage => 'जल्द आ रहा है';

  @override
  String get paymentCancelledMessage => 'भुगतान रद्द किया गया';

  @override
  String get paymentFailedMessage =>
      'भुगतान पूरा नहीं हो सका। कृपया दोबारा प्रयास करें।';

  @override
  String get verifyEmailTitle => 'अपना ईमेल सत्यापित करें';

  @override
  String verifyEmailSubtitle(String email) {
    return 'हमने $email पर एक सत्यापन लिंक भेजा है। उसे खोलें और फिर यहाँ वापस आएँ — यह अपने आप अपडेट हो जाएगा।';
  }

  @override
  String get verifyEmailChecking => 'जाँच हो रही है…';

  @override
  String get resendEmailLabel => 'ईमेल दोबारा भेजें';

  @override
  String get termsAndConditionsLabel => 'नियम और शर्तें';

  @override
  String get privacyPolicyLabel => 'गोपनीयता नीति';

  @override
  String get legalLastUpdatedLabel => 'अंतिम अपडेट: 09 मार्च 2026';

  @override
  String get termsAndConditionsIntro =>
      'हमारे द्वारा संचालित इस ऐप का उपयोग करने से पहले कृपया ये सेवा शर्तें ध्यान से पढ़ें।';

  @override
  String get termsAndConditionsHeading => 'उपयोग की शर्तें';

  @override
  String get termsAndConditionsBody =>
      'It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using \'Content here, content here\', making it look like readable English. Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a search for \'lorem ipsum\' will uncover many web sites still in their infancy. Various versions have evolved over the years, sometimes by accident, sometimes on purpose (injected humour and the like).';

  @override
  String get privacyPolicyIntro =>
      'हमारे द्वारा संचालित इस ऐप का उपयोग करने से पहले कृपया यह गोपनीयता नीति ध्यान से पढ़ें।';

  @override
  String get privacyPolicySection1Heading => '1. जानकारी का संग्रह';

  @override
  String get privacyPolicySection1Body =>
      'आपके अनुभव को बेहतर बनाने के लिए हम आवश्यक जानकारी एकत्र करते हैं। इसमें वह विवरण शामिल है जो आप सीधे देते हैं, जैसे खाता जानकारी, और उपयोग एनालिटिक्स व कुकीज़ से मिली जानकारी भी।';

  @override
  String get privacyPolicySection2Heading => '2. जानकारी का उपयोग';

  @override
  String get privacyPolicySection2Body =>
      'एकत्रित जानकारी का उपयोग हमारी सेवाओं को बेहतर बनाने, व्यक्तिगत सुझाव देने और एक सहज अनुभव सुनिश्चित करने के लिए किया जाता है। आपकी स्पष्ट सहमति के बिना हम आपका डेटा साझा नहीं करते।';

  @override
  String get privacyPolicySection3Heading => '3. जानकारी की सेटिंग';

  @override
  String get privacyPolicySection3Body =>
      'आपके डेटा पर पूरा नियंत्रण आपका है। अपनी गोपनीयता प्राथमिकताएँ प्रबंधित करें, व्यक्तिगत विवरण अपडेट करें और सेटिंग्स को अपनी ज़रूरत के अनुसार बदलें।';

  @override
  String get privacyPolicySection4Heading => '4. सुरक्षा उपाय';

  @override
  String get privacyPolicySection4Body =>
      'हम उन्नत सुरक्षा प्रोटोकॉल, एन्क्रिप्शन और नियमित ऑडिट के ज़रिए आपके डेटा की सुरक्षा को प्राथमिकता देते हैं, ताकि अनधिकृत पहुँच या सेंध से बचाव हो सके।';

  @override
  String get profilePageTitle => 'प्रोफ़ाइल';

  @override
  String get changePasswordLabel => 'पासवर्ड बदलें';

  @override
  String get myOrdersLabel => 'मेरे ऑर्डर';

  @override
  String get myAddressLabel => 'मेरे पते';

  @override
  String get darkModeLabel => 'डार्क मोड';

  @override
  String get logoutLabel => 'लॉग आउट';

  @override
  String get logoutTitle => 'लॉग आउट';

  @override
  String get logoutConfirmMessage => 'क्या आप वाकई लॉग आउट करना चाहते हैं?';

  @override
  String get deleteAccountLabel => 'खाता हटाएँ';

  @override
  String get deleteAccountTitle => 'अपना खाता हटाएँ?';

  @override
  String get deleteAccountConfirmMessage =>
      'इससे हर स्टोर पर आपकी प्रोफ़ाइल, पते, कार्ट, विशलिस्ट और समीक्षाएँ स्थायी रूप से हट जाएँगी। आपके पहले से दिए गए ऑर्डर उन स्टोर्स के बिक्री रिकॉर्ड के रूप में बने रहेंगे। इसे पूर्ववत नहीं किया जा सकता।';

  @override
  String get deleteAccountFailedMessage =>
      'आपका खाता नहीं हटाया जा सका। कृपया दोबारा प्रयास करें।';

  @override
  String get profileLoadErrorMessage =>
      'आपकी प्रोफ़ाइल लोड करते समय कुछ गड़बड़ हो गई।';

  @override
  String get sortRelevanceLabel => 'प्रासंगिकता';

  @override
  String get sortPriceLowToHighLabel => 'क़ीमत (कम से ज़्यादा)';

  @override
  String get sortPriceHighToLowLabel => 'क़ीमत (ज़्यादा से कम)';

  @override
  String get sortRatingHighToLowLabel => 'रेटिंग (ज़्यादा से कम)';

  @override
  String get sortDiscountHighToLowLabel => 'छूट (ज़्यादा से कम)';

  @override
  String get priceFilterAllLabel => 'सभी क़ीमतें';

  @override
  String get priceFilterUnder100Label => '₹100 से कम';

  @override
  String get priceFilter100To250Label => '₹100 - ₹250';

  @override
  String get priceFilter250To500Label => '₹250 - ₹500';

  @override
  String get priceFilterOver500Label => '₹500 से अधिक';

  @override
  String get reviewsSectionTitle => 'रेटिंग और समीक्षाएँ';

  @override
  String get writeReviewLabel => 'समीक्षा लिखें';

  @override
  String get editReviewLabel => 'अपनी समीक्षा संपादित करें';

  @override
  String get deleteReviewLabel => 'हटाएँ';

  @override
  String get reviewSheetTitle => 'इस उत्पाद को रेट करें';

  @override
  String get reviewRatingPrompt => 'कितने स्टार?';

  @override
  String get reviewTextLabel => 'आपकी समीक्षा';

  @override
  String get reviewTextHint => 'दूसरे ख़रीदारों को बताएँ कि आपको यह कैसा लगा…';

  @override
  String get reviewSubmitLabel => 'समीक्षा सबमिट करें';

  @override
  String get reviewMissingRatingMessage => 'पहले एक स्टार रेटिंग चुनें।';

  @override
  String get reviewDeleteConfirmTitle => 'अपनी समीक्षा हटाएँ?';

  @override
  String get reviewDeleteConfirmMessage =>
      'इससे आपकी रेटिंग उत्पाद के औसत से हट जाएगी। आप कभी भी नई समीक्षा लिख सकते हैं।';

  @override
  String get reviewSignedOutMessage =>
      'इस उत्पाद की समीक्षा करने के लिए साइन इन करें।';

  @override
  String get verifiedPurchaseLabel => 'सत्यापित ख़रीद';

  @override
  String get reviewsEmptyTitle => 'अभी कोई समीक्षा नहीं';

  @override
  String get reviewsEmptySubtitle =>
      'इस उत्पाद को रेट करने वाले पहले व्यक्ति बनें और दूसरे ख़रीदारों की मदद करें।';

  @override
  String get unratedLabel => 'अभी कोई रेटिंग नहीं';

  @override
  String get rateOrderLabel => 'ऑर्डर रेट करें';

  @override
  String get editOrderRatingLabel => 'रेटिंग बदलें';

  @override
  String get rateOrderSheetTitle => 'यह ऑर्डर कैसा रहा?';

  @override
  String get rateOrderTextLabel => 'आपकी प्रतिक्रिया';

  @override
  String get rateOrderTextHint => 'डिलीवरी कैसी रही?';

  @override
  String get orderRatingNotDeliveredMessage =>
      'ऑर्डर डिलीवर होने के बाद ही आप उसे रेट कर सकते हैं।';

  @override
  String get orderRatingFailedMessage =>
      'आपकी रेटिंग सेव नहीं हो सकी। कृपया दोबारा प्रयास करें।';

  @override
  String get yourRatingLabel => 'आपकी रेटिंग';

  @override
  String reviewCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count समीक्षाएँ',
      one: '$count समीक्षा',
    );
    return '$_temp0';
  }

  @override
  String get reviewAgeJustNow => 'अभी-अभी';

  @override
  String reviewAgeMinutesAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count मिनट पहले',
      one: '$count मिनट पहले',
    );
    return '$_temp0';
  }

  @override
  String reviewAgeHoursAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count घंटे पहले',
      one: '$count घंटा पहले',
    );
    return '$_temp0';
  }

  @override
  String reviewAgeDaysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count दिन पहले',
      one: '$count दिन पहले',
    );
    return '$_temp0';
  }

  @override
  String reviewAgeMonthsAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count महीने पहले',
      one: '$count महीना पहले',
    );
    return '$_temp0';
  }

  @override
  String reviewAgeYearsAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count साल पहले',
      one: '$count साल पहले',
    );
    return '$_temp0';
  }

  @override
  String get graviaCategoriesTitle => 'सभी श्रेणियाँ';

  @override
  String get graviaSeeAll => 'सभी देखें';

  @override
  String get graviaPopularItemsTitle => 'लोकप्रिय आइटम';

  @override
  String get graviaHomeLoadErrorMessage =>
      'इस स्टोर का कैटलॉग लोड नहीं हो सका।';

  @override
  String get graviaCancel => 'रद्द करें';

  @override
  String graviaDiscountPercentOff(String percent) {
    return '$percent% छूट';
  }

  @override
  String get graviaAddToCart => 'कार्ट में डालें';

  @override
  String get graviaAddToCartSheetTitle => 'कार्ट में डालें';

  @override
  String get graviaDeleteLabel => 'हटाएँ';

  @override
  String get graviaDeleteAddressTitle => 'पता हटाएँ';

  @override
  String get graviaDeleteAddressConfirmMessage =>
      'क्या आप वाकई यह पता हटाना चाहते हैं? इसे पूर्ववत नहीं किया जा सकता।';

  @override
  String get graviaClearCartTitle => 'कार्ट खाली करें';

  @override
  String get graviaClearCartConfirmMessage =>
      'क्या आप वाकई कार्ट से सभी आइटम हटाना चाहते हैं?';

  @override
  String get graviaClearCartConfirmLabel => 'कार्ट खाली करें';

  @override
  String get graviaOrderPlacedTitle => 'ऑर्डर सफलतापूर्वक हो गया';

  @override
  String get graviaOrderPlacedSubtitle =>
      'आपके ऑर्डर के लिए धन्यवाद — ऑर्डर सेक्शन में आप अपनी डिलीवरी ट्रैक कर सकते हैं';

  @override
  String get graviaTrackYourOrderLabel => 'अपना ऑर्डर ट्रैक करें';

  @override
  String get graviaSearchHint => 'खोजें';

  @override
  String get graviaNavHome => 'होम';

  @override
  String get graviaNavCategories => 'श्रेणियाँ';

  @override
  String get graviaNavFavourite => 'पसंदीदा';

  @override
  String get graviaNavOrders => 'ऑर्डर';

  @override
  String get graviaNavProfile => 'प्रोफ़ाइल';

  @override
  String get graviaRecentSearchTitle => 'हाल की खोजें';

  @override
  String get graviaSearchLoadErrorMessage =>
      'खोज लोड करते समय कुछ गड़बड़ हो गई।';

  @override
  String get graviaSearchResultsErrorMessage =>
      'खोज करते समय कुछ गड़बड़ हो गई।';

  @override
  String get graviaSearchCategoryBadge => 'श्रेणी';

  @override
  String get graviaSearchNoResultsTitle => 'कोई परिणाम नहीं मिला';

  @override
  String graviaSearchNoResultsSubtitle(String query) {
    return '\"$query\" से कुछ मेल नहीं खाता। कोई दूसरा शब्द आज़माएँ।';
  }

  @override
  String get graviaProductDetailsTitle => 'उत्पाद विवरण';

  @override
  String get graviaSelectQtyLabel => 'मात्रा चुनें';

  @override
  String get graviaKeyInformationTitle => 'मुख्य जानकारी';

  @override
  String get graviaReadMore => 'और पढ़ें';

  @override
  String get graviaReadLess => 'कम पढ़ें';

  @override
  String get graviaSimilarProductsTitle => 'मिलते-जुलते उत्पाद';

  @override
  String get graviaProductDetailsLoadErrorMessage =>
      'यह उत्पाद लोड करते समय कुछ गड़बड़ हो गई।';

  @override
  String graviaAddToCartWithPrice(String price) {
    return 'कार्ट में डालें ($price)';
  }

  @override
  String get graviaCategoriesPageTitle => 'श्रेणियाँ';

  @override
  String get graviaCategoriesLoadErrorMessage =>
      'श्रेणियाँ लोड करते समय कुछ गड़बड़ हो गई।';

  @override
  String get graviaCategoriesRefreshFailedMessage =>
      'रीफ़्रेश नहीं हो सका — आपकी पिछली लोड की गई श्रेणियाँ दिखाई जा रही हैं।';

  @override
  String get graviaSortLabel => 'क्रमबद्ध करें';

  @override
  String get graviaPriceLabel => 'क़ीमत';

  @override
  String get graviaSortBySheetTitle => 'इस क्रम में';

  @override
  String get graviaPriceSheetTitle => 'क़ीमत';

  @override
  String get graviaCategoryDetailsEmptyMessage =>
      'इन फ़िल्टरों से कोई उत्पाद मेल नहीं खाता।';

  @override
  String get graviaSelectAddressTitle => 'पता चुनें';

  @override
  String get graviaAddNewAddressLabel => 'नया पता जोड़ें';

  @override
  String get graviaDefaultAddressSectionTitle => 'डिफ़ॉल्ट पता';

  @override
  String get graviaOtherAddressSectionTitle => 'अन्य पते';

  @override
  String get graviaEditLabel => 'संपादित करें';

  @override
  String get graviaAddressLoadErrorMessage =>
      'आपके पते लोड करते समय कुछ गड़बड़ हो गई।';

  @override
  String get graviaAddressSaveFailedMessage =>
      'पता सेव नहीं हो सका। कृपया दोबारा प्रयास करें।';

  @override
  String get graviaAddressDeleteFailedMessage =>
      'पता हटाया नहीं जा सका। कृपया दोबारा प्रयास करें।';

  @override
  String get graviaAddressEmptyTitle => 'कोई सेव किया हुआ पता नहीं';

  @override
  String get graviaAddressEmptySubtitle =>
      'शुरू करने के लिए अपना पहला डिलीवरी पता जोड़ें।';

  @override
  String get graviaEditAddressTitle => 'पता संपादित करें';

  @override
  String get graviaNameLabel => 'नाम';

  @override
  String get graviaNameHint => 'जैसे: राहुल शर्मा';

  @override
  String get graviaPhoneNumberLabel => 'फ़ोन नंबर';

  @override
  String get graviaPhoneNumberHint => 'जैसे: 98765 43210';

  @override
  String get graviaAddressLine1Label => 'पता पंक्ति 1';

  @override
  String get graviaAddressLine1Hint => 'मकान नं., गली का नाम';

  @override
  String get graviaAddressLine2Label => 'पता पंक्ति 2';

  @override
  String get graviaAddressLine2Hint => 'अपार्टमेंट, सुइट आदि (वैकल्पिक)';

  @override
  String get graviaLandmarkLabel => 'लैंडमार्क';

  @override
  String get graviaLandmarkHint => 'पास का लैंडमार्क (वैकल्पिक)';

  @override
  String get graviaCityLabel => 'शहर';

  @override
  String get graviaCityHint => 'जैसे: नई दिल्ली';

  @override
  String get graviaStateLabel => 'राज्य';

  @override
  String get graviaStateHint => 'जैसे: दिल्ली (वैकल्पिक)';

  @override
  String get graviaCountryLabel => 'देश';

  @override
  String get graviaSelectCountryTitle => 'देश चुनें';

  @override
  String get graviaPostalCodeLabel => 'पिन कोड';

  @override
  String get graviaPostalCodeHint => 'जैसे: 110001';

  @override
  String get graviaAddressTagLabel => 'टैग';

  @override
  String get graviaAddressTagHint => 'जैसे: घर, ऑफ़िस';

  @override
  String get graviaAddAddressButtonLabel => 'पता जोड़ें';

  @override
  String get graviaUpdateAddressButtonLabel => 'पता अपडेट करें';

  @override
  String get graviaRequiredFieldErrorMessage => 'यह फ़ील्ड आवश्यक है';

  @override
  String get graviaUseMyLocationLabel => 'मेरा स्थान इस्तेमाल करें';

  @override
  String get graviaLocationUnavailableMessage =>
      'आपका स्थान प्राप्त नहीं हो सका। लोकेशन अनुमति जाँचें और दोबारा प्रयास करें।';

  @override
  String get graviaAddressSearchLabel => 'पता खोजें';

  @override
  String get graviaAddressSearchHint => 'क्षेत्र, गली, लैंडमार्क खोजें…';

  @override
  String get graviaProfilePageTitle => 'प्रोफ़ाइल';

  @override
  String get graviaChangePasswordLabel => 'पासवर्ड बदलें';

  @override
  String get graviaMyOrdersLabel => 'मेरे ऑर्डर';

  @override
  String get graviaMyAddressLabel => 'मेरे पते';

  @override
  String get graviaDarkModeLabel => 'डार्क मोड';

  @override
  String get graviaPrivacyPolicyLabel => 'गोपनीयता नीति';

  @override
  String get graviaTermsAndConditionsLabel => 'नियम और शर्तें';

  @override
  String get graviaLogoutLabel => 'लॉग आउट';

  @override
  String get graviaLogoutTitle => 'लॉग आउट';

  @override
  String get graviaLogoutConfirmMessage =>
      'क्या आप वाकई लॉग आउट करना चाहते हैं?';

  @override
  String get graviaProfileLoadErrorMessage =>
      'आपकी प्रोफ़ाइल लोड करते समय कुछ गड़बड़ हो गई।';

  @override
  String get graviaEditProfileTitle => 'प्रोफ़ाइल संपादित करें';

  @override
  String get graviaEmailAddressLabel => 'ईमेल पता';

  @override
  String get graviaEmailAddressHint => 'जैसे: rahul.sharma@example.com';

  @override
  String get graviaMobileNumberLabel => 'मोबाइल नंबर';

  @override
  String get graviaUpdateProfileButtonLabel => 'अपडेट करें';

  @override
  String get graviaChangePhotoTitle => 'फ़ोटो बदलें';

  @override
  String get graviaTakePhotoLabel => 'फ़ोटो लें';

  @override
  String get graviaChooseFromGalleryLabel => 'गैलरी से चुनें';

  @override
  String get graviaAvatarPickerMobileOnlyMessage =>
      'फ़ोटो बदलना केवल मोबाइल पर उपलब्ध है';

  @override
  String get graviaChangePasswordTitle => 'पासवर्ड बदलें';

  @override
  String get graviaCurrentPasswordLabel => 'वर्तमान पासवर्ड';

  @override
  String get graviaCurrentPasswordHint => 'अपना वर्तमान पासवर्ड दर्ज करें';

  @override
  String get graviaNewPasswordLabel => 'नया पासवर्ड';

  @override
  String get graviaNewPasswordHint => 'अपना नया पासवर्ड दर्ज करें';

  @override
  String get graviaConfirmNewPasswordLabel => 'नए पासवर्ड की पुष्टि करें';

  @override
  String get graviaConfirmNewPasswordHint =>
      'अपना नया पासवर्ड दोबारा दर्ज करें';

  @override
  String get graviaUpdatePasswordButtonLabel => 'पासवर्ड अपडेट करें';

  @override
  String get graviaPasswordUpdatedMessage =>
      'आपका पासवर्ड अपडेट कर दिया गया है।';

  @override
  String get graviaMyCartTitle => 'मेरा कार्ट';

  @override
  String get graviaBeforeYouCheckoutTitle => 'चेकआउट से पहले';

  @override
  String get graviaCouponCodeLabel => 'कूपन कोड';

  @override
  String get graviaApplyLabel => 'लागू करें';

  @override
  String get graviaCouponRemoveLabel => 'हटाएँ';

  @override
  String graviaCouponApplied(String code) {
    return '$code लागू हो गया';
  }

  @override
  String graviaCouponLine(String code) {
    return 'कूपन ($code)';
  }

  @override
  String get graviaItemTotalLabel => 'आइटम कुल';

  @override
  String get graviaDiscountLabel => 'छूट';

  @override
  String get graviaDeliveryLabel => 'डिलीवरी';

  @override
  String get graviaDeliveryFreeLabel => 'मुफ़्त';

  @override
  String get graviaGrandTotalLabel => 'कुल योग';

  @override
  String get graviaProceedToCheckoutLabel => 'चेकआउट करें';

  @override
  String get graviaCartEmptyTitle => 'आपका कार्ट खाली है';

  @override
  String get graviaCartEmptySubtitle => 'शुरू करने के लिए आइटम जोड़ें।';

  @override
  String get graviaCartBarTitle => 'और उत्पाद देखें';

  @override
  String get graviaExploreLabel => 'देखें';

  @override
  String get graviaCheckoutLabel => 'चेकआउट';

  @override
  String graviaCartSummary(int count, String total) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count आइटम',
      one: '$count आइटम',
    );
    return '$_temp0 | $total';
  }

  @override
  String get graviaOrdersPageTitle => 'ऑर्डर';

  @override
  String get graviaUpcomingTabLabel => 'आगामी';

  @override
  String get graviaPastTabLabel => 'पिछले';

  @override
  String get graviaPendingStatusLabel => 'ऑर्डर हो गया';

  @override
  String get graviaInProcessStatusLabel => 'रास्ते में है';

  @override
  String get graviaDeliveredStatusLabel => 'डिलीवर हो गया';

  @override
  String get graviaCancelledStatusLabel => 'रद्द किया गया';

  @override
  String get graviaDeliveryOtpLabel => 'डिलीवरी OTP';

  @override
  String get graviaCancelOrderLabel => 'रद्द करें';

  @override
  String get graviaTrackOrderLabel => 'ऑर्डर ट्रैक करें';

  @override
  String get graviaViewDetailsLabel => 'विवरण देखें';

  @override
  String get graviaWriteReviewLabel => 'समीक्षा लिखें';

  @override
  String get graviaRefundPendingLabel => 'रिफ़ंड प्रोसेस हो रहा है';

  @override
  String get graviaRefundProcessedLabel => 'रिफ़ंड हो गया';

  @override
  String get graviaRefundFailedLabel => 'रिफ़ंड विफल रहा';

  @override
  String get graviaCancelOrderConfirmTitle => 'यह ऑर्डर रद्द करें?';

  @override
  String get graviaCancelOrderConfirmBody =>
      'इससे आपका ऑर्डर रद्द हो जाएगा। यदि आपने भुगतान किया है, तो पूरी राशि रिफ़ंड कर दी जाएगी।';

  @override
  String get graviaCancelOrderConfirmCta => 'ऑर्डर रद्द करें';

  @override
  String get graviaCancelOrderDismissCta => 'ऑर्डर रखें';

  @override
  String get graviaCancelFailedMessage =>
      'ऑर्डर रद्द नहीं हो सका। कृपया दोबारा प्रयास करें।';

  @override
  String get graviaOrdersLoadErrorMessage =>
      'आपके ऑर्डर लोड करते समय कुछ गड़बड़ हो गई।';

  @override
  String get graviaOrdersRefreshFailedMessage =>
      'रीफ़्रेश नहीं हो सका — आपके पिछले लोड किए गए ऑर्डर दिखाए जा रहे हैं।';

  @override
  String get graviaTrackOrderTitle => 'ऑर्डर ट्रैक करें';

  @override
  String get graviaOrderStatusTitle => 'ऑर्डर की स्थिति';

  @override
  String get graviaOrderItemsTitle => 'आइटम';

  @override
  String get graviaOrderSummaryTitle => 'सारांश';

  @override
  String get graviaOrderDetailsTitle => 'ऑर्डर विवरण';

  @override
  String get graviaDeliveryAddressTitle => 'डिलीवरी पता';

  @override
  String get graviaOrderIdLabel => 'ऑर्डर ID';

  @override
  String get graviaOrderPlacedOnLabel => 'ऑर्डर की तारीख़';

  @override
  String get graviaPaymentIdLabel => 'भुगतान ID';

  @override
  String get graviaNoOnlinePaymentLabel => 'कोई ऑनलाइन भुगतान नहीं';

  @override
  String get graviaRefundLabel => 'रिफ़ंड';

  @override
  String get graviaCopiedMessage => 'कॉपी हो गया';

  @override
  String get graviaOrderTotalLabel => 'कुल भुगतान';

  @override
  String get graviaOrderStepPlacedLabel => 'ऑर्डर हो गया';

  @override
  String get graviaOrderStepOnTheWayLabel => 'रास्ते में है';

  @override
  String get graviaOrderStepDeliveredLabel => 'डिलीवर हो गया';

  @override
  String get graviaOrderStepCancelledLabel => 'रद्द किया गया';

  @override
  String get graviaOrderStepUndatedLabel => 'समय दर्ज नहीं है';

  @override
  String get graviaOrdersEmptyTitle => 'अभी कोई ऑर्डर नहीं';

  @override
  String get graviaOrdersEmptySubtitle =>
      'आपके पिछले और चालू ऑर्डर यहाँ दिखाई देंगे।';

  @override
  String get graviaFilterSheetTitle => 'फ़िल्टर';

  @override
  String get graviaFilterReasonHeading => 'एक कारण चुनें';

  @override
  String get graviaFilterLastWeekLabel => 'पिछला सप्ताह';

  @override
  String get graviaFilterLastMonthLabel => 'पिछला महीना';

  @override
  String get graviaFilterStatusLabel => 'स्थिति';

  @override
  String get graviaFilterDateLabel => 'तारीख़';

  @override
  String get graviaFilterAllStatusesLabel => 'सभी';

  @override
  String get graviaApplyFilterLabel => 'फ़िल्टर लागू करें';

  @override
  String get graviaFavouritePageTitle => 'पसंदीदा';

  @override
  String get graviaFavouriteEmptyTitle => 'अभी कोई पसंदीदा नहीं';

  @override
  String get graviaFavouriteEmptySubtitle =>
      'किसी उत्पाद पर दिल का निशान दबाएँ, वह यहाँ सेव रहेगा।';

  @override
  String graviaAddedToCartMessage(int count, String name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count × $name कार्ट में जोड़े गए',
      one: '$name कार्ट में जोड़ा गया',
    );
    return '$_temp0';
  }

  @override
  String get graviaDeliveryLocationLabel => 'डिलीवरी स्थान';

  @override
  String get graviaNoLocationSelectedLabel => 'कोई स्थान चुना नहीं गया';

  @override
  String get graviaNotificationsTitle => 'सूचनाएँ';

  @override
  String get graviaNotificationsLoadErrorMessage =>
      'आपकी सूचनाएँ लोड करते समय कुछ गड़बड़ हो गई।';

  @override
  String get graviaNotificationsEmptyTitle => 'अभी कोई सूचना नहीं';

  @override
  String get graviaNotificationsEmptySubtitle =>
      'आपके ऑर्डर और खाते से जुड़े अपडेट यहाँ दिखाई देंगे।';

  @override
  String get validationNameRequired => 'कृपया अपना नाम दर्ज करें।';

  @override
  String get validationEmailRequired => 'कृपया अपना ईमेल पता दर्ज करें।';

  @override
  String get validationEmailInvalid => 'मान्य ईमेल पता दर्ज करें।';

  @override
  String get validationMobileRequired => 'कृपया अपना मोबाइल नंबर दर्ज करें।';

  @override
  String get validationMobileInvalid => 'मान्य मोबाइल नंबर दर्ज करें।';

  @override
  String get validationPasswordRequired => 'कृपया अपना पासवर्ड दर्ज करें।';

  @override
  String get validationWeakPassword =>
      'पासवर्ड कम से कम 6 अक्षरों का होना चाहिए।';

  @override
  String get validationConfirmPasswordRequired =>
      'कृपया अपने नए पासवर्ड की पुष्टि करें।';

  @override
  String get validationPasswordsDontMatch => 'पासवर्ड मेल नहीं खाते।';

  @override
  String get retryButton => 'फिर से कोशिश करें';
}
