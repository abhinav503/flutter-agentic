import 'package:flutter/material.dart';

import '../../theme/app_spacing.dart';

/// Two equal-width actions side by side — the cancel/confirm pair sheet
/// content renders when it owns local state and can't hand its buttons to
/// `AppBottomSheet.actions` (which lives outside the content's rebuild
/// scope). Same expansion rules as that slot, so the two never drift.
class ActionPair extends StatelessWidget {
  final Widget first;
  final Widget second;
  final double gap;

  const ActionPair({
    super.key,
    required this.first,
    required this.second,
    this.gap = AppSpacing.base,
  });

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(child: first),
      SizedBox(width: gap),
      Expanded(child: second),
    ],
  );
}
