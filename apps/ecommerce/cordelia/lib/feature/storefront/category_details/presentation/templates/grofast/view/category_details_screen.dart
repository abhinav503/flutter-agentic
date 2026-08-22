import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:core/core/base/base_screen.dart';
import 'package:core/core/theme/app_spacing.dart';

import 'package:cordelia/constants/app_routes.dart';
import 'package:cordelia/feature/auth/presentation/sign_in_gate.dart';
import 'package:cordelia/feature/storefront/home/domain/entities/product_entity.dart';
import 'package:cordelia/templates/grofast/constants/grofast_image_const.dart';
import 'package:cordelia/templates/grofast/constants/grofast_text_style_const.dart';
import 'package:cordelia/templates/grofast/constants/grofast_value_const.dart';
import 'package:cordelia/templates/grofast/widgets/grofast_filter_sheet_content.dart';
import 'package:cordelia/templates/grofast/widgets/grofast_header_row.dart';
import 'package:cordelia/templates/grofast/widgets/grofast_product_grid.dart';
import 'package:cordelia/templates/grofast/widgets/grofast_screen_body.dart';
import 'package:cordelia/templates/grofast/widgets/grofast_search_field.dart';
import 'package:cordelia/templates/grofast/widgets/grofast_sheet.dart';
import 'package:cordelia/templates/grofast/widgets/grofast_state_views.dart';

import '../widgets/category_details_skeleton_body.dart';
import '../../../bloc/category_details_bloc.dart';

/// `grofast` template's Category Details (kit frame `119:937`) — a
/// tap-to-search field with the filter square beside it, the category name
/// over a result count, and the pack's staggered grid.
///
/// The kit's category rail across the top isn't reproduced: it would have to
/// re-fetch the store's whole category list to render a control that only
/// navigates sideways, and the shared `CategoryDetailsBloc` is scoped to the
/// one category it was pushed with (spec sheet §11).
class CategoryDetailsScreen extends BaseScreen {
  final String storeId;
  final String categoryName;

  const CategoryDetailsScreen({
    super.key,
    required this.storeId,
    required this.categoryName,
  });

  @override
  State<CategoryDetailsScreen> createState() => _CategoryDetailsScreenState();
}

class _CategoryDetailsScreenState
    extends BaseScreenState<CategoryDetailsScreen> {
  void _openProductDetails(ProductEntity product) => context.push(
    AppRoutes.productDetailsPath(product.id),
    extra: widget.storeId,
  );

  void _openSearch() => context.push(AppRoutes.search, extra: widget.storeId);

  Future<void> _addToBag(ProductEntity product) async {
    if (!await context.addToCartOrSignIn(product, 1) || !mounted) return;
    showSnackBar(GrofastValueConst.addedToBagMessage(product.name, 1));
  }

  void _openFilterSheet(CategoryDetailsLoaded state) {
    final bloc = context.read<CategoryDetailsBloc>();

    showGrofastSheet<void>(
      child: GrofastFilterSheetContent(
        initialSort: state.sort,
        initialPriceFilter: state.priceFilter,
        onApply: (sort, priceFilter) => bloc
          ..add(CategoryDetailsEvent.sortChanged(sort: sort))
          ..add(
            CategoryDetailsEvent.priceFilterChanged(priceFilter: priceFilter),
          ),
      ),
    );
  }

  @override
  SystemUiOverlayStyle? overlayStyle(BuildContext context) =>
      BaseScreenState.themedStatusIcons(context);

  @override
  Widget body(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: BlocBuilder<CategoryDetailsBloc, CategoryDetailsState>(
        builder: (context, state) {
          // Only the loaded state can open a filter sheet — there is nothing
          // to filter until the products are in.
          final loaded = switch (state) {
            CategoryDetailsLoaded() => state,
            _ => null,
          };

          return GrofastScreenBody(
            // The header carries the back control, so it docks like every
            // other back-button screen — a custom headerRow doesn't auto-pin.
            pinnedHeader: true,
            headerRow: Column(
              children: [
                GrofastHeaderRow(
                  trailing: GrofastBagAction(storeId: widget.storeId),
                ),
                const SizedBox(height: AppSpacing.xl2),
                // No `heroTag`: the flight is Home <-> Search only. Sharing
                // the tag here would also pair this bar with Home's during
                // the Home -> Category Details push, flying it on a
                // transition the kit draws as a plain page change (same call
                // dailymart's Category Details makes).
                GrofastSearchField(
                  hint: GrofastValueConst.searchHint,
                  onTap: _openSearch,
                  trailing: GrofastSquareAction(
                    asset: GrofastImageConst.filter,
                    onTap: loaded == null
                        ? _openSearch
                        : () => _openFilterSheet(loaded),
                    tooltip: GrofastValueConst.sortByTitle,
                  ),
                ),
              ],
            ),
            gap: AppSpacing.xl4,
            body: GrofastSwitcher(
              child: switch (state) {
                CategoryDetailsLoading() =>
                  const GrofastCategoryDetailsSkeletonBody(),
                CategoryDetailsError(
                  :final message,
                  :final storeId,
                  :final categoryId,
                  :final categoryName,
                ) =>
                  GrofastErrorView(
                    message: message,
                    onRetry: () => context.read<CategoryDetailsBloc>().add(
                      CategoryDetailsEvent.started(
                        storeId: storeId,
                        categoryId: categoryId,
                        categoryName: categoryName,
                      ),
                    ),
                  ),
                CategoryDetailsLoaded() => _CategoryContent(
                  title: state.categoryName,
                  products: state.visibleProducts,
                  onProductTap: _openProductDetails,
                  onAddToBag: _addToBag,
                  onFavouriteToggle: (product) =>
                      context.toggleFavouriteOrSignIn(product),
                ),
              },
            ),
          );
        },
      ),
    );
  }
}

class _CategoryContent extends StatelessWidget {
  final String title;
  final List<ProductEntity> products;
  final ValueChanged<ProductEntity> onProductTap;
  final ValueChanged<ProductEntity> onAddToBag;
  final ValueChanged<ProductEntity> onFavouriteToggle;

  const _CategoryContent({
    required this.title,
    required this.products,
    required this.onProductTap,
    required this.onAddToBag,
    required this.onFavouriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    if (products.isEmpty) {
      return GrofastEmptyState(
        icon: Icons.local_grocery_store_outlined,
        title: GrofastValueConst.categoryDetailsEmptyTitle,
        subtitle: GrofastValueConst.categoryDetailsEmptySubtitle,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          GrofastValueConst.categoryProductsTitle(title),
          style: GrofastTextStyleConst.sectionBold(tt),
        ),
        const SizedBox(height: AppSpacing.xs3),
        Text(
          GrofastValueConst.resultsCountLabel(products.length),
          style: GrofastTextStyleConst.meta(
            tt,
          ).copyWith(color: cs.onSurfaceVariant),
        ),
        const SizedBox(height: AppSpacing.xl2),
        GrofastProductGrid(
          products: products,
          onAdd: onAddToBag,
          onProductTap: onProductTap,
          onFavouriteToggle: onFavouriteToggle,
        ),
      ],
    );
  }
}
