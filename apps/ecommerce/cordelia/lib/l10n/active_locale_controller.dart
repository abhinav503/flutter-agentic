import 'package:flutter/widgets.dart';

import 'package:cordelia/feature/storefront/template/store_language.dart';

import 'gen/app_localizations.dart';
import 'l10n.dart';

/// Holds the [Locale] currently driving [MaterialApp.router]'s `locale` —
/// the language sibling of `ActiveThemeController`, swapped per storefront
/// visit by `StorefrontPage` and restored to the app default on exit.
class ActiveLocaleController extends ValueNotifier<Locale> {
  ActiveLocaleController() : super(L10n.appDefaultLocale);

  void apply(Locale locale) {
    // Before the notify, so listeners' rebuilds read the new strings.
    L10n.current = lookupAppLocalizations(locale);
    value = locale;
  }

  void resetToAppDefault() => apply(L10n.appDefaultLocale);
}

/// Lives here, not beside the enum — `StoreLanguage` stays pure Dart so
/// domain entities can hold it, and `Locale` is a Flutter type.
extension StoreLanguageLocaleX on StoreLanguage {
  Locale get asLocale => switch (this) {
    StoreLanguage.en => const Locale('en'),
    StoreLanguage.hi => const Locale('hi'),
  };
}
