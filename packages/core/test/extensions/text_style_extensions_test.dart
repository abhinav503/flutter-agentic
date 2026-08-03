import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:core/core/extensions/text_style_extensions.dart';

/// Resolves a google_fonts style without the font *file*.
///
/// Resolving a family kicks off a load that can only fail here — there are no
/// font assets in a test run and `flutter_test` blocks the network — and that
/// failure lands as an unhandled async error on whichever zone created the
/// future, failing the test after it has already passed. The style itself is
/// computed synchronously and is the only thing under test, so the load's
/// fate is caught here and dropped.
T _withoutFontFiles<T>(T Function() body) {
  late T result;
  runZonedGuarded(() => result = body(), (_, _) {});
  return result;
}

void main() {
  // google_fonts reaches for the asset manifest as soon as a family resolves.
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  group('TextStyle.atWeight', () {
    // A role as AppTheme hands it over: the family is already pinned to the
    // w400 cut, because that is the weight `headlineMedium` carries.
    TextStyle themed() => _withoutFontFiles(
      () => GoogleFonts.raleway(textStyle: const TextStyle(fontSize: 28)),
    );

    test('re-resolves the font file, where copyWith only sets the field', () {
      final base = themed();
      final viaCopyWith = base.copyWith(fontWeight: FontWeight.w800);
      final viaAtWeight = _withoutFontFiles(
        () => base.atWeight(FontWeight.w800),
      );

      expect(viaAtWeight.fontWeight, FontWeight.w800);
      // The bug this guards: copyWith keeps the regular cut, so w700 and w800
      // both come out as a fake-bolded regular and render identically.
      expect(viaCopyWith.fontFamily, base.fontFamily);
      expect(viaAtWeight.fontFamily, isNot(base.fontFamily));
    });

    test('gives distinct cuts to distinct weights', () {
      final base = themed();

      expect(
        _withoutFontFiles(() => base.atWeight(FontWeight.w700)).fontFamily,
        isNot(_withoutFontFiles(() => base.atWeight(FontWeight.w800)).fontFamily),
      );
    });

    test('keeps everything else the base style carries', () {
      final style = _withoutFontFiles(
        () => themed()
            .copyWith(fontSize: 14, letterSpacing: 0.5)
            .atWeight(FontWeight.w600),
      );

      expect(style.fontSize, 14);
      expect(style.letterSpacing, 0.5);
    });

    test('falls back to copyWith for a family google_fonts does not know', () {
      const bundled = TextStyle(fontFamily: 'SomeBundledFont');
      final style = bundled.atWeight(FontWeight.w800);

      expect(style.fontFamily, 'SomeBundledFont');
      expect(style.fontWeight, FontWeight.w800);
    });
  });
}
