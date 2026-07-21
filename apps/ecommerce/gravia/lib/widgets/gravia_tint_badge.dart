import 'package:flutter/material.dart';

import 'package:core/core/theme/app_colors_extension.dart';
import 'package:core/core/ui/atoms/badge.dart';

import 'package:gravia/constants/text_style_const.dart';

/// Gravia's tinted-primary info badge — mint-on-tinted-primary fill with the
/// pack's badge label style in `cs.primary`. Every small info badge in the
/// app (`AddressCard`'s tag, an in-process `OrderCard`'s status badge)
/// renders this, never a re-typed [AppBadge] recipe — the three copies of
/// this exact param set had already drifted into separate comments
/// cross-referencing each other before this existed.
///
/// [GraviaProductCard]'s weight badge needs the same recipe but can't render
/// this widget directly — it passes badge params through to core's
/// `ProductCard` block, which builds its own `AppBadge` internally. Use
/// [labelStyle]/[backgroundColor] there instead of duplicating the recipe.
class GraviaTintBadge extends StatelessWidget {
  final String text;

  const GraviaTintBadge({super.key, required this.text});

  static TextStyle labelStyle(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    return TextStyleConst.badgeLabel(tt).copyWith(color: cs.primary);
  }

  static Color backgroundColor(BuildContext context) => Theme.of(
    context,
  ).extension<AppColorsExtension>()!.tintedPrimaryFill;

  @override
  Widget build(BuildContext context) => AppBadge(
    text: text,
    intent: AppBadgeIntent.info,
    backgroundColor: backgroundColor(context),
    textStyle: labelStyle(context),
  );
}
