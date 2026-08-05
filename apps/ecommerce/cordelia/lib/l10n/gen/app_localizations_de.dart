// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get languageSheetTitle => 'Sprache';

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
      other: 'Stk.',
      one: 'Stk.',
    );
    return '$_temp0';
  }

  @override
  String get loginTitle => 'Willkommen bei CordeliaApps';

  @override
  String get loginSubtitle =>
      'Melden Sie sich mit Ihrer E-Mail-Adresse oder über soziale Netzwerke an';

  @override
  String get emailLabel => 'E-Mail-Adresse';

  @override
  String get emailHint => 'you@example.com';

  @override
  String get passwordLabel => 'Passwort';

  @override
  String get passwordHint => 'Passwort eingeben';

  @override
  String get forgotPasswordLabel => 'Passwort vergessen?';

  @override
  String passwordResetEmailSentMessage(String email) {
    return 'Link zum Zurücksetzen des Passworts an $email gesendet';
  }

  @override
  String get continueLabel => 'Weiter';

  @override
  String get orLoginWith => 'Oder anmelden mit';

  @override
  String get continueWithGoogle => 'Mit Google fortfahren';

  @override
  String get continueWithApple => 'Mit Apple fortfahren';

  @override
  String get byContinuingAgree => 'Wenn Sie fortfahren, akzeptieren Sie unsere';

  @override
  String get termsOfServiceAndPrivacyPolicy => 'AGB & Datenschutzerklärung';

  @override
  String get dontHaveAccount => 'Noch kein Konto? ';

  @override
  String get signupLink => 'Registrieren';

  @override
  String get signupTitle => 'Konto registrieren';

  @override
  String get signupSubtitle => 'Geben Sie unten Ihre Daten ein';

  @override
  String get nameLabel => 'Name';

  @override
  String get nameHint => 'z. B. Mark Shelby';

  @override
  String get mobileLabel => 'Mobilnummer';

  @override
  String get mobileHint => '(303) 555-0105';

  @override
  String get iAgreeLabel => 'Ich akzeptiere ';

  @override
  String get termsAndConditionsLink => 'AGB';

  @override
  String get mustAgreeToTermsMessage =>
      'Bitte akzeptieren Sie die AGB, um fortzufahren.';

  @override
  String get authWebUnsupportedMessage =>
      'Die Anmeldung ist nur auf Mobilgeräten verfügbar.';

  @override
  String get sessionExpiredMessage =>
      'Ihre Sitzung ist abgelaufen. Bitte melden Sie sich erneut an.';

  @override
  String get signupButtonLabel => 'Registrieren';

  @override
  String get alreadyHaveAccount => 'Sie haben schon ein Konto? ';

  @override
  String get loginLink => 'Anmelden';

  @override
  String get comingSoonMessage => 'Demnächst verfügbar';

  @override
  String get paymentCancelledMessage => 'Zahlung abgebrochen';

  @override
  String get paymentFailedMessage =>
      'Die Zahlung konnte nicht abgeschlossen werden. Bitte erneut versuchen.';

  @override
  String get verifyEmailTitle => 'E-Mail-Adresse bestätigen';

  @override
  String verifyEmailSubtitle(String email) {
    return 'Wir haben einen Bestätigungslink an $email gesendet. Öffnen Sie ihn und kehren Sie dann hierher zurück — die Anzeige aktualisiert sich automatisch.';
  }

  @override
  String get verifyEmailChecking => 'Wird geprüft…';

  @override
  String get resendEmailLabel => 'E-Mail erneut senden';

  @override
  String get termsAndConditionsLabel => 'AGB';

  @override
  String get privacyPolicyLabel => 'Datenschutzerklärung';

  @override
  String get legalLastUpdatedLabel => 'Zuletzt aktualisiert: 09. März 2026';

  @override
  String get termsAndConditionsIntro =>
      'Bitte lesen Sie diese Nutzungsbedingungen sorgfältig, bevor Sie unsere App nutzen.';

  @override
  String get termsAndConditionsHeading => 'Nutzungsbedingungen';

  @override
  String get termsAndConditionsBody =>
      'It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using \'Content here, content here\', making it look like readable English. Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a search for \'lorem ipsum\' will uncover many web sites still in their infancy. Various versions have evolved over the years, sometimes by accident, sometimes on purpose (injected humour and the like).';

  @override
  String get privacyPolicyIntro =>
      'Bitte lesen Sie diese Datenschutzerklärung sorgfältig, bevor Sie unsere App nutzen.';

  @override
  String get privacyPolicySection1Heading => '1. Datenerhebung';

  @override
  String get privacyPolicySection1Body =>
      'Wir erheben nur die Daten, die wir benötigen, um Ihr Einkaufserlebnis zu verbessern. Dazu gehören Angaben, die Sie uns direkt machen, etwa Ihre Kontodaten, sowie Informationen aus Nutzungsanalysen und Cookies.';

  @override
  String get privacyPolicySection2Heading => '2. Datenverwendung';

  @override
  String get privacyPolicySection2Body =>
      'Die erhobenen Daten dienen dazu, unsere Dienste zu verbessern, personalisierte Empfehlungen zu geben und einen reibungslosen Ablauf zu gewährleisten. Ohne Ihre ausdrückliche Zustimmung geben wir Ihre Daten nicht weiter.';

  @override
  String get privacyPolicySection3Heading => '3. Datenschutzeinstellungen';

  @override
  String get privacyPolicySection3Body =>
      'Sie behalten die volle Kontrolle über Ihre Daten. Verwalten Sie Ihre Datenschutzeinstellungen, aktualisieren Sie Ihre persönlichen Angaben und passen Sie alles an Ihre Bedürfnisse an.';

  @override
  String get privacyPolicySection4Heading => '4. Sicherheitsmaßnahmen';

  @override
  String get privacyPolicySection4Body =>
      'Die Sicherheit Ihrer Daten hat für uns Priorität: Wir setzen moderne Sicherheitsprotokolle und Verschlüsselung ein und führen regelmäßige Audits durch, um unbefugten Zugriff und Datenlecks zu verhindern.';

  @override
  String get profilePageTitle => 'Profil';

  @override
  String get changePasswordLabel => 'Passwort ändern';

  @override
  String get myOrdersLabel => 'Meine Bestellungen';

  @override
  String get myAddressLabel => 'Meine Adressen';

  @override
  String get darkModeLabel => 'Dunkelmodus';

  @override
  String get logoutLabel => 'Abmelden';

  @override
  String get logoutTitle => 'Abmelden';

  @override
  String get logoutConfirmMessage => 'Möchten Sie sich wirklich abmelden?';

  @override
  String get deleteAccountLabel => 'Konto löschen';

  @override
  String get deleteAccountTitle => 'Konto löschen?';

  @override
  String get deleteAccountConfirmMessage =>
      'Dadurch werden Ihr Profil, Ihre Adressen, Ihr Warenkorb, Ihre Merkliste und Ihre Bewertungen in allen Shops dauerhaft gelöscht. Bereits aufgegebene Bestellungen bleiben als Verkaufsbelege bei den jeweiligen Shops. Dieser Schritt kann nicht widerrufen werden.';

  @override
  String get deleteAccountFailedMessage =>
      'Ihr Konto konnte nicht gelöscht werden. Bitte erneut versuchen.';

  @override
  String get profileLoadErrorMessage =>
      'Beim Laden Ihres Profils ist ein Fehler aufgetreten.';

  @override
  String get sortRelevanceLabel => 'Relevanz';

  @override
  String get sortPriceLowToHighLabel => 'Preis (aufsteigend)';

  @override
  String get sortPriceHighToLowLabel => 'Preis (absteigend)';

  @override
  String get sortRatingHighToLowLabel => 'Bewertung (absteigend)';

  @override
  String get sortDiscountHighToLowLabel => 'Rabatt (absteigend)';

  @override
  String get priceFilterAllLabel => 'Alle Preise';

  @override
  String priceFilterUnderLabel(String price) {
    return 'Unter $price';
  }

  @override
  String priceFilterOverLabel(String price) {
    return 'Über $price';
  }

  @override
  String priceFilterRangeLabel(String from, String to) {
    return '$from - $to';
  }

  @override
  String get reviewsSectionTitle => 'Bewertungen';

  @override
  String get writeReviewLabel => 'Bewertung schreiben';

  @override
  String get editReviewLabel => 'Bewertung bearbeiten';

  @override
  String get deleteReviewLabel => 'Löschen';

  @override
  String get reviewSheetTitle => 'Produkt bewerten';

  @override
  String get reviewRatingPrompt => 'Wie viele Sterne?';

  @override
  String get reviewTextLabel => 'Ihre Bewertung';

  @override
  String get reviewTextHint => 'Teilen Sie anderen Kunden Ihre Meinung mit…';

  @override
  String get reviewSubmitLabel => 'Bewertung absenden';

  @override
  String get reviewMissingRatingMessage =>
      'Bitte wählen Sie zuerst eine Sternebewertung.';

  @override
  String get reviewDeleteConfirmTitle => 'Bewertung löschen?';

  @override
  String get reviewDeleteConfirmMessage =>
      'Dadurch wird Ihre Bewertung aus dem Durchschnitt des Produkts entfernt. Sie können jederzeit eine neue schreiben.';

  @override
  String get reviewSignedOutMessage =>
      'Melden Sie sich an, um dieses Produkt zu bewerten.';

  @override
  String get verifiedPurchaseLabel => 'Verifizierter Kauf';

  @override
  String get reviewsEmptyTitle => 'Noch keine Bewertungen';

  @override
  String get reviewsEmptySubtitle =>
      'Bewerten Sie dieses Produkt als Erste oder Erster und helfen Sie anderen bei der Entscheidung.';

  @override
  String get unratedLabel => 'Noch keine Bewertungen';

  @override
  String get rateOrderLabel => 'Bestellung bewerten';

  @override
  String get editOrderRatingLabel => 'Bewertung bearbeiten';

  @override
  String get rateOrderSheetTitle => 'Wie war diese Bestellung?';

  @override
  String get rateOrderTextLabel => 'Ihr Feedback';

  @override
  String get rateOrderTextHint => 'Wie war die Lieferung?';

  @override
  String get orderRatingNotDeliveredMessage =>
      'Sie können eine Bestellung erst bewerten, wenn sie geliefert wurde.';

  @override
  String get orderRatingFailedMessage =>
      'Ihre Bewertung konnte nicht gespeichert werden. Bitte erneut versuchen.';

  @override
  String get yourRatingLabel => 'Ihre Bewertung';

  @override
  String orderPlacedAtLabel(String date, String time) {
    return '$date um $time';
  }

  @override
  String reviewCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Bewertungen',
      one: '$count Bewertung',
    );
    return '$_temp0';
  }

  @override
  String get reviewAgeJustNow => 'Gerade eben';

  @override
  String reviewAgeMinutesAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'vor $count Minuten',
      one: 'vor $count Minute',
    );
    return '$_temp0';
  }

  @override
  String reviewAgeHoursAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'vor $count Stunden',
      one: 'vor $count Stunde',
    );
    return '$_temp0';
  }

  @override
  String reviewAgeDaysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'vor $count Tagen',
      one: 'vor $count Tag',
    );
    return '$_temp0';
  }

  @override
  String reviewAgeMonthsAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'vor $count Monaten',
      one: 'vor $count Monat',
    );
    return '$_temp0';
  }

  @override
  String reviewAgeYearsAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'vor $count Jahren',
      one: 'vor $count Jahr',
    );
    return '$_temp0';
  }

  @override
  String get graviaCategoriesTitle => 'Alle Kategorien';

  @override
  String get graviaSeeAll => 'Alle ansehen';

  @override
  String get graviaPopularItemsTitle => 'Beliebte Artikel';

  @override
  String get graviaHomeLoadErrorMessage =>
      'Katalog dieses Shops konnte nicht geladen werden.';

  @override
  String get graviaCancel => 'Abbrechen';

  @override
  String graviaDiscountPercentOff(String percent) {
    return '$percent% RABATT';
  }

  @override
  String get graviaAddToCart => 'In den Warenkorb';

  @override
  String get graviaAddToCartSheetTitle => 'In den Warenkorb';

  @override
  String get graviaDeleteLabel => 'Löschen';

  @override
  String get graviaDeleteAddressTitle => 'Adresse löschen';

  @override
  String get graviaDeleteAddressConfirmMessage =>
      'Möchten Sie diese Adresse wirklich löschen? Dies kann nicht rückgängig gemacht werden.';

  @override
  String get graviaClearCartTitle => 'Warenkorb leeren';

  @override
  String get graviaClearCartConfirmMessage =>
      'Möchten Sie wirklich alle Artikel aus Ihrem Warenkorb entfernen?';

  @override
  String get graviaClearCartConfirmLabel => 'Warenkorb leeren';

  @override
  String get graviaOrderPlacedTitle => 'Bestellung erfolgreich aufgegeben';

  @override
  String get graviaOrderPlacedSubtitle =>
      'Vielen Dank für Ihre Bestellung. Sie können Ihre Lieferung im Bestellbereich verfolgen.';

  @override
  String get graviaTrackYourOrderLabel => 'Bestellung verfolgen';

  @override
  String get graviaSearchHint => 'Suche';

  @override
  String get graviaNavHome => 'Start';

  @override
  String get graviaNavCategories => 'Kategorien';

  @override
  String get graviaNavFavourite => 'Merkliste';

  @override
  String get graviaNavOrders => 'Bestellungen';

  @override
  String get graviaNavProfile => 'Profil';

  @override
  String get graviaRecentSearchTitle => 'Letzte Suchen';

  @override
  String get graviaSearchLoadErrorMessage =>
      'Beim Laden der Suche ist ein Fehler aufgetreten.';

  @override
  String get graviaSearchResultsErrorMessage =>
      'Bei der Suche ist ein Fehler aufgetreten.';

  @override
  String get graviaSearchCategoryBadge => 'Kategorie';

  @override
  String get graviaSearchNoResultsTitle => 'Keine Ergebnisse gefunden';

  @override
  String graviaSearchNoResultsSubtitle(String query) {
    return 'Für „$query“ gibt es keine Treffer. Versuchen Sie ein anderes Stichwort.';
  }

  @override
  String get graviaProductDetailsTitle => 'Produktdetails';

  @override
  String get graviaSelectQtyLabel => 'Menge wählen';

  @override
  String get graviaKeyInformationTitle => 'Wichtige Infos';

  @override
  String get graviaReadMore => 'Mehr lesen';

  @override
  String get graviaReadLess => 'Weniger lesen';

  @override
  String get graviaSimilarProductsTitle => 'Ähnliche Produkte';

  @override
  String get graviaProductDetailsLoadErrorMessage =>
      'Beim Laden des Produkts ist ein Fehler aufgetreten.';

  @override
  String graviaAddToCartWithPrice(String price) {
    return 'In den Warenkorb ($price)';
  }

  @override
  String get graviaCategoriesPageTitle => 'Kategorien';

  @override
  String get graviaCategoriesLoadErrorMessage =>
      'Beim Laden der Kategorien ist ein Fehler aufgetreten.';

  @override
  String get graviaCategoriesRefreshFailedMessage =>
      'Aktualisierung fehlgeschlagen — zuletzt geladene Kategorien werden angezeigt.';

  @override
  String get graviaSortLabel => 'Sortieren';

  @override
  String get graviaPriceLabel => 'Preis';

  @override
  String get graviaSortBySheetTitle => 'Sortieren nach';

  @override
  String get graviaPriceSheetTitle => 'Preis';

  @override
  String get graviaCategoryDetailsEmptyMessage =>
      'Keine Produkte passen zu diesen Filtern.';

  @override
  String get graviaSelectAddressTitle => 'Adresse wählen';

  @override
  String get graviaAddNewAddressLabel => 'Neue Adresse hinzufügen';

  @override
  String get graviaDefaultAddressSectionTitle => 'Standardadresse';

  @override
  String get graviaOtherAddressSectionTitle => 'Weitere Adressen';

  @override
  String get graviaEditLabel => 'Bearbeiten';

  @override
  String get graviaAddressLoadErrorMessage =>
      'Beim Laden Ihrer Adressen ist ein Fehler aufgetreten.';

  @override
  String get graviaAddressSaveFailedMessage =>
      'Adresse konnte nicht gespeichert werden. Bitte erneut versuchen.';

  @override
  String get graviaAddressDeleteFailedMessage =>
      'Adresse konnte nicht gelöscht werden. Bitte erneut versuchen.';

  @override
  String get graviaAddressEmptyTitle => 'Keine gespeicherten Adressen';

  @override
  String get graviaAddressEmptySubtitle =>
      'Fügen Sie Ihre erste Lieferadresse hinzu.';

  @override
  String get graviaEditAddressTitle => 'Adresse bearbeiten';

  @override
  String get graviaNameLabel => 'Name';

  @override
  String get graviaNameHint => 'z. B. Mark Shelby';

  @override
  String get graviaPhoneNumberLabel => 'Telefonnummer';

  @override
  String get graviaPhoneNumberHint => 'z. B. (303) 555-0105';

  @override
  String get graviaAddressLine1Label => 'Adresszeile 1';

  @override
  String get graviaAddressLine1Hint => 'Hausnr., Straße';

  @override
  String get graviaAddressLine2Label => 'Adresszeile 2';

  @override
  String get graviaAddressLine2Hint => 'Wohnung, Etage usw. (optional)';

  @override
  String get graviaLandmarkLabel => 'Orientierungspunkt';

  @override
  String get graviaLandmarkHint => 'Markanter Punkt in der Nähe (optional)';

  @override
  String get graviaCityLabel => 'Stadt';

  @override
  String get graviaCityHint => 'z. B. New Delhi';

  @override
  String get graviaStateLabel => 'Bundesland';

  @override
  String get graviaStateHint => 'z. B. Delhi (optional)';

  @override
  String get graviaCountryLabel => 'Land';

  @override
  String get graviaSelectCountryTitle => 'Land wählen';

  @override
  String get graviaPostalCodeLabel => 'Postleitzahl';

  @override
  String get graviaPostalCodeHint => 'z. B. 62639';

  @override
  String get graviaAddressTagLabel => 'Bezeichnung';

  @override
  String get graviaAddressTagHint => 'z. B. Zuhause, Büro';

  @override
  String get graviaAddAddressButtonLabel => 'Adresse hinzufügen';

  @override
  String get graviaUpdateAddressButtonLabel => 'Adresse aktualisieren';

  @override
  String get graviaRequiredFieldErrorMessage => 'Pflichtfeld';

  @override
  String get graviaUseMyLocationLabel => 'Meinen Standort verwenden';

  @override
  String get graviaLocationUnavailableMessage =>
      'Standort konnte nicht ermittelt werden. Prüfen Sie die Standortberechtigung und versuchen Sie es erneut.';

  @override
  String get graviaAddressSearchLabel => 'Adresse suchen';

  @override
  String get graviaAddressSearchHint =>
      'Ort, Straße, Orientierungspunkt suchen…';

  @override
  String get graviaProfilePageTitle => 'Profil';

  @override
  String get graviaChangePasswordLabel => 'Passwort ändern';

  @override
  String get graviaMyOrdersLabel => 'Meine Bestellungen';

  @override
  String get graviaMyAddressLabel => 'Meine Adressen';

  @override
  String get graviaDarkModeLabel => 'Dunkelmodus';

  @override
  String get graviaPrivacyPolicyLabel => 'Datenschutzerklärung';

  @override
  String get graviaTermsAndConditionsLabel => 'AGB';

  @override
  String get graviaLogoutLabel => 'Abmelden';

  @override
  String get graviaLogoutTitle => 'Abmelden';

  @override
  String get graviaLogoutConfirmMessage =>
      'Möchten Sie sich wirklich abmelden?';

  @override
  String get graviaProfileLoadErrorMessage =>
      'Beim Laden Ihres Profils ist ein Fehler aufgetreten.';

  @override
  String get graviaEditProfileTitle => 'Profil bearbeiten';

  @override
  String get graviaEmailAddressLabel => 'E-Mail-Adresse';

  @override
  String get graviaEmailAddressHint => 'z. B. mark.shelby@example.com';

  @override
  String get graviaMobileNumberLabel => 'Mobilnummer';

  @override
  String get graviaUpdateProfileButtonLabel => 'Aktualisieren';

  @override
  String get graviaChangePhotoTitle => 'Foto ändern';

  @override
  String get graviaTakePhotoLabel => 'Foto aufnehmen';

  @override
  String get graviaChooseFromGalleryLabel => 'Aus Galerie wählen';

  @override
  String get graviaAvatarPickerMobileOnlyMessage =>
      'Das Ändern des Fotos ist nur auf dem Mobilgerät möglich';

  @override
  String get graviaChangePasswordTitle => 'Passwort ändern';

  @override
  String get graviaCurrentPasswordLabel => 'Aktuelles Passwort';

  @override
  String get graviaCurrentPasswordHint => 'Aktuelles Passwort eingeben';

  @override
  String get graviaNewPasswordLabel => 'Neues Passwort';

  @override
  String get graviaNewPasswordHint => 'Neues Passwort eingeben';

  @override
  String get graviaConfirmNewPasswordLabel => 'Neues Passwort bestätigen';

  @override
  String get graviaConfirmNewPasswordHint => 'Neues Passwort erneut eingeben';

  @override
  String get graviaUpdatePasswordButtonLabel => 'Passwort ändern';

  @override
  String get graviaPasswordUpdatedMessage => 'Ihr Passwort wurde aktualisiert.';

  @override
  String get graviaMyCartTitle => 'Mein Warenkorb';

  @override
  String get graviaBeforeYouCheckoutTitle => 'Bevor Sie zur Kasse gehen';

  @override
  String get graviaCouponCodeLabel => 'Gutscheincode';

  @override
  String get graviaApplyLabel => 'Übernehmen';

  @override
  String get graviaCouponRemoveLabel => 'Entfernen';

  @override
  String graviaCouponApplied(String code) {
    return '$code übernommen';
  }

  @override
  String graviaCouponLine(String code) {
    return 'Gutschein ($code)';
  }

  @override
  String get graviaItemTotalLabel => 'Zwischensumme';

  @override
  String get graviaDiscountLabel => 'Rabatt';

  @override
  String get graviaDeliveryLabel => 'Lieferung';

  @override
  String get graviaDeliveryFreeLabel => 'GRATIS';

  @override
  String get graviaGrandTotalLabel => 'Gesamtsumme';

  @override
  String get graviaProceedToCheckoutLabel => 'Zur Kasse';

  @override
  String get graviaCartEmptyTitle => 'Ihr Warenkorb ist leer';

  @override
  String get graviaCartEmptySubtitle => 'Fügen Sie Artikel hinzu.';

  @override
  String get graviaCartBarTitle => 'Mehr Produkte ansehen';

  @override
  String get graviaExploreLabel => 'Entdecken';

  @override
  String get graviaCheckoutLabel => 'Zur Kasse';

  @override
  String graviaCartSummary(int count, String total) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Artikel',
      one: '$count Artikel',
    );
    return '$_temp0 | $total';
  }

  @override
  String get graviaOrdersPageTitle => 'Bestellungen';

  @override
  String get graviaUpcomingTabLabel => 'Laufend';

  @override
  String get graviaPastTabLabel => 'Vergangen';

  @override
  String get graviaPendingStatusLabel => 'Aufgegeben';

  @override
  String get graviaInProcessStatusLabel => 'Unterwegs';

  @override
  String get graviaDeliveredStatusLabel => 'Geliefert';

  @override
  String get graviaCancelledStatusLabel => 'Storniert';

  @override
  String get graviaDeliveryOtpLabel => 'Liefer-OTP';

  @override
  String get graviaCancelOrderLabel => 'Stornieren';

  @override
  String get graviaTrackOrderLabel => 'Verfolgen';

  @override
  String get graviaViewDetailsLabel => 'Details ansehen';

  @override
  String get graviaWriteReviewLabel => 'Bewertung schreiben';

  @override
  String get graviaRefundPendingLabel => 'Rückerstattung läuft';

  @override
  String get graviaRefundProcessedLabel => 'Erstattet';

  @override
  String get graviaRefundFailedLabel => 'Fehlgeschlagen';

  @override
  String get graviaCancelOrderConfirmTitle => 'Diese Bestellung stornieren?';

  @override
  String get graviaCancelOrderConfirmBody =>
      'Ihre Bestellung wird storniert. Bereits gezahlte Beträge werden vollständig zurückerstattet.';

  @override
  String get graviaCancelOrderConfirmCta => 'Bestellung stornieren';

  @override
  String get graviaCancelOrderDismissCta => 'Behalten';

  @override
  String get graviaCancelFailedMessage =>
      'Bestellung konnte nicht storniert werden. Bitte erneut versuchen.';

  @override
  String get graviaOrdersLoadErrorMessage =>
      'Beim Laden Ihrer Bestellungen ist ein Fehler aufgetreten.';

  @override
  String get graviaOrdersRefreshFailedMessage =>
      'Aktualisierung fehlgeschlagen — zuletzt geladene Bestellungen werden angezeigt.';

  @override
  String get graviaTrackOrderTitle => 'Bestellung verfolgen';

  @override
  String get graviaOrderStatusTitle => 'Bestellstatus';

  @override
  String get graviaOrderItemsTitle => 'Artikel';

  @override
  String get graviaOrderSummaryTitle => 'Übersicht';

  @override
  String get graviaOrderDetailsTitle => 'Bestelldetails';

  @override
  String get graviaDeliveryAddressTitle => 'Lieferadresse';

  @override
  String get graviaOrderIdLabel => 'Bestellnr.';

  @override
  String get graviaOrderPlacedOnLabel => 'Aufgegeben am';

  @override
  String get graviaPaymentIdLabel => 'Zahlungs-ID';

  @override
  String get graviaNoOnlinePaymentLabel => 'Keine Online-Zahlung';

  @override
  String get graviaRefundLabel => 'Rückerstattung';

  @override
  String get graviaCopiedMessage => 'Kopiert';

  @override
  String get graviaOrderTotalLabel => 'Bezahlt';

  @override
  String get graviaOrderStepPlacedLabel => 'Bestellung aufgegeben';

  @override
  String get graviaOrderStepOnTheWayLabel => 'Unterwegs';

  @override
  String get graviaOrderStepDeliveredLabel => 'Geliefert';

  @override
  String get graviaOrderStepCancelledLabel => 'Storniert';

  @override
  String get graviaOrderStepUndatedLabel => 'Zeit nicht erfasst';

  @override
  String get graviaOrdersEmptyTitle => 'Noch keine Bestellungen';

  @override
  String get graviaOrdersEmptySubtitle =>
      'Ihre laufenden und vergangenen Bestellungen erscheinen hier.';

  @override
  String get graviaFilterSheetTitle => 'Filter';

  @override
  String get graviaFilterReasonHeading => 'Grund wählen';

  @override
  String get graviaFilterLastWeekLabel => 'Letzte Woche';

  @override
  String get graviaFilterLastMonthLabel => 'Letzter Monat';

  @override
  String get graviaFilterStatusLabel => 'Status';

  @override
  String get graviaFilterDateLabel => 'Datum';

  @override
  String get graviaFilterAllStatusesLabel => 'Alle';

  @override
  String get graviaApplyFilterLabel => 'Filter übernehmen';

  @override
  String get graviaFavouritePageTitle => 'Merkliste';

  @override
  String get graviaFavouriteEmptyTitle => 'Merkliste ist leer';

  @override
  String get graviaFavouriteEmptySubtitle =>
      'Tippen Sie auf das Herz eines Produkts, um es hier zu speichern.';

  @override
  String graviaAddedToCartMessage(int count, String name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count × $name in den Warenkorb gelegt',
      one: '$name in den Warenkorb gelegt',
    );
    return '$_temp0';
  }

  @override
  String get graviaDeliveryLocationLabel => 'Lieferort';

  @override
  String get graviaNoLocationSelectedLabel => 'Kein Ort ausgewählt';

  @override
  String get graviaNotificationsTitle => 'Benachrichtigungen';

  @override
  String get graviaNotificationsLoadErrorMessage =>
      'Beim Laden Ihrer Benachrichtigungen ist ein Fehler aufgetreten.';

  @override
  String get graviaNotificationsEmptyTitle => 'Noch keine Benachrichtigungen';

  @override
  String get graviaNotificationsEmptySubtitle =>
      'Updates zu Ihren Bestellungen und Ihrem Konto erscheinen hier.';

  @override
  String get dailymartTopSellerTitle => 'Bestseller🔥';

  @override
  String get dailymartCategoriesTitle => 'Nach Kategorie einkaufen';

  @override
  String get dailymartPopularProductsTitle => 'Beliebte Produkte';

  @override
  String get dailymartSeeAll => 'Alle ansehen';

  @override
  String get dailymartSearchHint => 'Produkte suchen';

  @override
  String get dailymartHomeLoadErrorMessage =>
      'Der Katalog dieses Shops konnte nicht geladen werden.';

  @override
  String get dailymartNoLocationSelectedLabel => 'Standort wählen';

  @override
  String get dailymartNotificationsTitle => 'Benachrichtigung';

  @override
  String get dailymartNotificationsLoadErrorMessage =>
      'Ihre Benachrichtigungen konnten nicht geladen werden.';

  @override
  String get dailymartNotificationsEmptyTitle =>
      'Noch keine Benachrichtigungen';

  @override
  String get dailymartNotificationsEmptySubtitle =>
      'Angebote und Bestell-Updates dieses Shops erscheinen hier.';

  @override
  String get dailymartOrderNow => 'Jetzt bestellen';

  @override
  String dailymartPromoSubtitle(String percent) {
    return 'Bis zu $percent% Rabatt\nheute auf Ihre Bestellung';
  }

  @override
  String dailymartDiscountPercentOff(String percent) {
    return '$percent% Rabatt';
  }

  @override
  String get dailymartNavHome => 'Start';

  @override
  String get dailymartNavWishlist => 'Merkliste';

  @override
  String get dailymartNavCart => 'Warenkorb';

  @override
  String get dailymartNavProfile => 'Profil';

  @override
  String get dailymartRecentSearchTitle => 'Letzte Suchen';

  @override
  String get dailymartRecentlyViewedTitle => 'Zuletzt angesehen';

  @override
  String dailymartResultsForLabel(String query) {
    return 'Ergebnis für „$query“';
  }

  @override
  String dailymartResultsCountLabel(int count) {
    return '$count Ergebnisse';
  }

  @override
  String get dailymartSearchLoadErrorMessage =>
      'Die Suche konnte nicht geladen werden.';

  @override
  String get dailymartSearchResultsErrorMessage =>
      'Die Suche in diesem Shop war nicht möglich.';

  @override
  String get dailymartSearchNoResultsTitle => 'Keine Ergebnisse';

  @override
  String dailymartSearchNoResultsSubtitle(String query) {
    return 'Nichts in diesem Shop passt bisher zu „$query“.';
  }

  @override
  String get dailymartCategoryBadge => 'Kategorie';

  @override
  String get dailymartFilterLabel => 'Filter';

  @override
  String get dailymartSortSheetTitle => 'Sortieren nach';

  @override
  String get dailymartPriceSheetTitle => 'Preis';

  @override
  String get dailymartCategoryDetailsEmptyTitle => 'Nichts gefunden';

  @override
  String get dailymartCategoryDetailsEmptySubtitle =>
      'Keine Produkte in dieser Kategorie passen zu diesen Filtern.';

  @override
  String get dailymartCategoryDetailsErrorMessage =>
      'Diese Kategorie konnte nicht geladen werden.';

  @override
  String get dailymartWishlistEmptyTitle => 'Noch nichts gemerkt';

  @override
  String get dailymartWishlistEmptySubtitle =>
      'Tippen Sie auf das Herz bei einem Produkt – es wartet dann hier auf Sie.';

  @override
  String get dailymartWishlistExploreAction => 'Jetzt einkaufen';

  @override
  String get dailymartProductDetailsTitle => 'Produktdetails';

  @override
  String get dailymartDescriptionsTabLabel => 'Beschreibung';

  @override
  String get dailymartReviewsTabLabel => 'Bewertungen';

  @override
  String get dailymartRelatedProductsTitle => 'Ähnliche Produkte';

  @override
  String get dailymartSelectSizeLabel => 'Größe wählen';

  @override
  String get dailymartProductDetailsLoadErrorMessage =>
      'Die Produktdetails konnten nicht geladen werden.';

  @override
  String get dailymartAddToCart => 'In den Warenkorb';

  @override
  String get dailymartAddToCartSheetTitle => 'In den Warenkorb';

  @override
  String dailymartAddedToCartMessage(int count, String name) {
    return '$count × $name in den Warenkorb gelegt.';
  }

  @override
  String dailymartStarRowLabel(int stars) {
    return '$stars Sterne';
  }

  @override
  String get dailymartMyCartTitle => 'Mein Warenkorb';

  @override
  String get dailymartCouponHint => 'Gutscheincode eingeben';

  @override
  String get dailymartCouponRemoveLabel => 'Entfernen';

  @override
  String get dailymartCouponDetailLabel => 'Gutschein';

  @override
  String dailymartCouponApplied(String code) {
    return '$code angewendet';
  }

  @override
  String dailymartCouponLine(String code) {
    return 'Gutschein ($code)';
  }

  @override
  String get dailymartSubTotalLabel => 'Zwischensumme';

  @override
  String get dailymartDeliveryLabel => 'Lieferung';

  @override
  String get dailymartDeliveryFreeLabel => 'Gratis';

  @override
  String get dailymartDiscountLabel => 'Rabatt';

  @override
  String get dailymartTotalCostLabel => 'Gesamtsumme';

  @override
  String get dailymartProceedToCheckoutLabel => 'Zur Kasse';

  @override
  String get dailymartCartEmptyTitle => 'Ihr Warenkorb ist leer';

  @override
  String get dailymartCartEmptySubtitle =>
      'Hinzugefügte Produkte erscheinen hier – bereit zur Kasse.';

  @override
  String get dailymartCartExploreAction => 'Jetzt einkaufen';

  @override
  String get dailymartRemovedFromCartMessage => 'Aus dem Warenkorb entfernt.';

  @override
  String get dailymartCheckoutTitle => 'Kasse';

  @override
  String get dailymartShippingAddressLabel => 'Lieferadresse';

  @override
  String get dailymartOrderListLabel => 'Bestellübersicht';

  @override
  String get dailymartContinueToPaymentLabel => 'Weiter zur Zahlung';

  @override
  String get dailymartOrderPlacedTitle => 'Zahlung erfolgreich!';

  @override
  String get dailymartOrderPlacedMessage =>
      'Vielen Dank für Ihren Einkauf! Ihre Zahlung wurde erfolgreich verarbeitet. 🎉';

  @override
  String get dailymartTrackOrderLabel => 'Bestellung verfolgen';

  @override
  String dailymartCartSummary(int count, String total) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Artikel',
      one: '$count Artikel',
    );
    return '$_temp0 | $total';
  }

  @override
  String get dailymartViewCartLabel => 'Warenkorb ansehen';

  @override
  String get dailymartGeneralSectionTitle => 'Allgemein';

  @override
  String get dailymartPreferencesSectionTitle => 'Einstellungen';

  @override
  String get dailymartEditProfileLabel => 'Profil bearbeiten';

  @override
  String get dailymartChangePasswordLabel => 'Passwort ändern';

  @override
  String get dailymartMyOrdersLabel => 'Meine Bestellungen';

  @override
  String get dailymartMyAddressLabel => 'Meine Adressen';

  @override
  String get dailymartDarkModeLabel => 'Dunkelmodus';

  @override
  String get dailymartPrivacyPolicyLabel => 'Datenschutzerklärung';

  @override
  String get dailymartTermsAndConditionsLabel => 'AGB';

  @override
  String get dailymartLogoutLabel => 'Abmelden';

  @override
  String get dailymartLogoutTitle => 'Abmelden?';

  @override
  String get dailymartLogoutConfirmMessage =>
      'Sie müssen sich erneut anmelden, um zu bestellen oder eine Bestellung zu verfolgen.';

  @override
  String get dailymartProfileLoadErrorMessage =>
      'Ihr Profil konnte nicht geladen werden.';

  @override
  String get dailymartEditProfileTitle => 'Profil bearbeiten';

  @override
  String get dailymartFullNameLabel => 'Vollständiger Name';

  @override
  String get dailymartFullNameHint => 'Vollständigen Namen eingeben';

  @override
  String get dailymartEmailLabel => 'E-Mail';

  @override
  String get dailymartEmailHint => 'name@beispiel.de';

  @override
  String get dailymartPhoneNumberLabel => 'Telefonnummer';

  @override
  String get dailymartPhoneNumberHint => 'Telefonnummer eingeben';

  @override
  String get dailymartSaveChangesLabel => 'Änderungen speichern';

  @override
  String get dailymartChangePhotoTitle => 'Foto ändern';

  @override
  String get dailymartTakePhotoLabel => 'Foto aufnehmen';

  @override
  String get dailymartChooseFromGalleryLabel => 'Aus Galerie wählen';

  @override
  String get dailymartAvatarPickerMobileOnlyMessage =>
      'Die Fotoauswahl ist nur auf dem Smartphone verfügbar.';

  @override
  String get dailymartChangePasswordTitle => 'Passwort ändern';

  @override
  String get dailymartCurrentPasswordLabel => 'Aktuelles Passwort';

  @override
  String get dailymartCurrentPasswordHint => 'Aktuelles Passwort eingeben';

  @override
  String get dailymartNewPasswordLabel => 'Neues Passwort';

  @override
  String get dailymartNewPasswordHint => 'Neues Passwort eingeben';

  @override
  String get dailymartConfirmNewPasswordLabel => 'Neues Passwort bestätigen';

  @override
  String get dailymartConfirmNewPasswordHint =>
      'Neues Passwort erneut eingeben';

  @override
  String get dailymartUpdatePasswordButtonLabel => 'Passwort aktualisieren';

  @override
  String get dailymartPasswordUpdatedMessage =>
      'Ihr Passwort wurde aktualisiert.';

  @override
  String get dailymartSelectAddressTitle => 'Adresse wählen';

  @override
  String get dailymartAddNewAddressLabel => 'Neue Adresse hinzufügen';

  @override
  String get dailymartAddressLoadErrorMessage =>
      'Ihre Adressen konnten nicht geladen werden.';

  @override
  String get dailymartAddressSaveFailedMessage =>
      'Die Adresse konnte nicht gespeichert werden.';

  @override
  String get dailymartAddressEmptyTitle => 'Keine gespeicherten Adressen';

  @override
  String get dailymartAddressEmptySubtitle =>
      'Fügen Sie eine hinzu, damit dieser Shop zu Ihnen liefert.';

  @override
  String get dailymartAddressDeleteFailedMessage =>
      'Die Adresse konnte nicht gelöscht werden.';

  @override
  String get dailymartEditAddressTooltip => 'Adresse bearbeiten';

  @override
  String get dailymartDeleteAddressTitle => 'Diese Adresse löschen?';

  @override
  String get dailymartDeleteAddressMessage =>
      'Sie wird aus Ihren gespeicherten Adressen entfernt.';

  @override
  String get dailymartDeleteLabel => 'Löschen';

  @override
  String get dailymartAddAddressTitle => 'Neue Adresse hinzufügen';

  @override
  String get dailymartEditAddressTitle => 'Adresse bearbeiten';

  @override
  String get dailymartAddressNameLabel => 'Name';

  @override
  String get dailymartAddressNameHint => 'z. B. Mark Shelby';

  @override
  String get dailymartAddressLine1Label => 'Adresszeile 1';

  @override
  String get dailymartAddressLine1Hint => 'Hausnr., Straße';

  @override
  String get dailymartAddressLine2Label => 'Adresszeile 2';

  @override
  String get dailymartAddressLine2Hint => 'Wohnung, Etage usw. (optional)';

  @override
  String get dailymartLandmarkLabel => 'Orientierungspunkt';

  @override
  String get dailymartLandmarkHint => 'Markanter Punkt in der Nähe (optional)';

  @override
  String get dailymartCityLabel => 'Stadt';

  @override
  String get dailymartCityHint => 'z. B. New Delhi';

  @override
  String get dailymartStateLabel => 'Bundesland';

  @override
  String get dailymartStateHint => 'z. B. Delhi (optional)';

  @override
  String get dailymartCountryLabel => 'Land';

  @override
  String get dailymartSelectCountryTitle => 'Land wählen';

  @override
  String get dailymartPostalCodeLabel => 'Postleitzahl';

  @override
  String get dailymartPostalCodeHint => 'z. B. 62639';

  @override
  String get dailymartAddressTagLabel => 'Bezeichnung';

  @override
  String get dailymartAddressTagHint => 'z. B. Zuhause, Büro';

  @override
  String get dailymartAddAddressButtonLabel => 'Adresse hinzufügen';

  @override
  String get dailymartUpdateAddressButtonLabel => 'Adresse aktualisieren';

  @override
  String get dailymartRequiredFieldErrorMessage => 'Pflichtfeld';

  @override
  String get dailymartMyOrdersTitle => 'Meine Bestellungen';

  @override
  String get dailymartOrdersSearchHint => 'Was suchen Sie ...';

  @override
  String get dailymartOrdersFilterAllLabel => 'Alle';

  @override
  String get dailymartOrdersFilterActiveLabel => 'Aktiv';

  @override
  String get dailymartOrdersFilterCompletedLabel => 'Abgeschlossen';

  @override
  String get dailymartOrdersFilterCancelledLabel => 'Storniert';

  @override
  String dailymartOrderSummaryLabel(int count, String date) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Artikel',
      one: '$count Artikel',
    );
    return '$_temp0 · $date';
  }

  @override
  String get dailymartOrdersDateRangeLabel => 'Zeitraum';

  @override
  String get dailymartOrdersAllTimeLabel => 'Alle';

  @override
  String get dailymartOrdersFilterLastWeekLabel => 'Letzte Woche';

  @override
  String get dailymartOrdersFilterLastMonthLabel => 'Letzter Monat';

  @override
  String get dailymartResetLabel => 'Zurücksetzen';

  @override
  String get dailymartApplyLabel => 'Übernehmen';

  @override
  String get dailymartOrdersLoadErrorMessage =>
      'Ihre Bestellungen konnten nicht geladen werden.';

  @override
  String get dailymartOrdersEmptyTitle => 'Noch keine Bestellungen';

  @override
  String get dailymartOrdersEmptySubtitle =>
      'Ihre Bestellungen bei diesem Shop erscheinen hier.';

  @override
  String get dailymartOrdersNoResultsTitle => 'Nichts gefunden';

  @override
  String get dailymartOrdersNoResultsSubtitle =>
      'Keine Bestellungen passen zu dieser Suche oder diesem Filter.';

  @override
  String get dailymartOrderCancelFailedMessage =>
      'Die Bestellung konnte nicht storniert werden.';

  @override
  String get dailymartOrdersRefreshFailedMessage =>
      'Ihre Bestellungen konnten nicht aktualisiert werden.';

  @override
  String get dailymartTrackOrderTitle => 'Bestellung verfolgen';

  @override
  String get dailymartTrackOrderAction => 'Verfolgen';

  @override
  String get dailymartOrderDetailsTitle => 'Bestelldetails';

  @override
  String get dailymartOrderIdLabel => 'Bestellnummer';

  @override
  String get dailymartDeliveryOtpLabel => 'Liefer-OTP';

  @override
  String get dailymartPaymentTitle => 'Zahlung';

  @override
  String get dailymartAmountPaidLabel => 'Bezahlter Betrag';

  @override
  String get dailymartPaymentIdLabel => 'Zahlungs-ID';

  @override
  String get dailymartRefundLabel => 'Rückerstattung';

  @override
  String get dailymartCopiedMessage => 'Kopiert';

  @override
  String get dailymartNoOnlinePaymentLabel => 'Nicht online bezahlt';

  @override
  String get dailymartRefundPendingLabel => 'In Bearbeitung';

  @override
  String get dailymartRefundProcessedLabel => 'Erstattet';

  @override
  String get dailymartRefundFailedLabel => 'Fehlgeschlagen';

  @override
  String get dailymartOrderStatusTitle => 'Bestellstatus';

  @override
  String get dailymartOrderStepPlacedLabel => 'Aufgegeben';

  @override
  String get dailymartOrderStepOnTheWayLabel => 'Unterwegs';

  @override
  String get dailymartOrderStepDeliveredLabel => 'Geliefert';

  @override
  String get dailymartOrderStepCancelledLabel => 'Storniert';

  @override
  String get dailymartOrderStepUndatedLabel => 'Zeit nicht erfasst';

  @override
  String get dailymartOrderStepPendingLabel => 'Ausstehend';

  @override
  String get dailymartCancelOrderLabel => 'Bestellung stornieren';

  @override
  String get dailymartCancelOrderTitle => 'Diese Bestellung stornieren?';

  @override
  String get dailymartCancelOrderMessage =>
      'Bereits bezahlte Beträge werden zurückerstattet.';

  @override
  String get dailymartCancelOrderConfirmLabel => 'Bestellung stornieren';

  @override
  String get dailymartCancelLabel => 'Abbrechen';

  @override
  String grofastGreeting(String name) {
    return 'Hallo $name 👋';
  }

  @override
  String get grofastGreetingFallbackName => 'Gast';

  @override
  String get grofastGreetingSubtitle => 'Frische Lebensmittel entdecken';

  @override
  String get grofastSearchHint => 'Frische Lebensmittel suchen';

  @override
  String get grofastCategoriesTitle => 'Kategorien';

  @override
  String get grofastPopularTitle => 'Beliebt';

  @override
  String get grofastSeeAll => 'alle ansehen';

  @override
  String get grofastHomeLoadErrorMessage =>
      'Katalog dieses Shops konnte nicht geladen werden.';

  @override
  String get grofastNoLocationSelectedLabel => 'Standort wählen';

  @override
  String get grofastClaimNow => 'jetzt einlösen';

  @override
  String grofastPromoDiscountLabel(String percent) {
    return '$percent Rabatt';
  }

  @override
  String get grofastCategoriesLoadErrorMessage =>
      'Kategorien konnten nicht geladen werden.';

  @override
  String get grofastCategoriesEmptyTitle => 'Noch keine Kategorien';

  @override
  String get grofastCategoriesEmptySubtitle =>
      'Dieser Shop hat noch keine Kategorien veröffentlicht.';

  @override
  String grofastCategoryProductsTitle(String category) {
    return 'Alle $category';
  }

  @override
  String get grofastCategoryDetailsEmptyTitle => 'Noch nichts hier';

  @override
  String get grofastCategoryDetailsEmptySubtitle =>
      'Derzeit keine Produkte in dieser Kategorie.';

  @override
  String get grofastCategoryDetailsErrorMessage =>
      'Kategorie konnte nicht geladen werden.';

  @override
  String get grofastSearchTitle => 'Lebensmittel suchen';

  @override
  String get grofastRecentSearchTitle => 'Letzte Suchen';

  @override
  String grofastResultsCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Ergebnisse',
      one: '$count Ergebnis',
    );
    return '$_temp0 gefunden';
  }

  @override
  String get grofastSearchLoadErrorMessage =>
      'Suche konnte nicht geladen werden.';

  @override
  String get grofastSearchResultsErrorMessage =>
      'Suche in diesem Shop fehlgeschlagen.';

  @override
  String get grofastSearchNoResultsTitle => 'Keine Ergebnisse';

  @override
  String grofastSearchNoResultsSubtitle(String query) {
    return 'Keine Treffer für „$query“. Versuchen Sie ein anderes Wort.';
  }

  @override
  String get grofastSearchIdleTitle => 'Was suchen Sie?';

  @override
  String get grofastSearchIdleSubtitle =>
      'Ganzen Shop nach Name oder Kategorie durchsuchen.';

  @override
  String get grofastSortByTitle => 'Sortieren nach';

  @override
  String get grofastPriceTitle => 'Preis';

  @override
  String get grofastApplyLabel => 'Übernehmen';

  @override
  String get grofastResetLabel => 'Zurücksetzen';

  @override
  String get grofastAddToBagTooltip => 'In den Warenkorb';

  @override
  String get grofastFavouriteTooltip => 'Auf die Merkliste';

  @override
  String get grofastDecreaseQuantityLabel => 'Menge verringern';

  @override
  String get grofastIncreaseQuantityLabel => 'Menge erhöhen';

  @override
  String get grofastProductDetailsTitle => 'Produktdetails';

  @override
  String get grofastDescriptionTitle => 'Beschreibung';

  @override
  String get grofastSelectSizeTitle => 'Größe wählen';

  @override
  String get grofastAddToBag => 'In den Warenkorb';

  @override
  String get grofastProductDetailsLoadErrorMessage =>
      'Produkt konnte gerade nicht geladen werden.';

  @override
  String grofastAddedToBagMessage(int count, String name) {
    return '$count × $name in den Warenkorb gelegt.';
  }

  @override
  String get grofastNoDescriptionLabel =>
      'Noch keine Beschreibung für dieses Produkt.';

  @override
  String get grofastBagTitle => 'Mein Warenkorb';

  @override
  String grofastBagItemCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Artikel',
      one: '$count Artikel',
    );
    return '$_temp0';
  }

  @override
  String get grofastPromoCodeHint => 'Gutscheincode eingeben';

  @override
  String get grofastPromoApplyLabel => 'Übernehmen';

  @override
  String get grofastPromoRemoveLabel => 'Entfernen';

  @override
  String get grofastCouponDetailLabel => 'Gutschein';

  @override
  String grofastPromoApplied(String code) {
    return '$code übernommen';
  }

  @override
  String grofastCouponLine(String code) {
    return 'Gutschein ($code)';
  }

  @override
  String get grofastPromoComingSoonMessage =>
      'Gutscheincodes sind demnächst verfügbar.';

  @override
  String get grofastTotalLabel => 'Gesamtsumme';

  @override
  String get grofastSubtotalLabel => 'Zwischensumme';

  @override
  String get grofastDiscountLabel => 'Rabatt';

  @override
  String get grofastProceedToCheckoutLabel => 'Zur Kasse';

  @override
  String get grofastBagEmptyTitle => 'Ihr Warenkorb ist leer';

  @override
  String get grofastBagEmptySubtitle =>
      'Legen Sie frische Lebensmittel hinein – sie erscheinen hier.';

  @override
  String get grofastBagExploreAction => 'Jetzt einkaufen';

  @override
  String get grofastRemovedFromBagMessage => 'Aus dem Warenkorb entfernt.';

  @override
  String get grofastCheckoutTitle => 'Kasse';

  @override
  String get grofastItemsTitle => 'Artikel';

  @override
  String get grofastDeliveryAddressTitle => 'Lieferadresse';

  @override
  String get grofastAddNewLabel => 'neu hinzufügen';

  @override
  String get grofastChangeAddressLabel => 'ändern';

  @override
  String get grofastNoAddressSelectedLabel => 'Lieferort wählen';

  @override
  String get grofastConfirmOrderLabel => 'Bestellung bestätigen';

  @override
  String get grofastOrderPlacedTitle => 'Erfolgreich!';

  @override
  String get grofastOrderPlacedMessage => 'Ihre Bestellung wurde aufgegeben.';

  @override
  String get grofastBrowseHomeLabel => 'Zur Startseite';

  @override
  String get grofastNavHome => 'Start';

  @override
  String get grofastNavCategories => 'Kategorien';

  @override
  String get grofastNavBag => 'Warenkorb';

  @override
  String get grofastNavAccount => 'Konto';

  @override
  String get grofastProfileTitle => 'Profil';

  @override
  String get grofastNotificationTileLabel => 'Benachrichtigung';

  @override
  String get grofastOrdersTileLabel => 'Meine Bestellungen';

  @override
  String get grofastWishlistTileLabel => 'Merkliste';

  @override
  String get grofastMyProfileLabel => 'Mein Profil';

  @override
  String get grofastChangePasswordLabel => 'Passwort ändern';

  @override
  String get grofastDarkModeLabel => 'Dunkelmodus';

  @override
  String get grofastMyAddressLabel => 'Meine Adressen';

  @override
  String get grofastPrivacyPolicyLabel => 'Datenschutzerklärung';

  @override
  String get grofastTermsAndConditionsLabel => 'AGB';

  @override
  String get grofastLogOutLabel => 'Abmelden';

  @override
  String get grofastLogOutTitle => 'Abmelden?';

  @override
  String get grofastLogOutConfirmMessage =>
      'Zum Bestellen müssen Sie sich erneut anmelden.';

  @override
  String get grofastProfileLoadErrorMessage =>
      'Profil konnte nicht geladen werden.';

  @override
  String get grofastProfileNameFallback => 'Ihr Konto';

  @override
  String get grofastEditProfileTitle => 'Mein Profil';

  @override
  String get grofastFullNameLabel => 'Vollständiger Name';

  @override
  String get grofastFullNameHint => 'Vollständigen Namen eingeben';

  @override
  String get grofastEmailLabel => 'E-Mail';

  @override
  String get grofastEmailHint => 'sie@beispiel.de';

  @override
  String get grofastPhoneNumberLabel => 'Telefonnummer';

  @override
  String get grofastPhoneNumberHint => 'Telefonnummer eingeben';

  @override
  String get grofastSaveChangesLabel => 'Änderungen speichern';

  @override
  String get grofastChangePhotoTitle => 'Foto ändern';

  @override
  String get grofastTakePhotoLabel => 'Foto aufnehmen';

  @override
  String get grofastChooseFromGalleryLabel => 'Aus Galerie wählen';

  @override
  String get grofastAvatarPickerMobileOnlyMessage =>
      'Fotoauswahl ist nur auf dem Smartphone verfügbar.';

  @override
  String get grofastProfileUpdatedMessage => 'Ihr Profil wurde aktualisiert.';

  @override
  String get grofastChangePasswordTitle => 'Passwort ändern';

  @override
  String get grofastCurrentPasswordLabel => 'Aktuelles Passwort';

  @override
  String get grofastCurrentPasswordHint => 'Aktuelles Passwort eingeben';

  @override
  String get grofastNewPasswordLabel => 'Neues Passwort';

  @override
  String get grofastNewPasswordHint => 'Neues Passwort eingeben';

  @override
  String get grofastConfirmNewPasswordLabel => 'Neues Passwort bestätigen';

  @override
  String get grofastConfirmNewPasswordHint => 'Neues Passwort erneut eingeben';

  @override
  String get grofastUpdatePasswordButtonLabel => 'Passwort aktualisieren';

  @override
  String get grofastPasswordUpdatedMessage =>
      'Ihr Passwort wurde aktualisiert.';

  @override
  String get grofastWishlistTitle => 'Merkliste';

  @override
  String get grofastWishlistEmptyTitle => 'Noch nichts gespeichert';

  @override
  String get grofastWishlistEmptySubtitle =>
      'Tippen Sie auf das Herz, um Artikel zu merken.';

  @override
  String get grofastWishlistExploreAction => 'Jetzt einkaufen';

  @override
  String get grofastNotificationsTitle => 'Benachrichtigungen';

  @override
  String get grofastNotificationsFilterAllLabel => 'Alle';

  @override
  String get grofastNotificationsSearchHint => 'Benachrichtigungen suchen';

  @override
  String get grofastNotificationsNowTitle => 'Jetzt';

  @override
  String get grofastNotificationsPastTitle => 'Früher';

  @override
  String get grofastNotificationsLoadErrorMessage =>
      'Benachrichtigungen konnten nicht geladen werden.';

  @override
  String get grofastNotificationsEmptyTitle => 'Noch keine Benachrichtigungen';

  @override
  String get grofastNotificationsEmptySubtitle =>
      'Wir informieren Sie über Neues zu Ihren Bestellungen.';

  @override
  String get grofastNotificationsNoResultsTitle => 'Nichts gefunden';

  @override
  String grofastNotificationsNoResultsSubtitle(String query) {
    return 'Keine Benachrichtigung passt zu „$query“.';
  }

  @override
  String get grofastSelectAddressTitle => 'Standort wählen';

  @override
  String get grofastAddNewAddressLabel => 'Neue Adresse hinzufügen';

  @override
  String get grofastAddressLoadErrorMessage =>
      'Adressen konnten nicht geladen werden.';

  @override
  String get grofastAddressEmptyTitle => 'Keine gespeicherten Adressen';

  @override
  String get grofastAddressEmptySubtitle =>
      'Fügen Sie eine hinzu, damit wir wissen, wohin geliefert wird.';

  @override
  String get grofastAddressSaveFailedMessage =>
      'Adresse konnte nicht gespeichert werden.';

  @override
  String get grofastAddressDeleteFailedMessage =>
      'Adresse konnte nicht gelöscht werden.';

  @override
  String get grofastEditAddressTooltip => 'Adresse bearbeiten';

  @override
  String get grofastDeleteAddressTitle => 'Diese Adresse löschen?';

  @override
  String get grofastDeleteAddressMessage =>
      'Sie wird aus Ihren gespeicherten Standorten entfernt. Das kann nicht rückgängig gemacht werden.';

  @override
  String get grofastDeleteLabel => 'Löschen';

  @override
  String get grofastCancelLabel => 'Abbrechen';

  @override
  String get grofastAddAddressTitle => 'Neue Adresse hinzufügen';

  @override
  String get grofastEditAddressTitle => 'Adresse bearbeiten';

  @override
  String get grofastAddressNameLabel => 'Name';

  @override
  String get grofastAddressNameHint => 'z. B. Yona Angela';

  @override
  String get grofastAddressLine1Label => 'Adresszeile 1';

  @override
  String get grofastAddressLine1Hint => 'Hausnr., Straße';

  @override
  String get grofastAddressLine2Label => 'Adresszeile 2';

  @override
  String get grofastAddressLine2Hint => 'Wohnung, Etage usw. (optional)';

  @override
  String get grofastLandmarkLabel => 'Orientierungspunkt';

  @override
  String get grofastLandmarkHint => 'Orientierungspunkt in der Nähe (optional)';

  @override
  String get grofastCityLabel => 'Stadt';

  @override
  String get grofastCityHint => 'z. B. Bengaluru';

  @override
  String get grofastStateLabel => 'Bundesland';

  @override
  String get grofastStateHint => 'z. B. Karnataka (optional)';

  @override
  String get grofastCountryLabel => 'Land';

  @override
  String get grofastSelectCountryTitle => 'Land wählen';

  @override
  String get grofastPostalCodeLabel => 'Postleitzahl';

  @override
  String get grofastPostalCodeHint => 'z. B. 62639';

  @override
  String get grofastAddressTagLabel => 'Bezeichnung';

  @override
  String get grofastAddressTagHint => 'z. B. Zuhause, Büro';

  @override
  String get grofastMobileLabel => 'Mobilnummer';

  @override
  String get grofastMobileHint => 'Wo wir Sie erreichen';

  @override
  String get grofastAddAddressButtonLabel => 'Adresse hinzufügen';

  @override
  String get grofastUpdateAddressButtonLabel => 'Adresse aktualisieren';

  @override
  String get grofastRequiredFieldErrorMessage => 'Pflichtfeld';

  @override
  String get grofastMyOrdersTitle => 'Meine Bestellungen';

  @override
  String get grofastOrdersSearchHint => 'Bestellungen suchen';

  @override
  String get grofastOrdersFilterAllLabel => 'Alle';

  @override
  String get grofastOrdersFilterActiveLabel => 'Unterwegs';

  @override
  String get grofastOrdersFilterCompletedLabel => 'Geliefert';

  @override
  String get grofastOrdersFilterCancelledLabel => 'Storniert';

  @override
  String get grofastOrdersDateFilterTitle => 'Nach Datum filtern';

  @override
  String get grofastOrdersDateRangeLabel => 'Zeitraum';

  @override
  String get grofastOrdersAllTimeLabel => 'Alle';

  @override
  String get grofastOrdersFilterLastWeekLabel => 'Letzte Woche';

  @override
  String get grofastOrdersFilterLastMonthLabel => 'Letzter Monat';

  @override
  String get grofastOrdersLoadErrorMessage =>
      'Bestellungen konnten nicht geladen werden.';

  @override
  String get grofastOrdersRefreshFailedMessage =>
      'Bestellungen konnten nicht aktualisiert werden.';

  @override
  String get grofastOrdersEmptyTitle => 'Noch keine Bestellungen';

  @override
  String get grofastOrdersEmptySubtitle =>
      'Ihre Bestellungen erscheinen hier, sobald Sie eine aufgeben.';

  @override
  String get grofastOrdersNoResultsTitle => 'Nichts gefunden';

  @override
  String get grofastOrdersNoResultsSubtitle =>
      'Keine Bestellung passt zu diesen Filtern. Erweitern Sie sie.';

  @override
  String grofastOrderNumberLabel(String date) {
    return 'Bestellung $date';
  }

  @override
  String grofastOrderItemCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Artikel',
      one: '$count Artikel',
    );
    return '$_temp0';
  }

  @override
  String grofastOrderDeliveredLine(String label) {
    return 'Geliefert an $label';
  }

  @override
  String grofastOrderDeliveringLine(String label) {
    return 'Unterwegs zu $label';
  }

  @override
  String get grofastOrderCancelledLine => 'Diese Bestellung wurde storniert';

  @override
  String get grofastTrackOrderTitle => 'Bestellung verfolgen';

  @override
  String get grofastOrderDetailTitle => 'Bestelldetails';

  @override
  String get grofastCopyTooltip => 'Kopieren';

  @override
  String grofastCopiedMessage(String label) {
    return '$label kopiert.';
  }

  @override
  String get grofastTrackingDetailTitle => 'Sendungsdetails';

  @override
  String get grofastOrderStatusLabel => 'Status';

  @override
  String get grofastPurchaseDateLabel => 'Kaufdatum';

  @override
  String get grofastOrderIdLabel => 'Bestellnummer';

  @override
  String get grofastDeliveryOtpLabel => 'Liefer-OTP';

  @override
  String get grofastPaymentIdLabel => 'Zahlungs-ID';

  @override
  String get grofastAmountPaidLabel => 'Bezahlter Betrag';

  @override
  String get grofastNoOnlinePaymentLabel => 'Nicht online bezahlt';

  @override
  String get grofastRefundLabel => 'Rückerstattung';

  @override
  String get grofastOrderReceivedLabel => 'Bestellung erhalten';

  @override
  String get grofastCancelOrderLabel => 'Bestellung stornieren';

  @override
  String get grofastCancelOrderTitle => 'Diese Bestellung stornieren?';

  @override
  String get grofastCancelOrderMessage =>
      'Bezahlte Beträge werden zurückerstattet. Das kann nicht rückgängig gemacht werden.';

  @override
  String get grofastCancelOrderConfirmLabel => 'Bestellung stornieren';

  @override
  String get grofastOrderCancelFailedMessage =>
      'Bestellung konnte nicht storniert werden.';

  @override
  String get grofastOrderStepUndatedLabel => 'Zeit nicht erfasst';

  @override
  String get grofastOrderStepPendingLabel => 'Ausstehend';

  @override
  String get grofastStatusPlacedLabel => 'Aufgegeben';

  @override
  String get grofastStatusOnDeliveryLabel => 'Unterwegs';

  @override
  String get grofastStatusDeliveredLabel => 'Geliefert';

  @override
  String get grofastStatusCancelledLabel => 'Storniert';

  @override
  String get grofastRefundPendingLabel => 'Rückerstattung unterwegs';

  @override
  String get grofastRefundProcessedLabel => 'Zurückerstattet';

  @override
  String get grofastRefundFailedLabel => 'Fehlgeschlagen';

  @override
  String get validationNameRequired => 'Bitte geben Sie Ihren Namen ein.';

  @override
  String get validationEmailRequired =>
      'Bitte geben Sie Ihre E-Mail-Adresse ein.';

  @override
  String get validationEmailInvalid =>
      'Geben Sie eine gültige E-Mail-Adresse ein.';

  @override
  String get validationMobileRequired =>
      'Bitte geben Sie Ihre Mobilnummer ein.';

  @override
  String get validationMobileInvalid =>
      'Geben Sie eine gültige Mobilnummer ein.';

  @override
  String get validationPasswordRequired => 'Bitte geben Sie Ihr Passwort ein.';

  @override
  String get validationWeakPassword =>
      'Das Passwort muss mindestens 6 Zeichen lang sein.';

  @override
  String get validationConfirmPasswordRequired =>
      'Bitte bestätigen Sie Ihr neues Passwort.';

  @override
  String get validationPasswordsDontMatch =>
      'Die Passwörter stimmen nicht überein.';

  @override
  String get retryButton => 'Erneut versuchen';
}
