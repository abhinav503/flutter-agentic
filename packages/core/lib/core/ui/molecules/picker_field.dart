import 'package:flutter/material.dart';

import '../../theme/app_shapes_extension.dart';
import '../../theme/app_spacing.dart';

/// A read-only, field-shaped **trigger**: a label above a tappable box
/// showing the current value with a trailing glyph. Opens whatever the
/// caller wants (usually a picklist bottom sheet) — it never edits text,
/// which is why it isn't an `AppTextField` (that atom requires a live
/// `TextEditingController` and would only ever be read-only here).
///
/// Style packs pass their box recipe (fill vs outline, radius, height) and
/// typography; the structure — label → gap → box(value | trailing) with the
/// value ellipsised — lives here once.
///
/// ```dart
/// AppPickerField(
///   label: 'City',
///   value: state.city,
///   hint: 'Select city',
///   onTap: _pickCity,
/// )
/// ```
class AppPickerField extends StatelessWidget {
  final String label;

  /// The current value; empty shows [hint] in [hintStyle] instead.
  final String value;
  final String? hint;
  final VoidCallback onTap;

  /// Trailing glyph (default a chevron in `onSurfaceVariant`).
  final Widget? trailing;

  final TextStyle? labelStyle;
  final TextStyle? valueStyle;
  final TextStyle? hintStyle;

  /// Gap between the label and the box (default [AppSpacing.xs3], matching
  /// `AppTextField`).
  final double? labelSpacing;

  /// Insets the label independently of the box.
  final EdgeInsetsGeometry? labelPadding;

  /// Box recipe. [decoration] wins outright when set; otherwise
  /// [fillColor]/[borderColor]/[borderRadius] compose one (the default is
  /// the outlined look `AppTextField` idles at).
  final BoxDecoration? decoration;
  final Color? fillColor;
  final Color? borderColor;
  final BorderRadius? borderRadius;

  final double? height;
  final EdgeInsetsGeometry? padding;

  /// Ripple the box on tap, clipped to its radius. Off by default — a
  /// bordered trigger in a form usually reads better without one, and an
  /// `InkWell` needs a `Material` ancestor to paint at all. Packs whose
  /// typed fields ripple turn it on so the picked one matches them.
  final bool splashOnTap;

  const AppPickerField({
    super.key,
    required this.label,
    required this.value,
    required this.onTap,
    this.hint,
    this.trailing,
    this.labelStyle,
    this.valueStyle,
    this.hintStyle,
    this.labelSpacing,
    this.labelPadding,
    this.decoration,
    this.fillColor,
    this.borderColor,
    this.borderRadius,
    this.height,
    this.padding,
    this.splashOnTap = false,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final radius =
        borderRadius ?? BorderRadius.circular(context.appShapes.inputRadius);
    final showHint = value.isEmpty && hint != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: labelPadding ?? EdgeInsets.zero,
          child: Text(
            label,
            style: labelStyle ?? tt.labelMedium!.copyWith(color: cs.onSurface),
          ),
        ),
        SizedBox(height: labelSpacing ?? AppSpacing.xs3),
        _Tappable(
          onTap: onTap,
          splash: splashOnTap,
          radius: radius,
          child: Container(
            height: height,
            padding:
                padding ??
                const EdgeInsets.symmetric(
                  horizontal: AppSpacing.base,
                  vertical: AppSpacing.sm,
                ),
            decoration:
                decoration ??
                BoxDecoration(
                  color: fillColor,
                  borderRadius: radius,
                  border: fillColor == null || borderColor != null
                      ? Border.all(color: borderColor ?? cs.outline)
                      : null,
                ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    showHint ? hint! : value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: showHint
                        ? (hintStyle ??
                              tt.bodyMedium!.copyWith(
                                color: cs.onSurfaceVariant,
                              ))
                        : (valueStyle ??
                              tt.bodyMedium!.copyWith(color: cs.onSurface)),
                  ),
                ),
                const SizedBox(width: AppSpacing.xs),
                trailing ??
                    Icon(
                      Icons.keyboard_arrow_down,
                      size: 20,
                      color: cs.onSurfaceVariant,
                    ),
              ],
            ),
          ),
        ),
      ],
    );
  }

}

/// The box's tap target: an ink ripple where the pack asks for one, a plain
/// opaque hit test otherwise.
class _Tappable extends StatelessWidget {
  final VoidCallback onTap;
  final bool splash;
  final BorderRadius radius;
  final Widget child;

  const _Tappable({
    required this.onTap,
    required this.splash,
    required this.radius,
    required this.child,
  });

  @override
  Widget build(BuildContext context) => splash
      ? InkWell(onTap: onTap, borderRadius: radius, child: child)
      : GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          child: child,
        );
}
