import 'package:flutter/widgets.dart';

import 'gen/app_localizations.dart';

/// Static access to the active locale's strings — the bridge that lets the
/// existing const-holder API (`ValueConst`, `GraviaValueConst`) delegate to
/// gen-l10n without threading a `BuildContext` through every call site
/// (BLoC error copy and validators have none).
///
/// Kept in lockstep with `ActiveLocaleController`: `apply()` reassigns
/// [current] *before* notifying listeners, so by the time
/// `MaterialApp.locale` rebuilds the tree every getter already reads the
/// new language.
abstract final class L10n {
  /// CordeliaApps' own chrome (discovery, auth) renders in English; a
  /// storefront visit swaps this per store and restores it on exit.
  static const appDefaultLocale = Locale('en');

  static AppLocalizations current = lookupAppLocalizations(appDefaultLocale);
}
