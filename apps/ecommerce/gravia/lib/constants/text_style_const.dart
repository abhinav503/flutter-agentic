import 'package:flutter/material.dart';

abstract final class TextStyleConst {
  static TextStyle textLgBold(TextTheme tt) => tt.titleLarge!.copyWith(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    height: 1.55,
    letterSpacing: -0.36,
  );

  static TextStyle textSmRegular(TextTheme tt) => tt.bodyMedium!.copyWith(
    height: 1.4,
    letterSpacing: -0.28,
  );

  static TextStyle badgeLabel(TextTheme tt) => tt.labelMedium!.copyWith(
    fontSize: 10,
    height: 1.3,
    letterSpacing: -0.2,
  );

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

  static TextStyle textXsRegular(TextTheme tt) => tt.bodySmall!.copyWith(
    height: 1.3,
    letterSpacing: -0.24,
  );

  static TextStyle textSmMedium(TextTheme tt) => tt.bodyMedium!.copyWith(
    fontWeight: FontWeight.w500,
    height: 1.4,
    letterSpacing: -0.28,
  );
}
