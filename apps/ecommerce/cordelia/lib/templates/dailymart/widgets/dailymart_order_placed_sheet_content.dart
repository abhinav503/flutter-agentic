import 'package:flutter/material.dart';

import 'package:core/core/theme/app_spacing.dart';

import 'package:cordelia/templates/dailymart/constants/dailymart_text_style_const.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_value_const.dart';

import 'dailymart_primary_button.dart';

/// Body of the checkout-success sheet — a terminal confirmation, so a single
/// full-width pill (spec sheet §9). Unlike gravia's, there is no "Track
/// order" action: this template's shell has no Orders tab to land on, so the
/// one exit continues shopping.
class DailyMartOrderPlacedSheetContent extends StatelessWidget {
  final VoidCallback onContinue;

  const DailyMartOrderPlacedSheetContent({super.key, required this.onContinue});

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
        children: [
          Icon(
            Icons.check_circle_rounded,
            size: AppSpacing.xl12,
            color: cs.primary,
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            DailyMartValueConst.orderPlacedMessage,
            textAlign: TextAlign.center,
            style: DailyMartTextStyleConst.bodyMdRegular(
              tt,
            ).copyWith(color: cs.onSurfaceVariant),
          ),
          const SizedBox(height: AppSpacing.xl4),
          DailyMartPrimaryButton(
            label: DailyMartValueConst.orderPlacedAction,
            onTap: onContinue,
          ),
        ],
      ),
    );
  }
}
