/// The storefront UI language the admin picked for a store — rides the same
/// store-doc → `ActiveStoreEntity` path as [StorefrontTemplate]. Kept pure
/// Dart (no `Locale` here) so domain entities can hold it; the l10n layer
/// maps it to a `Locale` (see `lib/l10n/active_locale_controller.dart`).
///
/// Every case here needs a matching `app_<code>.arb` at full key parity with
/// `app_en.arb` (the gen-l10n template) — a missing key falls back to the
/// template's English, which reads as a half-translated screen rather than an
/// error. Number and date shape is *not* this enum's job: the locale drives it
/// through core's `AppFormat`, and what a store charges in is
/// [StoreCurrency]'s.
enum StoreLanguage { en, hi, de, fr }

extension StoreLanguageX on StoreLanguage {
  /// Enum → wire value, matching the admin backend's `STORE_LANGUAGES`
  /// (`admin/src/lib/types.ts`).
  String get wireValue => switch (this) {
    StoreLanguage.en => 'en',
    StoreLanguage.hi => 'hi',
    StoreLanguage.de => 'de',
    StoreLanguage.fr => 'fr',
  };
}

/// Wire value → enum: tolerates unknown/missing values by defaulting to
/// English — same policy (and same reasoning) as
/// `StorefrontTemplateParse.toStorefrontTemplate`.
extension StoreLanguageParse on String {
  StoreLanguage toStoreLanguage() => switch (this) {
    'hi' => StoreLanguage.hi,
    'de' => StoreLanguage.de,
    'fr' => StoreLanguage.fr,
    _ => StoreLanguage.en,
  };
}
