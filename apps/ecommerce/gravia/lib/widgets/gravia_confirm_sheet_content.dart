import 'package:flutter/material.dart';

import 'package:core/core/theme/app_spacing.dart';

import 'package:gravia/constants/text_style_const.dart';
import 'package:gravia/constants/value_const.dart';
import 'package:gravia/widgets/gravia_action_pair.dart';

/// Body of a destructive-confirmation sheet — a plain message + a
/// Cancel/confirm pair, no local state. Shared across every "are you sure?"
/// gate in the app (delete address, clear cart, log out); the chrome (title +
/// Cancel close + hairline) comes from `showGraviaConfirmSheet`. [onConfirm]
/// performs the action — the sheet only gates the tap, it never touches a bloc.
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

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.base,
        AppSpacing.lg,
        AppSpacing.lg,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message,
            style: TextStyleConst.textSmRegular(
              tt,
            ).copyWith(color: cs.onSurfaceVariant),
          ),
          const SizedBox(height: AppSpacing.xl2),
          GraviaActionPair(
            left: GraviaAction(
              label: ValueConst.cancel,
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
        ],
      ),
    );
  }
}
