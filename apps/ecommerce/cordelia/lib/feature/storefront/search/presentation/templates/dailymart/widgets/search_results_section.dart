import 'package:flutter/material.dart';

import 'package:core/core/extensions/num_extensions.dart';
import 'package:core/core/theme/app_colors_extension.dart';
import 'package:core/core/theme/app_radius.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/network_image.dart';
import 'package:core/core/ui/molecules/icon_info_row.dart';

import 'package:cordelia/templates/dailymart/constants/dailymart_image_const.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_text_style_const.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_value_const.dart';
import 'package:cordelia/templates/dailymart/widgets/dailymart_icon_disc.dart';
import 'package:cordelia/templates/dailymart/widgets/dailymart_pill.dart';

import '../../../../../home/domain/entities/category_entity.dart';
import '../../../../../home/domain/entities/product_entity.dart';

/// The results state — 'Result for "query"' beside the kit's green count,
/// then one vertical list: matching categories first (they're
/// navigational), then products, each row's trailing control saying what
/// tapping it does (a tinted "Category" pill vs the green **+**).
class DailyMartSearchResultsSection extends StatelessWidget {
  final String query;
  final List<CategoryEntity> categories;
  final List<ProductEntity> products;
  final ValueChanged<CategoryEntity> onCategoryTap;
  final ValueChanged<ProductEntity> onProductTap;

  /// Opens the add-to-cart sheet — a list row has no room for the card's
  /// quantity-free instant add plus a details push, so the **+** here asks.
  final ValueChanged<ProductEntity> onAdd;

  const DailyMartSearchResultsSection({
    super.key,
    required this.query,
    required this.categories,
    required this.products,
    required this.onCategoryTap,
    required this.onProductTap,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                DailyMartValueConst.resultsForLabel(query),
                style: DailyMartTextStyleConst.bodyLgSemibold(
                  tt,
                ).copyWith(color: cs.onSurface),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            Text(
              DailyMartValueConst.resultsCountLabel(
                categories.length + products.length,
              ),
              style: DailyMartTextStyleConst.bodyMdMedium(
                tt,
              ).copyWith(color: cs.primary),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        for (final category in categories)
          _ResultRow(
            imageUrl: category.imageUrl,
            name: category.name,
            trailing: const _CategoryPill(),
            onTap: () => onCategoryTap(category),
          ),
        for (final product in products)
          _ResultRow(
            imageUrl: product.imageUrl,
            name: product.name,
            subtitle: product.price.asPrice,
            // The kit's 24 disc with its 14/24 glyph-to-disc ratio — the
            // container is drawn here now that `plus.svg` is a bare glyph.
            trailing: DailyMartIconDisc(
              asset: DailyMartImageConst.plus,
              onTap: () => onAdd(product),
              size: 24,
              iconSize: 14,
              backgroundColor: cs.primary,
              foregroundColor: cs.onPrimary,
            ),
            onTap: () => onProductTap(product),
          ),
      ],
    );
  }
}

class _ResultRow extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String? subtitle;
  final Widget trailing;
  final VoidCallback onTap;

  static const double _thumbSize = 56;

  const _ResultRow({
    required this.imageUrl,
    required this.name,
    this.subtitle,
    required this.trailing,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final rowStyle = DailyMartTextStyleConst.bodySmSemibold(
      tt,
    ).copyWith(color: cs.onSurface);

    return IconInfoRow(
      leading: ClipRRect(
        // The pack's list-thumbnail corner (spec sheet §2).
        borderRadius: AppRadius.sm,
        child: Container(
          width: _thumbSize,
          height: _thumbSize,
          color: cs.surfaceContainerHighest,
          child: AppNetworkImage(url: imageUrl, fit: BoxFit.cover),
        ),
      ),
      title: name,
      titleStyle: rowStyle,
      titleMaxLines: 1,
      subtitle: subtitle,
      subtitleStyle: rowStyle,
      lineGap: AppSpacing.xs4,
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      trailing: trailing,
      onTap: onTap,
    );
  }
}

/// The tinted single-tint pill that marks a category row — the pack's one
/// primary tint (`tintedPrimaryFill`, spec sheet §1) with a primary label.
class _CategoryPill extends StatelessWidget {
  const _CategoryPill();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return DailyMartPill(
      label: DailyMartValueConst.categoryBadge,
      color: context.appColors.tintedPrimaryFill,
      style: DailyMartTextStyleConst.bodyXsSemibold(
        tt,
      ).copyWith(color: cs.primary),
    );
  }
}
