import 'package:flutter/material.dart';

import 'package:core/core/ui/atoms/glass_surface.dart';

enum AppIconButtonVariant { filled, translucent, glass }

/// Standalone icon-only circular action button — header controls (back,
/// search) and overlay actions (favourite on a product image). Kept separate
/// from [AppButton] rather than adding a no-label mode to it: a translucent
/// fill and label-less sizing are variant-shaped concerns AppButton's
/// Fill/Outline/Text variants don't need, and folding them in would make
/// AppButton's branching harder to read and extend.
///
/// [AppIconButtonVariant.glass] pairs the same tint as [translucent] with an
/// actual backdrop blur (Figma's "Glass" effect) plus a gradient sheen and
/// highlight border. The blur only reads over photos/varied content behind
/// it — blurring a flat colour (e.g. sitting on [ColorScheme.primary]) is
/// visually identical to the same flat colour at any sigma, so the sheen is
/// what makes glass read on a solid-colour surface too.
///
/// Pass either [icon] (Material icon) or [iconBuilder] (custom icon widget,
/// e.g. an SVG asset) — [iconBuilder] receives the resolved foreground colour
/// and [iconSize], so the caller sizes the widget from the same source of
/// truth (e.g. `AppSvgImage.asset(path, color: color, width: size, height:
/// size)`) instead of guessing a value that would otherwise be silently
/// overridden by the enclosing fixed-size box.
///
/// ```dart
/// AppIconButton(icon: Icons.arrow_back, onTap: () => Navigator.pop(context))
/// AppIconButton(
///   iconBuilder: (color, size) => SvgPicture.asset(
///     'assets/icons/notification.svg',
///     width: size,
///     height: size,
///     colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
///   ),
///   variant: AppIconButtonVariant.glass,
///   onTap: () => ...,
/// )
/// ```
class AppIconButton extends StatelessWidget {
  final IconData? icon;
  final Widget Function(Color color, double size)? iconBuilder;
  final VoidCallback? onTap;
  final AppIconButtonVariant variant;
  final double containerSize;
  final double iconSize;

  const AppIconButton({
    super.key,
    this.icon,
    this.iconBuilder,
    this.onTap,
    this.variant = AppIconButtonVariant.filled,
    this.containerSize = 40,
    this.iconSize = 20,
  }) : assert(
          icon != null || iconBuilder != null,
          'AppIconButton requires either icon or iconBuilder',
        );

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isGlass = variant == AppIconButtonVariant.glass;
    final (bg, fg) = switch (variant) {
      AppIconButtonVariant.filled => (cs.primary, cs.onPrimary),
      AppIconButtonVariant.translucent ||
      AppIconButtonVariant.glass => (
          cs.onPrimary.withValues(alpha: 0.1),
          cs.onPrimary,
        ),
    };

    final iconWidget = iconBuilder != null
        ? SizedBox(
            width: iconSize,
            height: iconSize,
            child: iconBuilder!(fg, iconSize),
          )
        : Icon(icon, size: iconSize, color: fg);

    final button = isGlass
        ? AppGlassSurface(
            size: containerSize,
            tintColor: fg,
            child: iconWidget,
          )
        : Container(
            width: containerSize,
            height: containerSize,
            // Without an alignment, Container hands its child tight
            // containerSize×containerSize constraints with nothing to loosen
            // them (see Container.build in the Flutter SDK — the Align wrap
            // that would loosen them only happens `if (alignment != null)`),
            // so iconSize below containerSize gets silently clamped back up.
            // Centering forces that Align wrap, giving iconWidget loose
            // constraints it can actually size itself within.
            alignment: Alignment.center,
            decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
            child: iconWidget,
          );

    return GestureDetector(onTap: onTap, child: button);
  }
}
