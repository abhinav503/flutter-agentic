import 'package:flutter/material.dart';

enum AppIconButtonVariant { filled, translucent }

/// Standalone icon-only circular action button — header controls (back,
/// search) and overlay actions (favourite on a product image). Kept separate
/// from [AppButton] rather than adding a no-label mode to it: a translucent
/// fill and label-less sizing are variant-shaped concerns AppButton's
/// Fill/Outline/Text variants don't need, and folding them in would make
/// AppButton's branching harder to read and extend.
///
/// ```dart
/// AppIconButton(icon: Icons.arrow_back, onTap: () => Navigator.pop(context))
/// AppIconButton(
///   icon: Icons.favorite_border,
///   variant: AppIconButtonVariant.translucent,
///   onTap: () => ...,
/// )
/// ```
class AppIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final AppIconButtonVariant variant;
  final double size;

  const AppIconButton({
    super.key,
    required this.icon,
    this.onTap,
    this.variant = AppIconButtonVariant.filled,
    this.size = 40,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final (bg, fg) = switch (variant) {
      AppIconButtonVariant.filled => (cs.primary, cs.onPrimary),
      AppIconButtonVariant.translucent => (
          cs.onPrimary.withValues(alpha: 0.1),
          cs.onPrimary,
        ),
    };

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
        child: Icon(icon, size: size * 0.5, color: fg),
      ),
    );
  }
}
