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

  const CordeliaPrimaryButton({
    super.key,
    required this.label,
    this.onTap,
    this.state = AppButtonState.idle,
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
      labelStyle: CordeliaTextStyleConst.textMdMedium(
        tt,
      ).copyWith(color: cs.onPrimary),
      onTap: onTap,
    );
  }
}
