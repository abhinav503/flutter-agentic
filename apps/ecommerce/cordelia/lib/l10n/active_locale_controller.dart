import 'package:flutter/widgets.dart';

import 'package:core/core/formatting/app_format.dart';

import 'package:cordelia/feature/storefront/template/store_currency.dart';
import 'package:cordelia/feature/storefront/template/store_language.dart';

import 'gen/app_localizations.dart';
import 'l10n.dart';

/// Holds the [Locale] currently driving [MaterialApp.router]'s `locale` —
/// the language sibling of `ActiveThemeController`, swapped per storefront
/// visit by `StorefrontPage` and restored to the app default on exit.
class ActiveLocaleController extends ValueNotifier<Locale> {
  ActiveLocaleController() : super(L10n.appDefaultLocale);

  /// Swaps the strings *and* the number/date formatting together — a screen
  /// whose copy is German while its prices still use an English decimal point
  /// is the failure this single entry point exists to make unreachable.
  ///
  /// [currency] is the store's, and is omitted when only the language changes
  /// (the shopper's in-store language switch), since what the store charges in
  /// doesn't move with it.
  void apply(Locale locale, {StoreCurrency? currency}) {
    // Both before the notify, so listeners' rebuilds read the new language
    // and the new formatting in the same frame.
    L10n.current = lookupAppLocalizations(locale);
    AppFormat.apply(
      locale: locale.toLanguageTag(),
      currencyCode: currency?.wireValue,
    );
    value = locale;
  }

  void resetToAppDefault() {
    AppFormat.resetToDefaults();
    apply(L10n.appDefaultLocale);
  }
}

/// Lives here, not beside the enum — `StoreLanguage` stays pure Dart so
/// domain entities can hold it, and `Locale` is a Flutter type.
extension StoreLanguageLocaleX on StoreLanguage {
  Locale get asLocale => switch (this) {
    StoreLanguage.en => const Locale('en'),
    StoreLanguage.hi => const Locale('hi'),
    StoreLanguage.de => const Locale('de'),
  };
}
