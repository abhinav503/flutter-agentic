import 'package:cordelia/templates/gravia/constants/gravia_text_style_const.dart';
import 'package:cordelia/templates/gravia/constants/gravia_value_const.dart';
import 'package:cordelia/templates/gravia/widgets/gravia_list_thumbnail.dart';
import 'package:cordelia/templates/gravia/widgets/gravia_tint_badge.dart';
import 'package:flutter/material.dart';

import 'package:core/core/extensions/num_extensions.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/molecules/icon_info_row.dart';
import '../../../../../home/domain/entities/category_entity.dart';
import '../../../../../home/domain/entities/product_entity.dart';

/// The capped suggestion list shown while the shopper types — categories
/// first (they're navigational), then products. The caller (SearchBloc) has
/// already limited the combined count; this widget just renders what it's
/// given.
class SearchSuggestionsSection extends StatelessWidget {
  final List<ProductEntity> products;
  final List<CategoryEntity> categories;
  final ValueChanged<ProductEntity> onProductTap;
  final ValueChanged<CategoryEntity> onCategoryTap;

  const SearchSuggestionsSection({
    super.key,
    required this.products,
    required this.categories,
    required this.onProductTap,
    required this.onCategoryTap,
  });

  static const double _thumbSize = 44;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        children: [
          for (final category in categories)
            IconInfoRow(
              leading: GraviaListThumbnail(
                url: category.imageUrl,
                size: _thumbSize,
              ),
              title: category.name,
              titleStyle: GraviaTextStyleConst.textMdMedium(
                tt,
              ).copyWith(color: cs.onSurface),
              titleMaxLines: 1,
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
              // The pack's tinted-primary badge — same recipe as the order
              // card's status badge and the address tag, correct in both
              // light and dark.
              trailing: const GraviaTintBadge(
                text: GraviaValueConst.searchCategoryBadge,
              ),
              onTap: () => onCategoryTap(category),
            ),
          for (final product in products)
            IconInfoRow(
              leading: GraviaListThumbnail(
                url: product.imageUrl,
                size: _thumbSize,
              ),
              title: product.name,
              titleStyle: GraviaTextStyleConst.textMdMedium(
                tt,
              ).copyWith(color: cs.onSurface),
              titleMaxLines: 1,
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
              trailing: Text(
                product.price.asPrice,
                style: GraviaTextStyleConst.textSmBold(
                  tt,
                ).copyWith(color: cs.onSurface),
              ),
              onTap: () => onProductTap(product),
            ),
        ],
      ),
    );
  }
}
