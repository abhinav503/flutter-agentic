import 'package:flutter/material.dart';

import 'package:core/core/theme/app_spacing.dart';

import 'package:gravia/constants/color_const.dart';

/// Gravia's docked bottom bar shell (design.md's "Docked bottom CTA"
/// pattern): a surface-coloured strip with the same top hairline as
/// `BottomNavBar` — so every docked bar separates from scrollable content
/// the same way — plus the bottom safe-area inset and the pack's bar
/// padding. Screens put their CTA content in [child] (usually a
/// [GraviaPrimaryButton], optionally in a Row with other controls).
class GraviaDockedBar extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;

  const GraviaDockedBar({super.key, required this.child, this.padding});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: cs.surface,
        border: Border(top: BorderSide(color: cs.dockedHairline, width: 0.5)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding:
              padding ??
              const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.base,
              ),
          child: child,
        ),
      ),
    );
  }
}
