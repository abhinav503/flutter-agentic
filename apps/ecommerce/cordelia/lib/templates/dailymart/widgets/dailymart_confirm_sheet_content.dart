import 'package:flutter/material.dart';

import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/molecules/confirm_sheet_body.dart';

import 'package:cordelia/templates/dailymart/constants/dailymart_text_style_const.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_value_const.dart';

import 'dailymart_action_pair.dart';

/// Body of a DailyMart confirmation sheet — centred title + message over the
/// pack's [DailyMartActionPair]. No drag handle and no close disc: the two
/// buttons *are* the exits, and adding a third would make the destructive
/// choice one of several equal-looking ways out (spec sheet §9).
///
/// [onConfirm] performs the action; this widget only gates the tap and never
/// touches a bloc.
class DailyMartConfirmSheetContent extends StatelessWidget {
  final String title;
  final String message;
  final String confirmLabel;
  final VoidCallback onConfirm;

  const DailyMartConfirmSheetContent({
    super.key,
    required this.title,
    required this.message,
    required this.confirmLabel,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    // No SafeArea — the chromeless AppBottomSheet presenting this
    // (`showDailyMartConfirmSheet`) already pads the bottom device inset.
    return ConfirmSheetBody(
      title: title,
      message: message,
      titleStyle: DailyMartTextStyleConst.headingH5(
        tt,
      ).copyWith(color: cs.onSurface),
      messageStyle: DailyMartTextStyleConst.bodySmRegular(
        tt,
      ).copyWith(color: cs.onSurfaceVariant),
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.xl4,
        AppSpacing.lg,
        AppSpacing.lg,
      ),
      actions: DailyMartActionPair(
        cancelLabel: DailyMartValueConst.cancelLabel,
        confirmLabel: confirmLabel,
        onCancel: () => Navigator.of(context).pop(),
        onConfirm: () {
          Navigator.of(context).pop();
          onConfirm();
        },
      ),
    );
  }
}
