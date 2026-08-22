import 'package:flutter/material.dart';

import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/molecules/confirm_sheet_body.dart';

import 'package:cordelia/templates/gravia/constants/gravia_text_style_const.dart';
import 'package:cordelia/templates/gravia/constants/gravia_value_const.dart';

import 'gravia_action_pair.dart';

/// Body of a destructive-confirmation sheet — a plain message + a
/// Cancel/confirm pair, no local state. Shared across every "are you sure?"
/// gate in the storefront (delete address, clear cart); the chrome (title +
/// Cancel close + hairline) comes from `showGraviaConfirmSheet`. [onConfirm]
/// performs the action — the sheet only gates the tap, it never touches a
/// bloc.
class GraviaConfirmSheetContent extends StatelessWidget {
  final String message;
  final String confirmLabel;
  final VoidCallback onConfirm;

  const GraviaConfirmSheetContent({
    super.key,
    required this.message,
    required this.confirmLabel,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return ConfirmSheetBody(
      message: message,
      // A plain sentence, not a dialog — this pack's sheet carries its title
      // in the chrome above, so the body reads left like body copy.
      textAlign: TextAlign.start,
      messageStyle: GraviaTextStyleConst.textSmRegular(
        tt,
      ).copyWith(color: cs.onSurfaceVariant),
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.base,
        AppSpacing.lg,
        AppSpacing.lg,
      ),
      actionsGap: AppSpacing.xl2,
      actions: GraviaActionPair(
        left: GraviaAction(
          label: GraviaValueConst.cancel,
          kind: GraviaActionKind.secondary,
          // Same neutral black/white Cancel outline as the Add to Cart
          // sheet, not core's default primary-coloured secondary text.
          labelColor: cs.onSurface,
          onTap: () => Navigator.of(context).pop(),
        ),
        right: GraviaAction(
          label: confirmLabel,
          kind: GraviaActionKind.tintedError,
          onTap: () {
            onConfirm();
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }
}
