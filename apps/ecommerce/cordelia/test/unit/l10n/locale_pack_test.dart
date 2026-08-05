import 'dart:convert';
import 'dart:io';

import 'package:core/core/extensions/num_extensions.dart';
import 'package:core/core/formatting/app_format.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cordelia/feature/storefront/template/store_currency.dart';
import 'package:cordelia/feature/storefront/template/store_language.dart';
import 'package:cordelia/l10n/active_locale_controller.dart';
import 'package:cordelia/l10n/l10n.dart';

/// The two space characters CLDR puts inside a formatted price. Named rather
/// than written as literals because they are indistinguishable from an ordinary
/// space on screen and in a diff — a mistyped plain space here reads as a
/// formatting bug that isn't there.
const nbsp = '\u00A0'; // no-break space: before the currency symbol
const nnbsp = '\u202F'; // narrow no-break space: French thousands separator

/// gen-l10n silently falls back to the template's English for a key a
/// translation is missing, so a half-finished locale ships as a
/// half-English screen rather than a build failure. These tests are what
/// turns that into a failure.
void main() {
  setUpAll(AppFormat.init);

  Map<String, dynamic> arb(String code) => jsonDecode(
    File('lib/l10n/app_$code.arb').readAsStringSync(),
  ) as Map<String, dynamic>;

  List<String> keysOf(String code) =>
      arb(code).keys.where((k) => !k.startsWith('@')).toList();

  group('arb parity', () {
    final template = keysOf('en');

    // Every StoreLanguage case must have a pack behind it — the enum is what
    // the admin's picklist writes, so a case without an arb is a store an
    // admin can select and a shopper can't read.
    for (final language in StoreLanguage.values) {
      test('app_${language.wireValue}.arb covers every template key', () {
        final keys = keysOf(language.wireValue);
        expect(
          keys.toSet().difference(template.toSet()),
          isEmpty,
          reason: 'keys not in app_en.arb (typo or stale key?)',
        );
        expect(
          template.toSet().difference(keys.toSet()),
          isEmpty,
          reason: 'missing translations — these would render as English',
        );
      });
    }

    test('every StoreLanguage has an arb file at all', () {
      for (final language in StoreLanguage.values) {
        expect(
          File('lib/l10n/app_${language.wireValue}.arb').existsSync(),
          isTrue,
          reason: '${language.name} is selectable but has no translations',
        );
      }
    });
  });

  group('picker order', () {
    // `values` order is what every pack's Profile → Language sheet renders,
    // and the admin's STORE_LANGUAGES mirrors it. Both are plain declaration
    // order that nothing else depends on, which makes the ordering easy to
    // undo while tidying — hence a test rather than only a comment.
    test('English is offered first', () {
      expect(StoreLanguage.values.first, StoreLanguage.en);
    });

    test('Hindi is offered last', () {
      expect(
        StoreLanguage.values.last,
        StoreLanguage.hi,
        reason: 'a new language belongs before hi, not after it',
      );
    });

    test('the admin picklist is in the same order', () {
      // The two lists drive different pickers (shopper vs store owner) and
      // would drift silently: an owner would set a language from one order and
      // a shopper would re-pick it from another.
      final admin = RegExp(r'export const STORE_LANGUAGES = \[([^\]]*)\]')
          .firstMatch(
            File('../../../admin/src/lib/types.ts').readAsStringSync(),
          )!
          .group(1)!;
      final codes = RegExp('"([a-z-]+)"')
          .allMatches(admin)
          .map((m) => m.group(1))
          .toList();
      expect(
        codes,
        StoreLanguage.values.map((l) => l.wireValue).toList(),
      );
    });
  });

  group('applying a store locale', () {
    final controller = ActiveLocaleController();

    tearDown(controller.resetToAppDefault);

    test('German swaps the strings and the number format together', () {
      controller.apply(StoreLanguage.de.asLocale, currency: StoreCurrency.eur);

      // Strings.
      expect(L10n.current.languageSheetTitle, 'Sprache');
      // A language names itself in every locale, so this one must not change.
      expect(L10n.current.languageGerman, 'Deutsch');

      // …and formatting, in the same call. A German screen printing an
      // English decimal point is the bug this pairing prevents.
      final price = 1234.56.asPrice;
      expect(price, contains('1.234,56'));
      expect(price.trimRight(), endsWith('€'));
    });

    test('the store keeps its currency when only the language changes', () {
      controller.apply(StoreLanguage.de.asLocale, currency: StoreCurrency.gbp);
      // What the shopper's in-store Language row does: no currency passed.
      controller.apply(StoreLanguage.en.asLocale);

      expect(12.5.asPrice, contains('£'));
      expect(12.5.asPrice, contains('12.50'), reason: 'English decimal point');
    });

    test('leaving a storefront restores the app default', () {
      controller.apply(StoreLanguage.de.asLocale, currency: StoreCurrency.eur);
      controller.resetToAppDefault();

      expect(controller.value, L10n.appDefaultLocale);
      expect(AppFormat.locale, 'en');
      expect(12.5.asPrice, '₹12.50');
    });
  });

  // Width caps for the narrow slots, read straight from the arb so this loops
  // over every locale — a new language inherits the guard the day its arb
  // lands, which is the same reason the parity group loops.
  //
  // Every cap is derived from what English already ships in that slot, not
  // invented: a bigger number here would not be a budget. Slots where English
  // itself is long (refund *pending* is "Refund processing", 17) are
  // deliberately absent — there is no tight budget there to enforce.
  group('copy fits its narrow slots', () {
    const caps = <String, int>{
      // gravia's 5-item bar already ships 'Bestellungen' (12) in German.
      'graviaNavHome': 12,
      'graviaNavCategories': 12,
      'graviaNavFavourite': 12,
      'graviaNavOrders': 12,
      'graviaNavProfile': 12,
      'dailymartNavHome': 12,
      'dailymartNavWishlist': 12,
      'dailymartNavCart': 12,
      'dailymartNavProfile': 12,
      'grofastNavHome': 12,
      'grofastNavCategories': 12,
      'grofastNavBag': 12,
      'grofastNavAccount': 12,
      // Small tinted status badges — English 'Order Placed' is 12.
      'graviaPendingStatusLabel': 12,
      'graviaInProcessStatusLabel': 12,
      'graviaDeliveredStatusLabel': 12,
      'graviaCancelledStatusLabel': 12,
      // These two double as a timeline step name AND their pack's status pill
      // (dailymart's DailyMartPill, grofast's Track Order pill), so they are
      // capped even though the sibling *OrderStep* keys are not. They also
      // have to keep meaning "the order was placed" — rendering them as
      // "pending" collides with the *OrderStepPendingLabel* that marks a step
      // not yet reached, which is exactly what fr/es first shipped.
      'dailymartOrderStepPlacedLabel': 12,
      'grofastStatusPlacedLabel': 12,
      // Paired card actions: two side-by-side buttons in one card row
      // (gravia's GraviaActionPair), and dailymart's button sharing a Row with
      // the price inside an 88px-thumbnail card.
      'graviaTrackOrderLabel': 12,
      'graviaCancelOrderLabel': 12,
      'dailymartTrackOrderAction': 12,
      // Status pill; the overflow that forced a German override.
      'graviaRefundFailedLabel': 14,
      'dailymartRefundFailedLabel': 14,
      'grofastRefundFailedLabel': 14,
      // Date quick-pick chips — English 'All time' is 8.
      'dailymartOrdersAllTimeLabel': 10,
      'grofastOrdersAllTimeLabel': 10,
    };

    // `String.length` is a width proxy only where one code unit is roughly one
    // rendered glyph — true for Latin script, false for Devanagari, whose
    // combining vowel marks and conjuncts count separately but render inside
    // the same cluster. Hindi's 16-code-unit 'ऑर्डर ट्रैक करें' is 14 clusters
    // and narrower again on screen; it has shipped in these slots for months.
    // Judge a non-Latin locale on a device, not with this counter.
    const nonLatinScript = {StoreLanguage.hi};

    for (final language in StoreLanguage.values.where(
      (l) => !nonLatinScript.contains(l),
    )) {
      test('${language.wireValue} respects every capped slot', () {
        final values = arb(language.wireValue);
        for (final entry in caps.entries) {
          final value = values[entry.key] as String?;
          expect(value, isNotNull, reason: '${entry.key} missing');
          expect(
            value!.length,
            lessThanOrEqualTo(entry.value),
            reason:
                '${entry.key} is ${value.length} chars ("$value") but its slot '
                'caps at ${entry.value} — shorten it rather than raising the cap',
          );
        }
      });
    }
  });

  group('applying the French locale', () {
    final controller = ActiveLocaleController();

    tearDown(controller.resetToAppDefault);

    test('swaps strings and formatting together', () {
      controller.apply(StoreLanguage.fr.asLocale, currency: StoreCurrency.eur);

      expect(L10n.current.languageSheetTitle, 'Langue');
      expect(L10n.current.languageFrench, 'Français');
      // French groups with a NARROW no-break space (U+202F) and precedes the
      // symbol with a plain one (U+00A0) — pinned by codepoint in core's
      // app_format_test; here we only assert the locale actually took effect.
      expect(1234567.89.asPrice, '1${nnbsp}234${nnbsp}567,89$nbsp€');
    });

    test('0 takes the singular, unlike English', () {
      controller.apply(StoreLanguage.fr.asLocale, currency: StoreCurrency.eur);
      // CLDR puts 0 in French's `one` category, so a translator writing only
      // the plural into `one` would print "0 unités" on every zero-count row.
      expect(L10n.current.unitPiecesLabel(0), 'unité');
      expect(L10n.current.unitPiecesLabel(1), 'unité');
      expect(L10n.current.unitPiecesLabel(3), 'unités');
    });
  });

  group('applying the Spanish locale', () {
    final controller = ActiveLocaleController();

    tearDown(controller.resetToAppDefault);

    test('swaps strings and formatting together', () {
      controller.apply(StoreLanguage.es.asLocale, currency: StoreCurrency.eur);

      expect(L10n.current.languageSheetTitle, 'Idioma');
      expect(L10n.current.languageSpanish, 'Español');
      // Plain 'es' resolves to Spain's conventions — point-grouped, comma
      // decimal, trailing symbol, the same shape as de/it. A Latin-American
      // store would register a region-tagged locale instead ('es-MX' formats
      // as €1,234,567.89, symbol first); AppFormat reads
      // Locale.toLanguageTag(), so that needs no formatting code, only a new
      // enum case sharing this same arb.
      expect(1234567.89.asPrice, '1.234.567,89$nbsp€');
    });

    test('0 takes the plural, unlike French', () {
      controller.apply(StoreLanguage.es.asLocale, currency: StoreCurrency.eur);
      // Spanish shares English's plural categories here where French does not,
      // so both are pinned rather than assumed from "it's a Romance language".
      expect(L10n.current.unitPiecesLabel(0), 'uds.');
      expect(L10n.current.unitPiecesLabel(1), 'ud.');
      expect(L10n.current.unitPiecesLabel(3), 'uds.');
    });

    test('every question and exclamation carries its opening mark', () {
      // The commonest Spanish localization defect, and invisible to every
      // structural check: key, placeholders and length are all fine while the
      // copy reads as broken Spanish. Enforced across the file by
      // scripts/check-arb-parity.py; asserted here too so the rule cannot be
      // dropped from the tool without a test going red.
      arb('es').forEach((key, value) {
        if (key.startsWith('@')) return;
        final text = value as String;
        expect(
          text.split('?').length,
          lessThanOrEqualTo(text.split('¿').length),
          reason: '$key closes a question it never opened: "$text"',
        );
        expect(
          text.split('!').length,
          lessThanOrEqualTo(text.split('¡').length),
          reason: '$key closes an exclamation it never opened: "$text"',
        );
      });
    });
  });

  group('applying the Italian locale', () {
    final controller = ActiveLocaleController();

    tearDown(controller.resetToAppDefault);

    test('swaps strings and formatting together', () {
      controller.apply(StoreLanguage.it.asLocale, currency: StoreCurrency.eur);

      expect(L10n.current.languageSheetTitle, 'Lingua');
      expect(L10n.current.languageItalian, 'Italiano');
      // Italian shares de/es's point-grouped shape, unlike French.
      expect(1234567.89.asPrice, '1.234.567,89$nbsp€');
    });

    test('the invariant unit keeps both ICU branches', () {
      controller.apply(StoreLanguage.it.asLocale, currency: StoreCurrency.eur);
      // 'pz' does not inflect, so both branches read the same — but both must
      // still exist, or gen-l10n has nothing to select for one of them.
      expect(L10n.current.unitPiecesLabel(1), 'pz');
      expect(L10n.current.unitPiecesLabel(3), 'pz');
    });
  });

  // Translating locale-by-locale from a shared contract makes it easy for one
  // language's convention to bleed into another's file. These are cheap to
  // check and impossible to spot by reading, since the offending characters
  // are either punctuation or invisible.
  group('no locale borrows another\'s typography', () {
    const spanishOnly = {StoreLanguage.es};
    const frenchOnly = {StoreLanguage.fr};

    for (final language in StoreLanguage.values.where(
      (l) => !spanishOnly.contains(l),
    )) {
      test('${language.wireValue} has no Spanish inverted marks', () {
        arb(language.wireValue).forEach((key, value) {
          if (key.startsWith('@')) return;
          expect(
            value as String,
            isNot(anyOf(contains('¿'), contains('¡'))),
            reason: '$key uses a Spanish-only mark',
          );
        });
      });
    }

    for (final language in StoreLanguage.values.where(
      (l) => !frenchOnly.contains(l),
    )) {
      test('${language.wireValue} has no French punctuation spacing', () {
        arb(language.wireValue).forEach((key, value) {
          if (key.startsWith('@')) return;
          for (final mark in ['!', '?', ':', ';']) {
            expect(
              value as String,
              isNot(contains(' $mark')),
              reason: '$key puts a no-break space before "$mark", which only '
                  'French does',
            );
          }
        });
      });
    }
  });

  group('order timeline labels stay distinct', () {
    // A 12-char cap invites collapsing two short labels into one word. These
    // two mean different things — the step *name* ("Order Placed") versus a
    // step *not yet reached* ("Pending") — and fr and es both shipped them
    // identical before this was caught.
    const pairs = [
      ('dailymartOrderStepPlacedLabel', 'dailymartOrderStepPendingLabel'),
      ('grofastStatusPlacedLabel', 'grofastOrderStepPendingLabel'),
    ];

    for (final language in StoreLanguage.values) {
      test('${language.wireValue} distinguishes placed from pending', () {
        final values = arb(language.wireValue);
        for (final (placed, pending) in pairs) {
          expect(
            values[placed],
            isNot(values[pending]),
            reason: '$placed and $pending must not read the same',
          );
        }
      });
    }
  });
}
