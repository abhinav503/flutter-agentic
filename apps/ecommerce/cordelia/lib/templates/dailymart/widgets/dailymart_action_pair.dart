import 'package:flutter/material.dart';

import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/blocks/action_pair.dart';

import 'dailymart_outline_button.dart';
import 'dailymart_primary_button.dart';

/// Two half-width CTAs side by side — outlined left, filled right, an
/// `AppSpacing.lg` gap between them (spec sheet §13). The kit's Filter sheet
/// Reset/Apply pair is the source; every "cancel or commit" row in the pack
/// renders this so the two buttons can't drift to different widths.
class DailyMartActionPair extends StatelessWidget {
  final String cancelLabel;
  final String confirmLabel;
  final VoidCallback onCancel;
  final VoidCallback onConfirm;

  const DailyMartActionPair({
    super.key,
    required this.cancelLabel,
    required this.confirmLabel,
    required this.onCancel,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) => ActionPair(
    gap: AppSpacing.lg,
    first: DailyMartOutlineButton(label: cancelLabel, onTap: onCancel),
    second: DailyMartPrimaryButton(label: confirmLabel, onTap: onConfirm),
  );
}
