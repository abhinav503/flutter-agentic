/// The currency a store charges in — rides the same store-doc →
/// `ActiveStoreEntity` path as [StorefrontTemplate] and [StoreLanguage].
///
/// Deliberately independent of the storefront language: a shopper reading a
/// UK store in German still pays in £, so the symbol is the store's to decide
/// while the separators and the symbol's side are the locale's (see core's
/// `AppFormat`). Inferring one from the other would misprice the storefront
/// the moment a shopper switches language.
///
/// A closed set rather than a free ISO-4217 string, matching the admin's
/// picklist — an unrecognised code would render as a bare `'XYZ'` prefix in
/// front of every price with nothing to catch it before a shopper does.
enum StoreCurrency { inr, eur, gbp, usd }

extension StoreCurrencyX on StoreCurrency {
  /// Enum → wire value, matching the admin backend's `STORE_CURRENCIES`
  /// (`admin/src/lib/types.ts`). Uppercase because these are the ISO-4217
  /// codes `NumberFormat.simpleCurrency` expects by `name`.
  String get wireValue => switch (this) {
    StoreCurrency.inr => 'INR',
    StoreCurrency.eur => 'EUR',
    StoreCurrency.gbp => 'GBP',
    StoreCurrency.usd => 'USD',
  };
}

/// Wire value → enum: tolerates unknown/missing values by defaulting to
/// rupees — same policy (and same reasoning) as
/// `StoreLanguageParse.toStoreLanguage`. Case-insensitive, since a store doc
/// written by hand is as likely to say `'eur'` as `'EUR'`.
extension StoreCurrencyParse on String {
  StoreCurrency toStoreCurrency() => switch (toUpperCase()) {
    'EUR' => StoreCurrency.eur,
    'GBP' => StoreCurrency.gbp,
    'USD' => StoreCurrency.usd,
    _ => StoreCurrency.inr,
  };
}
