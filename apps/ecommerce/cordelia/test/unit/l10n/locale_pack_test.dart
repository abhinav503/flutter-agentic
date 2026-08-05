import 'dart:convert';
import 'dart:io';

import 'package:core/core/extensions/num_extensions.dart';
import 'package:core/core/formatting/app_format.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cordelia/feature/storefront/template/store_currency.dart';
import 'package:cordelia/feature/storefront/template/store_language.dart';
import 'package:cordelia/l10n/active_locale_controller.dart';
import 'package:cordelia/l10n/l10n.dart';

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

  group('German copy fits its slot', () {
    // The slots checked in the widgets during the port: a status badge, the
    // two-up card action pair, and the narrowest nav tab. German runs 30-40%
    // longer than English, and these are where that first breaks.
    setUp(
      () => ActiveLocaleController().apply(
        StoreLanguage.de.asLocale,
        currency: StoreCurrency.eur,
      ),
    );

    test('badge and paired-action labels stay verb-length', () {
      final l10n = L10n.current;
      expect(l10n.graviaPendingStatusLabel.length, lessThanOrEqualTo(12));
      expect(l10n.graviaTrackOrderLabel.length, lessThanOrEqualTo(12));
      expect(l10n.dailymartTrackOrderAction.length, lessThanOrEqualTo(12));
    });

    test('nav tab labels stay within the widest shipped English pack', () {
      final l10n = L10n.current;
      // gravia already ships 'Bestellungen' (12) in a 5-item bar, so that is
      // the demonstrated ceiling rather than an invented one.
      for (final label in [
        l10n.grofastNavHome,
        l10n.grofastNavCategories,
        l10n.grofastNavBag,
        l10n.grofastNavAccount,
        l10n.dailymartNavHome,
        l10n.dailymartNavWishlist,
        l10n.dailymartNavCart,
        l10n.dailymartNavProfile,
      ]) {
        expect(label.length, lessThanOrEqualTo(12), reason: label);
      }
    });
  });
}
