import 'package:flutter/material.dart';

import 'package:core/core/theme/app_spacing.dart';

import 'package:gravia/constants/text_style_const.dart';
import 'package:gravia/constants/value_const.dart';
import 'package:gravia/widgets/gravia_action_pair.dart';

/// Body of the delete-confirmation sheet opened from [AddressCard]'s Delete
/// action — a plain message + Cancel/Delete pair, no local state.
class DeleteAddressSheetContent extends StatelessWidget {
  final VoidCallback onConfirm;

  const DeleteAddressSheetContent({super.key, required this.onConfirm});

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
            ValueConst.deleteAddressConfirmMessage,
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
              label: ValueConst.deleteLabel,
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
