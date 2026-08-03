import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// The GROFAST kit's type tokens, each based off the nearest M3 role so the
/// family and default colour still come from the theme (spec sheet §4).
///
/// The pack pairs **two** families: Raleway (from the preset, so it arrives on
/// every role for free) carries headings, labels and body; Montserrat carries
/// numerics — prices, unit suffixes, counts and inline links. A theme preset
/// holds one `fontFamily`, so the Montserrat half is resolved here via
/// `GoogleFonts` instead of the `TextTheme`. Only tokens a real screen renders
/// live here.
abstract final class GrofastTextStyleConst {
  // ------------------------------------------------------- Raleway (theme)

  /// Text/Reguler/Big — 28/700. The screen title on every page that has one
  /// ("My Bag", "Hey Yona 👋", "Success!").
  static TextStyle displayBold(TextTheme tt) =>
      tt.headlineMedium!.copyWith(fontSize: 28, fontWeight: FontWeight.w700);

  /// Text/Reguler/Medium — 20/700. Section headers ("Categories", "Popular",
  /// "All Categories", "Tracking Detail").
  static TextStyle sectionBold(TextTheme tt) =>
      tt.titleLarge!.copyWith(fontSize: 20, fontWeight: FontWeight.w700);

  /// 18/700. The one step down from [sectionBold], for a sheet's own title
  /// and a card's headline.
  static TextStyle subheadBold(TextTheme tt) =>
      tt.titleMedium!.copyWith(fontSize: 18, fontWeight: FontWeight.w700);

  /// 16/700. A category tile's name and a list row's primary line.
  static TextStyle rowTitleBold(TextTheme tt) =>
      tt.titleMedium!.copyWith(fontSize: 16, fontWeight: FontWeight.w700);

  /// 14/700. A product card's name — the pack's smallest bold.
  static TextStyle cardTitleBold(TextTheme tt) =>
      tt.titleSmall!.copyWith(fontSize: 14, fontWeight: FontWeight.w700);

  /// 14/600. Every button label, the header's centred title, and the active
  /// nav tab's label.
  static TextStyle labelSemibold(TextTheme tt) =>
      tt.labelLarge!.copyWith(fontSize: 14, fontWeight: FontWeight.w600);

  /// 14/500. Menu rows, chip labels, and any secondary line at reading size.
  static TextStyle bodyMedium(TextTheme tt) =>
      tt.bodyMedium!.copyWith(fontSize: 14, fontWeight: FontWeight.w500);

  /// Text/Reguler/Small — 12/500. Sub-lines, timestamps, form labels.
  static TextStyle bodySmall(TextTheme tt) =>
      tt.bodySmall!.copyWith(fontSize: 12, fontWeight: FontWeight.w500);

  /// 12/400. Field placeholders — rendered at 40% ink by the field itself, so
  /// this token stays a plain regular weight.
  static TextStyle placeholder(TextTheme tt) =>
      tt.bodySmall!.copyWith(fontSize: 12, fontWeight: FontWeight.w400);

  // -------------------------------------------------- Montserrat (numerics)

  /// A price's leading run — "$ 2." at 18/600. The trailing digits step down
  /// to [priceDecimal]; `GrofastPrice` renders the pair, so screens never
  /// split a formatted string themselves.
  static TextStyle price(TextTheme tt) => GoogleFonts.montserrat(
    textStyle: tt.titleMedium,
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );

  /// The decimal run of a price — 14/600, deliberately smaller than the
  /// integer part beside it.
  static TextStyle priceDecimal(TextTheme tt) => GoogleFonts.montserrat(
    textStyle: tt.titleSmall,
    fontSize: 14,
    fontWeight: FontWeight.w600,
  );

  /// A price's unit suffix ("/kg") — 10/500, and drawn at 50% opacity by its
  /// call site so it recedes behind the number.
  static TextStyle unitSuffix(TextTheme tt) => GoogleFonts.montserrat(
    textStyle: tt.labelSmall,
    fontSize: 10,
    fontWeight: FontWeight.w500,
  );

  /// Small numeric meta beside a title — item counts, order dates, quantities.
  static TextStyle meta(TextTheme tt) => GoogleFonts.montserrat(
    textStyle: tt.labelSmall,
    fontSize: 10,
    fontWeight: FontWeight.w500,
  );

  /// Text/Link/Small — 12/400. Inline actions that sit at the end of a
  /// section header ("see all", "add new").
  static TextStyle link(TextTheme tt) => GoogleFonts.montserrat(
    textStyle: tt.bodySmall,
    fontSize: 12,
    fontWeight: FontWeight.w400,
  );
}
