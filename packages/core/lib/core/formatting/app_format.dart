import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

/// The locale and currency every money/date helper in `core` formats against.
///
/// Ambient rather than `BuildContext`-derived because the helpers reading it
/// are `num`/`DateTime` extensions and static `*ValueConst` formatters, which
/// have no context to read — the same constraint that already makes an app's
/// string table a static holder (cordelia's `L10n.current`). An app swaps this
/// wherever it swaps that table, so a screen's copy and its prices can never
/// disagree about which locale is live.
///
/// **Language and currency are separate axes.** A shopper reading a UK store
/// in German still pays in £: the *symbol* comes from the store, while the
/// separators and the symbol's side come from the shopper's locale. Passing
/// one and inferring the other is the bug this split exists to prevent.
abstract final class AppFormat {
  /// Matches `ColorScheme`-style fallbacks elsewhere in core: a sensible
  /// default so an app that never calls [apply] still renders, rather than a
  /// late-init throw on the first price.
  static const _fallbackLocale = 'en';
  static const _fallbackCurrency = 'INR';

  static String _locale = _fallbackLocale;
  static String _currencyCode = _fallbackCurrency;

  // Rebuilt on apply(), not per call: a product grid formats a price per card
  // and NumberFormat re-parses the locale's pattern in its constructor.
  static NumberFormat _money = _buildMoney(
    _fallbackLocale,
    _fallbackCurrency,
    2,
  );
  static NumberFormat _wholeMoney = _buildMoney(
    _fallbackLocale,
    _fallbackCurrency,
    0,
  );

  static String get locale => _locale;
  static String get currencyCode => _currencyCode;

  /// Loads the CLDR date tables `DateFormat` needs for any locale beyond the
  /// default. Called from `initCoreDependencies()` so an app can't forget it
  /// and then read English month names in a German storefront.
  static Future<void> init() => initializeDateFormatting();

  /// [currencyCode] is an ISO-4217 code (`'INR'`, `'EUR'`, `'GBP'`). Omitting
  /// it keeps the currently-applied currency, so a language switch inside one
  /// store doesn't have to restate what that store charges in.
  static void apply({required String locale, String? currencyCode}) {
    _locale = locale;
    _currencyCode = currencyCode ?? _currencyCode;
    _money = _buildMoney(_locale, _currencyCode, 2);
    _wholeMoney = _buildMoney(_locale, _currencyCode, 0);
    _decimals.clear();
  }

  static void resetToDefaults() {
    _currencyCode = _fallbackCurrency;
    apply(locale: _fallbackLocale, currencyCode: _fallbackCurrency);
  }

  /// The formatter behind [PriceFormatX.asPrice]; [whole] picks the
  /// decimal-less variant that a round amount renders through.
  static NumberFormat money({required bool whole}) =>
      whole ? _wholeMoney : _money;

  // Keyed by fraction digits and cleared on apply(), for the same
  // reason the money formatters are rebuilt there: a rating renders per
  // review row, and constructing a NumberFormat re-parses the locale pattern.
  static final Map<int, NumberFormat> _decimals = {};

  /// A plain (non-currency) fixed-decimal formatter — the locale-aware
  /// `toStringAsFixed`, for a rating average or any other bare number whose
  /// decimal mark still has to be a comma in German.
  static NumberFormat decimal(int fractionDigits) =>
      _decimals.putIfAbsent(fractionDigits, () {
        final format = NumberFormat.decimalPattern(_locale);
        format.minimumFractionDigits = fractionDigits;
        format.maximumFractionDigits = fractionDigits;
        return format;
      });

  /// The active locale's decimal separator — `'.'` in English, `','` in
  /// German, French, Spanish and Italian. Read by
  /// [PriceFormatX.asPriceParts], which can't assume a point.
  static String get decimalSeparator => _money.symbols.DECIMAL_SEP;

  static NumberFormat _buildMoney(
    String locale,
    String code,
    int decimalDigits,
  ) => NumberFormat.simpleCurrency(
    locale: locale,
    name: code,
    decimalDigits: decimalDigits,
  );
}
