import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:core/core/base/base_screen.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/shimmer_box.dart';

import 'package:cordelia/constants/app_routes.dart';
import 'package:cordelia/feature/storefront/active_store/presentation/cubit/active_store_cubit.dart';
import 'package:cordelia/templates/grofast/constants/grofast_dimen_const.dart';
import 'package:cordelia/templates/grofast/constants/grofast_value_const.dart';
import 'package:cordelia/templates/grofast/widgets/grofast_category_tile.dart';
import 'package:cordelia/templates/grofast/widgets/grofast_product_grid.dart';
import 'package:cordelia/templates/grofast/widgets/grofast_screen_body.dart';
import 'package:cordelia/templates/grofast/widgets/grofast_search_field.dart';
import 'package:cordelia/templates/grofast/widgets/grofast_section_header.dart';
import 'package:cordelia/templates/grofast/widgets/grofast_state_views.dart';

import '../../../../../home/domain/entities/category_entity.dart';
import '../../../../domain/entities/category_group_entity.dart';
import '../../../bloc/categories_bloc.dart';

/// `grofast` template's Categories tab — the kit's "All Categories" frame
/// (`119:796`): a tap-to-search field over a 2-column grid of square pastel
/// tiles.
///
/// The kit draws one flat grid under one title. Real stores can group their
/// categories, so a store with a single group renders exactly the kit's flat
/// grid and one with several gets a section header per group — the grid
/// itself is identical either way (spec sheet §11).
class CategoriesScreen extends BaseScreen {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends BaseScreenState<CategoriesScreen> {
  String get _storeId => context.read<ActiveStoreCubit>().state!.storeId;

  void _openCategoryDetails(CategoryEntity category) => context.push(
    AppRoutes.categoryDetailsPath(category.id, category.name),
    extra: _storeId,
  );

  void _openSearch() => context.push(AppRoutes.search, extra: _storeId);

  @override
  SystemUiOverlayStyle? overlayStyle(BuildContext context) =>
      BaseScreenState.themedStatusIcons(context);

  @override
  Widget body(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: BlocConsumer<CategoriesBloc, CategoriesState>(
        listener: (context, state) {
          if (state case CategoriesLoaded(refreshFailed: true)) {
            showSnackBar(GrofastValueConst.categoriesLoadErrorMessage);
          }
        },
        builder: (context, state) => GrofastScreenBody(
          // A tab root has nowhere to pop back to, so the header carries the
          // search field alone. The kit docks a filter square beside it; a
          // category list has no axis to filter on, so it isn't reproduced
          // (spec sheet §11).
          headerRow: GrofastSearchField(
            hint: GrofastValueConst.searchHint,
            onTap: _openSearch,
          ),
          gap: AppSpacing.xl4,
          // The nav bar below reserves its own height (and the device inset
          // with it), so this is breathing room only.
          bottomInset: AppSpacing.xl2,
          body: GrofastSwitcher(
            child: switch (state) {
              CategoriesLoading() => const _CategoriesSkeletonBody(),
              CategoriesError(:final message) => GrofastErrorView(
                message: message,
                onRetry: () => context.read<CategoriesBloc>().add(
                  const CategoriesEvent.started(),
                ),
              ),
              CategoriesLoaded(:final categories)
                  when categories.groups.every((g) => g.categories.isEmpty) =>
                const GrofastEmptyState(
                  icon: Icons.grid_view_rounded,
                  title: GrofastValueConst.categoriesEmptyTitle,
                  subtitle: GrofastValueConst.categoriesEmptySubtitle,
                ),
              CategoriesLoaded(:final categories) => _CategoriesContent(
                groups: categories.groups,
                onCategoryTap: _openCategoryDetails,
              ),
            },
          ),
        ),
      ),
    );
  }
}

class _CategoriesContent extends StatelessWidget {
  final List<CategoryGroupEntity> groups;
  final ValueChanged<CategoryEntity> onCategoryTap;

  const _CategoriesContent({required this.groups, required this.onCategoryTap});

  @override
  Widget build(BuildContext context) {
    final isSingleGroup = groups.length == 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GrofastSectionHeader(title: GrofastValueConst.allCategoriesTitle),
        const SizedBox(height: AppSpacing.xl2),
        for (final group in groups) ...[
          if (!isSingleGroup && group.categories.isNotEmpty) ...[
            GrofastSectionHeader(title: group.name),
            const SizedBox(height: AppSpacing.lg),
          ],
          _CategoryGrid(
            categories: group.categories,
            onCategoryTap: onCategoryTap,
          ),
          const SizedBox(height: AppSpacing.xl4),
        ],
      ],
    );
  }
}

/// The kit's 2-column square grid. Non-lazy on purpose: a store's category
/// list is a handful of tiles, and the whole page scrolls as one.
class _CategoryGrid extends StatelessWidget {
  final List<CategoryEntity> categories;
  final ValueChanged<CategoryEntity> onCategoryTap;

  const _CategoryGrid({required this.categories, required this.onCategoryTap});

  @override
  Widget build(BuildContext context) => GridView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    padding: EdgeInsets.zero,
    itemCount: categories.length,
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      crossAxisSpacing: GrofastDimenConst.gridColumnGap,
      mainAxisSpacing: GrofastDimenConst.gridRowGap,
      childAspectRatio: GrofastDimenConst.categoryGridAspectRatio,
    ),
    itemBuilder: (context, index) => GrofastCategoryTile(
      category: categories[index],
      index: index,
      onTap: () => onCategoryTap(categories[index]),
    ),
  );
}

/// First-load skeleton — the same square grid at the same aspect ratio, so
/// nothing reflows when the tiles land.
class _CategoriesSkeletonBody extends StatelessWidget {
  const _CategoriesSkeletonBody();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const ShimmerBox(width: 180, height: AppSpacing.xl5),
      const SizedBox(height: AppSpacing.xl2),
      GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        itemCount: 6,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: GrofastDimenConst.gridColumnGap,
          mainAxisSpacing: GrofastDimenConst.gridRowGap,
          childAspectRatio: GrofastDimenConst.categoryGridAspectRatio,
        ),
        itemBuilder: (context, index) =>
            const GrofastCardSkeleton(height: double.infinity),
      ),
    ],
  );
}
