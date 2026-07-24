import 'package:flutter/material.dart';

abstract final class TextStyleConst {
  static TextStyle textLgBold(TextTheme tt) => tt.titleLarge!.copyWith(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    height: 1.55,
    letterSpacing: -0.36,
  );

  static TextStyle textSmRegular(TextTheme tt) =>
      tt.bodyMedium!.copyWith(height: 1.4, letterSpacing: -0.28);

  static TextStyle badgeLabel(TextTheme tt) =>
      tt.labelMedium!.copyWith(fontSize: 10, height: 1.3, letterSpacing: -0.2);

  static TextStyle textMdBold(TextTheme tt) => tt.titleMedium!.copyWith(
    fontWeight: FontWeight.w700,
    height: 1.5,
    letterSpacing: -0.32,
  );

  static TextStyle textMdMedium(TextTheme tt) => tt.titleMedium!.copyWith(
    fontWeight: FontWeight.w500,
    height: 1.5,
    letterSpacing: -0.32,
  );

  static TextStyle textXsRegular(TextTheme tt) =>
      tt.bodySmall!.copyWith(height: 1.3, letterSpacing: -0.24);
  static TextStyle textXsBold(TextTheme tt) => tt.bodySmall!.copyWith(
    height: 1.3,
    letterSpacing: -0.24,
    fontWeight: FontWeight.w700,
  );

  static TextStyle textSmMedium(TextTheme tt) => tt.bodyMedium!.copyWith(
    fontWeight: FontWeight.w500,
    height: 1.4,
    letterSpacing: -0.28,
  );

  static TextStyle textSmBold(TextTheme tt) => tt.bodyMedium!.copyWith(
    fontWeight: FontWeight.w700,
    height: 1.4,
    letterSpacing: -0.28,
  );

  static TextStyle textMdRegular(TextTheme tt) =>
      tt.bodyLarge!.copyWith(height: 1.5, letterSpacing: -0.32);

  static TextStyle textXlBold(TextTheme tt) => tt.titleLarge!.copyWith(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    height: 1.5,
    letterSpacing: -0.4,
  );

  // Display/xs/Bold (24px/132%) — the kit's Display scale, not Text; used
  // by the Order Placed confirmation sheet's headline. First Display-scale
  // token this app has needed — base it off headlineSmall (24px, the exact
  // fontSize match), same pattern as every Text-scale method here.
  static TextStyle displayXsBold(TextTheme tt) => tt.headlineSmall!.copyWith(
    fontWeight: FontWeight.w700,
    height: 1.32,
    letterSpacing: -0.48,
  );
}
