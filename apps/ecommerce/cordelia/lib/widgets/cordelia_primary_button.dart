import 'package:flutter/material.dart';

import 'package:core/core/ui/atoms/button.dart';

import 'package:cordelia/constants/cordelia_dimen_const.dart';
import 'package:cordelia/constants/cordelia_text_style_const.dart';

/// The Cordelia-brand full-width primary CTA — [AppButton] with the
/// docked-bar button spec baked in (large pill, 45px tall, textMd/medium on
/// primary). App-level (not pack-level) because the shared auth screens
/// render it too — the `gravia` pack consumes it as `GraviaPrimaryButton`.
class CordeliaPrimaryButton extends StatelessWidget {
  /// The kit's CTA height — shorter than [AppButtonSize.large]'s default.
  static const double barHeight = CordeliaDimenConst.controlHeight;

  final String label;
  final VoidCallback? onTap;

  /// Passed straight through to [AppButton] — e.g. `AppButtonState.loading`
  /// while a form submit is in flight. Defaults to idle, so every existing
  /// caller is unaffected.
  final AppButtonState state;

  /// Paints the pill with a gradient instead of flat `cs.primary` — for the
  /// app's own chrome, which uses `CordeliaColorConst.brandButtonGradient`.
  ///
  /// Opt-in rather than the default because this widget is *also* the gravia
  /// pack's CTA (`GraviaPrimaryButton` is a typedef of it): defaulting to the
  /// CordeliaApps gradient would repaint every gravia storefront's Cart,
  /// Address and Edit Profile button in the platform's brand, not the
  /// store's.
  final Gradient? gradient;

  const CordeliaPrimaryButton({
    super.key,
    required this.label,
    this.onTap,
    this.state = AppButtonState.idle,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return AppButton(
      label: label,
      fullWidth: true,
      size: AppButtonSize.large,
      height: barHeight,
      state: state,
      gradient: gradient,
      // Pinned rather than left to inherit: the label sits on the gradient's
      // own dark end regardless of theme, so a textTheme role's ink would
      // silently win over the button's foreground colour and go invisible.
      // Dropped while disabled for the same reason in reverse — the pin
      // outranks AppButton's disabled ink, which would print onPrimary on
      // the inert fill.
      labelStyle: state == AppButtonState.disabled
          ? CordeliaTextStyleConst.textMdMedium(tt)
          : CordeliaTextStyleConst.textMdMedium(
              tt,
            ).copyWith(color: cs.onPrimary),
      onTap: onTap,
    );
  }
}
