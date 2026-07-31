import 'package:flutter/material.dart';

/// The DailyMart kit's type tokens, each based off the nearest M3 role so
/// family and default colour still come from the theme (spec sheet §4).
///
/// Tracking is a flat −2% below 18px and **0** at 18px and above; `headingH5`
/// is the lone positive. Only tokens a real screen renders live here.
abstract final class DailyMartTextStyleConst {
  /// Heading/H5 — 20/600, lh 28, ls +0.5. Sheet titles.
  static TextStyle headingH5(TextTheme tt) => tt.titleLarge!.copyWith(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.4,
    letterSpacing: 0.5,
  );

  /// Body/Large/Semibold — 18/600, ls 0. Every section header.
  static TextStyle bodyLgSemibold(TextTheme tt) => tt.titleMedium!.copyWith(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.55,
    letterSpacing: 0,
  );

  /// Body/Large/Bold — 18/700, lh 1.4. The shopper's name on Profile. The
  /// pack's third and last use of Bold, alongside the promo headline and the
  /// "See all" chip.
  static TextStyle bodyLgBold(TextTheme tt) => tt.titleMedium!.copyWith(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    height: 1.4,
    letterSpacing: 0,
  );

  /// Body/Medium/Semibold — 16/600. The shopper's name in Home's header.
  static TextStyle bodyMdSemibold(TextTheme tt) => tt.titleMedium!.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.55,
    letterSpacing: -0.32,
  );

  /// Body/Medium/Medium — 16/500. "See all" text, result counts, CTA labels.
  static TextStyle bodyMdMedium(TextTheme tt) => tt.titleMedium!.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 1.6,
    letterSpacing: -0.32,
  );

  /// Body/Medium/Regular — 16/400. Select-field values.
  static TextStyle bodyMdRegular(TextTheme tt) =>
      tt.bodyLarge!.copyWith(height: 1.6, letterSpacing: -0.32);

  /// Body/Small/Semibold — 14/600. Product name, price, field labels.
  static TextStyle bodySmSemibold(TextTheme tt) => tt.bodyMedium!.copyWith(
    fontWeight: FontWeight.w600,
    height: 1.55,
    letterSpacing: -0.28,
  );

  /// Body/Small/Medium — 14/500. Profile menu-row labels, form field labels.
  static TextStyle bodySmMedium(TextTheme tt) => tt.bodyMedium!.copyWith(
    fontWeight: FontWeight.w500,
    height: 1.55,
    letterSpacing: -0.28,
  );

  /// Body/Small/Regular — 14/400. Search placeholder, location, recent terms.
  static TextStyle bodySmRegular(TextTheme tt) =>
      tt.bodyMedium!.copyWith(height: 1.55, letterSpacing: -0.28);

  /// Body/XSmall/Medium — 12/500. Category labels, ratings, nav labels.
  static TextStyle bodyXsMedium(TextTheme tt) => tt.bodySmall!.copyWith(
    fontWeight: FontWeight.w500,
    height: 1.55,
    letterSpacing: -0.24,
  );

  /// Body/XSmall/Semibold — 12/600. Discount pill, "Order Now".
  static TextStyle bodyXsSemibold(TextTheme tt) => tt.bodySmall!.copyWith(
    fontWeight: FontWeight.w600,
    height: 1.55,
    letterSpacing: -0.24,
  );

  /// The green "See all" chip — 12/700, and the pack's only use of Bold
  /// outside a promo headline.
  static TextStyle chipLabel(TextTheme tt) => tt.bodySmall!.copyWith(
    fontWeight: FontWeight.w700,
    height: 1.5,
    letterSpacing: 0,
  );

  /// Promo-card headline — 24/700.
  static TextStyle promoTitle(TextTheme tt) => tt.headlineSmall!.copyWith(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    height: 1.36,
    letterSpacing: 0,
  );

  /// Checkout success headline — 28/700, the pack's largest type and its
  /// only use above 24. One screen renders it (kit frame `34 Order
  /// Successfully`), which is why it isn't folded into [promoTitle].
  static TextStyle successTitle(TextTheme tt) => tt.headlineMedium!.copyWith(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    height: 1.55,
    letterSpacing: 0,
  );
}
