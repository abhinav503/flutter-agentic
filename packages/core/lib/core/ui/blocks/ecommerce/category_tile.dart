import 'package:flutter/material.dart';

import '../../../theme/app_spacing.dart';

/// Circular category entry: image on an elevated circle, label underneath.
/// Used in horizontal category rails and category grids.
///
/// Defaults to the theme's `bodyMedium` role; pass [labelStyle] when a style
/// pack's real screens use different metrics for category labels.
class CategoryTile extends StatelessWidget {
  final Widget image;
  final String label;
  final VoidCallback? onTap;
  final TextStyle? labelStyle;

  /// Diameter of the circle behind the image.
  final double size;

  /// Padding between the circle's edge and [image] — shrink this (keeping
  /// [size] fixed) to make the image itself render larger within the same
  /// circle, rather than growing the whole tile.
  final EdgeInsetsGeometry imagePadding;

  /// Circle fill — omit to keep the themed default (`surfaceContainerHighest`).
  /// Callers pass this for a brand-specific fixed shade (e.g. a kit's
  /// Gray/50-in-light, Gray/950-in-dark pair) rather than the theme role.
  final Color? backgroundColor;

  const CategoryTile({
    super.key,
    required this.image,
    required this.label,
    this.onTap,
    this.labelStyle,
    this.size = 64,
    this.imagePadding = const EdgeInsets.all(AppSpacing.base),
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: size,
            height: size,
            padding: imagePadding,
            decoration: BoxDecoration(
              color: backgroundColor ?? cs.surfaceContainerHighest,
              shape: BoxShape.circle,
            ),
            child: image,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            label,
            style: labelStyle ?? tt.bodyMedium,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
