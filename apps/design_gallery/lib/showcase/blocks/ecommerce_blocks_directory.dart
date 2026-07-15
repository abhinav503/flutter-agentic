import 'package:core/core/ui/atoms/icon_button.dart';
import 'package:core/core/ui/blocks/ecommerce/category_tile.dart';
import 'package:core/core/ui/blocks/ecommerce/product_card.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

import '../showcase_layouts.dart';

WidgetbookFolder ecommerceBlocksFolder() {
  return WidgetbookFolder(
    name: 'Ecommerce',
    children: [
      allVariants(
        'ProductCard',
        (context) => showcaseGrid(context, [
          Variant(
            'Default',
            ProductCard(
              image: placeholderImage(context),
              title: 'Washington Red Apple',
              badgeLabel: '300 g',
              meta: const [
                ProductCardMeta(icon: Icon(Icons.bolt), label: '10 Min'),
              ],
              price: '\$6.30',
              originalPrice: '\$8.00',
              actionLabel: 'Add To Cart',
              onAction: () {},
            ),
          ),
          Variant(
            'With trailing action',
            Builder(
              builder: (context) {
                final cs = Theme.of(context).colorScheme;
                return ProductCard(
                  image: placeholderImage(context),
                  title: 'Washington Red Apple',
                  badgeLabel: '300 g',
                  badgeLabelStyle: TextStyle(color: cs.primary),
                  badgeBackgroundColor: cs.primary.withValues(alpha: 0.1),
                  meta: const [
                    ProductCardMeta(icon: Icon(Icons.bolt), label: '10 Min'),
                  ],
                  metaLabelStyle: TextStyle(color: cs.onSurface),
                  price: '\$6.30',
                  originalPrice: '\$8.00',
                  actionLabel: 'Add To Cart',
                  onAction: () {},
                  // Docks a fully separate tappable widget on the CTA's
                  // trailing edge — see AppButton's `trailingAction`.
                  trailingAction: AppIconButton(
                    icon: Icons.shopping_bag_outlined,
                    variant: AppIconButtonVariant.glass,
                    containerSize: 32,
                    iconSize: 16,
                    glassHighlightThickness: 2,
                    glassBlurSigma: 4,
                    onTap: () {},
                  ),
                );
              },
            ),
          ),
        ]),
      ),
      allVariants(
        'CategoryTile',
        (context) => showcase(context, [
          Variant(
            'Default',
            CategoryTile(
              image: placeholderImage(context, icon: Icons.eco_outlined),
              label: 'Vegetables',
              onTap: () {},
            ),
          ),
          Variant(
            'Tighter imagePadding (e.g. gravia)',
            CategoryTile(
              imagePadding: const EdgeInsets.all(8),
              image: placeholderImage(context, icon: Icons.eco_outlined),
              label: 'Vegetables',
              onTap: () {},
            ),
          ),
        ]),
      ),
    ],
  );
}
