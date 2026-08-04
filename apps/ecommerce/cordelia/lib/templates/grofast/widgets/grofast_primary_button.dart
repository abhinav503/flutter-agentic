import 'package:flutter/material.dart';

import 'package:core/core/theme/app_radius.dart';
import 'package:core/core/ui/atoms/button.dart';

import 'package:cordelia/templates/grofast/constants/grofast_color_const.dart';
import 'package:cordelia/templates/grofast/constants/grofast_dimen_const.dart';
import 'package:cordelia/templates/grofast/constants/grofast_text_style_const.dart';

/// GROFAST's affirmative CTA — [AppButton] pinned to the pack's 50px pill and
/// painted with the brand gradient (spec sheet §13), so no screen re-types
/// the height/gradient/label triple.
///
/// The gradient, not `cs.primary`, is what makes a control read as
/// affirmative in this pack; a flat green pill is out of place. `AppButton`
/// keeps its own `onPrimary` foreground, which is white in both modes.
class GrofastPrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final AppButtonState state;
  final bool fullWidth;

  const GrofastPrimaryButton({
    super.key,
    required this.label,
    this.onTap,
    this.state = AppButtonState.idle,
    this.fullWidth = true,
  });

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return AppButton(
      label: label,
      onTap: onTap,
      state: state,
      size: AppButtonSize.large,
      fullWidth: fullWidth,
      height: GrofastDimenConst.controlHeight,
      gradient: GrofastColorConst.brandGradient,
      borderRadius: AppRadius.full,
      labelStyle: GrofastTextStyleConst.labelSemibold(tt),
    );
  }
}

/// The pack's one **non**-gradient button: the Bag's "Apply", a compact ink
/// pill that sits inside the promo-code row. Uses `cs.secondary`, the kit's
/// Dark-Green — held to the same value in both modes (the preset says why),
/// so the pill reads as the same control on either canvas.
class GrofastInkButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final double? width;

  const GrofastInkButton({
    super.key,
    required this.label,
    this.onTap,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    final button = AppButton(
      label: label,
      onTap: onTap,
      // `large` only for its horizontal inset — the pack pins the height
      // itself, so the size's vertical padding never applies.
      size: AppButtonSize.large,
      fullWidth: width != null,
      height: GrofastDimenConst.applyPillHeight,
      borderRadius: BorderRadius.circular(GrofastDimenConst.applyPillRadius),
      backgroundColor: cs.secondary,
      foregroundColor: cs.onSecondary,
      labelStyle: GrofastTextStyleConst.labelSemibold(tt),
    );

    return width == null ? button : SizedBox(width: width, child: button);
  }
}
