import 'package:flutter/material.dart';

import 'package:core/core/theme/app_shapes_extension.dart';
import 'package:core/core/theme/app_spacing.dart';

import 'package:cordelia/templates/grofast/constants/grofast_color_const.dart';
import 'package:cordelia/templates/grofast/constants/grofast_dimen_const.dart';
import 'package:cordelia/templates/grofast/constants/grofast_text_style_const.dart';

/// The pack's labelled form field (spec sheet §13): a 12/500 label over a
/// 50px filled input at radius 18, sharing the search bar's ink-at-6% fill so
/// every input in the app reads as one control family.
///
/// Not core's `AppTextField`: that atom draws an outlined field with a
/// floating label, while this pack fills its inputs and stacks the label
/// above them.
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
    final radius = BorderRadius.circular(context.appShapes.inputRadius);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: GrofastDimenConst.fieldLabelInset,
          ),
          child: Text(
            label,
            style: GrofastTextStyleConst.bodySmall(
              tt,
            ).copyWith(color: cs.onSurfaceVariant),
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          onChanged: onChanged,
          enabled: enabled,
          maxLines: obscureText ? 1 : maxLines,
          cursorColor: cs.primary,
          style: GrofastTextStyleConst.bodyMedium(
            tt,
          ).copyWith(color: enabled ? cs.onSurface : cs.onSurfaceVariant),
          decoration: InputDecoration(
            hintText: hint,
            errorText: errorText,
            hintStyle: GrofastTextStyleConst.placeholder(
              tt,
            ).copyWith(color: cs.onSurface.withValues(alpha: 0.4)),
            filled: true,
            fillColor: cs.fieldFill,
            suffixIcon: suffix,
            // A fixed height only works for a single line; a multi-line
            // field grows instead.
            constraints: maxLines == 1
                ? const BoxConstraints(
                    minHeight: GrofastDimenConst.controlHeight,
                  )
                : null,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.base,
            ),
            border: OutlineInputBorder(
              borderRadius: radius,
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: radius,
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: radius,
              borderSide: BorderSide(color: cs.primary),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: radius,
              borderSide: BorderSide(color: cs.error),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: radius,
              borderSide: BorderSide(color: cs.error),
            ),
            errorStyle: GrofastTextStyleConst.bodySmall(
              tt,
            ).copyWith(color: cs.error),
          ),
        ),
      ],
    );
  }
}

/// A field-shaped **button** that opens a picklist sheet — the City and
/// Country rows on the address form. Same fill, height and radius as
/// [GrofastFormField] so the form reads as one column of controls, with a
/// chevron standing in for the caret.
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
    final radius = BorderRadius.circular(context.appShapes.inputRadius);
    final isEmpty = value.isEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: GrofastDimenConst.fieldLabelInset,
          ),
          child: Text(
            label,
            style: GrofastTextStyleConst.bodySmall(
              tt,
            ).copyWith(color: cs.onSurfaceVariant),
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Material(
          color: cs.fieldFill,
          borderRadius: radius,
          child: InkWell(
            onTap: onTap,
            borderRadius: radius,
            child: Container(
              height: GrofastDimenConst.controlHeight,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      isEmpty ? hint : value,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: isEmpty
                          ? GrofastTextStyleConst.placeholder(tt).copyWith(
                              color: cs.onSurface.withValues(alpha: 0.4),
                            )
                          : GrofastTextStyleConst.bodyMedium(
                              tt,
                            ).copyWith(color: cs.onSurface),
                    ),
                  ),
                  Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: AppSpacing.xl4,
                    color: cs.onSurfaceVariant,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
