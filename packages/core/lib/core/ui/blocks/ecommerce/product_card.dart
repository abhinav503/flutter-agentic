import 'package:flutter/material.dart';

import '../../../theme/app_shapes_extension.dart';
import '../../../theme/app_spacing.dart';
import '../../atoms/badge.dart';
import '../../atoms/button.dart';
import 'product_meta_row.dart';

export 'product_meta_row.dart' show ProductCardMeta, ProductMetaRow;

/// Photo-forward commerce card: square image, optional quantity badge, title,
/// meta row, price with optional strike-through original, and a full-width
/// pill CTA. The composition matches the ecommerce style pack
/// (docs/ai-rules/design.md); all colour/shape comes from the theme, so it
/// re-skins per preset like any atom.
///
/// ```dart
/// ProductCard(
///   image: Image.network(url, fit: BoxFit.cover),
///   title: 'Washington Red Apple',
///   badgeLabel: '300 g',
///   meta: const [ProductCardMeta(icon: Icon(Icons.bolt), label: '10 Min')],
///   price: '\$6.30',
///   originalPrice: '\$8.00',
///   actionLabel: 'Add To Cart',
///   onAction: () => ...,
/// )
/// ```
class ProductCard extends StatelessWidget {
  final Widget image;
  final String title;
  final TextStyle? titleStyle;
  final String price;
  final String? originalPrice;
  final String? badgeLabel;
  final TextStyle? badgeLabelStyle;
  final Color? badgeBackgroundColor;
  final List<ProductCardMeta> meta;
  final TextStyle? metaLabelStyle;
  final String? actionLabel;
  final TextStyle? actionLabelStyle;
  final VoidCallback? onAction;
  final VoidCallback? onTap;

  /// Optional widget shown to the right of the CTA button (e.g. a glass
  /// icon-only quick action) — caller-built so core stays SVG/icon-package
  /// agnostic, same reasoning as [ProductCardMeta.icon].
  final Widget? trailingAction;

  const ProductCard({
    super.key,
    required this.image,
    required this.title,
    this.titleStyle,
    required this.price,
    this.originalPrice,
    this.badgeLabel,
    this.badgeLabelStyle,
    this.badgeBackgroundColor,
    this.meta = const [],
    this.metaLabelStyle,
    this.actionLabel,
    this.actionLabelStyle,
    this.onAction,
    this.onTap,
    this.trailingAction,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final shapes = Theme.of(context).extension<AppShapes>() ?? AppShapes.standard;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(shapes.cardRadius),
            child: AspectRatio(aspectRatio: 1, child: image),
          ),
          if (badgeLabel != null) ...[
            const SizedBox(height: AppSpacing.xs),
            AppBadge(
              text: badgeLabel!,
              intent: AppBadgeIntent.info,
              textStyle: badgeLabelStyle,
              backgroundColor: badgeBackgroundColor,
            ),
          ],
          const SizedBox(height: AppSpacing.xs2),
          Text(
            title,
            style: titleStyle ?? tt.titleMedium!.copyWith(fontWeight: FontWeight.w700),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          if (meta.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.xs3),
            ProductMetaRow(meta: meta, labelStyle: metaLabelStyle),
          ],
          const SizedBox(height: AppSpacing.xs3),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(price,
                  style: tt.titleMedium!
                      .copyWith(fontWeight: FontWeight.w700, color: cs.onSurface)),
              if (originalPrice != null) ...[
                const SizedBox(width: AppSpacing.xs2),
                Text(
                  originalPrice!,
                  style: tt.bodySmall!.copyWith(
                    color: cs.onSurfaceVariant,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
              ],
            ],
          ),
          if (actionLabel != null) ...[
            const SizedBox(height: AppSpacing.xs),
            AppButton(
              label: actionLabel!,
              onTap: onAction,
              size: AppButtonSize.small,
              fullWidth: true,
              height: AppSpacing.xl9,
              // Ecommerce CTA is always a full pill, regardless of the
              // active style pack's own button radius.
              borderRadius: BorderRadius.circular(999),
              labelStyle: actionLabelStyle,
              trailingAction: trailingAction,
            ),
          ],
        ],
      ),
    );
  }
}
