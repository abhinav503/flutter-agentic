import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:core/core/theme/app_radius.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/text_field.dart';

import 'package:cordelia/constants/cordelia_color_const.dart';
import 'package:cordelia/constants/cordelia_dimen_const.dart';
import 'package:cordelia/constants/cordelia_text_style_const.dart';

/// The Cordelia-brand form-field look — [AppTextField] with this app's own
/// spec baked in: square-rounded (16, `AppRadius.xl`) input box, not the
/// gravia pack's shared pill input radius (`app_theme_presets.dart`'s gravia
/// preset — that's for `SearchFieldBar`'s glass field, deliberately left
/// untouched); a fixed 45px height matching the screen's other controls
/// ([CordeliaPrimaryButton], header glass discs); and a Text/sm/regular label
/// in the fixed `CordeliaColorConst.gray500` (identical in both themes,
/// unlike `onSurfaceVariant`) with extra breathing room under it.
///
/// Started in the Add/Edit Address form; app-level (not pack-level) because
/// the shared auth screens render it too — the `gravia` pack consumes it as
/// `GraviaFormField`.
class CordeliaFormField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String? hint;
  final String? errorText;
  final TextInputType keyboardType;
  final ValueChanged<String>? onChanged;
  final List<TextInputFormatter>? inputFormatters;

  /// For a password field's `eye.svg` visibility toggle — Login/Signup's
  /// only callers so far.
  final bool obscureText;
  final Widget? suffix;

  /// Set false for a field that shows a value but can't be edited — e.g.
  /// Edit Profile's Email, which can't change without Firebase's own
  /// re-verification flow. `AppTextField` already has a disabled state;
  /// this just wires it through.
  final bool enabled;

  const CordeliaFormField({
    super.key,
    required this.label,
    required this.controller,
    this.hint,
    this.errorText,
    this.keyboardType = TextInputType.text,
    this.onChanged,
    this.inputFormatters,
    this.obscureText = false,
    this.suffix,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return AppTextField(
      controller: controller,
      label: label,
      hint: hint,
      keyboardType: keyboardType,
      state: !enabled
          ? AppTextFieldState.disabled
          : errorText != null
          ? AppTextFieldState.error
          : AppTextFieldState.idle,
      errorText: errorText,
      onChanged: onChanged,
      inputFormatters: inputFormatters,
      borderRadius: AppRadius.xl,
      labelStyle: CordeliaTextStyleConst.textSmRegular(
        tt,
      ).copyWith(color: CordeliaColorConst.gray500),
      labelSpacing: AppSpacing.xs,
      height: CordeliaDimenConst.controlHeight,
      obscureText: obscureText,
      suffix: suffix,
    );
  }
}
