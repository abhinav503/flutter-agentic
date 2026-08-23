// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get noConnectionMessage =>
      'Nessuna connessione a Internet. Controlla la rete e riprova.';

  @override
  String get languageSheetTitle => 'Lingua';

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
      other: 'pz',
      one: 'pz',
    );
    return '$_temp0';
  }

  @override
  String get loginTitle => 'Benvenuto su CordeliaApps';

  @override
  String get loginSubtitle =>
      'Accedi al tuo account con l\'e-mail o i social network';

  @override
  String get emailLabel => 'Indirizzo e-mail';

  @override
  String get emailHint => 'nome@esempio.com';

  @override
  String get passwordLabel => 'Password';

  @override
  String get passwordHint => 'Inserisci la tua password';

  @override
  String get forgotPasswordLabel => 'Hai dimenticato la password?';

  @override
  String passwordResetEmailSentMessage(String email) {
    return 'Link per reimpostare la password inviato a $email';
  }

  @override
  String get continueLabel => 'Continua';

  @override
  String get byContinuingAgree => 'Continuando, accetti i nostri';

  @override
  String get termsOfServiceAndPrivacyPolicy =>
      'Termini di servizio e Informativa sulla privacy';

  @override
  String get dontHaveAccount => 'Non hai un account? ';

  @override
  String get signupLink => 'Registrati';

  @override
  String get signupTitle => 'Registra il tuo account';

  @override
  String get signupSubtitle => 'Inserisci i tuoi dati qui sotto';

  @override
  String get nameLabel => 'Nome';

  @override
  String get nameHint => 'es. Mark Shelby';

  @override
  String get mobileLabel => 'Numero di cellulare';

  @override
  String get mobileHint => '(303) 555-0105';

  @override
  String get iAgreeLabel => 'Accetto i ';

  @override
  String get termsAndConditionsLink => 'Termini e condizioni';

  @override
  String get mustAgreeToTermsMessage =>
      'Per continuare devi accettare i Termini e condizioni.';

  @override
  String get authWebUnsupportedMessage =>
      'L\'accesso è disponibile solo su mobile.';

  @override
  String get sessionExpiredMessage =>
      'La tua sessione è scaduta. Accedi di nuovo.';

  @override
  String get signupButtonLabel => 'Registrati';

  @override
  String get alreadyHaveAccount => 'Hai già un account? ';

  @override
  String get loginLink => 'Accedi';

  @override
  String get comingSoonMessage => 'Prossimamente';

  @override
  String get deliveryUnavailableMessage =>
      'Questo negozio non effettua consegne all\'indirizzo selezionato.';

  @override
  String get paymentCancelledMessage => 'Pagamento annullato';

  @override
  String couponMinOrderMessage(String price) {
    return 'Il tuo ordine è sotto il minimo di $price previsto da questo codice';
  }

  @override
  String get paymentFailedMessage =>
      'Non è stato possibile completare il pagamento. Riprova.';

  @override
  String get verifyEmailTitle => 'Verifica la tua e-mail';

  @override
  String verifyEmailSubtitle(String email) {
    return 'Abbiamo inviato un link di verifica a $email. Aprilo, poi torna qui: la pagina si aggiornerà automaticamente.';
  }

  @override
  String get verifyEmailChecking => 'Verifica in corso…';

  @override
  String get resendEmailLabel => 'Invia di nuovo l\'e-mail';

  @override
  String get termsAndConditionsLabel => 'Termini e condizioni';

  @override
  String get privacyPolicyLabel => 'Informativa sulla privacy';

  @override
  String get legalLastUpdatedLabel => 'Ultimo aggiornamento: 6 agosto 2026';

  @override
  String get termsAndConditionsIntro =>
      'Queste condizioni si applicano ogni volta che usi l\'app CordeliaApps. Leggile prima di ordinare — creare un account o effettuare un ordine significa accettarle.';

  @override
  String get termsAndConditionsSection1Heading => '1. Chi siamo';

  @override
  String get termsAndConditionsSection1Body =>
      'CordeliaApps sviluppa e gestisce questa app di acquisti. Abbiamo sede in India e collaboriamo con negozi in India, nel Regno Unito, negli Stati Uniti e in tutta Europa, perciò l\'app è disponibile in diverse lingue e mostra i prezzi nella valuta di ciascun negozio. Se una traduzione differisce dalla versione inglese, prevale la versione inglese.';

  @override
  String get termsAndConditionsSection2Heading =>
      '2. Il nostro ruolo — da chi acquisti';

  @override
  String get termsAndConditionsSection2Body =>
      'CordeliaApps è la piattaforma, non il negozio. Ogni prodotto che vedi è pubblicato, prezzato, venduto e consegnato dal singolo negozio che stai consultando, e il tuo contratto di acquisto è con quel negozio. Non siamo il venditore e non incassiamo il prezzo della merce, quindi le domande su un ordine, un prodotto o un rimborso sono gestite dal negozio, e l\'app è il luogo in cui lo raggiungi.';

  @override
  String get termsAndConditionsSection3Heading => '3. Il tuo account';

  @override
  String get termsAndConditionsSection3Body =>
      'Per ordinare serve un account. Fornisci dati corretti, verifica il tuo indirizzo e-mail e non condividere la password — tutto ciò che avviene tramite il tuo account si considera fatto da te. Puoi eliminare l\'account in qualsiasi momento dal tuo profilo. I tuoi ordini passati restano presso i negozi che li hanno evasi, perché sono le loro scritture commerciali.';

  @override
  String get termsAndConditionsSection4Heading => '4. Ordini e pagamento';

  @override
  String get termsAndConditionsSection4Body =>
      'Effettuare un ordine è una proposta di acquisto al negozio. Il negozio può rifiutarla — ad esempio se un articolo è esaurito o non può essere consegnato al tuo indirizzo — e in tal caso ti rimborsa per intero. I prezzi sono stabiliti dal negozio nella propria valuta e comprendono le imposte applicabili, salvo diversa indicazione del negozio. Il pagamento è incassato dal fornitore di pagamenti del negozio e viene versato al negozio; CordeliaApps non trattiene mai il tuo denaro.';

  @override
  String get termsAndConditionsSection5Heading =>
      '5. Consegna, annullamenti e rimborsi';

  @override
  String get termsAndConditionsSection5Body =>
      'Il negozio prepara e consegna il tuo ordine, e ogni tempo di consegna indicato è una stima, non una promessa. Puoi annullare un ordine nell\'app finché non è stato spedito, e il negozio rimborsa l\'importo sul metodo di pagamento che hai usato. Se un rimborso è dovuto per qualsiasi altro motivo, è sempre il negozio a emetterlo. Nulla di tutto ciò riduce i diritti che la tua legge locale ti riconosce.';

  @override
  String get termsAndConditionsSection6Heading =>
      '6. Informazioni sui prodotti e recensioni';

  @override
  String get termsAndConditionsSection6Body =>
      'I negozi scrivono da sé nomi, descrizioni, immagini e prezzi dei propri prodotti, quindi tali informazioni provengono dal negozio e non da noi. Possono verificarsi errori, e un negozio può correggere un errore oppure annullare e rimborsare un ordine interessato. Se pubblichi una recensione, deve riflettere la tua esperienza diretta — resti titolare di ciò che scrivi e consenti a noi e al negozio di mostrarlo nell\'app. Possiamo rimuovere contenuti falsi, offensivi o contrari a queste condizioni.';

  @override
  String get termsAndConditionsSection7Heading => '7. Uso consentito';

  @override
  String get termsAndConditionsSection7Body =>
      'Usa l\'app per fare acquisti e nient\'altro. Non effettuare ordini fraudolenti, non creare account che non ti appartengono, non raccogliere dati in modo automatizzato, non interferire con il funzionamento dell\'app e non usarla per scopi illeciti. Possiamo sospendere o chiudere un account che lo faccia.';

  @override
  String get termsAndConditionsSection8Heading =>
      '8. Disponibilità e nostra responsabilità';

  @override
  String get termsAndConditionsSection8Body =>
      'Lavoriamo per mantenere l\'app efficiente, ma non possiamo garantire che sia sempre disponibile o priva di difetti, e possiamo modificare o ritirare funzionalità. Siamo responsabili dell\'app in sé. Non siamo responsabili della merce venduta da un negozio, dell\'esattezza di quanto il negozio pubblica, né del modo in cui gestisce il tuo ordine. Nulla di quanto qui previsto limita una responsabilità che la legge non consente di limitare.';

  @override
  String get termsAndConditionsSection9Heading =>
      '9. Legge applicabile e i tuoi diritti locali';

  @override
  String get termsAndConditionsSection9Body =>
      'Queste condizioni sono regolate dalle leggi dell\'India e i tribunali indiani sono competenti. Poiché serviamo acquirenti anche in altri Paesi, ciò non ti priva della tutela delle norme imperative in materia di consumo del luogo in cui risiedi. Se sei un consumatore nel Regno Unito o nell\'Unione europea, conservi i tuoi diritti di legge locali, compreso l\'eventuale diritto di recesso entro il termine previsto dalla tua legislazione.';

  @override
  String get termsAndConditionsSection10Heading => '10. Modifiche e contatti';

  @override
  String get termsAndConditionsSection10Body =>
      'Aggiorniamo queste condizioni man mano che l\'app cambia, e la data in cima a questa pagina indica l\'ultima modifica. Continuare a usare l\'app dopo una modifica significa accettare le condizioni aggiornate. Se qualcosa non ti è chiaro, o ti serve aiuto con un ordine, scrivici a support@cordeliaapps.com.';

  @override
  String get privacyPolicyIntro =>
      'Leggi attentamente questa informativa sulla privacy prima di usare la nostra app.';

  @override
  String get privacyPolicySection1Heading => '1. Raccolta delle informazioni';

  @override
  String get privacyPolicySection1Body =>
      'Raccogliamo le informazioni essenziali per migliorare la tua esperienza. Comprendono i dati che fornisci direttamente, come quelli del tuo account, e le informazioni ottenute dalle analisi di utilizzo e dai cookie.';

  @override
  String get privacyPolicySection2Heading => '2. Utilizzo delle informazioni';

  @override
  String get privacyPolicySection2Body =>
      'Le informazioni raccolte servono a migliorare i nostri servizi, offrirti consigli personalizzati e garantirti un\'esperienza senza intoppi. Non condividiamo i tuoi dati senza il tuo consenso esplicito.';

  @override
  String get privacyPolicySection3Heading => '3. Gestione delle informazioni';

  @override
  String get privacyPolicySection3Body =>
      'Hai il pieno controllo dei tuoi dati. Puoi gestire le preferenze sulla privacy, aggiornare i dati personali e adattare le impostazioni alle tue esigenze.';

  @override
  String get privacyPolicySection4Heading => '4. Misure di sicurezza';

  @override
  String get privacyPolicySection4Body =>
      'La sicurezza dei tuoi dati è la nostra priorità: li proteggiamo con protocolli avanzati, metodi di crittografia e controlli periodici, per prevenire accessi non autorizzati e violazioni.';

  @override
  String get profilePageTitle => 'Profilo';

  @override
  String get changePasswordLabel => 'Modifica password';

  @override
  String get myOrdersLabel => 'I miei ordini';

  @override
  String get myAddressLabel => 'I miei indirizzi';

  @override
  String get darkModeLabel => 'Modalità scura';

  @override
  String get logoutLabel => 'Esci';

  @override
  String get logoutTitle => 'Esci';

  @override
  String get logoutConfirmMessage => 'Vuoi davvero uscire?';

  @override
  String get deleteAccountLabel => 'Elimina account';

  @override
  String get deleteAccountTitle => 'Eliminare il tuo account?';

  @override
  String get deleteAccountConfirmMessage =>
      'Questa operazione elimina definitivamente il tuo profilo, gli indirizzi, il carrello, i preferiti e le recensioni in tutti i negozi. Gli ordini che hai già effettuato restano ai rispettivi negozi come documenti di vendita. L\'operazione non può essere annullata.';

  @override
  String get profileLoadErrorMessage =>
      'Si è verificato un errore durante il caricamento del profilo.';

  @override
  String get helpAndSupportLabel => 'Aiuto e assistenza';

  @override
  String get supportIntro =>
      'Dicci cosa non ha funzionato e sistemeremo tutto.';

  @override
  String supportStoreSectionTitle(String storeName) {
    return 'Contatta $storeName';
  }

  @override
  String get supportStoreSectionSubtitle =>
      'Per tutto ciò che riguarda un ordine: un articolo sbagliato, una consegna in ritardo o un rimborso che non è arrivato.';

  @override
  String get supportEmailAction => 'Invia un\'e-mail';

  @override
  String get supportCallAction => 'Chiama';

  @override
  String supportHoursLabel(String hours) {
    return 'Risponde $hours';
  }

  @override
  String get supportPlatformSectionTitle => 'CordeliaApps';

  @override
  String get supportPlatformSectionSubtitle =>
      'Per il tuo account, l\'accesso o un problema con l\'app stessa.';

  @override
  String get supportPlatformOnlySubtitle =>
      'Questo negozio non ha ancora pubblicato un contatto. Scrivici e gli inoltreremo tutto ciò che riguarda un ordine.';

  @override
  String get supportPolicySectionTitle => 'Politiche';

  @override
  String get supportRefundPolicyAction => 'Rimborso e annullamento';

  @override
  String supportAppVersionLabel(String version) {
    return 'Cordelia $version';
  }

  @override
  String get supportOrderCtaLabel => 'Ti serve aiuto per questo ordine?';

  @override
  String supportLaunchFailedMessage(String value) {
    return 'Impossibile aprire quell\'app. $value è stato copiato negli appunti.';
  }

  @override
  String supportEmailSubjectOrder(String orderId) {
    return 'Aiuto per l\'ordine $orderId';
  }

  @override
  String supportEmailSubjectStore(String storeName) {
    return 'Aiuto per $storeName';
  }

  @override
  String get supportEmailSubjectPlatform => 'Aiuto per CordeliaApps';

  @override
  String get supportEmailBodyPrompt => 'Descrivi che cosa non ha funzionato:';

  @override
  String get supportEmailBodyDetailsHeading =>
      'Dati per l\'assistenza: lasciali pure qui.';

  @override
  String get supportEmailOrderLabel => 'Ordine';

  @override
  String get supportEmailStoreLabel => 'Negozio';

  @override
  String get supportEmailAccountLabel => 'Account';

  @override
  String get supportEmailAppLabel => 'App';

  @override
  String get sortRelevanceLabel => 'Rilevanza';

  @override
  String get sortPriceLowToHighLabel => 'Prezzo (dal più basso)';

  @override
  String get sortPriceHighToLowLabel => 'Prezzo (dal più alto)';

  @override
  String get sortRatingHighToLowLabel => 'Valutazione (dalla più alta)';

  @override
  String get sortDiscountHighToLowLabel => 'Sconto (dal più alto)';

  @override
  String get priceFilterAllLabel => 'Tutti i prezzi';

  @override
  String priceFilterUnderLabel(String price) {
    return 'Meno di $price';
  }

  @override
  String priceFilterOverLabel(String price) {
    return 'Oltre $price';
  }

  @override
  String priceFilterRangeLabel(String from, String to) {
    return '$from - $to';
  }

  @override
  String get reviewsSectionTitle => 'Valutazioni e recensioni';

  @override
  String get writeReviewLabel => 'Scrivi una recensione';

  @override
  String get editReviewLabel => 'Modifica la tua recensione';

  @override
  String get deleteReviewLabel => 'Elimina';

  @override
  String get reviewSheetTitle => 'Valuta questo prodotto';

  @override
  String get reviewRatingPrompt => 'Quante stelle?';

  @override
  String get reviewTextLabel => 'La tua recensione';

  @override
  String get reviewTextHint => 'Racconta agli altri clienti cosa ne pensi…';

  @override
  String get reviewSubmitLabel => 'Invia recensione';

  @override
  String get reviewMissingRatingMessage =>
      'Scegli prima una valutazione in stelle.';

  @override
  String get reviewDeleteConfirmTitle => 'Eliminare la tua recensione?';

  @override
  String get reviewDeleteConfirmMessage =>
      'La tua valutazione verrà rimossa dalla media del prodotto. Puoi scriverne una nuova in qualsiasi momento.';

  @override
  String get verifiedPurchaseLabel => 'Acquisto verificato';

  @override
  String get reviewsEmptyTitle => 'Nessuna recensione';

  @override
  String get reviewsEmptySubtitle =>
      'Sii il primo a valutare questo prodotto e aiuta gli altri clienti a decidere.';

  @override
  String get reportReviewLabel => 'Segnala';

  @override
  String get reportReviewSheetTitle => 'Segnala questa recensione';

  @override
  String get reportReviewPrompt => 'Perché la segnali?';

  @override
  String get reportReasonOffensive => 'Offensiva o abusiva';

  @override
  String get reportReasonSpam => 'Spam o pubblicità';

  @override
  String get reportReasonIrrelevant => 'Non riguarda questo prodotto';

  @override
  String get reportReasonPersonalInfo => 'Contiene dati personali';

  @override
  String get reportReviewBlockLabel =>
      'Nascondi anche le recensioni di questo cliente';

  @override
  String get reportReviewSubmitLabel => 'Invia segnalazione';

  @override
  String get reportReviewMissingReasonMessage => 'Scegli prima un motivo.';

  @override
  String get reportReviewSuccessMessage =>
      'Grazie, il negozio è stato avvisato.';

  @override
  String get unratedLabel => 'Nessuna valutazione';

  @override
  String get guestLabel => 'Ospite';

  @override
  String get locationLocatingLabel => 'Individuazione…';

  @override
  String get locationNoAddressMessage =>
      'Nessun CAP trovato per la tua posizione.';

  @override
  String get locationServiceOffMessage =>
      'La localizzazione è disattivata su questo dispositivo.';

  @override
  String get locationPermissionDeniedMessage =>
      'Il permesso di localizzazione è disattivato: attivalo nelle Impostazioni per vedere cosa c\'è vicino a te.';

  @override
  String get locationUnavailableMessage =>
      'Impossibile ottenere la tua posizione. Riprova.';

  @override
  String get outOfStockLabel => 'Esaurito';

  @override
  String cartLineSubtitle(String pack, String availability) {
    return '$pack · $availability';
  }

  @override
  String get updateRequiredTitle => 'Aggiorna CordeliaApps';

  @override
  String get updateRequiredMessage =>
      'Questa versione non è più supportata. Aggiorna per continuare gli acquisti: ci vuole un minuto.';

  @override
  String get updateNowButton => 'Aggiorna ora';

  @override
  String get updateLinkCopiedMessage =>
      'Link di aggiornamento copiato: incollalo nel browser.';

  @override
  String onlyNLeftLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ne restano solo $count',
      one: 'Ne resta solo 1',
    );
    return '$_temp0';
  }

  @override
  String get cartUnavailableItemsMessage =>
      'Alcuni articoli nel tuo carrello non sono più disponibili. Aggiorna il carrello per continuare.';

  @override
  String productSoldOutMessage(String name) {
    return '$name è appena andato esaurito. Aggiorna il carrello per continuare.';
  }

  @override
  String productStockReducedMessage(String name) {
    return 'Non è rimasto abbastanza $name. Aggiorna il carrello per continuare.';
  }

  @override
  String get checkoutFailedMessage =>
      'Non è stato possibile effettuare il tuo ordine.';

  @override
  String get paymentRefundedNote => 'Il tuo pagamento è stato rimborsato.';

  @override
  String get rateOrderLabel => 'Valuta l\'ordine';

  @override
  String get editOrderRatingLabel => 'Modifica valutazione';

  @override
  String get rateOrderSheetTitle => 'Com\'è andato questo ordine?';

  @override
  String get rateOrderTextLabel => 'Il tuo feedback';

  @override
  String get rateOrderTextHint => 'Com\'è andata la consegna?';

  @override
  String get orderRatingNotDeliveredMessage =>
      'Puoi valutare un ordine dopo la consegna.';

  @override
  String get orderRatingFailedMessage =>
      'Non è stato possibile salvare la tua valutazione. Riprova.';

  @override
  String get yourRatingLabel => 'La tua valutazione';

  @override
  String orderPlacedAtLabel(String date, String time) {
    return '$date alle $time';
  }

  @override
  String reviewCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count recensioni',
      one: '$count recensione',
    );
    return '$_temp0';
  }

  @override
  String get reviewAgeJustNow => 'Adesso';

  @override
  String reviewAgeMinutesAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minuti fa',
      one: '$count minuto fa',
    );
    return '$_temp0';
  }

  @override
  String reviewAgeHoursAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ore fa',
      one: '$count ora fa',
    );
    return '$_temp0';
  }

  @override
  String reviewAgeDaysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count giorni fa',
      one: '$count giorno fa',
    );
    return '$_temp0';
  }

  @override
  String reviewAgeMonthsAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count mesi fa',
      one: '$count mese fa',
    );
    return '$_temp0';
  }

  @override
  String reviewAgeYearsAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count anni fa',
      one: '$count anno fa',
    );
    return '$_temp0';
  }

  @override
  String get graviaCategoriesTitle => 'Tutte le categorie';

  @override
  String get graviaSeeAll => 'Vedi tutto';

  @override
  String get graviaPopularItemsTitle => 'Articoli popolari';

  @override
  String get graviaHomeLoadErrorMessage =>
      'Impossibile caricare il catalogo di questo negozio.';

  @override
  String get graviaCancel => 'Annulla';

  @override
  String graviaDiscountPercentOff(String percent) {
    return '$percent% SCONTO';
  }

  @override
  String get graviaAddToCart => 'Aggiungi al carrello';

  @override
  String get graviaAddToCartSheetTitle => 'Aggiungi al carrello';

  @override
  String get graviaDeleteLabel => 'Elimina';

  @override
  String get graviaDeleteAddressTitle => 'Elimina indirizzo';

  @override
  String get graviaDeleteAddressConfirmMessage =>
      'Vuoi davvero eliminare questo indirizzo? L\'azione non può essere annullata.';

  @override
  String get graviaClearCartTitle => 'Svuota il carrello';

  @override
  String get graviaClearCartConfirmMessage =>
      'Vuoi davvero rimuovere tutti gli articoli dal tuo carrello?';

  @override
  String get graviaClearCartConfirmLabel => 'Svuota carrello';

  @override
  String get graviaOrderPlacedTitle => 'Ordine effettuato con successo';

  @override
  String get graviaOrderPlacedSubtitle =>
      'Grazie per il tuo ordine, puoi seguire la consegna nella sezione ordini';

  @override
  String get graviaTrackYourOrderLabel => 'Segui il tuo ordine';

  @override
  String get graviaSearchHint => 'Cerca';

  @override
  String get graviaNavHome => 'Home';

  @override
  String get graviaNavCategories => 'Categorie';

  @override
  String get graviaNavFavourite => 'Preferiti';

  @override
  String get graviaNavOrders => 'Ordini';

  @override
  String get graviaNavProfile => 'Profilo';

  @override
  String get graviaRecentSearchTitle => 'Ricerche recenti';

  @override
  String get graviaSearchLoadErrorMessage =>
      'Si è verificato un errore durante il caricamento della ricerca.';

  @override
  String get graviaSearchResultsErrorMessage =>
      'Si è verificato un errore durante la ricerca.';

  @override
  String get graviaSearchCategoryBadge => 'Categoria';

  @override
  String get graviaSearchNoResultsTitle => 'Nessun risultato';

  @override
  String graviaSearchNoResultsSubtitle(String query) {
    return 'Nessun risultato per \"$query\". Prova con un\'altra parola.';
  }

  @override
  String get graviaProductDetailsTitle => 'Dettagli prodotto';

  @override
  String selectOptionLabel(String option) {
    return 'Scegli $option';
  }

  @override
  String get graviaSelectQtyLabel => 'Seleziona quantità';

  @override
  String get graviaKeyInformationTitle => 'Informazioni principali';

  @override
  String get graviaReadMore => 'Leggi di più';

  @override
  String get graviaReadLess => 'Leggi meno';

  @override
  String get graviaSimilarProductsTitle => 'Prodotti simili';

  @override
  String get graviaProductDetailsLoadErrorMessage =>
      'Si è verificato un errore durante il caricamento del prodotto.';

  @override
  String graviaAddToCartWithPrice(String price) {
    return 'Aggiungi al carrello ($price)';
  }

  @override
  String get graviaCategoriesPageTitle => 'Categorie';

  @override
  String get graviaCategoriesLoadErrorMessage =>
      'Si è verificato un errore durante il caricamento delle categorie.';

  @override
  String get graviaCategoriesRefreshFailedMessage =>
      'Aggiornamento non riuscito — vengono mostrate le ultime categorie caricate.';

  @override
  String get graviaSortLabel => 'Ordina';

  @override
  String get graviaPriceLabel => 'Prezzo';

  @override
  String get graviaSortBySheetTitle => 'Ordina per';

  @override
  String get graviaPriceSheetTitle => 'Prezzo';

  @override
  String get graviaCategoryDetailsEmptyMessage =>
      'Nessun prodotto corrisponde a questi filtri.';

  @override
  String get graviaSelectAddressTitle => 'Seleziona indirizzo';

  @override
  String get graviaAddNewAddressLabel => 'Aggiungi nuovo indirizzo';

  @override
  String get graviaDefaultAddressSectionTitle => 'Indirizzo predefinito';

  @override
  String get graviaOtherAddressSectionTitle => 'Altri indirizzi';

  @override
  String get graviaEditLabel => 'Modifica';

  @override
  String get graviaAddressLoadErrorMessage =>
      'Si è verificato un errore durante il caricamento dei tuoi indirizzi.';

  @override
  String get graviaAddressSaveFailedMessage =>
      'Impossibile salvare l\'indirizzo. Riprova.';

  @override
  String get graviaAddressDeleteFailedMessage =>
      'Impossibile eliminare l\'indirizzo. Riprova.';

  @override
  String get graviaAddressEmptyTitle => 'Nessun indirizzo salvato';

  @override
  String get graviaAddressEmptySubtitle =>
      'Aggiungi il tuo primo indirizzo di consegna per iniziare.';

  @override
  String get graviaEditAddressTitle => 'Modifica indirizzo';

  @override
  String get graviaNameLabel => 'Nome';

  @override
  String get graviaNameHint => 'es. Mark Shelby';

  @override
  String get graviaPhoneNumberLabel => 'Numero di telefono';

  @override
  String get graviaPhoneNumberHint => 'es. (303) 555-0105';

  @override
  String get graviaAddressLine1Label => 'Indirizzo (riga 1)';

  @override
  String get graviaAddressLine1Hint => 'Numero civico, via';

  @override
  String get graviaAddressLine2Label => 'Indirizzo (riga 2)';

  @override
  String get graviaAddressLine2Hint =>
      'Appartamento, interno, ecc. (facoltativo)';

  @override
  String get graviaLandmarkLabel => 'Punto di riferimento';

  @override
  String get graviaLandmarkHint => 'Punto di riferimento vicino (facoltativo)';

  @override
  String get graviaCityLabel => 'Città';

  @override
  String get graviaCityHint => 'es. New Delhi';

  @override
  String get graviaStateLabel => 'Provincia';

  @override
  String get graviaStateHint => 'es. Delhi (facoltativo)';

  @override
  String get graviaCountryLabel => 'Paese';

  @override
  String get graviaSelectCountryTitle => 'Seleziona il paese';

  @override
  String get graviaPostalCodeLabel => 'CAP';

  @override
  String get graviaPostalCodeHint => 'es. 62639';

  @override
  String get graviaAddressTagLabel => 'Etichetta';

  @override
  String get graviaAddressTagHint => 'es. Casa, Ufficio';

  @override
  String get graviaAddAddressButtonLabel => 'Aggiungi indirizzo';

  @override
  String get graviaUpdateAddressButtonLabel => 'Aggiorna indirizzo';

  @override
  String get graviaRequiredFieldErrorMessage => 'Questo campo è obbligatorio';

  @override
  String get graviaUseMyLocationLabel => 'Usa la mia posizione';

  @override
  String get graviaProfilePageTitle => 'Profilo';

  @override
  String get graviaChangePasswordLabel => 'Modifica password';

  @override
  String get graviaMyOrdersLabel => 'I miei ordini';

  @override
  String get graviaMyAddressLabel => 'I miei indirizzi';

  @override
  String get graviaDarkModeLabel => 'Modalità scura';

  @override
  String get graviaPrivacyPolicyLabel => 'Informativa sulla privacy';

  @override
  String get graviaTermsAndConditionsLabel => 'Termini e condizioni';

  @override
  String get graviaLogoutLabel => 'Esci';

  @override
  String get graviaLogoutTitle => 'Esci';

  @override
  String get graviaLogoutConfirmMessage => 'Vuoi davvero uscire?';

  @override
  String get graviaProfileLoadErrorMessage =>
      'Si è verificato un errore durante il caricamento del tuo profilo.';

  @override
  String get graviaEditProfileTitle => 'Modifica profilo';

  @override
  String get graviaEmailAddressLabel => 'Indirizzo e-mail';

  @override
  String get graviaEmailAddressHint => 'es. mark.shelby@example.com';

  @override
  String get graviaMobileNumberLabel => 'Numero di cellulare';

  @override
  String get graviaUpdateProfileButtonLabel => 'Aggiorna';

  @override
  String get graviaChangePhotoTitle => 'Modifica foto';

  @override
  String get graviaTakePhotoLabel => 'Scatta una foto';

  @override
  String get graviaChooseFromGalleryLabel => 'Scegli dalla galleria';

  @override
  String get graviaAvatarPickerMobileOnlyMessage =>
      'La modifica della foto è disponibile solo su mobile';

  @override
  String get graviaChangePasswordTitle => 'Modifica password';

  @override
  String get graviaCurrentPasswordLabel => 'Password attuale';

  @override
  String get graviaCurrentPasswordHint => 'Inserisci la tua password attuale';

  @override
  String get graviaNewPasswordLabel => 'Nuova password';

  @override
  String get graviaNewPasswordHint => 'Inserisci la tua nuova password';

  @override
  String get graviaConfirmNewPasswordLabel => 'Conferma nuova password';

  @override
  String get graviaConfirmNewPasswordHint =>
      'Inserisci di nuovo la tua nuova password';

  @override
  String get graviaUpdatePasswordButtonLabel => 'Aggiorna password';

  @override
  String get graviaPasswordUpdatedMessage =>
      'La tua password è stata aggiornata.';

  @override
  String get graviaMyCartTitle => 'Il mio carrello';

  @override
  String get graviaBeforeYouCheckoutTitle => 'Prima di concludere l\'ordine';

  @override
  String get graviaCouponCodeLabel => 'Codice promozionale';

  @override
  String get graviaApplyLabel => 'Applica';

  @override
  String get graviaCouponRemoveLabel => 'Rimuovi';

  @override
  String graviaCouponApplied(String code) {
    return '$code applicato';
  }

  @override
  String graviaCouponLine(String code) {
    return 'Codice promozionale ($code)';
  }

  @override
  String get graviaItemTotalLabel => 'Totale articoli';

  @override
  String get graviaDiscountLabel => 'Sconto';

  @override
  String get graviaDeliveryLabel => 'Consegna';

  @override
  String get graviaDeliveryFreeLabel => 'GRATUITA';

  @override
  String get graviaGrandTotalLabel => 'Totale complessivo';

  @override
  String get graviaProceedToCheckoutLabel => 'Vai alla cassa';

  @override
  String get graviaCartEmptyTitle => 'Il tuo carrello è vuoto';

  @override
  String get graviaCartEmptySubtitle => 'Aggiungi articoli per iniziare.';

  @override
  String get graviaCartBarTitle => 'Vedi altri prodotti';

  @override
  String get graviaExploreLabel => 'Esplora';

  @override
  String get graviaCheckoutLabel => 'Concludi l\'ordine';

  @override
  String graviaCartSummary(int count, String total) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count articoli',
      one: '$count articolo',
    );
    return '$_temp0 | $total';
  }

  @override
  String get graviaOrdersPageTitle => 'Ordini';

  @override
  String get graviaUpcomingTabLabel => 'In arrivo';

  @override
  String get graviaPastTabLabel => 'Passati';

  @override
  String get graviaPendingStatusLabel => 'Effettuato';

  @override
  String get graviaInProcessStatusLabel => 'In consegna';

  @override
  String get graviaDeliveredStatusLabel => 'Consegnato';

  @override
  String get graviaCancelledStatusLabel => 'Annullato';

  @override
  String get graviaDeliveryOtpLabel => 'OTP di consegna';

  @override
  String get graviaCancelOrderLabel => 'Annulla';

  @override
  String get graviaTrackOrderLabel => 'Traccia';

  @override
  String get graviaViewDetailsLabel => 'Dettagli';

  @override
  String get graviaWriteReviewLabel => 'Scrivi una recensione';

  @override
  String get graviaRefundPendingLabel => 'In corso';

  @override
  String get graviaRefundProcessedLabel => 'Rimborsato';

  @override
  String get graviaRefundFailedLabel => 'Non riuscito';

  @override
  String get graviaCancelOrderConfirmTitle => 'Annullare questo ordine?';

  @override
  String get graviaCancelOrderConfirmBody =>
      'Il tuo ordine verrà annullato. Se hai già pagato, riceverai il rimborso completo.';

  @override
  String get graviaCancelOrderConfirmCta => 'Annulla l\'ordine';

  @override
  String get graviaCancelOrderDismissCta => 'Mantieni l\'ordine';

  @override
  String get graviaCancelFailedMessage =>
      'Impossibile annullare l\'ordine. Riprova.';

  @override
  String get graviaOrdersLoadErrorMessage =>
      'Si è verificato un errore durante il caricamento dei tuoi ordini.';

  @override
  String get graviaOrdersRefreshFailedMessage =>
      'Aggiornamento non riuscito — vengono mostrati gli ultimi ordini caricati.';

  @override
  String get graviaTrackOrderTitle => 'Stato dell\'ordine';

  @override
  String get graviaOrderStatusTitle => 'Stato dell\'ordine';

  @override
  String get graviaOrderItemsTitle => 'Articoli';

  @override
  String get graviaOrderSummaryTitle => 'Riepilogo';

  @override
  String get graviaOrderDetailsTitle => 'Dettagli dell\'ordine';

  @override
  String get graviaDeliveryAddressTitle => 'Indirizzo di consegna';

  @override
  String get graviaOrderIdLabel => 'ID ordine';

  @override
  String get graviaOrderPlacedOnLabel => 'Effettuato il';

  @override
  String get graviaPaymentIdLabel => 'ID pagamento';

  @override
  String get graviaNoOnlinePaymentLabel => 'Nessun pagamento online';

  @override
  String get graviaRefundLabel => 'Rimborso';

  @override
  String get graviaCopiedMessage => 'Copiato';

  @override
  String get graviaOrderTotalLabel => 'Totale pagato';

  @override
  String get graviaOrderStepPlacedLabel => 'Ordine effettuato';

  @override
  String get graviaOrderStepOnTheWayLabel => 'In consegna';

  @override
  String get graviaOrderStepDeliveredLabel => 'Consegnato';

  @override
  String get graviaOrderStepCancelledLabel => 'Annullato';

  @override
  String get graviaOrderStepUndatedLabel => 'Orario non registrato';

  @override
  String get graviaOrdersEmptyTitle => 'Nessun ordine';

  @override
  String get graviaOrdersEmptySubtitle =>
      'I tuoi ordini passati e attivi compariranno qui.';

  @override
  String get graviaFilterSheetTitle => 'Filtra';

  @override
  String get graviaFilterReasonHeading => 'Seleziona un motivo';

  @override
  String get graviaFilterLastWeekLabel => '7 giorni';

  @override
  String get graviaFilterLastMonthLabel => '30 giorni';

  @override
  String get graviaFilterStatusLabel => 'Stato';

  @override
  String get graviaFilterDateLabel => 'Data';

  @override
  String get graviaFilterAllStatusesLabel => 'Tutti';

  @override
  String get graviaApplyFilterLabel => 'Applica filtro';

  @override
  String get graviaFavouritePageTitle => 'Preferiti';

  @override
  String get graviaFavouriteEmptyTitle => 'Nessun preferito';

  @override
  String get graviaFavouriteEmptySubtitle =>
      'Tocca il cuore su un prodotto per salvarlo qui.';

  @override
  String graviaAddedToCartMessage(int count, String name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count × $name aggiunti al carrello',
      one: '$name aggiunto al carrello',
    );
    return '$_temp0';
  }

  @override
  String get graviaDeliveryLocationLabel => 'Luogo di consegna';

  @override
  String get graviaNoLocationSelectedLabel => 'Nessun luogo selezionato';

  @override
  String get graviaNotificationsTitle => 'Notifiche';

  @override
  String get graviaNotificationsLoadErrorMessage =>
      'Si è verificato un errore durante il caricamento delle notifiche.';

  @override
  String get graviaNotificationsEmptyTitle => 'Nessuna notifica';

  @override
  String get graviaNotificationsEmptySubtitle =>
      'Gli aggiornamenti sui tuoi ordini e sul tuo account compariranno qui.';

  @override
  String get dailymartTopSellerTitle => 'Più venduti🔥';

  @override
  String get dailymartCategoriesTitle => 'Acquista per categoria';

  @override
  String get dailymartPopularProductsTitle => 'Prodotti popolari';

  @override
  String get dailymartSeeAll => 'Vedi tutto';

  @override
  String get dailymartSearchHint => 'Cerca prodotti';

  @override
  String get dailymartHomeLoadErrorMessage =>
      'Non è stato possibile caricare il catalogo di questo negozio.';

  @override
  String get dailymartNoLocationSelectedLabel => 'Seleziona una posizione';

  @override
  String get dailymartNotificationsTitle => 'Notifiche';

  @override
  String get dailymartNotificationsLoadErrorMessage =>
      'Non è stato possibile caricare le tue notifiche.';

  @override
  String get dailymartNotificationsEmptyTitle => 'Nessuna notifica';

  @override
  String get dailymartNotificationsEmptySubtitle =>
      'Le offerte e gli aggiornamenti sugli ordini di questo negozio compariranno qui.';

  @override
  String get dailymartOrderNow => 'Ordina ora';

  @override
  String dailymartPromoSubtitle(String percent) {
    return 'Approfitta di sconti fino al $percent%\nsul tuo ordine di oggi';
  }

  @override
  String dailymartDiscountPercentOff(String percent) {
    return '$percent% di sconto';
  }

  @override
  String get dailymartNavHome => 'Home';

  @override
  String get dailymartNavWishlist => 'Preferiti';

  @override
  String get dailymartNavCart => 'Carrello';

  @override
  String get dailymartNavProfile => 'Profilo';

  @override
  String get dailymartRecentSearchTitle => 'Ricerche recenti';

  @override
  String get dailymartRecentlyViewedTitle => 'Visti di recente';

  @override
  String dailymartResultsForLabel(String query) {
    return 'Risultati per \"$query\"';
  }

  @override
  String dailymartResultsCountLabel(int count) {
    return '$count trovati';
  }

  @override
  String get dailymartSearchLoadErrorMessage =>
      'Non è stato possibile caricare la ricerca.';

  @override
  String get dailymartSearchResultsErrorMessage =>
      'Non è stato possibile cercare in questo negozio.';

  @override
  String get dailymartSearchNoResultsTitle => 'Nessun risultato';

  @override
  String dailymartSearchNoResultsSubtitle(String query) {
    return 'Nessun prodotto di questo negozio corrisponde ancora a \"$query\".';
  }

  @override
  String get dailymartCategoryBadge => 'Categoria';

  @override
  String get dailymartFilterLabel => 'Filtra';

  @override
  String get dailymartSortSheetTitle => 'Ordina per';

  @override
  String get dailymartPriceSheetTitle => 'Prezzo';

  @override
  String get dailymartCategoryDetailsEmptyTitle => 'Nessun prodotto';

  @override
  String get dailymartCategoryDetailsEmptySubtitle =>
      'Nessun prodotto di questa categoria corrisponde a quei filtri.';

  @override
  String get dailymartCategoryDetailsErrorMessage =>
      'Non è stato possibile caricare questa categoria.';

  @override
  String get dailymartWishlistEmptyTitle => 'Nessun preferito';

  @override
  String get dailymartWishlistEmptySubtitle =>
      'Tocca il cuore su un prodotto e lo ritroverai qui.';

  @override
  String get dailymartWishlistExploreAction => 'Inizia lo shopping';

  @override
  String get dailymartProductDetailsTitle => 'Dettagli prodotto';

  @override
  String get dailymartDescriptionsTabLabel => 'Descrizione';

  @override
  String get dailymartReviewsTabLabel => 'Recensioni';

  @override
  String get dailymartRelatedProductsTitle => 'Prodotti correlati';

  @override
  String get dailymartSelectSizeLabel => 'Seleziona il formato';

  @override
  String get dailymartProductDetailsLoadErrorMessage =>
      'Non è stato possibile caricare i dettagli del prodotto.';

  @override
  String get dailymartAddToCart => 'Aggiungi al carrello';

  @override
  String get dailymartAddToCartSheetTitle => 'Aggiungi al carrello';

  @override
  String dailymartAddedToCartMessage(int count, String name) {
    return 'Aggiunti $count × $name al tuo carrello.';
  }

  @override
  String dailymartStarRowLabel(int stars) {
    return '$stars stelle';
  }

  @override
  String get dailymartMyCartTitle => 'Il mio carrello';

  @override
  String get dailymartCouponHint => 'Inserisci il codice promozionale';

  @override
  String get dailymartCouponRemoveLabel => 'Rimuovi';

  @override
  String get dailymartCouponDetailLabel => 'Codice promozionale';

  @override
  String dailymartCouponApplied(String code) {
    return '$code applicato';
  }

  @override
  String dailymartCouponLine(String code) {
    return 'Codice promozionale ($code)';
  }

  @override
  String get dailymartSubTotalLabel => 'Subtotale';

  @override
  String get dailymartDeliveryLabel => 'Consegna';

  @override
  String get dailymartDeliveryFreeLabel => 'Gratuita';

  @override
  String get dailymartDiscountLabel => 'Sconto';

  @override
  String get dailymartTotalCostLabel => 'Costo totale';

  @override
  String get dailymartProceedToCheckoutLabel => 'Vai alla cassa';

  @override
  String get dailymartCartEmptyTitle => 'Il tuo carrello è vuoto';

  @override
  String get dailymartCartEmptySubtitle =>
      'I prodotti che aggiungi compariranno qui, pronti per l\'ordine.';

  @override
  String get dailymartCartExploreAction => 'Inizia lo shopping';

  @override
  String get dailymartRemovedFromCartMessage => 'Rimosso dal tuo carrello.';

  @override
  String get dailymartCheckoutTitle => 'Concludi l\'ordine';

  @override
  String get dailymartShippingAddressLabel => 'Indirizzo di spedizione';

  @override
  String get dailymartOrderListLabel => 'Riepilogo dell\'ordine';

  @override
  String get dailymartContinueToPaymentLabel => 'Continua con il pagamento';

  @override
  String get dailymartOrderPlacedTitle => 'Pagamento riuscito!';

  @override
  String get dailymartOrderPlacedMessage =>
      'Grazie per il tuo acquisto! Siamo felici di dirti che il pagamento è stato elaborato correttamente. 🎉';

  @override
  String get dailymartTrackOrderLabel => 'Traccia il mio ordine';

  @override
  String dailymartCartSummary(int count, String total) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count articoli',
      one: '$count articolo',
    );
    return '$_temp0 | $total';
  }

  @override
  String get dailymartViewCartLabel => 'Vedi il carrello';

  @override
  String get dailymartGeneralSectionTitle => 'Generale';

  @override
  String get dailymartPreferencesSectionTitle => 'Preferenze';

  @override
  String get dailymartEditProfileLabel => 'Modifica profilo';

  @override
  String get dailymartChangePasswordLabel => 'Modifica password';

  @override
  String get dailymartMyOrdersLabel => 'I miei ordini';

  @override
  String get dailymartMyAddressLabel => 'I miei indirizzi';

  @override
  String get dailymartDarkModeLabel => 'Modalità scura';

  @override
  String get dailymartPrivacyPolicyLabel => 'Informativa sulla privacy';

  @override
  String get dailymartTermsAndConditionsLabel => 'Termini e condizioni';

  @override
  String get dailymartLogoutLabel => 'Esci';

  @override
  String get dailymartLogoutTitle => 'Vuoi uscire?';

  @override
  String get dailymartLogoutConfirmMessage =>
      'Dovrai accedere di nuovo per effettuare un ordine o per seguirne uno.';

  @override
  String get dailymartProfileLoadErrorMessage =>
      'Non è stato possibile caricare il tuo profilo.';

  @override
  String get dailymartEditProfileTitle => 'Modifica profilo';

  @override
  String get dailymartFullNameLabel => 'Nome completo';

  @override
  String get dailymartFullNameHint => 'Inserisci il tuo nome completo';

  @override
  String get dailymartEmailLabel => 'E-mail';

  @override
  String get dailymartEmailHint => 'tu@esempio.com';

  @override
  String get dailymartPhoneNumberLabel => 'Numero di telefono';

  @override
  String get dailymartPhoneNumberHint => 'Inserisci il tuo numero di telefono';

  @override
  String get dailymartSaveChangesLabel => 'Salva le modifiche';

  @override
  String get dailymartChangePhotoTitle => 'Modifica foto';

  @override
  String get dailymartTakePhotoLabel => 'Scatta una foto';

  @override
  String get dailymartChooseFromGalleryLabel => 'Scegli dalla galleria';

  @override
  String get dailymartAvatarPickerMobileOnlyMessage =>
      'La scelta di una foto è disponibile solo su mobile.';

  @override
  String get dailymartChangePasswordTitle => 'Modifica password';

  @override
  String get dailymartCurrentPasswordLabel => 'Password attuale';

  @override
  String get dailymartCurrentPasswordHint => 'Inserisci la password attuale';

  @override
  String get dailymartNewPasswordLabel => 'Nuova password';

  @override
  String get dailymartNewPasswordHint => 'Inserisci la nuova password';

  @override
  String get dailymartConfirmNewPasswordLabel => 'Conferma la nuova password';

  @override
  String get dailymartConfirmNewPasswordHint => 'Reinserisci la nuova password';

  @override
  String get dailymartUpdatePasswordButtonLabel => 'Aggiorna password';

  @override
  String get dailymartPasswordUpdatedMessage =>
      'La tua password è stata aggiornata.';

  @override
  String get dailymartSelectAddressTitle => 'Seleziona l\'indirizzo';

  @override
  String get dailymartAddNewAddressLabel => 'Aggiungi un nuovo indirizzo';

  @override
  String get dailymartAddressLoadErrorMessage =>
      'Non è stato possibile caricare i tuoi indirizzi.';

  @override
  String get dailymartAddressSaveFailedMessage =>
      'Non è stato possibile salvare l\'indirizzo.';

  @override
  String get dailymartAddressEmptyTitle => 'Nessun indirizzo salvato';

  @override
  String get dailymartAddressEmptySubtitle =>
      'Aggiungine uno per farti consegnare a casa da questo negozio.';

  @override
  String get dailymartAddressDeleteFailedMessage =>
      'Non è stato possibile eliminare l\'indirizzo.';

  @override
  String get dailymartEditAddressTooltip => 'Modifica indirizzo';

  @override
  String get dailymartDeleteAddressTitle => 'Vuoi eliminare questo indirizzo?';

  @override
  String get dailymartDeleteAddressMessage =>
      'Verrà rimosso dai tuoi indirizzi salvati.';

  @override
  String get dailymartDeleteLabel => 'Elimina';

  @override
  String get dailymartAddAddressTitle => 'Aggiungi un nuovo indirizzo';

  @override
  String get dailymartEditAddressTitle => 'Modifica indirizzo';

  @override
  String get dailymartAddressNameLabel => 'Nome';

  @override
  String get dailymartAddressNameHint => 'es. Mario Rossi';

  @override
  String get dailymartAddressLine1Label => 'Indirizzo (riga 1)';

  @override
  String get dailymartAddressLine1Hint => 'Numero civico, via';

  @override
  String get dailymartAddressLine2Label => 'Indirizzo (riga 2)';

  @override
  String get dailymartAddressLine2Hint =>
      'Appartamento, interno, ecc. (opzionale)';

  @override
  String get dailymartLandmarkLabel => 'Punto di riferimento';

  @override
  String get dailymartLandmarkHint => 'Punto di riferimento vicino (opzionale)';

  @override
  String get dailymartCityLabel => 'Città';

  @override
  String get dailymartCityHint => 'es. Milano';

  @override
  String get dailymartStateLabel => 'Provincia';

  @override
  String get dailymartStateHint => 'es. MI (opzionale)';

  @override
  String get dailymartCountryLabel => 'Paese';

  @override
  String get dailymartSelectCountryTitle => 'Seleziona il paese';

  @override
  String get dailymartPostalCodeLabel => 'CAP';

  @override
  String get dailymartPostalCodeHint => 'es. 62639';

  @override
  String get dailymartAddressTagLabel => 'Etichetta';

  @override
  String get dailymartAddressTagHint => 'es. Casa, Ufficio';

  @override
  String get dailymartAddAddressButtonLabel => 'Aggiungi indirizzo';

  @override
  String get dailymartUpdateAddressButtonLabel => 'Aggiorna indirizzo';

  @override
  String get dailymartRequiredFieldErrorMessage =>
      'Questo campo è obbligatorio';

  @override
  String get dailymartMyOrdersTitle => 'I miei ordini';

  @override
  String get dailymartOrdersSearchHint => 'Cosa stai cercando...';

  @override
  String get dailymartOrdersFilterAllLabel => 'Tutti';

  @override
  String get dailymartOrdersFilterActiveLabel => 'In corso';

  @override
  String get dailymartOrdersFilterCompletedLabel => 'Completati';

  @override
  String get dailymartOrdersFilterCancelledLabel => 'Annullati';

  @override
  String dailymartOrderSummaryLabel(int count, String date) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count articoli',
      one: '$count articolo',
    );
    return '$_temp0 · $date';
  }

  @override
  String get dailymartOrdersDateRangeLabel => 'Intervallo di date';

  @override
  String get dailymartOrdersAllTimeLabel => 'Sempre';

  @override
  String get dailymartOrdersFilterLastWeekLabel => '7 giorni';

  @override
  String get dailymartOrdersFilterLastMonthLabel => '30 giorni';

  @override
  String get dailymartResetLabel => 'Reimposta';

  @override
  String get dailymartApplyLabel => 'Applica';

  @override
  String get dailymartOrdersLoadErrorMessage =>
      'Non è stato possibile caricare i tuoi ordini.';

  @override
  String get dailymartOrdersEmptyTitle => 'Nessun ordine';

  @override
  String get dailymartOrdersEmptySubtitle =>
      'I tuoi ordini da questo negozio compariranno qui.';

  @override
  String get dailymartOrdersNoResultsTitle => 'Nessun ordine trovato';

  @override
  String get dailymartOrdersNoResultsSubtitle =>
      'Nessun ordine corrisponde a quella ricerca o a quel filtro.';

  @override
  String get dailymartOrderCancelFailedMessage =>
      'Non è stato possibile annullare l\'ordine.';

  @override
  String get dailymartOrdersRefreshFailedMessage =>
      'Non è stato possibile aggiornare i tuoi ordini.';

  @override
  String get dailymartTrackOrderTitle => 'Stato dell\'ordine';

  @override
  String get dailymartTrackOrderAction => 'Traccia';

  @override
  String get dailymartOrderDetailsTitle => 'Dettagli dell\'ordine';

  @override
  String get dailymartOrderIdLabel => 'ID ordine';

  @override
  String get dailymartDeliveryOtpLabel => 'OTP di consegna';

  @override
  String get dailymartPaymentTitle => 'Pagamento';

  @override
  String get dailymartAmountPaidLabel => 'Importo pagato';

  @override
  String get dailymartPaymentIdLabel => 'ID pagamento';

  @override
  String get dailymartRefundLabel => 'Rimborso';

  @override
  String get dailymartCopiedMessage => 'Copiato';

  @override
  String get dailymartNoOnlinePaymentLabel => 'Non pagato online';

  @override
  String get dailymartRefundPendingLabel => 'In corso';

  @override
  String get dailymartRefundProcessedLabel => 'Rimborsato';

  @override
  String get dailymartRefundFailedLabel => 'Non riuscito';

  @override
  String get dailymartOrderStatusTitle => 'Stato dell\'ordine';

  @override
  String get dailymartOrderStepPlacedLabel => 'Effettuato';

  @override
  String get dailymartOrderStepOnTheWayLabel => 'In consegna';

  @override
  String get dailymartOrderStepDeliveredLabel => 'Consegnato';

  @override
  String get dailymartOrderStepCancelledLabel => 'Annullato';

  @override
  String get dailymartOrderStepUndatedLabel => 'Orario non registrato';

  @override
  String get dailymartOrderStepPendingLabel => 'In attesa';

  @override
  String get dailymartCancelOrderLabel => 'Annulla';

  @override
  String get dailymartCancelOrderTitle => 'Vuoi annullare l\'ordine?';

  @override
  String get dailymartCancelOrderMessage =>
      'Se l\'ordine è stato pagato, riceverai un rimborso.';

  @override
  String get dailymartCancelOrderConfirmLabel => 'Annulla l\'ordine';

  @override
  String get dailymartCancelLabel => 'Annulla';

  @override
  String grofastGreeting(String name) {
    return 'Ciao $name 👋';
  }

  @override
  String get grofastGreetingFallbackName => 'a te';

  @override
  String get grofastGreetingSubtitle => 'Trova la spesa fresca che cerchi';

  @override
  String get grofastSearchHint => 'Cerca prodotti freschi';

  @override
  String get grofastCategoriesTitle => 'Categorie';

  @override
  String get grofastPopularTitle => 'Popolari';

  @override
  String get grofastSeeAll => 'vedi tutto';

  @override
  String get grofastHomeLoadErrorMessage =>
      'Non è stato possibile caricare il catalogo di questo negozio.';

  @override
  String get grofastNoLocationSelectedLabel => 'Scegli una posizione';

  @override
  String get grofastClaimNow => 'riscatta';

  @override
  String grofastPromoDiscountLabel(String percent) {
    return 'Sconto $percent';
  }

  @override
  String get grofastCategoriesLoadErrorMessage =>
      'Non è stato possibile caricare le categorie.';

  @override
  String get grofastCategoriesEmptyTitle => 'Nessuna categoria';

  @override
  String get grofastCategoriesEmptySubtitle =>
      'Questo negozio non ha pubblicato nessuna categoria.';

  @override
  String grofastCategoryProductsTitle(String category) {
    return 'Tutto in $category';
  }

  @override
  String get grofastCategoryDetailsEmptyTitle => 'Ancora niente qui';

  @override
  String get grofastCategoryDetailsEmptySubtitle =>
      'Nessun prodotto in questa categoria al momento.';

  @override
  String get grofastCategoryDetailsErrorMessage =>
      'Non è stato possibile caricare questa categoria.';

  @override
  String get grofastSearchTitle => 'Cerca prodotti';

  @override
  String get grofastRecentSearchTitle => 'Ricerche recenti';

  @override
  String grofastResultsCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Trovati $count risultati',
      one: 'Trovato $count risultato',
    );
    return '$_temp0';
  }

  @override
  String get grofastSearchLoadErrorMessage =>
      'Non è stato possibile caricare la ricerca.';

  @override
  String get grofastSearchResultsErrorMessage =>
      'Non è stato possibile cercare in questo negozio.';

  @override
  String get grofastSearchNoResultsTitle => 'Nessun risultato';

  @override
  String grofastSearchNoResultsSubtitle(String query) {
    return 'Nessun risultato per \"$query\". Prova un\'altra parola.';
  }

  @override
  String get grofastSearchIdleTitle => 'Cosa stai cercando?';

  @override
  String get grofastSearchIdleSubtitle =>
      'Cerca in tutto il negozio per nome o categoria.';

  @override
  String get grofastSortByTitle => 'Ordina per';

  @override
  String get grofastPriceTitle => 'Prezzo';

  @override
  String get grofastApplyLabel => 'Applica';

  @override
  String get grofastResetLabel => 'Reimposta';

  @override
  String get grofastAddToBagTooltip => 'Aggiungi al carrello';

  @override
  String get grofastFavouriteTooltip => 'Aggiungi ai preferiti';

  @override
  String get grofastDecreaseQuantityLabel => 'Riduci quantità';

  @override
  String get grofastIncreaseQuantityLabel => 'Aumenta quantità';

  @override
  String get grofastProductDetailsTitle => 'Dettagli prodotto';

  @override
  String get grofastDescriptionTitle => 'Descrizione';

  @override
  String get grofastSelectSizeTitle => 'Scegli il formato';

  @override
  String get grofastAddToBag => 'Aggiungi al carrello';

  @override
  String get grofastProductDetailsLoadErrorMessage =>
      'Non è stato possibile caricare questo prodotto.';

  @override
  String grofastAddedToBagMessage(int count, String name) {
    return 'Aggiunto al carrello: $count × $name.';
  }

  @override
  String get grofastNoDescriptionLabel =>
      'Nessuna descrizione per questo prodotto.';

  @override
  String get grofastBagTitle => 'Il mio carrello';

  @override
  String grofastBagItemCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count articoli',
      one: '$count articolo',
    );
    return '$_temp0';
  }

  @override
  String get grofastPromoCodeHint => 'Aggiungi codice promozionale';

  @override
  String get grofastPromoApplyLabel => 'Applica';

  @override
  String get grofastPromoRemoveLabel => 'Rimuovi';

  @override
  String get grofastCouponDetailLabel => 'Codice promozionale';

  @override
  String grofastPromoApplied(String code) {
    return '$code applicato';
  }

  @override
  String grofastCouponLine(String code) {
    return 'Codice promozionale ($code)';
  }

  @override
  String get grofastPromoComingSoonMessage =>
      'I codici promozionali arriveranno prossimamente.';

  @override
  String get grofastTotalLabel => 'Totale';

  @override
  String get grofastSubtotalLabel => 'Subtotale';

  @override
  String get grofastDeliveryLabel => 'Consegna';

  @override
  String get grofastDeliveryFreeLabel => 'Gratuita';

  @override
  String get grofastDiscountLabel => 'Sconto';

  @override
  String get grofastProceedToCheckoutLabel => 'Vai alla cassa';

  @override
  String get grofastBagEmptyTitle => 'Il tuo carrello è vuoto';

  @override
  String get grofastBagEmptySubtitle =>
      'Aggiungi qualche prodotto fresco e lo troverai qui.';

  @override
  String get grofastBagExploreAction => 'Inizia la spesa';

  @override
  String get grofastRemovedFromBagMessage => 'Rimosso dal carrello.';

  @override
  String get grofastCheckoutTitle => 'Concludi l\'ordine';

  @override
  String get grofastItemsTitle => 'Articoli';

  @override
  String get grofastDeliveryAddressTitle => 'Indirizzo di consegna';

  @override
  String get grofastAddNewLabel => 'aggiungi';

  @override
  String get grofastChangeAddressLabel => 'modifica';

  @override
  String get grofastNoAddressSelectedLabel => 'Scegli dove consegnare';

  @override
  String get grofastConfirmOrderLabel => 'Conferma l\'ordine';

  @override
  String get grofastOrderPlacedTitle => 'Fatto!';

  @override
  String get grofastOrderPlacedMessage =>
      'Il tuo ordine è stato creato con successo.';

  @override
  String get grofastBrowseHomeLabel => 'Vai alla home';

  @override
  String get grofastNavHome => 'Home';

  @override
  String get grofastNavCategories => 'Categorie';

  @override
  String get grofastNavBag => 'Carrello';

  @override
  String get grofastNavAccount => 'Profilo';

  @override
  String get grofastProfileTitle => 'Profilo';

  @override
  String get grofastNotificationTileLabel => 'Notifiche';

  @override
  String get grofastOrdersTileLabel => 'I miei ordini';

  @override
  String get grofastWishlistTileLabel => 'Preferiti';

  @override
  String get grofastMyProfileLabel => 'Il mio profilo';

  @override
  String get grofastChangePasswordLabel => 'Modifica password';

  @override
  String get grofastDarkModeLabel => 'Modalità scura';

  @override
  String get grofastMyAddressLabel => 'I miei indirizzi';

  @override
  String get grofastPrivacyPolicyLabel => 'Informativa sulla privacy';

  @override
  String get grofastTermsAndConditionsLabel => 'Termini e condizioni';

  @override
  String get grofastLogOutLabel => 'Esci';

  @override
  String get grofastLogOutTitle => 'Vuoi uscire?';

  @override
  String get grofastLogOutConfirmMessage =>
      'Dovrai accedere di nuovo per effettuare un ordine.';

  @override
  String get grofastProfileLoadErrorMessage =>
      'Non è stato possibile caricare il tuo profilo.';

  @override
  String get grofastProfileNameFallback => 'Il tuo account';

  @override
  String get grofastEditProfileTitle => 'Il mio profilo';

  @override
  String get grofastFullNameLabel => 'Nome completo';

  @override
  String get grofastFullNameHint => 'Inserisci il tuo nome completo';

  @override
  String get grofastEmailLabel => 'E-mail';

  @override
  String get grofastEmailHint => 'tu@esempio.com';

  @override
  String get grofastPhoneNumberLabel => 'Numero di telefono';

  @override
  String get grofastPhoneNumberHint => 'Inserisci il tuo numero di telefono';

  @override
  String get grofastSaveChangesLabel => 'Salva modifiche';

  @override
  String get grofastChangePhotoTitle => 'Cambia foto';

  @override
  String get grofastTakePhotoLabel => 'Scatta una foto';

  @override
  String get grofastChooseFromGalleryLabel => 'Scegli dalla galleria';

  @override
  String get grofastAvatarPickerMobileOnlyMessage =>
      'La scelta della foto è disponibile solo su mobile.';

  @override
  String get grofastProfileUpdatedMessage =>
      'Il tuo profilo è stato aggiornato.';

  @override
  String get grofastChangePasswordTitle => 'Modifica password';

  @override
  String get grofastCurrentPasswordLabel => 'Password attuale';

  @override
  String get grofastCurrentPasswordHint => 'Inserisci la password attuale';

  @override
  String get grofastNewPasswordLabel => 'Nuova password';

  @override
  String get grofastNewPasswordHint => 'Inserisci la nuova password';

  @override
  String get grofastConfirmNewPasswordLabel => 'Conferma nuova password';

  @override
  String get grofastConfirmNewPasswordHint => 'Reinserisci la nuova password';

  @override
  String get grofastUpdatePasswordButtonLabel => 'Aggiorna password';

  @override
  String get grofastPasswordUpdatedMessage =>
      'La tua password è stata aggiornata.';

  @override
  String get grofastWishlistTitle => 'Preferiti';

  @override
  String get grofastWishlistEmptyTitle => 'Nessun preferito';

  @override
  String get grofastWishlistEmptySubtitle =>
      'Tocca il cuore su tutto quello che vuoi salvare per dopo.';

  @override
  String get grofastWishlistExploreAction => 'Inizia la spesa';

  @override
  String get grofastNotificationsTitle => 'Notifiche';

  @override
  String get grofastNotificationsFilterAllLabel => 'Tutte';

  @override
  String get grofastNotificationsSearchHint => 'Cerca nelle notifiche';

  @override
  String get grofastNotificationsNowTitle => 'Adesso';

  @override
  String get grofastNotificationsPastTitle => 'Precedenti';

  @override
  String get grofastNotificationsLoadErrorMessage =>
      'Non è stato possibile caricare le notifiche.';

  @override
  String get grofastNotificationsEmptyTitle => 'Nessuna notifica';

  @override
  String get grofastNotificationsEmptySubtitle =>
      'Ti avviseremo quando succede qualcosa ai tuoi ordini.';

  @override
  String get grofastNotificationsNoResultsTitle => 'Nessun risultato';

  @override
  String grofastNotificationsNoResultsSubtitle(String query) {
    return 'Nessuna notifica corrisponde a \"$query\".';
  }

  @override
  String get grofastSelectAddressTitle => 'Scegli l\'indirizzo';

  @override
  String get grofastAddNewAddressLabel => 'Aggiungi indirizzo';

  @override
  String get grofastAddressLoadErrorMessage =>
      'Non è stato possibile caricare i tuoi indirizzi.';

  @override
  String get grofastAddressEmptyTitle => 'Nessun indirizzo salvato';

  @override
  String get grofastAddressEmptySubtitle =>
      'Aggiungine uno così sappiamo dove portare la tua spesa.';

  @override
  String get grofastAddressSaveFailedMessage =>
      'Non è stato possibile salvare l\'indirizzo.';

  @override
  String get grofastAddressDeleteFailedMessage =>
      'Non è stato possibile eliminare l\'indirizzo.';

  @override
  String get grofastEditAddressTooltip => 'Modifica indirizzo';

  @override
  String get grofastDeleteAddressTitle => 'Eliminare questo indirizzo?';

  @override
  String get grofastDeleteAddressMessage =>
      'Verrà rimosso dalle posizioni salvate. L\'operazione non può essere annullata.';

  @override
  String get grofastDeleteLabel => 'Elimina';

  @override
  String get grofastCancelLabel => 'Annulla';

  @override
  String get grofastAddAddressTitle => 'Aggiungi indirizzo';

  @override
  String get grofastEditAddressTitle => 'Modifica indirizzo';

  @override
  String get grofastAddressNameLabel => 'Nome';

  @override
  String get grofastAddressNameHint => 'es. Yona Angela';

  @override
  String get grofastAddressLine1Label => 'Indirizzo (riga 1)';

  @override
  String get grofastAddressLine1Hint => 'Numero civico, via';

  @override
  String get grofastAddressLine2Label => 'Indirizzo (riga 2)';

  @override
  String get grofastAddressLine2Hint => 'Interno, scala, ecc. (facoltativo)';

  @override
  String get grofastLandmarkLabel => 'Punto di riferimento';

  @override
  String get grofastLandmarkHint => 'Punto di riferimento vicino (facoltativo)';

  @override
  String get grofastCityLabel => 'Città';

  @override
  String get grofastCityHint => 'es. Bengaluru';

  @override
  String get grofastStateLabel => 'Regione';

  @override
  String get grofastStateHint => 'es. Karnataka (facoltativo)';

  @override
  String get grofastCountryLabel => 'Paese';

  @override
  String get grofastSelectCountryTitle => 'Scegli il paese';

  @override
  String get grofastPostalCodeLabel => 'Codice postale';

  @override
  String get grofastPostalCodeHint => 'es. 62639';

  @override
  String get grofastAddressTagLabel => 'Etichetta';

  @override
  String get grofastAddressTagHint => 'es. Casa, Ufficio';

  @override
  String get grofastMobileLabel => 'Numero di cellulare';

  @override
  String get grofastMobileHint => 'Dove possiamo contattarti';

  @override
  String get grofastAddAddressButtonLabel => 'Aggiungi indirizzo';

  @override
  String get grofastUpdateAddressButtonLabel => 'Aggiorna indirizzo';

  @override
  String get grofastRequiredFieldErrorMessage => 'Questo campo è obbligatorio';

  @override
  String get grofastMyOrdersTitle => 'I miei ordini';

  @override
  String get grofastOrdersSearchHint => 'Cerca nei tuoi ordini';

  @override
  String get grofastOrdersFilterAllLabel => 'Tutti';

  @override
  String get grofastOrdersFilterActiveLabel => 'In consegna';

  @override
  String get grofastOrdersFilterCompletedLabel => 'Consegnati';

  @override
  String get grofastOrdersFilterCancelledLabel => 'Annullati';

  @override
  String get grofastOrdersDateFilterTitle => 'Filtra per data';

  @override
  String get grofastOrdersDateRangeLabel => 'Intervallo di date';

  @override
  String get grofastOrdersAllTimeLabel => 'Sempre';

  @override
  String get grofastOrdersFilterLastWeekLabel => '7 giorni';

  @override
  String get grofastOrdersFilterLastMonthLabel => '30 giorni';

  @override
  String get grofastOrdersLoadErrorMessage =>
      'Non è stato possibile caricare i tuoi ordini.';

  @override
  String get grofastOrdersRefreshFailedMessage =>
      'Non è stato possibile aggiornare i tuoi ordini.';

  @override
  String get grofastOrdersEmptyTitle => 'Nessun ordine';

  @override
  String get grofastOrdersEmptySubtitle =>
      'I tuoi ordini appariranno qui dopo il primo acquisto.';

  @override
  String get grofastOrdersNoResultsTitle => 'Nessun risultato';

  @override
  String get grofastOrdersNoResultsSubtitle =>
      'Nessun ordine corrisponde a questi filtri. Prova ad allargarli.';

  @override
  String grofastOrderNumberLabel(String date) {
    return 'Ordine del $date';
  }

  @override
  String grofastOrderItemCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count articoli',
      one: '$count articolo',
    );
    return '$_temp0';
  }

  @override
  String grofastOrderDeliveredLine(String label) {
    return 'Consegnato a $label';
  }

  @override
  String grofastOrderDeliveringLine(String label) {
    return 'In consegna a $label';
  }

  @override
  String get grofastOrderCancelledLine => 'Questo ordine è stato annullato';

  @override
  String get grofastTrackOrderTitle => 'Stato dell\'ordine';

  @override
  String get grofastOrderDetailTitle => 'Dettagli dell\'ordine';

  @override
  String get grofastCopyTooltip => 'Copia';

  @override
  String grofastCopiedMessage(String label) {
    return '$label copiato.';
  }

  @override
  String get grofastTrackingDetailTitle => 'Dettagli della consegna';

  @override
  String get grofastOrderStatusLabel => 'Stato';

  @override
  String get grofastPurchaseDateLabel => 'Data di acquisto';

  @override
  String get grofastOrderIdLabel => 'ID ordine';

  @override
  String get grofastDeliveryOtpLabel => 'OTP di consegna';

  @override
  String get grofastPaymentIdLabel => 'ID pagamento';

  @override
  String get grofastAmountPaidLabel => 'Importo pagato';

  @override
  String get grofastNoOnlinePaymentLabel => 'Non pagato online';

  @override
  String get grofastRefundLabel => 'Rimborso';

  @override
  String get grofastOrderReceivedLabel => 'Ordine ricevuto';

  @override
  String get grofastCancelOrderLabel => 'Annulla';

  @override
  String get grofastCancelOrderTitle => 'Annullare questo ordine?';

  @override
  String get grofastCancelOrderMessage =>
      'Ti rimborseremo quanto hai pagato. L\'operazione non può essere annullata.';

  @override
  String get grofastCancelOrderConfirmLabel => 'Annulla l\'ordine';

  @override
  String get grofastOrderCancelFailedMessage =>
      'Non è stato possibile annullare l\'ordine.';

  @override
  String get grofastOrderStepUndatedLabel => 'Orario non registrato';

  @override
  String get grofastOrderStepPendingLabel => 'In attesa';

  @override
  String get grofastStatusPlacedLabel => 'Effettuato';

  @override
  String get grofastStatusOnDeliveryLabel => 'In consegna';

  @override
  String get grofastStatusDeliveredLabel => 'Consegnato';

  @override
  String get grofastStatusCancelledLabel => 'Annullato';

  @override
  String get grofastRefundPendingLabel => 'In corso';

  @override
  String get grofastRefundProcessedLabel => 'Rimborsato';

  @override
  String get grofastRefundFailedLabel => 'Non riuscito';

  @override
  String get validationNameRequired => 'Inserisci il tuo nome.';

  @override
  String get validationEmailRequired => 'Inserisci il tuo indirizzo e-mail.';

  @override
  String get validationEmailInvalid => 'Inserisci un indirizzo e-mail valido.';

  @override
  String get validationMobileRequired =>
      'Inserisci il tuo numero di cellulare.';

  @override
  String get validationMobileInvalid =>
      'Inserisci un numero di cellulare valido.';

  @override
  String get validationPasswordRequired => 'Inserisci la tua password.';

  @override
  String get validationWeakPassword =>
      'La password deve contenere almeno 6 caratteri.';

  @override
  String get validationConfirmPasswordRequired =>
      'Conferma la tua nuova password.';

  @override
  String get validationPasswordsDontMatch => 'Le password non corrispondono.';

  @override
  String get notificationsSectionToday => 'Oggi';

  @override
  String get notificationsSectionYesterday => 'Ieri';

  @override
  String get notificationsSectionEarlier => 'Prima';

  @override
  String get notificationsPermissionTitle => 'Le notifiche sono disattivate';

  @override
  String get notificationsPermissionSubtitle =>
      'Attivale per ricevere aggiornamenti sui tuoi ordini e offerte di questo negozio.';

  @override
  String get notificationsPermissionCta => 'Attiva le notifiche';

  @override
  String get notificationsPermissionBlockedMessage =>
      'Le notifiche sono bloccate per CordeliaApps. Attivale nelle impostazioni del tuo dispositivo.';
}
