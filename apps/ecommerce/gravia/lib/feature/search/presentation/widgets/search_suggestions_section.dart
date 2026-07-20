import 'package:flutter/material.dart';

import 'package:core/core/theme/app_spacing.dart';

import 'package:gravia/constants/text_style_const.dart';
import 'package:gravia/constants/value_const.dart';
import 'package:gravia/widgets/gravia_list_thumbnail.dart';
import 'package:gravia/widgets/gravia_tint_badge.dart';

import '../../../home/domain/entities/category_entity.dart';
import '../../../home/domain/entities/product_entity.dart';

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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        children: [
          for (final category in categories)
            _SuggestionTile(
              imageUrl: category.imageUrl,
              name: category.name,
              // The pack's tinted-primary badge — same recipe as the order
              // card's status badge and the address tag, correct in both
              // light and dark.
              trailing: const GraviaTintBadge(
                text: ValueConst.searchCategoryBadge,
              ),
              onTap: () => onCategoryTap(category),
            ),
          for (final product in products)
            _SuggestionTile(
              imageUrl: product.imageUrl,
              name: product.name,
              trailing: Text(
                ValueConst.formattedPrice(product.price),
                style: TextStyleConst.textSmBold(
                  Theme.of(context).textTheme,
                ).copyWith(color: Theme.of(context).colorScheme.onSurface),
              ),
              onTap: () => onProductTap(product),
            ),
        ],
      ),
    );
  }
}

class _SuggestionTile extends StatelessWidget {
  final String imageUrl;
  final String name;
  final Widget trailing;
  final VoidCallback onTap;
  static const double _thumbSize = 44;

  const _SuggestionTile({
    required this.imageUrl,
    required this.name,
    required this.trailing,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        child: Row(
          children: [
            GraviaListThumbnail(url: imageUrl, size: _thumbSize),
            const SizedBox(width: AppSpacing.base),
            Expanded(
              child: Text(
                name,
                style: TextStyleConst.textMdMedium(
                  tt,
                ).copyWith(color: cs.onSurface),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: AppSpacing.base),
            trailing,
          ],
        ),
      ),
    );
  }
}
