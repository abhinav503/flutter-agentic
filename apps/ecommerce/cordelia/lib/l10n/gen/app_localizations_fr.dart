// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get noConnectionMessage =>
      'Pas de connexion Internet. Vérifiez votre réseau et réessayez.';

  @override
  String get languageSheetTitle => 'Langue';

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
      other: 'unités',
      one: 'unité',
    );
    return '$_temp0';
  }

  @override
  String get loginTitle => 'Bienvenue sur CordeliaApps';

  @override
  String get loginSubtitle =>
      'Connectez-vous à votre compte avec votre e-mail ou vos réseaux sociaux';

  @override
  String get emailLabel => 'Adresse e-mail';

  @override
  String get emailHint => 'vous@exemple.com';

  @override
  String get passwordLabel => 'Mot de passe';

  @override
  String get passwordHint => 'Saisissez votre mot de passe';

  @override
  String get forgotPasswordLabel => 'Mot de passe oublié ?';

  @override
  String passwordResetEmailSentMessage(String email) {
    return 'Lien de réinitialisation du mot de passe envoyé à $email';
  }

  @override
  String get continueLabel => 'Continuer';

  @override
  String get byContinuingAgree => 'En continuant, vous acceptez nos';

  @override
  String get termsOfServiceAndPrivacyPolicy =>
      'CGU et Politique de confidentialité';

  @override
  String get dontHaveAccount => 'Vous n\'avez pas de compte ? ';

  @override
  String get signupLink => 'S\'inscrire';

  @override
  String get signupTitle => 'Créez votre compte';

  @override
  String get signupSubtitle => 'Saisissez vos informations ci-dessous';

  @override
  String get nameLabel => 'Nom';

  @override
  String get nameHint => 'ex. Mark Shelby';

  @override
  String get mobileLabel => 'Numéro de mobile';

  @override
  String get mobileHint => '(303) 555-0105';

  @override
  String get iAgreeLabel => 'J\'accepte les ';

  @override
  String get termsAndConditionsLink => 'CGU';

  @override
  String get mustAgreeToTermsMessage =>
      'Veuillez accepter les CGU pour continuer.';

  @override
  String get authWebUnsupportedMessage =>
      'La connexion n\'est disponible que sur mobile.';

  @override
  String get sessionExpiredMessage =>
      'Votre session a expiré. Veuillez vous reconnecter.';

  @override
  String get signupButtonLabel => 'S\'inscrire';

  @override
  String get alreadyHaveAccount => 'Vous avez déjà un compte ? ';

  @override
  String get loginLink => 'Se connecter';

  @override
  String get comingSoonMessage => 'Bientôt disponible';

  @override
  String get deliveryUnavailableMessage =>
      'Cette boutique ne livre pas à l\'adresse sélectionnée.';

  @override
  String get paymentCancelledMessage => 'Paiement annulé';

  @override
  String couponMinOrderMessage(String price) {
    return 'Votre commande est inférieure au minimum de $price requis pour ce code promo';
  }

  @override
  String get paymentFailedMessage =>
      'Le paiement n\'a pas pu être finalisé. Veuillez réessayer.';

  @override
  String get verifyEmailTitle => 'Vérifiez votre e-mail';

  @override
  String verifyEmailSubtitle(String email) {
    return 'Nous avons envoyé un lien de vérification à $email. Ouvrez-le, puis revenez ici — cette page se mettra à jour automatiquement.';
  }

  @override
  String get verifyEmailChecking => 'Vérification…';

  @override
  String get resendEmailLabel => 'Renvoyer l\'e-mail';

  @override
  String get termsAndConditionsLabel => 'CGU';

  @override
  String get privacyPolicyLabel => 'Politique de confidentialité';

  @override
  String get legalLastUpdatedLabel => 'Dernière mise à jour : 6 août 2026';

  @override
  String get termsAndConditionsIntro =>
      'Ces conditions s\'appliquent chaque fois que vous utilisez l\'application CordeliaApps. Veuillez les lire avant de commander — créer un compte ou passer une commande vaut acceptation.';

  @override
  String get termsAndConditionsSection1Heading => '1. Qui nous sommes';

  @override
  String get termsAndConditionsSection1Body =>
      'CordeliaApps conçoit et exploite cette application d\'achat. Nous sommes établis en Inde et travaillons avec des commerces en Inde, au Royaume-Uni, aux États-Unis et partout en Europe. L\'application est donc disponible en plusieurs langues et affiche les prix dans la devise propre à chaque commerce. En cas de divergence entre une traduction et la version anglaise, la version anglaise prévaut.';

  @override
  String get termsAndConditionsSection2Heading =>
      '2. Notre rôle — auprès de qui vous achetez';

  @override
  String get termsAndConditionsSection2Body =>
      'CordeliaApps est la plateforme, pas le magasin. Chaque produit que vous voyez est mis en ligne, tarifé, vendu et livré par le commerce que vous consultez, et votre contrat d\'achat est conclu avec ce commerce. Nous ne sommes pas le vendeur et nous n\'encaissons pas le prix des marchandises ; les questions portant sur une commande, un produit ou un remboursement sont donc traitées par le commerce, l\'application étant le moyen de le joindre.';

  @override
  String get termsAndConditionsSection3Heading => '3. Votre compte';

  @override
  String get termsAndConditionsSection3Body =>
      'Un compte est nécessaire pour commander. Indiquez des informations exactes, confirmez votre adresse e-mail et gardez votre mot de passe pour vous — tout ce qui est fait depuis votre compte est réputé fait par vous. Vous pouvez supprimer votre compte à tout moment depuis votre profil. Vos commandes passées restent chez les commerces qui les ont honorées, car il s\'agit de leurs propres documents commerciaux.';

  @override
  String get termsAndConditionsSection4Heading => '4. Commandes et paiement';

  @override
  String get termsAndConditionsSection4Body =>
      'Passer une commande constitue une offre d\'achat auprès du commerce. Celui-ci peut la refuser — par exemple si un article est épuisé ou ne peut être livré à votre adresse — et vous rembourse alors intégralement. Les prix sont fixés par le commerce dans sa propre devise et incluent les taxes applicables, sauf mention contraire du commerce. Le paiement est encaissé par le prestataire de paiement du commerce et lui est reversé ; CordeliaApps ne détient jamais votre argent.';

  @override
  String get termsAndConditionsSection5Heading =>
      '5. Livraison, annulation et remboursement';

  @override
  String get termsAndConditionsSection5Body =>
      'Le commerce prépare et livre votre commande, et tout délai de livraison affiché est une estimation, non un engagement. Vous pouvez annuler une commande dans l\'application tant qu\'elle n\'a pas été expédiée, et le commerce vous rembourse sur le moyen de paiement utilisé. Si un remboursement est dû pour une autre raison, c\'est également le commerce qui l\'effectue. Rien de tout cela ne réduit les droits que vous accorde votre législation locale.';

  @override
  String get termsAndConditionsSection6Heading =>
      '6. Informations produits et avis';

  @override
  String get termsAndConditionsSection6Body =>
      'Les commerces rédigent eux-mêmes les noms, descriptions, images et prix de leurs produits, ces informations proviennent donc du commerce et non de nous. Des erreurs peuvent survenir, et un commerce peut corriger une erreur ou annuler et rembourser une commande concernée. Si vous publiez un avis, il doit refléter votre propre expérience — vous restez propriétaire de ce que vous écrivez et vous nous autorisez, ainsi que le commerce, à l\'afficher dans l\'application. Nous pouvons retirer un contenu faux, offensant ou contraire aux présentes conditions.';

  @override
  String get termsAndConditionsSection7Heading => '7. Usage acceptable';

  @override
  String get termsAndConditionsSection7Body =>
      'Utilisez l\'application pour faire vos achats et rien d\'autre. Ne passez pas de commandes frauduleuses, ne créez pas de comptes qui ne sont pas les vôtres, ne collectez pas automatiquement de données, n\'entravez pas le fonctionnement de l\'application et ne l\'utilisez à aucune fin illicite. Nous pouvons suspendre ou fermer un compte qui y contreviendrait.';

  @override
  String get termsAndConditionsSection8Heading =>
      '8. Disponibilité et notre responsabilité';

  @override
  String get termsAndConditionsSection8Body =>
      'Nous nous efforçons de maintenir l\'application en bon état de marche, sans pouvoir garantir qu\'elle sera toujours disponible ni exempte de défauts, et nous pouvons modifier ou retirer des fonctionnalités. Nous sommes responsables de l\'application elle-même. Nous ne sommes pas responsables des marchandises vendues par un commerce, de l\'exactitude de ce qu\'il publie, ni de la manière dont il traite votre commande. Rien ici ne limite une responsabilité que la loi ne permet pas de limiter.';

  @override
  String get termsAndConditionsSection9Heading =>
      '9. Droit applicable et vos droits locaux';

  @override
  String get termsAndConditionsSection9Body =>
      'Les présentes conditions sont régies par le droit indien et les tribunaux indiens sont compétents. Comme nous servons des acheteurs dans d\'autres pays, cela ne vous prive pas de la protection des règles impératives de consommation en vigueur là où vous résidez. Si vous êtes consommateur au Royaume-Uni ou dans l\'Union européenne, vous conservez vos droits légaux locaux, y compris tout droit de rétractation dans le délai prévu par votre législation.';

  @override
  String get termsAndConditionsSection10Heading =>
      '10. Modifications et contact';

  @override
  String get termsAndConditionsSection10Body =>
      'Nous mettons ces conditions à jour à mesure que l\'application évolue, et la date figurant en haut de cette page indique la dernière modification. Continuer à utiliser l\'application après une modification vaut acceptation des conditions mises à jour. Si un point vous semble obscur ou si vous avez besoin d\'aide pour une commande, écrivez-nous à support@cordeliaapps.com.';

  @override
  String get privacyPolicyIntro =>
      'Veuillez lire attentivement cette politique de confidentialité avant d\'utiliser notre application.';

  @override
  String get privacyPolicySection1Heading => '1. Collecte des informations';

  @override
  String get privacyPolicySection1Body =>
      'Nous recueillons les informations essentielles pour améliorer votre expérience. Cela comprend les données que vous nous communiquez directement, comme celles de votre compte, ainsi que les informations issues des analyses d\'utilisation et des cookies.';

  @override
  String get privacyPolicySection2Heading => '2. Utilisation des informations';

  @override
  String get privacyPolicySection2Body =>
      'Les informations collectées servent à améliorer nos services, à vous proposer des recommandations personnalisées et à garantir une expérience fluide. Nous ne partageons jamais vos données sans votre consentement explicite.';

  @override
  String get privacyPolicySection3Heading => '3. Paramètres des informations';

  @override
  String get privacyPolicySection3Body =>
      'Vous gardez le contrôle total de vos données. Gérez vos préférences de confidentialité, mettez à jour vos informations personnelles et adaptez vos paramètres à vos besoins.';

  @override
  String get privacyPolicySection4Heading => '4. Mesures de sécurité';

  @override
  String get privacyPolicySection4Body =>
      'Nous plaçons la sécurité de vos données au premier plan grâce à des protocoles avancés, des méthodes de chiffrement et des audits réguliers, afin de prévenir tout accès non autorisé ou toute violation.';

  @override
  String get profilePageTitle => 'Profil';

  @override
  String get changePasswordLabel => 'Modifier le mot de passe';

  @override
  String get myOrdersLabel => 'Mes commandes';

  @override
  String get myAddressLabel => 'Mes adresses';

  @override
  String get darkModeLabel => 'Mode sombre';

  @override
  String get logoutLabel => 'Se déconnecter';

  @override
  String get logoutTitle => 'Se déconnecter';

  @override
  String get logoutConfirmMessage => 'Voulez-vous vraiment vous déconnecter ?';

  @override
  String get deleteAccountLabel => 'Supprimer le compte';

  @override
  String get deleteAccountTitle => 'Supprimer votre compte ?';

  @override
  String get deleteAccountConfirmMessage =>
      'Cette action supprime définitivement votre profil, vos adresses, votre panier, vos favoris et vos avis dans toutes les boutiques. Les commandes que vous avez déjà passées restent chez ces boutiques comme justificatifs de vente. Cette action est irréversible.';

  @override
  String get profileLoadErrorMessage =>
      'Une erreur s\'est produite lors du chargement de votre profil.';

  @override
  String get helpAndSupportLabel => 'Aide et assistance';

  @override
  String get supportIntro =>
      'Dites-nous ce qui s\'est mal passé et nous arrangerons cela.';

  @override
  String supportStoreSectionTitle(String storeName) {
    return 'Contacter $storeName';
  }

  @override
  String get supportStoreSectionSubtitle =>
      'Pour tout ce qui concerne une commande : un article incorrect, une livraison en retard ou un remboursement qui n\'est pas arrivé.';

  @override
  String get supportEmailAction => 'Envoyer un e-mail';

  @override
  String get supportCallAction => 'Appeler';

  @override
  String supportHoursLabel(String hours) {
    return 'Répond $hours';
  }

  @override
  String get supportPlatformSectionTitle => 'CordeliaApps';

  @override
  String get supportPlatformSectionSubtitle =>
      'Pour votre compte, la connexion ou un problème avec l\'application elle-même.';

  @override
  String get supportPlatformOnlySubtitle =>
      'Cette boutique n\'a pas encore publié de contact. Écrivez-nous et nous lui transmettrons tout ce qui concerne une commande.';

  @override
  String get supportPolicySectionTitle => 'Politiques';

  @override
  String get supportRefundPolicyAction => 'Remboursement et annulation';

  @override
  String supportAppVersionLabel(String version) {
    return 'Cordelia $version';
  }

  @override
  String get supportOrderCtaLabel => 'Besoin d\'aide pour cette commande ?';

  @override
  String supportLaunchFailedMessage(String value) {
    return 'Impossible d\'ouvrir cette application. $value a été copié dans le presse-papiers.';
  }

  @override
  String supportEmailSubjectOrder(String orderId) {
    return 'Aide pour la commande $orderId';
  }

  @override
  String supportEmailSubjectStore(String storeName) {
    return 'Aide pour $storeName';
  }

  @override
  String get supportEmailSubjectPlatform => 'Aide pour CordeliaApps';

  @override
  String get supportEmailBodyPrompt => 'Décrivez ce qui s\'est mal passé :';

  @override
  String get supportEmailBodyDetailsHeading =>
      'Informations pour l\'assistance — merci de les laisser.';

  @override
  String get supportEmailOrderLabel => 'Commande';

  @override
  String get supportEmailStoreLabel => 'Boutique';

  @override
  String get supportEmailAccountLabel => 'Compte';

  @override
  String get supportEmailAppLabel => 'Application';

  @override
  String get sortRelevanceLabel => 'Pertinence';

  @override
  String get sortPriceLowToHighLabel => 'Prix (croissant)';

  @override
  String get sortPriceHighToLowLabel => 'Prix (décroissant)';

  @override
  String get sortRatingHighToLowLabel => 'Note (décroissante)';

  @override
  String get sortDiscountHighToLowLabel => 'Remise (décroissante)';

  @override
  String get priceFilterAllLabel => 'Tous les prix';

  @override
  String priceFilterUnderLabel(String price) {
    return 'Moins de $price';
  }

  @override
  String priceFilterOverLabel(String price) {
    return 'Plus de $price';
  }

  @override
  String priceFilterRangeLabel(String from, String to) {
    return '$from - $to';
  }

  @override
  String get reviewsSectionTitle => 'Notes et avis';

  @override
  String get writeReviewLabel => 'Rédiger un avis';

  @override
  String get editReviewLabel => 'Modifier votre avis';

  @override
  String get deleteReviewLabel => 'Supprimer';

  @override
  String get reviewSheetTitle => 'Noter ce produit';

  @override
  String get reviewRatingPrompt => 'Combien d\'étoiles ?';

  @override
  String get reviewTextLabel => 'Votre avis';

  @override
  String get reviewTextHint =>
      'Dites aux autres clients ce que vous en avez pensé…';

  @override
  String get reviewSubmitLabel => 'Envoyer l\'avis';

  @override
  String get reviewMissingRatingMessage =>
      'Choisissez d\'abord une note en étoiles.';

  @override
  String get reviewDeleteConfirmTitle => 'Supprimer votre avis ?';

  @override
  String get reviewDeleteConfirmMessage =>
      'Votre note sera retirée de la moyenne du produit. Vous pouvez en rédiger une nouvelle à tout moment.';

  @override
  String get verifiedPurchaseLabel => 'Achat vérifié';

  @override
  String get reviewsEmptyTitle => 'Aucun avis pour le moment';

  @override
  String get reviewsEmptySubtitle =>
      'Soyez le premier à noter ce produit et aidez les autres clients à se décider.';

  @override
  String get reportReviewLabel => 'Signaler';

  @override
  String get reportReviewSheetTitle => 'Signaler cet avis';

  @override
  String get reportReviewPrompt => 'Pourquoi le signalez-vous ?';

  @override
  String get reportReasonOffensive => 'Injurieux ou offensant';

  @override
  String get reportReasonSpam => 'Spam ou publicité';

  @override
  String get reportReasonIrrelevant => 'Sans rapport avec ce produit';

  @override
  String get reportReasonPersonalInfo => 'Contient des données personnelles';

  @override
  String get reportReviewBlockLabel => 'Masquer aussi les avis de ce client';

  @override
  String get reportReviewSubmitLabel => 'Envoyer le signalement';

  @override
  String get reportReviewMissingReasonMessage =>
      'Choisissez d\'abord un motif.';

  @override
  String get reportReviewSuccessMessage =>
      'Merci — la boutique a été prévenue.';

  @override
  String get unratedLabel => 'Aucune note pour le moment';

  @override
  String get guestLabel => 'Invité';

  @override
  String get locationLocatingLabel => 'Localisation…';

  @override
  String get locationNoAddressMessage =>
      'Aucun code postal trouvé pour votre position.';

  @override
  String get locationServiceOffMessage =>
      'La localisation est désactivée sur cet appareil.';

  @override
  String get locationPermissionDeniedMessage =>
      'L\'autorisation de localisation est désactivée — activez-la dans les Réglages pour voir ce qui est près de vous.';

  @override
  String get locationUnavailableMessage =>
      'Impossible d\'obtenir votre position. Réessayez.';

  @override
  String get outOfStockLabel => 'Rupture de stock';

  @override
  String onlyNLeftLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Plus que $count en stock',
      one: 'Plus qu\'1 en stock',
    );
    return '$_temp0';
  }

  @override
  String get cartUnavailableItemsMessage =>
      'Certains articles de votre panier ne sont plus disponibles. Modifiez votre panier pour continuer.';

  @override
  String productSoldOutMessage(String name) {
    return '$name vient d\'être épuisé. Modifiez votre panier pour continuer.';
  }

  @override
  String productStockReducedMessage(String name) {
    return 'Il ne reste pas assez de $name. Modifiez votre panier pour continuer.';
  }

  @override
  String get checkoutFailedMessage => 'Votre commande n\'a pas pu être passée.';

  @override
  String get paymentRefundedNote => 'Votre paiement a été remboursé.';

  @override
  String get rateOrderLabel => 'Noter la commande';

  @override
  String get editOrderRatingLabel => 'Modifier la note';

  @override
  String get rateOrderSheetTitle => 'Comment s\'est passée cette commande ?';

  @override
  String get rateOrderTextLabel => 'Votre commentaire';

  @override
  String get rateOrderTextHint => 'Comment s\'est passée la livraison ?';

  @override
  String get orderRatingNotDeliveredMessage =>
      'Vous pourrez noter une commande une fois qu\'elle aura été livrée.';

  @override
  String get orderRatingFailedMessage =>
      'Impossible d\'enregistrer votre note. Veuillez réessayer.';

  @override
  String get yourRatingLabel => 'Votre note';

  @override
  String orderPlacedAtLabel(String date, String time) {
    return '$date à $time';
  }

  @override
  String reviewCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count avis',
      one: '$count avis',
    );
    return '$_temp0';
  }

  @override
  String get reviewAgeJustNow => 'À l\'instant';

  @override
  String reviewAgeMinutesAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'il y a $count minutes',
      one: 'il y a $count minute',
    );
    return '$_temp0';
  }

  @override
  String reviewAgeHoursAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'il y a $count heures',
      one: 'il y a $count heure',
    );
    return '$_temp0';
  }

  @override
  String reviewAgeDaysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'il y a $count jours',
      one: 'il y a $count jour',
    );
    return '$_temp0';
  }

  @override
  String reviewAgeMonthsAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'il y a $count mois',
      one: 'il y a $count mois',
    );
    return '$_temp0';
  }

  @override
  String reviewAgeYearsAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'il y a $count ans',
      one: 'il y a $count an',
    );
    return '$_temp0';
  }

  @override
  String get graviaCategoriesTitle => 'Toutes les catégories';

  @override
  String get graviaSeeAll => 'Tout voir';

  @override
  String get graviaPopularItemsTitle => 'Articles populaires';

  @override
  String get graviaHomeLoadErrorMessage =>
      'Impossible de charger le catalogue de cette boutique.';

  @override
  String get graviaCancel => 'Annuler';

  @override
  String graviaDiscountPercentOff(String percent) {
    return '-$percent %';
  }

  @override
  String get graviaAddToCart => 'Ajouter au panier';

  @override
  String get graviaAddToCartSheetTitle => 'Ajouter au panier';

  @override
  String get graviaDeleteLabel => 'Supprimer';

  @override
  String get graviaDeleteAddressTitle => 'Supprimer l\'adresse';

  @override
  String get graviaDeleteAddressConfirmMessage =>
      'Voulez-vous vraiment supprimer cette adresse ? Cette action est irréversible.';

  @override
  String get graviaClearCartTitle => 'Vider le panier';

  @override
  String get graviaClearCartConfirmMessage =>
      'Voulez-vous vraiment retirer tous les articles de votre panier ?';

  @override
  String get graviaClearCartConfirmLabel => 'Vider le panier';

  @override
  String get graviaOrderPlacedTitle => 'Commande passée avec succès';

  @override
  String get graviaOrderPlacedSubtitle =>
      'Merci pour votre commande, vous pouvez suivre votre livraison dans la section des commandes';

  @override
  String get graviaTrackYourOrderLabel => 'Suivre votre commande';

  @override
  String get graviaSearchHint => 'Rechercher';

  @override
  String get graviaNavHome => 'Accueil';

  @override
  String get graviaNavCategories => 'Catégories';

  @override
  String get graviaNavFavourite => 'Favoris';

  @override
  String get graviaNavOrders => 'Commandes';

  @override
  String get graviaNavProfile => 'Profil';

  @override
  String get graviaRecentSearchTitle => 'Recherches récentes';

  @override
  String get graviaSearchLoadErrorMessage =>
      'Une erreur s\'est produite lors du chargement de la recherche.';

  @override
  String get graviaSearchResultsErrorMessage =>
      'Une erreur s\'est produite lors de la recherche.';

  @override
  String get graviaSearchCategoryBadge => 'Catégorie';

  @override
  String get graviaSearchNoResultsTitle => 'Aucun résultat';

  @override
  String graviaSearchNoResultsSubtitle(String query) {
    return 'Aucun résultat pour « $query ». Essayez un autre mot-clé.';
  }

  @override
  String get graviaProductDetailsTitle => 'Détails du produit';

  @override
  String get graviaSelectQtyLabel => 'Choisir la quantité';

  @override
  String get graviaKeyInformationTitle => 'Informations clés';

  @override
  String get graviaReadMore => 'Voir plus';

  @override
  String get graviaReadLess => 'Voir moins';

  @override
  String get graviaSimilarProductsTitle => 'Produits similaires';

  @override
  String get graviaProductDetailsLoadErrorMessage =>
      'Une erreur s\'est produite lors du chargement de ce produit.';

  @override
  String graviaAddToCartWithPrice(String price) {
    return 'Ajouter au panier ($price)';
  }

  @override
  String get graviaCategoriesPageTitle => 'Catégories';

  @override
  String get graviaCategoriesLoadErrorMessage =>
      'Une erreur s\'est produite lors du chargement des catégories.';

  @override
  String get graviaCategoriesRefreshFailedMessage =>
      'Actualisation impossible — affichage de vos dernières catégories chargées.';

  @override
  String get graviaSortLabel => 'Trier';

  @override
  String get graviaPriceLabel => 'Prix';

  @override
  String get graviaSortBySheetTitle => 'Trier par';

  @override
  String get graviaPriceSheetTitle => 'Prix';

  @override
  String get graviaCategoryDetailsEmptyMessage =>
      'Aucun produit ne correspond à ces filtres.';

  @override
  String get graviaSelectAddressTitle => 'Choisir une adresse';

  @override
  String get graviaAddNewAddressLabel => 'Ajouter une adresse';

  @override
  String get graviaDefaultAddressSectionTitle => 'Adresse par défaut';

  @override
  String get graviaOtherAddressSectionTitle => 'Autres adresses';

  @override
  String get graviaEditLabel => 'Modifier';

  @override
  String get graviaAddressLoadErrorMessage =>
      'Une erreur s\'est produite lors du chargement de vos adresses.';

  @override
  String get graviaAddressSaveFailedMessage =>
      'Impossible d\'enregistrer l\'adresse. Veuillez réessayer.';

  @override
  String get graviaAddressDeleteFailedMessage =>
      'Impossible de supprimer l\'adresse. Veuillez réessayer.';

  @override
  String get graviaAddressEmptyTitle => 'Aucune adresse enregistrée';

  @override
  String get graviaAddressEmptySubtitle =>
      'Ajoutez votre première adresse de livraison pour commencer.';

  @override
  String get graviaEditAddressTitle => 'Modifier l\'adresse';

  @override
  String get graviaNameLabel => 'Nom';

  @override
  String get graviaNameHint => 'ex. Mark Shelby';

  @override
  String get graviaPhoneNumberLabel => 'Numéro de téléphone';

  @override
  String get graviaPhoneNumberHint => 'ex. (303) 555-0105';

  @override
  String get graviaAddressLine1Label => 'Adresse ligne 1';

  @override
  String get graviaAddressLine1Hint => 'N° de rue, nom de la rue';

  @override
  String get graviaAddressLine2Label => 'Adresse ligne 2';

  @override
  String get graviaAddressLine2Hint =>
      'Appartement, bâtiment, etc. (facultatif)';

  @override
  String get graviaLandmarkLabel => 'Point de repère';

  @override
  String get graviaLandmarkHint => 'Point de repère à proximité (facultatif)';

  @override
  String get graviaCityLabel => 'Ville';

  @override
  String get graviaCityHint => 'ex. New Delhi';

  @override
  String get graviaStateLabel => 'État';

  @override
  String get graviaStateHint => 'ex. Delhi (facultatif)';

  @override
  String get graviaCountryLabel => 'Pays';

  @override
  String get graviaSelectCountryTitle => 'Choisir un pays';

  @override
  String get graviaPostalCodeLabel => 'Code postal';

  @override
  String get graviaPostalCodeHint => 'ex. 62639';

  @override
  String get graviaAddressTagLabel => 'Libellé';

  @override
  String get graviaAddressTagHint => 'ex. Domicile, Bureau';

  @override
  String get graviaAddAddressButtonLabel => 'Ajouter l\'adresse';

  @override
  String get graviaUpdateAddressButtonLabel => 'Mettre à jour l\'adresse';

  @override
  String get graviaRequiredFieldErrorMessage => 'Ce champ est obligatoire';

  @override
  String get graviaUseMyLocationLabel => 'Utiliser ma position';

  @override
  String get graviaProfilePageTitle => 'Profil';

  @override
  String get graviaChangePasswordLabel => 'Modifier le mot de passe';

  @override
  String get graviaMyOrdersLabel => 'Mes commandes';

  @override
  String get graviaMyAddressLabel => 'Mes adresses';

  @override
  String get graviaDarkModeLabel => 'Mode sombre';

  @override
  String get graviaPrivacyPolicyLabel => 'Politique de confidentialité';

  @override
  String get graviaTermsAndConditionsLabel => 'CGU';

  @override
  String get graviaLogoutLabel => 'Se déconnecter';

  @override
  String get graviaLogoutTitle => 'Se déconnecter';

  @override
  String get graviaLogoutConfirmMessage =>
      'Voulez-vous vraiment vous déconnecter ?';

  @override
  String get graviaProfileLoadErrorMessage =>
      'Une erreur s\'est produite lors du chargement de votre profil.';

  @override
  String get graviaEditProfileTitle => 'Modifier le profil';

  @override
  String get graviaEmailAddressLabel => 'Adresse e-mail';

  @override
  String get graviaEmailAddressHint => 'ex. mark.shelby@example.com';

  @override
  String get graviaMobileNumberLabel => 'Numéro de mobile';

  @override
  String get graviaUpdateProfileButtonLabel => 'Mettre à jour';

  @override
  String get graviaChangePhotoTitle => 'Changer la photo';

  @override
  String get graviaTakePhotoLabel => 'Prendre une photo';

  @override
  String get graviaChooseFromGalleryLabel => 'Choisir dans la galerie';

  @override
  String get graviaAvatarPickerMobileOnlyMessage =>
      'Le changement de photo n\'est disponible que sur mobile';

  @override
  String get graviaChangePasswordTitle => 'Modifier le mot de passe';

  @override
  String get graviaCurrentPasswordLabel => 'Mot de passe actuel';

  @override
  String get graviaCurrentPasswordHint => 'Saisissez votre mot de passe actuel';

  @override
  String get graviaNewPasswordLabel => 'Nouveau mot de passe';

  @override
  String get graviaNewPasswordHint => 'Saisissez votre nouveau mot de passe';

  @override
  String get graviaConfirmNewPasswordLabel =>
      'Confirmer le nouveau mot de passe';

  @override
  String get graviaConfirmNewPasswordHint =>
      'Saisissez à nouveau votre nouveau mot de passe';

  @override
  String get graviaUpdatePasswordButtonLabel => 'Modifier le mot de passe';

  @override
  String get graviaPasswordUpdatedMessage =>
      'Votre mot de passe a été modifié.';

  @override
  String get graviaMyCartTitle => 'Mon panier';

  @override
  String get graviaBeforeYouCheckoutTitle => 'Avant de commander';

  @override
  String get graviaCouponCodeLabel => 'Code promo';

  @override
  String get graviaApplyLabel => 'Appliquer';

  @override
  String get graviaCouponRemoveLabel => 'Retirer';

  @override
  String graviaCouponApplied(String code) {
    return '$code appliqué';
  }

  @override
  String graviaCouponLine(String code) {
    return 'Code promo ($code)';
  }

  @override
  String get graviaItemTotalLabel => 'Total des articles';

  @override
  String get graviaDiscountLabel => 'Remise';

  @override
  String get graviaDeliveryLabel => 'Livraison';

  @override
  String get graviaDeliveryFreeLabel => 'OFFERTE';

  @override
  String get graviaGrandTotalLabel => 'Total général';

  @override
  String get graviaProceedToCheckoutLabel => 'Commander';

  @override
  String get graviaCartEmptyTitle => 'Votre panier est vide';

  @override
  String get graviaCartEmptySubtitle => 'Ajoutez des articles pour commencer.';

  @override
  String get graviaCartBarTitle => 'Voir plus de produits';

  @override
  String get graviaExploreLabel => 'Explorer';

  @override
  String get graviaCheckoutLabel => 'Commander';

  @override
  String graviaCartSummary(int count, String total) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count articles',
      one: '$count article',
    );
    return '$_temp0 | $total';
  }

  @override
  String get graviaOrdersPageTitle => 'Commandes';

  @override
  String get graviaUpcomingTabLabel => 'En cours';

  @override
  String get graviaPastTabLabel => 'Passées';

  @override
  String get graviaPendingStatusLabel => 'Passée';

  @override
  String get graviaInProcessStatusLabel => 'En livraison';

  @override
  String get graviaDeliveredStatusLabel => 'Livrée';

  @override
  String get graviaCancelledStatusLabel => 'Annulée';

  @override
  String get graviaDeliveryOtpLabel => 'Code de livraison';

  @override
  String get graviaCancelOrderLabel => 'Annuler';

  @override
  String get graviaTrackOrderLabel => 'Suivre';

  @override
  String get graviaViewDetailsLabel => 'Voir les détails';

  @override
  String get graviaWriteReviewLabel => 'Rédiger un avis';

  @override
  String get graviaRefundPendingLabel => 'En cours';

  @override
  String get graviaRefundProcessedLabel => 'Remboursée';

  @override
  String get graviaRefundFailedLabel => 'Échec';

  @override
  String get graviaCancelOrderConfirmTitle => 'Annuler cette commande ?';

  @override
  String get graviaCancelOrderConfirmBody =>
      'Votre commande sera annulée. Si vous avez payé, vous serez intégralement remboursé.';

  @override
  String get graviaCancelOrderConfirmCta => 'Annuler la commande';

  @override
  String get graviaCancelOrderDismissCta => 'Conserver';

  @override
  String get graviaCancelFailedMessage =>
      'Impossible d\'annuler la commande. Veuillez réessayer.';

  @override
  String get graviaOrdersLoadErrorMessage =>
      'Une erreur s\'est produite lors du chargement de vos commandes.';

  @override
  String get graviaOrdersRefreshFailedMessage =>
      'Actualisation impossible — affichage de vos dernières commandes chargées.';

  @override
  String get graviaTrackOrderTitle => 'Suivi de commande';

  @override
  String get graviaOrderStatusTitle => 'Statut de la commande';

  @override
  String get graviaOrderItemsTitle => 'Articles';

  @override
  String get graviaOrderSummaryTitle => 'Récapitulatif';

  @override
  String get graviaOrderDetailsTitle => 'Détails de la commande';

  @override
  String get graviaDeliveryAddressTitle => 'Adresse de livraison';

  @override
  String get graviaOrderIdLabel => 'N° de commande';

  @override
  String get graviaOrderPlacedOnLabel => 'Passée le';

  @override
  String get graviaPaymentIdLabel => 'N° de paiement';

  @override
  String get graviaNoOnlinePaymentLabel => 'Aucun paiement en ligne';

  @override
  String get graviaRefundLabel => 'Remboursement';

  @override
  String get graviaCopiedMessage => 'Copié';

  @override
  String get graviaOrderTotalLabel => 'Total payé';

  @override
  String get graviaOrderStepPlacedLabel => 'Commande passée';

  @override
  String get graviaOrderStepOnTheWayLabel => 'En livraison';

  @override
  String get graviaOrderStepDeliveredLabel => 'Livrée';

  @override
  String get graviaOrderStepCancelledLabel => 'Annulée';

  @override
  String get graviaOrderStepUndatedLabel => 'Heure non enregistrée';

  @override
  String get graviaOrdersEmptyTitle => 'Aucune commande';

  @override
  String get graviaOrdersEmptySubtitle =>
      'Vos commandes passées et en cours apparaîtront ici.';

  @override
  String get graviaFilterSheetTitle => 'Filtrer';

  @override
  String get graviaFilterReasonHeading => 'Choisir un motif';

  @override
  String get graviaFilterLastWeekLabel => '7 jours';

  @override
  String get graviaFilterLastMonthLabel => '30 jours';

  @override
  String get graviaFilterStatusLabel => 'Statut';

  @override
  String get graviaFilterDateLabel => 'Date';

  @override
  String get graviaFilterAllStatusesLabel => 'Tous';

  @override
  String get graviaApplyFilterLabel => 'Appliquer';

  @override
  String get graviaFavouritePageTitle => 'Favoris';

  @override
  String get graviaFavouriteEmptyTitle => 'Aucun favori';

  @override
  String get graviaFavouriteEmptySubtitle =>
      'Touchez le cœur d\'un produit pour le conserver ici.';

  @override
  String graviaAddedToCartMessage(int count, String name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count × $name ajoutés au panier',
      one: '$name ajouté au panier',
    );
    return '$_temp0';
  }

  @override
  String get graviaDeliveryLocationLabel => 'Lieu de livraison';

  @override
  String get graviaNoLocationSelectedLabel => 'Aucun lieu sélectionné';

  @override
  String get graviaNotificationsTitle => 'Notifications';

  @override
  String get graviaNotificationsLoadErrorMessage =>
      'Une erreur s\'est produite lors du chargement de vos notifications.';

  @override
  String get graviaNotificationsEmptyTitle => 'Aucune notification';

  @override
  String get graviaNotificationsEmptySubtitle =>
      'Les mises à jour de vos commandes et de votre compte apparaîtront ici.';

  @override
  String get dailymartTopSellerTitle => 'Meilleures ventes🔥';

  @override
  String get dailymartCategoriesTitle => 'Acheter par catégorie';

  @override
  String get dailymartPopularProductsTitle => 'Produits populaires';

  @override
  String get dailymartSeeAll => 'Tout voir';

  @override
  String get dailymartSearchHint => 'Rechercher des produits';

  @override
  String get dailymartHomeLoadErrorMessage =>
      'Impossible de charger le catalogue de cette boutique.';

  @override
  String get dailymartNoLocationSelectedLabel => 'Sélectionner un lieu';

  @override
  String get dailymartNotificationsTitle => 'Notification';

  @override
  String get dailymartNotificationsLoadErrorMessage =>
      'Impossible de charger vos notifications.';

  @override
  String get dailymartNotificationsEmptyTitle =>
      'Aucune notification pour l\'instant';

  @override
  String get dailymartNotificationsEmptySubtitle =>
      'Les offres et le suivi des commandes de cette boutique s\'afficheront ici.';

  @override
  String get dailymartOrderNow => 'Commander';

  @override
  String dailymartPromoSubtitle(String percent) {
    return 'Profitez de remises jusqu\'à $percent %\nsur votre commande aujourd\'hui';
  }

  @override
  String dailymartDiscountPercentOff(String percent) {
    return '$percent % de remise';
  }

  @override
  String get dailymartNavHome => 'Accueil';

  @override
  String get dailymartNavWishlist => 'Favoris';

  @override
  String get dailymartNavCart => 'Panier';

  @override
  String get dailymartNavProfile => 'Profil';

  @override
  String get dailymartRecentSearchTitle => 'Recherches récentes';

  @override
  String get dailymartRecentlyViewedTitle => 'Vus récemment';

  @override
  String dailymartResultsForLabel(String query) {
    return 'Résultat pour « $query »';
  }

  @override
  String dailymartResultsCountLabel(int count) {
    return '$count résultats';
  }

  @override
  String get dailymartSearchLoadErrorMessage =>
      'Impossible de charger la recherche.';

  @override
  String get dailymartSearchResultsErrorMessage =>
      'Impossible d\'effectuer la recherche dans cette boutique.';

  @override
  String get dailymartSearchNoResultsTitle => 'Aucun résultat';

  @override
  String dailymartSearchNoResultsSubtitle(String query) {
    return 'Rien dans cette boutique ne correspond à « $query » pour l\'instant.';
  }

  @override
  String get dailymartCategoryBadge => 'Catégorie';

  @override
  String get dailymartFilterLabel => 'Filtrer';

  @override
  String get dailymartSortSheetTitle => 'Trier par';

  @override
  String get dailymartPriceSheetTitle => 'Prix';

  @override
  String get dailymartCategoryDetailsEmptyTitle => 'Rien ici';

  @override
  String get dailymartCategoryDetailsEmptySubtitle =>
      'Aucun produit de cette catégorie ne correspond à ces filtres.';

  @override
  String get dailymartCategoryDetailsErrorMessage =>
      'Impossible de charger cette catégorie.';

  @override
  String get dailymartWishlistEmptyTitle => 'Aucun favori pour l\'instant';

  @override
  String get dailymartWishlistEmptySubtitle =>
      'Touchez le cœur d\'un produit et il vous attendra ici.';

  @override
  String get dailymartWishlistExploreAction => 'Commencer mes achats';

  @override
  String get dailymartProductDetailsTitle => 'Détails du produit';

  @override
  String get dailymartDescriptionsTabLabel => 'Description';

  @override
  String get dailymartReviewsTabLabel => 'Avis';

  @override
  String get dailymartRelatedProductsTitle => 'Produits similaires';

  @override
  String get dailymartSelectSizeLabel => 'Choisir la taille';

  @override
  String get dailymartProductDetailsLoadErrorMessage =>
      'Impossible de charger les détails de ce produit.';

  @override
  String get dailymartAddToCart => 'Ajouter au panier';

  @override
  String get dailymartAddToCartSheetTitle => 'Ajouter au panier';

  @override
  String dailymartAddedToCartMessage(int count, String name) {
    return 'Ajout de $count × $name à votre panier.';
  }

  @override
  String dailymartStarRowLabel(int stars) {
    return '$stars étoiles';
  }

  @override
  String get dailymartMyCartTitle => 'Mon panier';

  @override
  String get dailymartCouponHint => 'Saisir le code promo';

  @override
  String get dailymartCouponRemoveLabel => 'Retirer';

  @override
  String get dailymartCouponDetailLabel => 'Code promo';

  @override
  String dailymartCouponApplied(String code) {
    return '$code appliqué';
  }

  @override
  String dailymartCouponLine(String code) {
    return 'Code promo ($code)';
  }

  @override
  String get dailymartSubTotalLabel => 'Sous-total';

  @override
  String get dailymartDeliveryLabel => 'Livraison';

  @override
  String get dailymartDeliveryFreeLabel => 'Gratuite';

  @override
  String get dailymartDiscountLabel => 'Remise';

  @override
  String get dailymartTotalCostLabel => 'Coût total';

  @override
  String get dailymartProceedToCheckoutLabel => 'Commander';

  @override
  String get dailymartCartEmptyTitle => 'Votre panier est vide';

  @override
  String get dailymartCartEmptySubtitle =>
      'Les produits que vous ajoutez s\'afficheront ici, prêts à être commandés.';

  @override
  String get dailymartCartExploreAction => 'Commencer mes achats';

  @override
  String get dailymartRemovedFromCartMessage => 'Retiré de votre panier.';

  @override
  String get dailymartCheckoutTitle => 'Commande';

  @override
  String get dailymartShippingAddressLabel => 'Adresse de livraison';

  @override
  String get dailymartOrderListLabel => 'Liste des articles';

  @override
  String get dailymartContinueToPaymentLabel => 'Continuer vers le paiement';

  @override
  String get dailymartOrderPlacedTitle => 'Paiement réussi !';

  @override
  String get dailymartOrderPlacedMessage =>
      'Merci pour votre achat ! Nous avons le plaisir de vous informer que votre paiement a bien été traité. 🎉';

  @override
  String get dailymartTrackOrderLabel => 'Suivre ma commande';

  @override
  String dailymartCartSummary(int count, String total) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count articles',
      one: '$count article',
    );
    return '$_temp0 | $total';
  }

  @override
  String get dailymartViewCartLabel => 'Voir le panier';

  @override
  String get dailymartGeneralSectionTitle => 'Général';

  @override
  String get dailymartPreferencesSectionTitle => 'Préférences';

  @override
  String get dailymartEditProfileLabel => 'Modifier le profil';

  @override
  String get dailymartChangePasswordLabel => 'Modifier le mot de passe';

  @override
  String get dailymartMyOrdersLabel => 'Mes commandes';

  @override
  String get dailymartMyAddressLabel => 'Mes adresses';

  @override
  String get dailymartDarkModeLabel => 'Mode sombre';

  @override
  String get dailymartPrivacyPolicyLabel => 'Politique de confidentialité';

  @override
  String get dailymartTermsAndConditionsLabel => 'CGU';

  @override
  String get dailymartLogoutLabel => 'Se déconnecter';

  @override
  String get dailymartLogoutTitle => 'Se déconnecter ?';

  @override
  String get dailymartLogoutConfirmMessage =>
      'Vous devrez vous reconnecter pour passer une commande ou en suivre une.';

  @override
  String get dailymartProfileLoadErrorMessage =>
      'Impossible de charger votre profil.';

  @override
  String get dailymartEditProfileTitle => 'Modifier le profil';

  @override
  String get dailymartFullNameLabel => 'Nom complet';

  @override
  String get dailymartFullNameHint => 'Saisissez votre nom complet';

  @override
  String get dailymartEmailLabel => 'E-mail';

  @override
  String get dailymartEmailHint => 'vous@exemple.com';

  @override
  String get dailymartPhoneNumberLabel => 'Numéro de téléphone';

  @override
  String get dailymartPhoneNumberHint => 'Saisissez votre numéro de téléphone';

  @override
  String get dailymartSaveChangesLabel => 'Enregistrer les modifications';

  @override
  String get dailymartChangePhotoTitle => 'Changer la photo';

  @override
  String get dailymartTakePhotoLabel => 'Prendre une photo';

  @override
  String get dailymartChooseFromGalleryLabel => 'Choisir dans la galerie';

  @override
  String get dailymartAvatarPickerMobileOnlyMessage =>
      'Le choix d\'une photo est disponible uniquement sur mobile.';

  @override
  String get dailymartChangePasswordTitle => 'Modifier le mot de passe';

  @override
  String get dailymartCurrentPasswordLabel => 'Mot de passe actuel';

  @override
  String get dailymartCurrentPasswordHint =>
      'Saisissez votre mot de passe actuel';

  @override
  String get dailymartNewPasswordLabel => 'Nouveau mot de passe';

  @override
  String get dailymartNewPasswordHint => 'Saisissez votre nouveau mot de passe';

  @override
  String get dailymartConfirmNewPasswordLabel =>
      'Confirmer le nouveau mot de passe';

  @override
  String get dailymartConfirmNewPasswordHint =>
      'Ressaisissez votre nouveau mot de passe';

  @override
  String get dailymartUpdatePasswordButtonLabel =>
      'Mettre à jour le mot de passe';

  @override
  String get dailymartPasswordUpdatedMessage =>
      'Votre mot de passe a été mis à jour.';

  @override
  String get dailymartSelectAddressTitle => 'Choisir une adresse';

  @override
  String get dailymartAddNewAddressLabel => 'Ajouter une adresse';

  @override
  String get dailymartAddressLoadErrorMessage =>
      'Impossible de charger vos adresses.';

  @override
  String get dailymartAddressSaveFailedMessage =>
      'Impossible d\'enregistrer cette adresse.';

  @override
  String get dailymartAddressEmptyTitle => 'Aucune adresse enregistrée';

  @override
  String get dailymartAddressEmptySubtitle =>
      'Ajoutez-en une pour que cette boutique livre à votre porte.';

  @override
  String get dailymartAddressDeleteFailedMessage =>
      'Impossible de supprimer cette adresse.';

  @override
  String get dailymartEditAddressTooltip => 'Modifier l\'adresse';

  @override
  String get dailymartDeleteAddressTitle => 'Supprimer cette adresse ?';

  @override
  String get dailymartDeleteAddressMessage =>
      'Elle sera retirée de vos adresses enregistrées.';

  @override
  String get dailymartDeleteLabel => 'Supprimer';

  @override
  String get dailymartAddAddressTitle => 'Ajouter une adresse';

  @override
  String get dailymartEditAddressTitle => 'Modifier l\'adresse';

  @override
  String get dailymartAddressNameLabel => 'Nom';

  @override
  String get dailymartAddressNameHint => 'ex. : Mark Shelby';

  @override
  String get dailymartAddressLine1Label => 'Adresse ligne 1';

  @override
  String get dailymartAddressLine1Hint => 'N° et nom de rue';

  @override
  String get dailymartAddressLine2Label => 'Adresse ligne 2';

  @override
  String get dailymartAddressLine2Hint =>
      'Appartement, bureau, etc. (facultatif)';

  @override
  String get dailymartLandmarkLabel => 'Point de repère';

  @override
  String get dailymartLandmarkHint => 'Point de repère proche (facultatif)';

  @override
  String get dailymartCityLabel => 'Ville';

  @override
  String get dailymartCityHint => 'ex. : New Delhi';

  @override
  String get dailymartStateLabel => 'État';

  @override
  String get dailymartStateHint => 'ex. : Delhi (facultatif)';

  @override
  String get dailymartCountryLabel => 'Pays';

  @override
  String get dailymartSelectCountryTitle => 'Choisir un pays';

  @override
  String get dailymartPostalCodeLabel => 'Code postal';

  @override
  String get dailymartPostalCodeHint => 'ex. : 62639';

  @override
  String get dailymartAddressTagLabel => 'Étiquette';

  @override
  String get dailymartAddressTagHint => 'ex. : Domicile, Bureau';

  @override
  String get dailymartAddAddressButtonLabel => 'Ajouter l\'adresse';

  @override
  String get dailymartUpdateAddressButtonLabel => 'Mettre à jour l\'adresse';

  @override
  String get dailymartRequiredFieldErrorMessage => 'Ce champ est obligatoire';

  @override
  String get dailymartMyOrdersTitle => 'Mes commandes';

  @override
  String get dailymartOrdersSearchHint => 'Que recherchez-vous...';

  @override
  String get dailymartOrdersFilterAllLabel => 'Toutes';

  @override
  String get dailymartOrdersFilterActiveLabel => 'En cours';

  @override
  String get dailymartOrdersFilterCompletedLabel => 'Terminées';

  @override
  String get dailymartOrdersFilterCancelledLabel => 'Annulées';

  @override
  String dailymartOrderSummaryLabel(int count, String date) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count articles',
      one: '$count article',
    );
    return '$_temp0 · $date';
  }

  @override
  String get dailymartOrdersDateRangeLabel => 'Période';

  @override
  String get dailymartOrdersAllTimeLabel => 'Tout';

  @override
  String get dailymartOrdersFilterLastWeekLabel => '7 jours';

  @override
  String get dailymartOrdersFilterLastMonthLabel => '30 jours';

  @override
  String get dailymartResetLabel => 'Réinitialiser';

  @override
  String get dailymartApplyLabel => 'Appliquer';

  @override
  String get dailymartOrdersLoadErrorMessage =>
      'Impossible de charger vos commandes.';

  @override
  String get dailymartOrdersEmptyTitle => 'Aucune commande pour l\'instant';

  @override
  String get dailymartOrdersEmptySubtitle =>
      'Vos commandes passées dans cette boutique s\'afficheront ici.';

  @override
  String get dailymartOrdersNoResultsTitle => 'Rien ici';

  @override
  String get dailymartOrdersNoResultsSubtitle =>
      'Aucune commande ne correspond à cette recherche ou à ce filtre.';

  @override
  String get dailymartOrderCancelFailedMessage =>
      'Impossible d\'annuler cette commande.';

  @override
  String get dailymartOrdersRefreshFailedMessage =>
      'Impossible d\'actualiser vos commandes.';

  @override
  String get dailymartTrackOrderTitle => 'Suivi de commande';

  @override
  String get dailymartTrackOrderAction => 'Suivre';

  @override
  String get dailymartOrderDetailsTitle => 'Détails de la commande';

  @override
  String get dailymartOrderIdLabel => 'N° de commande';

  @override
  String get dailymartDeliveryOtpLabel => 'Code de livraison';

  @override
  String get dailymartPaymentTitle => 'Paiement';

  @override
  String get dailymartAmountPaidLabel => 'Montant payé';

  @override
  String get dailymartPaymentIdLabel => 'N° de paiement';

  @override
  String get dailymartRefundLabel => 'Remboursement';

  @override
  String get dailymartCopiedMessage => 'Copié';

  @override
  String get dailymartNoOnlinePaymentLabel => 'Non payé en ligne';

  @override
  String get dailymartRefundPendingLabel => 'En cours';

  @override
  String get dailymartRefundProcessedLabel => 'Remboursée';

  @override
  String get dailymartRefundFailedLabel => 'Échec';

  @override
  String get dailymartOrderStatusTitle => 'Statut de la commande';

  @override
  String get dailymartOrderStepPlacedLabel => 'Passée';

  @override
  String get dailymartOrderStepOnTheWayLabel => 'En livraison';

  @override
  String get dailymartOrderStepDeliveredLabel => 'Livrée';

  @override
  String get dailymartOrderStepCancelledLabel => 'Annulée';

  @override
  String get dailymartOrderStepUndatedLabel => 'Non daté';

  @override
  String get dailymartOrderStepPendingLabel => 'En attente';

  @override
  String get dailymartCancelOrderLabel => 'Annuler';

  @override
  String get dailymartCancelOrderTitle => 'Annuler cette commande ?';

  @override
  String get dailymartCancelOrderMessage =>
      'Le montant vous sera remboursé si la commande a été payée.';

  @override
  String get dailymartCancelOrderConfirmLabel => 'Annuler la commande';

  @override
  String get dailymartCancelLabel => 'Annuler';

  @override
  String grofastGreeting(String name) {
    return 'Bonjour $name 👋';
  }

  @override
  String get grofastGreetingFallbackName => 'à vous';

  @override
  String get grofastGreetingSubtitle => 'Trouvez vos produits frais';

  @override
  String get grofastSearchHint => 'Rechercher des produits frais';

  @override
  String get grofastCategoriesTitle => 'Catégories';

  @override
  String get grofastPopularTitle => 'Populaire';

  @override
  String get grofastSeeAll => 'tout voir';

  @override
  String get grofastHomeLoadErrorMessage =>
      'Impossible de charger le catalogue de cette boutique.';

  @override
  String get grofastNoLocationSelectedLabel => 'Choisir un lieu';

  @override
  String get grofastClaimNow => 'en profiter';

  @override
  String grofastPromoDiscountLabel(String percent) {
    return '$percent de remise';
  }

  @override
  String get grofastCategoriesLoadErrorMessage =>
      'Impossible de charger les catégories.';

  @override
  String get grofastCategoriesEmptyTitle => 'Aucune catégorie';

  @override
  String get grofastCategoriesEmptySubtitle =>
      'Cette boutique n\'a publié aucune catégorie.';

  @override
  String grofastCategoryProductsTitle(String category) {
    return 'Rayon $category';
  }

  @override
  String get grofastCategoryDetailsEmptyTitle => 'Rien pour le moment';

  @override
  String get grofastCategoryDetailsEmptySubtitle =>
      'Aucun produit dans cette catégorie pour l\'instant.';

  @override
  String get grofastCategoryDetailsErrorMessage =>
      'Impossible de charger cette catégorie.';

  @override
  String get grofastSearchTitle => 'Rechercher des produits';

  @override
  String get grofastRecentSearchTitle => 'Recherches récentes';

  @override
  String grofastResultsCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count résultats trouvés',
      one: '$count résultat trouvé',
    );
    return '$_temp0';
  }

  @override
  String get grofastSearchLoadErrorMessage =>
      'Impossible de charger la recherche.';

  @override
  String get grofastSearchResultsErrorMessage =>
      'Impossible de lancer la recherche dans cette boutique.';

  @override
  String get grofastSearchNoResultsTitle => 'Aucun résultat';

  @override
  String grofastSearchNoResultsSubtitle(String query) {
    return 'Aucun résultat pour « $query ». Essayez un autre mot.';
  }

  @override
  String get grofastSearchIdleTitle => 'Que cherchez-vous ?';

  @override
  String get grofastSearchIdleSubtitle =>
      'Recherchez dans toute la boutique par nom ou par catégorie.';

  @override
  String get grofastSortByTitle => 'Trier par';

  @override
  String get grofastPriceTitle => 'Prix';

  @override
  String get grofastApplyLabel => 'Appliquer';

  @override
  String get grofastResetLabel => 'Réinitialiser';

  @override
  String get grofastAddToBagTooltip => 'Ajouter au panier';

  @override
  String get grofastFavouriteTooltip => 'Ajouter aux favoris';

  @override
  String get grofastDecreaseQuantityLabel => 'Diminuer la quantité';

  @override
  String get grofastIncreaseQuantityLabel => 'Augmenter la quantité';

  @override
  String get grofastProductDetailsTitle => 'Détails du produit';

  @override
  String get grofastDescriptionTitle => 'Description';

  @override
  String get grofastSelectSizeTitle => 'Choisir le format';

  @override
  String get grofastAddToBag => 'Ajouter au panier';

  @override
  String get grofastProductDetailsLoadErrorMessage =>
      'Impossible de charger ce produit pour le moment.';

  @override
  String grofastAddedToBagMessage(int count, String name) {
    return 'Ajout de $count × $name à votre panier.';
  }

  @override
  String get grofastNoDescriptionLabel =>
      'Ce produit n\'a pas encore de description.';

  @override
  String get grofastBagTitle => 'Mon panier';

  @override
  String grofastBagItemCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count articles',
      one: '$count article',
    );
    return '$_temp0';
  }

  @override
  String get grofastPromoCodeHint => 'Ajouter un code promo';

  @override
  String get grofastPromoApplyLabel => 'Appliquer';

  @override
  String get grofastPromoRemoveLabel => 'Retirer';

  @override
  String get grofastCouponDetailLabel => 'Code promo';

  @override
  String grofastPromoApplied(String code) {
    return '$code appliqué';
  }

  @override
  String grofastCouponLine(String code) {
    return 'Code promo ($code)';
  }

  @override
  String get grofastPromoComingSoonMessage =>
      'Les codes promo arrivent bientôt.';

  @override
  String get grofastTotalLabel => 'Total';

  @override
  String get grofastSubtotalLabel => 'Sous-total';

  @override
  String get grofastDeliveryLabel => 'Livraison';

  @override
  String get grofastDeliveryFreeLabel => 'Gratuite';

  @override
  String get grofastDiscountLabel => 'Remise';

  @override
  String get grofastProceedToCheckoutLabel => 'Commander';

  @override
  String get grofastBagEmptyTitle => 'Votre panier est vide';

  @override
  String get grofastBagEmptySubtitle =>
      'Ajoutez des produits frais et ils apparaîtront ici.';

  @override
  String get grofastBagExploreAction => 'Faire mes achats';

  @override
  String get grofastRemovedFromBagMessage => 'Retiré de votre panier.';

  @override
  String get grofastCheckoutTitle => 'Commande';

  @override
  String get grofastItemsTitle => 'Articles';

  @override
  String get grofastDeliveryAddressTitle => 'Adresse de livraison';

  @override
  String get grofastAddNewLabel => 'ajouter';

  @override
  String get grofastChangeAddressLabel => 'modifier';

  @override
  String get grofastNoAddressSelectedLabel => 'Choisir le lieu de livraison';

  @override
  String get grofastConfirmOrderLabel => 'Confirmer la commande';

  @override
  String get grofastOrderPlacedTitle => 'C\'est fait !';

  @override
  String get grofastOrderPlacedMessage =>
      'Votre commande a bien été enregistrée.';

  @override
  String get grofastBrowseHomeLabel => 'Retour à l\'accueil';

  @override
  String get grofastNavHome => 'Accueil';

  @override
  String get grofastNavCategories => 'Catégories';

  @override
  String get grofastNavBag => 'Panier';

  @override
  String get grofastNavAccount => 'Profil';

  @override
  String get grofastProfileTitle => 'Profil';

  @override
  String get grofastNotificationTileLabel => 'Notifications';

  @override
  String get grofastOrdersTileLabel => 'Mes commandes';

  @override
  String get grofastWishlistTileLabel => 'Favoris';

  @override
  String get grofastMyProfileLabel => 'Mon profil';

  @override
  String get grofastChangePasswordLabel => 'Modifier le mot de passe';

  @override
  String get grofastDarkModeLabel => 'Mode sombre';

  @override
  String get grofastMyAddressLabel => 'Mes adresses';

  @override
  String get grofastPrivacyPolicyLabel => 'Politique de confidentialité';

  @override
  String get grofastTermsAndConditionsLabel => 'CGU';

  @override
  String get grofastLogOutLabel => 'Se déconnecter';

  @override
  String get grofastLogOutTitle => 'Se déconnecter ?';

  @override
  String get grofastLogOutConfirmMessage =>
      'Vous devrez vous reconnecter pour passer une commande.';

  @override
  String get grofastProfileLoadErrorMessage =>
      'Impossible de charger votre profil.';

  @override
  String get grofastProfileNameFallback => 'Votre compte';

  @override
  String get grofastEditProfileTitle => 'Mon profil';

  @override
  String get grofastFullNameLabel => 'Nom complet';

  @override
  String get grofastFullNameHint => 'Saisissez votre nom complet';

  @override
  String get grofastEmailLabel => 'E-mail';

  @override
  String get grofastEmailHint => 'vous@exemple.com';

  @override
  String get grofastPhoneNumberLabel => 'Numéro de téléphone';

  @override
  String get grofastPhoneNumberHint => 'Saisissez votre numéro de téléphone';

  @override
  String get grofastSaveChangesLabel => 'Enregistrer';

  @override
  String get grofastChangePhotoTitle => 'Changer la photo';

  @override
  String get grofastTakePhotoLabel => 'Prendre une photo';

  @override
  String get grofastChooseFromGalleryLabel => 'Choisir dans la galerie';

  @override
  String get grofastAvatarPickerMobileOnlyMessage =>
      'La sélection de photo n\'est disponible que sur mobile.';

  @override
  String get grofastProfileUpdatedMessage => 'Votre profil a été mis à jour.';

  @override
  String get grofastChangePasswordTitle => 'Modifier le mot de passe';

  @override
  String get grofastCurrentPasswordLabel => 'Mot de passe actuel';

  @override
  String get grofastCurrentPasswordHint =>
      'Saisissez votre mot de passe actuel';

  @override
  String get grofastNewPasswordLabel => 'Nouveau mot de passe';

  @override
  String get grofastNewPasswordHint => 'Saisissez votre nouveau mot de passe';

  @override
  String get grofastConfirmNewPasswordLabel =>
      'Confirmer le nouveau mot de passe';

  @override
  String get grofastConfirmNewPasswordHint =>
      'Saisissez à nouveau votre nouveau mot de passe';

  @override
  String get grofastUpdatePasswordButtonLabel => 'Modifier le mot de passe';

  @override
  String get grofastPasswordUpdatedMessage =>
      'Votre mot de passe a été mis à jour.';

  @override
  String get grofastWishlistTitle => 'Favoris';

  @override
  String get grofastWishlistEmptyTitle => 'Aucun favori pour le moment';

  @override
  String get grofastWishlistEmptySubtitle =>
      'Touchez le cœur sur tout ce que vous voulez garder pour plus tard.';

  @override
  String get grofastWishlistExploreAction => 'Faire mes achats';

  @override
  String get grofastNotificationsTitle => 'Notifications';

  @override
  String get grofastNotificationsFilterAllLabel => 'Tout';

  @override
  String get grofastNotificationsSearchHint =>
      'Rechercher dans vos notifications';

  @override
  String get grofastNotificationsNowTitle => 'Récentes';

  @override
  String get grofastNotificationsPastTitle => 'Plus anciennes';

  @override
  String get grofastNotificationsLoadErrorMessage =>
      'Impossible de charger vos notifications.';

  @override
  String get grofastNotificationsEmptyTitle => 'Aucune notification';

  @override
  String get grofastNotificationsEmptySubtitle =>
      'Nous vous préviendrons dès qu\'il se passera quelque chose avec vos commandes.';

  @override
  String get grofastNotificationsNoResultsTitle => 'Rien ici';

  @override
  String grofastNotificationsNoResultsSubtitle(String query) {
    return 'Aucune notification ne correspond à « $query ».';
  }

  @override
  String get grofastSelectAddressTitle => 'Choisir une adresse';

  @override
  String get grofastAddNewAddressLabel => 'Ajouter une adresse';

  @override
  String get grofastAddressLoadErrorMessage =>
      'Impossible de charger vos adresses.';

  @override
  String get grofastAddressEmptyTitle => 'Aucune adresse enregistrée';

  @override
  String get grofastAddressEmptySubtitle =>
      'Ajoutez-en une pour que nous sachions où livrer vos courses.';

  @override
  String get grofastAddressSaveFailedMessage =>
      'Impossible d\'enregistrer cette adresse.';

  @override
  String get grofastAddressDeleteFailedMessage =>
      'Impossible de supprimer cette adresse.';

  @override
  String get grofastEditAddressTooltip => 'Modifier l\'adresse';

  @override
  String get grofastDeleteAddressTitle => 'Supprimer cette adresse ?';

  @override
  String get grofastDeleteAddressMessage =>
      'Elle sera retirée de vos adresses enregistrées. Cette action est irréversible.';

  @override
  String get grofastDeleteLabel => 'Supprimer';

  @override
  String get grofastCancelLabel => 'Annuler';

  @override
  String get grofastAddAddressTitle => 'Ajouter une adresse';

  @override
  String get grofastEditAddressTitle => 'Modifier l\'adresse';

  @override
  String get grofastAddressNameLabel => 'Nom';

  @override
  String get grofastAddressNameHint => 'ex. Yona Angela';

  @override
  String get grofastAddressLine1Label => 'Adresse ligne 1';

  @override
  String get grofastAddressLine1Hint => 'N° et nom de rue';

  @override
  String get grofastAddressLine2Label => 'Adresse ligne 2';

  @override
  String get grofastAddressLine2Hint => 'Appartement, étage, etc. (facultatif)';

  @override
  String get grofastLandmarkLabel => 'Point de repère';

  @override
  String get grofastLandmarkHint => 'Point de repère à proximité (facultatif)';

  @override
  String get grofastCityLabel => 'Ville';

  @override
  String get grofastCityHint => 'ex. Bengaluru';

  @override
  String get grofastStateLabel => 'Région';

  @override
  String get grofastStateHint => 'ex. Karnataka (facultatif)';

  @override
  String get grofastCountryLabel => 'Pays';

  @override
  String get grofastSelectCountryTitle => 'Choisir un pays';

  @override
  String get grofastPostalCodeLabel => 'Code postal';

  @override
  String get grofastPostalCodeHint => 'ex. 62639';

  @override
  String get grofastAddressTagLabel => 'Libellé';

  @override
  String get grofastAddressTagHint => 'ex. Domicile, Bureau';

  @override
  String get grofastMobileLabel => 'Numéro de mobile';

  @override
  String get grofastMobileHint => 'Pour vous joindre';

  @override
  String get grofastAddAddressButtonLabel => 'Ajouter l\'adresse';

  @override
  String get grofastUpdateAddressButtonLabel => 'Mettre à jour l\'adresse';

  @override
  String get grofastRequiredFieldErrorMessage => 'Ce champ est obligatoire';

  @override
  String get grofastMyOrdersTitle => 'Mes commandes';

  @override
  String get grofastOrdersSearchHint => 'Rechercher dans vos commandes';

  @override
  String get grofastOrdersFilterAllLabel => 'Tout';

  @override
  String get grofastOrdersFilterActiveLabel => 'En livraison';

  @override
  String get grofastOrdersFilterCompletedLabel => 'Livrées';

  @override
  String get grofastOrdersFilterCancelledLabel => 'Annulées';

  @override
  String get grofastOrdersDateFilterTitle => 'Filtrer par date';

  @override
  String get grofastOrdersDateRangeLabel => 'Période';

  @override
  String get grofastOrdersAllTimeLabel => 'Tout';

  @override
  String get grofastOrdersFilterLastWeekLabel => 'Semaine';

  @override
  String get grofastOrdersFilterLastMonthLabel => 'Mois';

  @override
  String get grofastOrdersLoadErrorMessage =>
      'Impossible de charger vos commandes.';

  @override
  String get grofastOrdersRefreshFailedMessage =>
      'Impossible d\'actualiser vos commandes.';

  @override
  String get grofastOrdersEmptyTitle => 'Aucune commande';

  @override
  String get grofastOrdersEmptySubtitle =>
      'Vos commandes apparaîtront ici dès que vous en passerez une.';

  @override
  String get grofastOrdersNoResultsTitle => 'Rien ici';

  @override
  String get grofastOrdersNoResultsSubtitle =>
      'Aucune commande ne correspond à ces filtres. Essayez de les élargir.';

  @override
  String grofastOrderNumberLabel(String date) {
    return 'Commande du $date';
  }

  @override
  String grofastOrderItemCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count articles',
      one: '$count article',
    );
    return '$_temp0';
  }

  @override
  String grofastOrderDeliveredLine(String label) {
    return 'Livrée à $label';
  }

  @override
  String grofastOrderDeliveringLine(String label) {
    return 'En cours de livraison à $label';
  }

  @override
  String get grofastOrderCancelledLine => 'Cette commande a été annulée';

  @override
  String get grofastTrackOrderTitle => 'Suivi de commande';

  @override
  String get grofastOrderDetailTitle => 'Détail de la commande';

  @override
  String get grofastCopyTooltip => 'Copier';

  @override
  String grofastCopiedMessage(String label) {
    return '$label copié.';
  }

  @override
  String get grofastTrackingDetailTitle => 'Détails du suivi';

  @override
  String get grofastOrderStatusLabel => 'Statut';

  @override
  String get grofastPurchaseDateLabel => 'Date d\'achat';

  @override
  String get grofastOrderIdLabel => 'N° de commande';

  @override
  String get grofastDeliveryOtpLabel => 'Code de livraison';

  @override
  String get grofastPaymentIdLabel => 'N° de paiement';

  @override
  String get grofastAmountPaidLabel => 'Montant payé';

  @override
  String get grofastNoOnlinePaymentLabel => 'Non payée en ligne';

  @override
  String get grofastRefundLabel => 'Remboursement';

  @override
  String get grofastOrderReceivedLabel => 'Commande reçue';

  @override
  String get grofastCancelOrderLabel => 'Annuler';

  @override
  String get grofastCancelOrderTitle => 'Annuler cette commande ?';

  @override
  String get grofastCancelOrderMessage =>
      'Nous vous rembourserons ce que vous avez payé. Cette action est irréversible.';

  @override
  String get grofastCancelOrderConfirmLabel => 'Annuler la commande';

  @override
  String get grofastOrderCancelFailedMessage =>
      'Impossible d\'annuler cette commande.';

  @override
  String get grofastOrderStepUndatedLabel => 'Heure non enregistrée';

  @override
  String get grofastOrderStepPendingLabel => 'En attente';

  @override
  String get grofastStatusPlacedLabel => 'Passée';

  @override
  String get grofastStatusOnDeliveryLabel => 'En livraison';

  @override
  String get grofastStatusDeliveredLabel => 'Livrée';

  @override
  String get grofastStatusCancelledLabel => 'Annulée';

  @override
  String get grofastRefundPendingLabel => 'En cours';

  @override
  String get grofastRefundProcessedLabel => 'Remboursée';

  @override
  String get grofastRefundFailedLabel => 'Échec';

  @override
  String get validationNameRequired => 'Veuillez saisir votre nom.';

  @override
  String get validationEmailRequired => 'Veuillez saisir votre adresse e-mail.';

  @override
  String get validationEmailInvalid => 'Saisissez une adresse e-mail valide.';

  @override
  String get validationMobileRequired =>
      'Veuillez saisir votre numéro de mobile.';

  @override
  String get validationMobileInvalid => 'Saisissez un numéro de mobile valide.';

  @override
  String get validationPasswordRequired =>
      'Veuillez saisir votre mot de passe.';

  @override
  String get validationWeakPassword =>
      'Le mot de passe doit contenir au moins 6 caractères.';

  @override
  String get validationConfirmPasswordRequired =>
      'Veuillez confirmer votre nouveau mot de passe.';

  @override
  String get validationPasswordsDontMatch =>
      'Les mots de passe ne correspondent pas.';

  @override
  String get notificationsSectionToday => 'Aujourd\'hui';

  @override
  String get notificationsSectionYesterday => 'Hier';

  @override
  String get notificationsSectionEarlier => 'Plus tôt';

  @override
  String get notificationsPermissionTitle =>
      'Les notifications sont désactivées';

  @override
  String get notificationsPermissionSubtitle =>
      'Activez-les pour recevoir le suivi de vos commandes et les offres de cette boutique.';

  @override
  String get notificationsPermissionCta => 'Activer les notifications';

  @override
  String get notificationsPermissionBlockedMessage =>
      'Les notifications sont bloquées pour CordeliaApps. Activez-les dans les réglages de votre appareil.';
}
