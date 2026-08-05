import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:cordelia/constants/value_const.dart';
import 'package:cordelia/feature/storefront/active_store/presentation/cubit/active_store_cubit.dart';
import 'package:cordelia/feature/storefront/template/store_language.dart';

import 'active_locale_controller.dart';
import 'active_locale_scope.dart';
import 'store_locale_prefs.dart';

/// The behaviour behind every pack's Profile → Language row — read the
/// active store's effective language and commit a new pick (persist the
/// per-store override, then apply the locale) — shared so the three packs'
/// rows can't drift; each pack still renders its own sheet chrome.
extension StoreLanguageSwitchX on BuildContext {
  StoreLanguage get currentStoreLanguage {
    final store = read<ActiveStoreCubit>().state!;
    return StoreLocalePrefs.overrideFor(store.storeId) ?? store.language;
  }

  void switchStoreLanguage(StoreLanguage language) {
    final store = read<ActiveStoreCubit>().state!;
    StoreLocalePrefs.saveOverride(store.storeId, language);
    ActiveLocaleScope.of(this).apply(language.asLocale);
  }
}

extension StoreLanguageLabelX on StoreLanguage {
  /// Self-named option labels ("English" / "Deutsch" / "Français" /
  /// "Español" / "Italiano" / "हिन्दी") — a language
  /// names itself the same way in every locale, so a shopper who can't read
  /// the current one can still find their own in the list.
  String get label => switch (this) {
    StoreLanguage.en => ValueConst.languageEnglish,
    StoreLanguage.de => ValueConst.languageGerman,
    StoreLanguage.fr => ValueConst.languageFrench,
    StoreLanguage.es => ValueConst.languageSpanish,
    StoreLanguage.it => ValueConst.languageItalian,
    StoreLanguage.hi => ValueConst.languageHindi,
  };
}
