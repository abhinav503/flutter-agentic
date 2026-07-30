import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:core/core/theme/app_radius.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/text_field.dart';

import 'package:cordelia/templates/dailymart/constants/dailymart_dimen_const.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_text_style_const.dart';

/// DailyMart's one form-field look — [AppTextField] pinned to the kit's
/// Personal Data spec: a 56px box at **radius 12** with a `cs.outline`
/// hairline, and a 14/500 ink label above it.
///
/// Radius 12, not the preset's pill `shape.input`: the pill belongs to the
/// *search* field, which is the pack's only round input (spec sheet §2). A
/// pilled multi-field form reads as a stack of search bars, and the kit
/// draws these square-rounded for exactly that reason.
class DailyMartFormField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String? hint;
  final String? errorText;
  final TextInputType keyboardType;
  final ValueChanged<String>? onChanged;
  final List<TextInputFormatter>? inputFormatters;

  /// False for a field that shows a value but can't be edited — Edit
  /// Profile's Email, which can't change without Firebase's own
  /// re-verification flow.
  final bool enabled;

  /// Change Password's three fields. No visibility toggle rides along: the
  /// kit ships no eye glyph, and a Material Symbol stand-in inside the one
  /// control the shopper is typing in would read as a foreign pack.
  final bool obscureText;

  const DailyMartFormField({
    super.key,
    required this.label,
    required this.controller,
    this.hint,
    this.errorText,
    this.keyboardType = TextInputType.text,
    this.onChanged,
    this.inputFormatters,
    this.enabled = true,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
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
      obscureText: obscureText,
      borderRadius: AppRadius.lg,
      labelStyle: DailyMartTextStyleConst.bodySmMedium(
        tt,
      ).copyWith(color: cs.onSurface),
      labelSpacing: AppSpacing.xs,
      height: DailyMartDimenConst.formFieldHeight,
    );
  }
}
