/// The storefront UI language the admin picked for a store — rides the same
/// store-doc → `ActiveStoreEntity` path as [StorefrontTemplate]. Kept pure
/// Dart (no `Locale` here) so domain entities can hold it; the l10n layer
/// maps it to a `Locale` (see `lib/l10n/active_locale_controller.dart`).
enum StoreLanguage { en, hi }

extension StoreLanguageX on StoreLanguage {
  /// Enum → wire value, matching the admin backend's `STORE_LANGUAGES`
  /// (`admin/src/lib/types.ts`).
  String get wireValue => switch (this) {
    StoreLanguage.en => 'en',
    StoreLanguage.hi => 'hi',
  };
}

/// Wire value → enum: tolerates unknown/missing values by defaulting to
/// English — same policy (and same reasoning) as
/// `StorefrontTemplateParse.toStorefrontTemplate`.
extension StoreLanguageParse on String {
  StoreLanguage toStoreLanguage() => switch (this) {
    'hi' => StoreLanguage.hi,
    _ => StoreLanguage.en,
  };
}
