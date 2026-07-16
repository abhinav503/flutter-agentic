import 'package:flutter/material.dart';

import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/svg_image.dart';

import 'package:gravia/constants/color_const.dart';
import 'package:gravia/constants/image_const.dart';
import 'package:gravia/constants/text_style_const.dart';
import 'package:gravia/constants/value_const.dart';

import '../../../home/domain/entities/product_entity.dart';

class RecentSearchSection extends StatelessWidget {
  final List<ProductEntity> products;
  final ValueChanged<ProductEntity> onProductTap;
  final ValueChanged<String> onRemove;
  static const double _rowHeight = 20;

  const RecentSearchSection({
    super.key,
    required this.products,
    required this.onProductTap,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) return const SizedBox.shrink();

    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final nameColor = Theme.of(context).brightness == Brightness.dark
        ? ColorConst.gray100
        : ColorConst.gray700;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            ValueConst.recentSearchTitle,
            style: TextStyleConst.textLgBold(tt).copyWith(color: cs.onSurface),
          ),
          const SizedBox(height: AppSpacing.xs),
          for (final product in products)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
              child: SizedBox(
                height: _rowHeight,
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => onProductTap(product),
                        behavior: HitTestBehavior.opaque,
                        child: Row(
                          children: [
                            AppSvgImage.asset(
                              ImageConst.undo,
                              width: _rowHeight,
                              height: _rowHeight,
                              color: cs.onSurface,
                            ),
                            const SizedBox(width: AppSpacing.base),
                            Expanded(
                              child: Text(
                                product.name,
                                style: TextStyleConst.textSmRegular(
                                  tt,
                                ).copyWith(color: nameColor),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.base),
                    GestureDetector(
                      onTap: () => onRemove(product.id),
                      behavior: HitTestBehavior.opaque,
                      child: AppSvgImage.asset(
                        ImageConst.remove,
                        width: _rowHeight,
                        height: _rowHeight,
                        color: cs.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
