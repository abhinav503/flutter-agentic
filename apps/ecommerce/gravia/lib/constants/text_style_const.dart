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
}
