import 'package:flutter/material.dart';

import '../../theme/app_colors_extension.dart';
import '../../theme/app_spacing.dart';

/// Bottom-docked CTA bar shell (design.md's "Docked bottom CTA" pattern): a
/// surface-coloured strip with a top hairline ([AppColorsExtension.dockedHairline],
/// the same hairline a pack's `BottomNavBar` draws — so every docked bar
/// separates from scrollable content the same way), the bottom safe-area
/// inset, and bar padding. Screens put their CTA content in [child] (usually
/// a full-width primary button, optionally in a Row with other controls).
class DockedBar extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;

  const DockedBar({super.key, required this.child, this.padding});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final hairline =
        Theme.of(context).extension<AppColorsExtension>()?.dockedHairline ??
            cs.outlineVariant;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: cs.surface,
        border: Border(top: BorderSide(color: hairline, width: 0.5)),
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
