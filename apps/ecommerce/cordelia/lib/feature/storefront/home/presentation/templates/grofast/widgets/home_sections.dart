import 'package:flutter/material.dart';

import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/shimmer_box.dart';
import 'package:core/core/ui/blocks/section_rail.dart';

import 'package:cordelia/feature/storefront/home/domain/entities/category_entity.dart';
import 'package:cordelia/feature/storefront/home/domain/entities/product_entity.dart';
import 'package:cordelia/templates/grofast/constants/grofast_dimen_const.dart';
import 'package:cordelia/templates/grofast/constants/grofast_value_const.dart';
import 'package:cordelia/templates/grofast/widgets/grofast_category_tile.dart';
import 'package:cordelia/templates/grofast/widgets/grofast_product_grid.dart';
import 'package:cordelia/templates/grofast/widgets/grofast_section_header.dart';

/// Home's category rail — the kit's tinted squares scrolling under a
/// "Categories / see all" header.
class GrofastHomeCategoryRail extends StatelessWidget {
  final List<CategoryEntity> categories;
  final ValueChanged<CategoryEntity> onCategoryTap;
  final VoidCallback onSeeAll;

  const GrofastHomeCategoryRail({
    super.key,
    required this.categories,
    required this.onCategoryTap,
    required this.onSeeAll,
  });

  @override
  Widget build(BuildContext context) => SectionRail(
    header: GrofastSectionHeader(
      title: GrofastValueConst.categoriesTitle,
      actionLabel: GrofastValueConst.seeAll,
      onAction: onSeeAll,
    ),
    gutter: GrofastDimenConst.screenGutter,
    itemSpacing: AppSpacing.sm,
    headerGap: AppSpacing.xl2,
    itemCount: categories.length,
    itemBuilder: (context, index) => GrofastCategoryRailTile(
      category: categories[index],
      index: index,
      onTap: () => onCategoryTap(categories[index]),
    ),
  );
}

/// Home's "Popular" block — the pack's staggered grid under its own header,
/// inset to the screen gutter (the grid is not full-bleed, unlike the promo
/// carousel above it).
class GrofastHomePopularGrid extends StatelessWidget {
  final List<ProductEntity> products;
  final ValueChanged<ProductEntity> onProductTap;
  final ValueChanged<ProductEntity> onAddToBag;
  final ValueChanged<ProductEntity> onFavouriteToggle;
  final VoidCallback onSeeAll;

  const GrofastHomePopularGrid({
    super.key,
    required this.products,
    required this.onProductTap,
    required this.onAddToBag,
    required this.onFavouriteToggle,
    required this.onSeeAll,
  });

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(
      horizontal: GrofastDimenConst.screenGutter,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GrofastSectionHeader(
          title: GrofastValueConst.popularTitle,
          actionLabel: GrofastValueConst.seeAll,
          onAction: onSeeAll,
        ),
        const SizedBox(height: AppSpacing.xl2),
        GrofastProductGrid(
          products: products,
          onAdd: onAddToBag,
          onProductTap: onProductTap,
          onFavouriteToggle: onFavouriteToggle,
        ),
      ],
    ),
  );
}

/// Home's first-load skeleton — the same blocks at the same sizes as the
/// loaded page (promo card, category rail, staggered grid), so nothing
/// reflows when data lands (spec sheet §14).
class GrofastHomeSkeletonBody extends StatelessWidget {
  const GrofastHomeSkeletonBody({super.key});

  @override
  Widget build(BuildContext context) {
    const gutter = GrofastDimenConst.screenGutter;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: gutter),
          child: GrofastCardSkeleton(height: GrofastDimenConst.promoCardHeight),
        ),
        const SizedBox(height: AppSpacing.xl6),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: gutter),
          child: ShimmerBox(width: 140, height: AppSpacing.xl4),
        ),
        const SizedBox(height: AppSpacing.xl2),
        SizedBox(
          height: GrofastDimenConst.categoryRailEntryHeight,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(left: gutter),
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 4,
            separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
            itemBuilder: (context, index) => const GrofastCardSkeleton(
              width: GrofastDimenConst.categoryRailTileSize,
              height: GrofastDimenConst.categoryRailTileSize,
              radius: GrofastDimenConst.tileRadius,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xl6),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: gutter),
          child: ShimmerBox(width: 110, height: AppSpacing.xl4),
        ),
        const SizedBox(height: AppSpacing.xl2),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: gutter),
          child: GrofastProductGridSkeleton(itemCount: 4),
        ),
      ],
    );
  }
}
