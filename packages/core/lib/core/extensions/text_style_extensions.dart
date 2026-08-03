import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

extension GoogleFontWeightX on TextStyle {
  /// This style at [weight], re-resolving the font **file** rather than only
  /// setting the field.
  ///
  /// `copyWith(fontWeight: …)` is not enough for a google_fonts family, and
  /// the failure is silent. google_fonts picks a static font file when the
  /// family is resolved and points `fontFamily` at that one cut
  /// (`Raleway_regular`), so a style taken off the theme — where an M3 role
  /// arrives at its own weight, `headlineMedium` at w400 — and then copied
  /// with w700 or w800 keeps the **regular** file and gets a synthetic bold
  /// from the rasterizer. Every weight above the role's own then renders
  /// identically: 700 and 800 are the same picture.
  ///
  /// The plain family name survives in `fontFamilyFallback`, which is what
  /// lets this re-resolve without the call site knowing which font the theme
  /// picked. A family google_fonts doesn't know (a bundled font, where
  /// `fontFamily` carries real weights on its own) falls through to a plain
  /// `copyWith`.
  TextStyle atWeight(FontWeight weight) {
    final family = fontFamilyFallback?.isNotEmpty ?? false
        ? fontFamilyFallback!.first
        : null;
    if (family == null) return copyWith(fontWeight: weight);
    try {
      return GoogleFonts.getFont(family, textStyle: this, fontWeight: weight);
    } on Exception {
      return copyWith(fontWeight: weight);
    }
  }
}
