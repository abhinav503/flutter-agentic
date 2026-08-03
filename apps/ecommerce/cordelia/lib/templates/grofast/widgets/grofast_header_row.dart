import 'package:flutter/material.dart';

import 'package:core/core/theme/app_radius.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/svg_image.dart';

import 'package:cordelia/templates/grofast/constants/grofast_color_const.dart';
import 'package:cordelia/templates/grofast/constants/grofast_dimen_const.dart';
import 'package:cordelia/templates/grofast/constants/grofast_image_const.dart';
import 'package:cordelia/templates/grofast/constants/grofast_text_style_const.dart';

/// The pack's back control: a 60 × 40 rounded **rectangle**, not a disc
/// (spec sheet §2). Outlined rather than filled, so it reads as chrome
/// against the plain white body.
class GrofastBackButton extends StatelessWidget {
  final VoidCallback? onTap;

  const GrofastBackButton({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return SizedBox(
      width: GrofastDimenConst.backButtonWidth,
      height: GrofastDimenConst.backButtonHeight,
      child: Material(
        color: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.full,
          side: BorderSide(color: cs.outline),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap ?? () => Navigator.of(context).maybePop(),
          child: Center(
            child: AppSvgImage.asset(
              GrofastImageConst.backArrow,
              width: AppSpacing.lg,
              height: AppSpacing.lg,
              color: cs.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}

/// A bare glyph action in a header row — the bell and the bag, each with an
/// optional unread dot. No disc behind it: the kit floats these directly on
/// the page (spec sheet §5).
class GrofastHeaderAction extends StatelessWidget {
  /// Pack SVG. Mutually exclusive with [icon].
  final String? asset;

  /// Material fallback for a glyph the kit doesn't export.
  final IconData? icon;
  final VoidCallback? onTap;
  final bool showDot;
  final String? tooltip;

  const GrofastHeaderAction({
    super.key,
    this.asset,
    this.icon,
    this.onTap,
    this.showDot = false,
    this.tooltip,
  }) : assert(
         (asset == null) != (icon == null),
         'Pass a pack asset or a Material icon, not both.',
       );

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final glyph = asset != null
        ? AppSvgImage.asset(
            asset!,
            width: GrofastDimenConst.headerIconSize,
            height: GrofastDimenConst.headerIconSize,
            color: cs.onSurface,
          )
        : Icon(
            icon,
            size: GrofastDimenConst.headerIconSize,
            color: cs.onSurface,
          );

    return Semantics(
      button: true,
      label: tooltip,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: SizedBox(
          // Padded out to the touch floor around a 25px glyph.
          width: AppSpacing.xl9,
          height: AppSpacing.xl9,
          child: Stack(
            alignment: Alignment.center,
            children: [
              glyph,
              if (showDot)
                Positioned(
                  top: AppSpacing.sm,
                  right: AppSpacing.sm,
                  child: Container(
                    width: AppSpacing.xs2,
                    height: AppSpacing.xs2,
                    decoration: BoxDecoration(
                      color: cs.error,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The pack's standard screen header (spec sheet §8): back control, an
/// optically centred title, and one trailing action.
///
/// The title is centred against the **screen**, not against what's left over
/// beside the controls — the kit balances it by giving the trailing slot the
/// same width as the back control.
class GrofastHeaderRow extends StatelessWidget {
  final String? title;
  final VoidCallback? onBack;
  final bool showBack;
  final Widget? trailing;

  const GrofastHeaderRow({
    super.key,
    this.title,
    this.onBack,
    this.showBack = true,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return SizedBox(
      height: GrofastDimenConst.backButtonHeight,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (title != null)
            Text(
              title!,
              style: GrofastTextStyleConst.labelSemibold(
                tt,
              ).copyWith(color: cs.onSurface),
            ),
          Align(
            alignment: Alignment.centerLeft,
            child: showBack
                ? GrofastBackButton(onTap: onBack)
                : const SizedBox(width: GrofastDimenConst.backButtonWidth),
          ),
          Align(
            alignment: Alignment.centerRight,
            child:
                trailing ??
                const SizedBox(width: GrofastDimenConst.backButtonWidth),
          ),
        ],
      ),
    );
  }
}

/// A circular gradient disc carrying a glyph — the pack's affirmative icon
/// control (Home's scan slot, the success sheet's check, a floating action).
/// Uses [GrofastColorConst.brandGradient] for the same reason
/// `GrofastPrimaryButton` does.
class GrofastGradientDisc extends StatelessWidget {
  final IconData? icon;
  final String? asset;
  final double size;
  final double glyphSize;
  final VoidCallback? onTap;
  final List<BoxShadow>? shadows;

  const GrofastGradientDisc({
    super.key,
    this.icon,
    this.asset,
    required this.size,
    required this.glyphSize,
    this.onTap,
    this.shadows,
  }) : assert(
         (asset == null) != (icon == null),
         'Pass a pack asset or a Material icon, not both.',
       );

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final disc = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: GrofastColorConst.brandGradient,
        shape: BoxShape.circle,
        boxShadow: shadows,
      ),
      alignment: Alignment.center,
      child: asset != null
          ? AppSvgImage.asset(
              asset!,
              width: glyphSize,
              height: glyphSize,
              color: cs.onPrimary,
            )
          : Icon(icon, size: glyphSize, color: cs.onPrimary),
    );

    if (onTap == null) return disc;
    return GestureDetector(onTap: onTap, child: disc);
  }
}
