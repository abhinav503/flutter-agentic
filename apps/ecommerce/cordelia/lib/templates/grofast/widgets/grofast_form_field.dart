import 'package:flutter/material.dart';

import 'package:core/core/theme/app_shapes_extension.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/text_field.dart';
import 'package:core/core/ui/molecules/picker_field.dart';

import 'package:cordelia/templates/grofast/constants/grofast_color_const.dart';
import 'package:cordelia/templates/grofast/constants/grofast_dimen_const.dart';
import 'package:cordelia/templates/grofast/constants/grofast_text_style_const.dart';

/// The pack's labelled form field (spec sheet §13): a 12/500 label over a
/// 50px filled input at radius 18, sharing the search bar's ink-at-6% fill so
/// every input in the app reads as one control family.
///
/// Core's [AppTextField] with this pack's spec passed in — the atom stacks
/// its label above the box and takes a fill, so the only pack-specific
/// things left here are the colours, the typography and the two metrics.
class GrofastFormField extends StatelessWidget {
  final String label;
  final String? hint;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final bool obscureText;

  /// Validation message under the field. These forms validate on submit
  /// through their shared mixin's `fieldErrors` map rather than with a
  /// `Form`/validator, so the message arrives as a value, not a callback.
  final String? errorText;

  final ValueChanged<String>? onChanged;

  /// False renders the field read-only and muted — Edit Profile's email,
  /// which Firebase owns.
  final bool enabled;

  final Widget? suffix;
  final int maxLines;

  const GrofastFormField({
    super.key,
    required this.label,
    required this.controller,
    this.hint,
    this.keyboardType,
    this.obscureText = false,
    this.errorText,
    this.onChanged,
    this.enabled = true,
    this.suffix,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return AppTextField(
      controller: controller,
      label: label,
      hint: hint,
      keyboardType: keyboardType ?? TextInputType.text,
      obscureText: obscureText,
      maxLines: obscureText ? 1 : maxLines,
      onChanged: onChanged,
      suffix: suffix,
      errorText: errorText,
      state: !enabled
          ? AppTextFieldState.disabled
          : errorText != null
          ? AppTextFieldState.error
          : AppTextFieldState.idle,
      // Filled, not outlined: the box only draws an edge when it has focus
      // or an error, which the atom handles from these two colours.
      showBorder: false,
      fillColor: cs.fieldFill,
      focusedBorderColor: cs.primary,
      cursorColor: cs.primary,
      labelStyle: GrofastTextStyleConst.bodySmall(
        tt,
      ).copyWith(color: cs.onSurfaceVariant),
      labelPadding: const EdgeInsets.only(
        left: GrofastDimenConst.fieldLabelInset,
      ),
      labelSpacing: AppSpacing.xs,
      textColor: enabled ? cs.onSurface : cs.onSurfaceVariant,
      hintStyle: GrofastTextStyleConst.placeholder(
        tt,
      ).copyWith(color: cs.onSurface.withValues(alpha: 0.4)),
      errorStyle: GrofastTextStyleConst.bodySmall(tt).copyWith(color: cs.error),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.base,
      ),
      // A fixed height only works for a single line; a multi-line field
      // grows instead.
      height: maxLines == 1 ? GrofastDimenConst.controlHeight : null,
    );
  }
}

/// A field-shaped **button** that opens a picklist sheet — the City and
/// Country rows on the address form. Core's [AppPickerField] carrying the
/// same fill, height and radius as [GrofastFormField], so the form reads as
/// one column of controls with a chevron standing in for the caret.
class GrofastDropdownField extends StatelessWidget {
  final String label;
  final String hint;

  /// Empty renders [hint] in the placeholder treatment.
  final String value;
  final VoidCallback onTap;

  const GrofastDropdownField({
    super.key,
    required this.label,
    required this.hint,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return AppPickerField(
      label: label,
      value: value,
      hint: hint,
      onTap: onTap,
      labelStyle: GrofastTextStyleConst.bodySmall(
        tt,
      ).copyWith(color: cs.onSurfaceVariant),
      labelPadding: const EdgeInsets.only(
        left: GrofastDimenConst.fieldLabelInset,
      ),
      labelSpacing: AppSpacing.xs,
      valueStyle: GrofastTextStyleConst.bodyMedium(
        tt,
      ).copyWith(color: cs.onSurface),
      hintStyle: GrofastTextStyleConst.placeholder(
        tt,
      ).copyWith(color: cs.onSurface.withValues(alpha: 0.4)),
      fillColor: cs.fieldFill,
      borderRadius: BorderRadius.circular(context.appShapes.inputRadius),
      height: GrofastDimenConst.controlHeight,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      // Matches the typed field beside it, which ripples.
      splashOnTap: true,
      trailing: Icon(
        Icons.keyboard_arrow_down_rounded,
        size: AppSpacing.xl4,
        color: cs.onSurfaceVariant,
      ),
    );
  }
}
