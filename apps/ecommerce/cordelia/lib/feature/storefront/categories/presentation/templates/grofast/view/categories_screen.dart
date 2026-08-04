import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:core/core/base/base_screen.dart';
import 'package:core/core/theme/app_spacing.dart';

import 'package:cordelia/constants/app_routes.dart';
import 'package:cordelia/feature/storefront/active_store/presentation/cubit/active_store_cubit.dart';
import 'package:cordelia/templates/grofast/constants/grofast_dimen_const.dart';
import 'package:cordelia/templates/grofast/constants/grofast_value_const.dart';
import 'package:cordelia/templates/grofast/widgets/grofast_category_tile.dart';
import 'package:cordelia/templates/grofast/widgets/grofast_screen_body.dart';
import 'package:cordelia/templates/grofast/widgets/grofast_search_field.dart';
import 'package:cordelia/templates/grofast/widgets/grofast_section_header.dart';
import 'package:cordelia/templates/grofast/widgets/grofast_state_views.dart';

import '../../../../../home/domain/entities/category_entity.dart';
import '../../../../domain/entities/category_group_entity.dart';
import '../widgets/categories_skeleton_body.dart';
import '../../../bloc/categories_bloc.dart';

/// `grofast` template's Categories tab — the kit's "All Categories" frame
/// (`119:796`): a tap-to-search field over a 2-column grid of square pastel
/// tiles.
///
/// The kit draws one flat grid under an "All Categories" title. That title
/// isn't reproduced: the tab is already named in the nav bar and its whole
/// body is the grid, so the line only pushed the tiles down. Real stores can
/// group their categories, so a store with a single group renders the kit's
/// flat grid and one with several gets a section header per group — those
/// headers name something the screen can't otherwise tell you, which is why
/// they stay (spec sheet §11).
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
          // The shell runs `extendBody`, so this scroll view reaches under
          // the nav: clear the bar, and let the last row pass behind the
          // dome — that content is what makes the dome visible.
          bottomInset: GrofastDimenConst.navScrollInset(context),
          body: GrofastSwitcher(
            child: switch (state) {
              CategoriesLoading() => const GrofastCategoriesSkeletonBody(),
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
        // No page title: the search field is the header, and a tab whose
        // whole body is the category grid doesn't need a line naming it.
        // Group headers below still appear when a store splits its catalog.
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
