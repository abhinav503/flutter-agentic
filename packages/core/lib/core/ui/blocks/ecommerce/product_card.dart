import 'package:flutter/material.dart';

import '../../../theme/app_shapes_extension.dart';
import '../../../theme/app_spacing.dart';
import '../../atoms/badge.dart';
import '../../atoms/button.dart';

/// One icon + label pair on the meta row (e.g. delivery time, discount).
class ProductCardMeta {
  final IconData icon;
  final String label;
  const ProductCardMeta({required this.icon, required this.label});
}

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
///   meta: const [ProductCardMeta(icon: Icons.bolt, label: '10 Min')],
///   price: '\$6.30',
///   originalPrice: '\$8.00',
///   actionLabel: 'Add To Cart',
///   onAction: () => ...,
/// )
/// ```
class ProductCard extends StatelessWidget {
  final Widget image;
  final String title;
  final String price;
  final String? originalPrice;
  final String? badgeLabel;
  final List<ProductCardMeta> meta;
  final String? actionLabel;
  final VoidCallback? onAction;
  final VoidCallback? onTap;

  const ProductCard({
    super.key,
    required this.image,
    required this.title,
    required this.price,
    this.originalPrice,
    this.badgeLabel,
    this.meta = const [],
    this.actionLabel,
    this.onAction,
    this.onTap,
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
            AppBadge(text: badgeLabel!, intent: AppBadgeIntent.info),
          ],
          const SizedBox(height: AppSpacing.xs2),
          Text(
            title,
            style: tt.titleMedium!.copyWith(fontWeight: FontWeight.w700),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          if (meta.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.xs3),
            Row(
              children: [
                for (final m in meta) ...[
                  Icon(m.icon, size: 14, color: cs.onSurfaceVariant),
                  const SizedBox(width: AppSpacing.xs4),
                  Text(m.label,
                      style:
                          tt.labelSmall!.copyWith(color: cs.onSurfaceVariant)),
                  const SizedBox(width: AppSpacing.xs),
                ],
              ],
            ),
          ],
          const SizedBox(height: AppSpacing.xs3),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(price,
                  style: tt.titleMedium!.copyWith(fontWeight: FontWeight.w700)),
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
            ),
          ],
        ],
      ),
    );
  }
}
