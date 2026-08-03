import 'package:flutter/material.dart';

import 'package:core/core/theme/app_shapes_extension.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/svg_image.dart';

import 'package:cordelia/templates/grofast/constants/grofast_color_const.dart';
import 'package:cordelia/templates/grofast/constants/grofast_dimen_const.dart';
import 'package:cordelia/templates/grofast/constants/grofast_image_const.dart';
import 'package:cordelia/templates/grofast/constants/grofast_text_style_const.dart';

/// The pack's search field (spec sheet §10): a 50px bar at radius 18, filled
/// with the ink at 6% — `cs.fieldFill`, a green-cast tint no neutral role
/// reproduces — with the search glyph leading in `cs.primary`.
///
/// Two modes, deliberately one widget: [onTap] makes it a *button* that
/// navigates to Search (Home, Category Details), while a [controller] makes
/// it a live input (the Search screen itself). A screen passes one or the
/// other, never both.
class GrofastSearchField extends StatelessWidget {
  final String hint;

  /// Live-input mode.
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final bool autofocus;

  /// Button mode — the whole field becomes one tap target.
  final VoidCallback? onTap;

  /// A square control docked at the trailing edge (Home's gradient scan
  /// slot, the results screens' filter square). Sized to match the field's
  /// height, so the pair reads as one 50px band.
  final Widget? trailing;

  const GrofastSearchField({
    super.key,
    required this.hint,
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.autofocus = false,
    this.onTap,
    this.trailing,
  }) : assert(
         onTap == null || controller == null,
         'A field is either a navigation target or a live input, not both.',
       );

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final radius = BorderRadius.circular(context.appShapes.inputRadius);

    final placeholderStyle = GrofastTextStyleConst.placeholder(
      tt,
    ).copyWith(color: cs.onSurface.withValues(alpha: 0.4));

    final field = Container(
      height: GrofastDimenConst.controlHeight,
      decoration: BoxDecoration(color: cs.fieldFill, borderRadius: radius),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Row(
        children: [
          AppSvgImage.asset(
            GrofastImageConst.search,
            width: AppSpacing.xl,
            height: AppSpacing.xl,
            color: cs.primary,
          ),
          const SizedBox(width: AppSpacing.base),
          Expanded(
            child: controller == null
                ? Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      hint,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: placeholderStyle,
                    ),
                  )
                : TextField(
                    controller: controller,
                    onChanged: onChanged,
                    onSubmitted: onSubmitted,
                    autofocus: autofocus,
                    textInputAction: TextInputAction.search,
                    style: GrofastTextStyleConst.bodySmall(
                      tt,
                    ).copyWith(color: cs.onSurface),
                    cursorColor: cs.primary,
                    decoration: InputDecoration(
                      isDense: true,
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                      hintText: hint,
                      hintStyle: placeholderStyle,
                    ),
                  ),
          ),
        ],
      ),
    );

    final bar = onTap == null
        ? field
        : GestureDetector(
            onTap: onTap,
            behavior: HitTestBehavior.opaque,
            child: field,
          );

    if (trailing == null) return bar;
    return Row(
      children: [
        Expanded(child: bar),
        const SizedBox(width: AppSpacing.lg),
        trailing!,
      ],
    );
  }
}

/// The square control that docks beside a [GrofastSearchField] — the kit's
/// filter button. Same 50px side and 18 radius as the field, filled with the
/// neutral card tint (the gradient is reserved for affirmative controls, and
/// opening a filter sheet is not one).
class GrofastSquareAction extends StatelessWidget {
  final String? asset;
  final IconData? icon;
  final VoidCallback onTap;
  final String? tooltip;

  const GrofastSquareAction({
    super.key,
    this.asset,
    this.icon,
    required this.onTap,
    this.tooltip,
  }) : assert(
         (asset == null) != (icon == null),
         'Pass a pack asset or a Material icon, not both.',
       );

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final radius = BorderRadius.circular(context.appShapes.inputRadius);

    return Semantics(
      button: true,
      label: tooltip,
      child: Material(
        color: cs.surfaceContainerLow,
        borderRadius: radius,
        child: InkWell(
          onTap: onTap,
          borderRadius: radius,
          child: SizedBox.square(
            dimension: GrofastDimenConst.controlHeight,
            child: Center(
              child: asset != null
                  ? AppSvgImage.asset(
                      asset!,
                      width: AppSpacing.xl2,
                      height: AppSpacing.xl2,
                      color: cs.onSurface,
                    )
                  : Icon(icon, size: AppSpacing.xl2, color: cs.onSurface),
            ),
          ),
        ),
      ),
    );
  }
}
