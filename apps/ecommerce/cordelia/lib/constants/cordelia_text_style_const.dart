import 'package:flutter/material.dart';

import 'package:core/core/extensions/text_style_extensions.dart';

/// The Cordelia brand type scale — used by the app's own chrome (auth,
/// discovery) and by the `gravia` pack, whose kit this scale was originally
/// sampled from (`GraviaTextStyleConst` is an alias of this class).
/// `dailymart` keeps its own scale.
///
/// **Weights go through `atWeight`, never `copyWith(fontWeight:)`.** The
/// preset's family arrives on each role already resolved to that role's own
/// weight, and copying a heavier one onto it keeps the regular font file and
/// fake-bolds it — every weight above the role's then renders the same. See
/// `core/extensions/text_style_extensions.dart`.
abstract final class CordeliaTextStyleConst {
  static TextStyle textLgBold(TextTheme tt) => tt.titleLarge!
      .copyWith(fontSize: 18, height: 1.55, letterSpacing: -0.36)
      .atWeight(FontWeight.w700);

  static TextStyle textSmRegular(TextTheme tt) => tt.bodyMedium!
      .copyWith(height: 1.4, letterSpacing: -0.28)
      .atWeight(FontWeight.w400);

  static TextStyle badgeLabel(TextTheme tt) => tt.labelMedium!
      .copyWith(fontSize: 10, height: 1.3, letterSpacing: -0.2)
      .atWeight(FontWeight.w500);

  static TextStyle textMdBold(TextTheme tt) => tt.titleMedium!
      .copyWith(height: 1.5, letterSpacing: -0.32)
      .atWeight(FontWeight.w700);

  static TextStyle textMdMedium(TextTheme tt) => tt.titleMedium!
      .copyWith(height: 1.5, letterSpacing: -0.32)
      .atWeight(FontWeight.w500);

  static TextStyle textXsRegular(TextTheme tt) => tt.bodySmall!
      .copyWith(height: 1.3, letterSpacing: -0.24)
      .atWeight(FontWeight.w400);

  static TextStyle textXsBold(TextTheme tt) => tt.bodySmall!
      .copyWith(height: 1.3, letterSpacing: -0.24)
      .atWeight(FontWeight.w700);

  static TextStyle textSmMedium(TextTheme tt) => tt.bodyMedium!
      .copyWith(height: 1.4, letterSpacing: -0.28)
      .atWeight(FontWeight.w500);

  static TextStyle textSmBold(TextTheme tt) => tt.bodyMedium!
      .copyWith(height: 1.4, letterSpacing: -0.28)
      .atWeight(FontWeight.w700);

  static TextStyle textMdRegular(TextTheme tt) => tt.bodyLarge!
      .copyWith(height: 1.5, letterSpacing: -0.32)
      .atWeight(FontWeight.w400);

  static TextStyle textXlBold(TextTheme tt) => tt.titleLarge!
      .copyWith(fontSize: 20, height: 1.5, letterSpacing: -0.4)
      .atWeight(FontWeight.w700);

  // Display/xs/Bold (24px/132%) — the kit's Display scale, not Text; used
  // by the Order Placed confirmation sheet's headline. First Display-scale
  // token this app has needed — base it off headlineSmall (24px, the exact
  // fontSize match), same pattern as every Text-scale method here.
  static TextStyle displayXsBold(TextTheme tt) => tt.headlineSmall!
      .copyWith(height: 1.32, letterSpacing: -0.48)
      .atWeight(FontWeight.w700);
}
