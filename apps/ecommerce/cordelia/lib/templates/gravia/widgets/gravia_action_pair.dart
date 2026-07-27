import 'package:flutter/material.dart';

import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/button.dart';

import 'package:cordelia/templates/gravia/constants/gravia_dimen_const.dart';
import 'package:cordelia/templates/gravia/constants/gravia_text_style_const.dart';
import 'gravia_tinted_button.dart';

enum GraviaActionKind { primary, secondary, tintedError }

/// One half of a [GraviaActionPair] row.
class GraviaAction {
  final String label;
  final GraviaActionKind kind;
  final VoidCallback? onTap;
  final Widget? leadingIcon;

  /// Overrides the recipe's default label colour (`onPrimary`/`primary`) —
  /// for a spec that calls for a fixed neutral tone regardless of variant
  /// (e.g. `AddressCard`'s Edit button, which is pure black/white, not the
  /// themed `primary` a plain secondary button would default to).
  final Color? labelColor;

  const GraviaAction({
    required this.label,
    required this.kind,
    this.onTap,
    this.leadingIcon,
    this.labelColor,
  });
}

/// Gravia's paired half-width action row — two [GraviaDimenConst.controlHeight]
/// pills sharing an [AppSpacing.base] gap and, critically, the *exact same*
/// label text style (`GraviaTextStyleConst.textSmMedium`) so sibling buttons
/// never visibly drift apart. Renders every "two actions side by side" row
/// in the storefront: `OrderCard`'s two action rows, `AddressCard`'s
/// Edit/Delete, and the Add to Cart sheet's Cancel/Add to Cart.
class GraviaActionPair extends StatelessWidget {
  final GraviaAction left;
  final GraviaAction right;

  const GraviaActionPair({super.key, required this.left, required this.right});

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(child: _button(context, left)),
      const SizedBox(width: AppSpacing.base),
      Expanded(child: _button(context, right)),
    ],
  );

  Widget _button(BuildContext context, GraviaAction action) {
    if (action.kind == GraviaActionKind.tintedError) {
      return GraviaTintedButton(
        label: action.label,
        leadingIcon: action.leadingIcon,
        onTap: action.onTap,
      );
    }

    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final defaultColor = action.kind == GraviaActionKind.primary
        ? cs.onPrimary
        : cs.primary;

    return AppButton(
      label: action.label,
      variant: action.kind == GraviaActionKind.primary
          ? AppButtonVariant.primary
          : AppButtonVariant.secondary,
      fullWidth: true,
      height: GraviaDimenConst.controlHeight,
      labelStyle: GraviaTextStyleConst.textSmMedium(
        tt,
      ).copyWith(color: action.labelColor ?? defaultColor),
      leadingIcon: action.leadingIcon,
      onTap: action.onTap,
    );
  }
}
