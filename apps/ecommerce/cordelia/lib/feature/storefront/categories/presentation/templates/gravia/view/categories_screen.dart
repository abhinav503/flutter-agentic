import 'package:cordelia/feature/storefront/active_store/presentation/active_store_capture.dart';
import 'package:cordelia/constants/app_routes.dart';
import 'package:cordelia/templates/gravia/constants/gravia_image_const.dart';
import 'package:cordelia/templates/gravia/constants/gravia_dimen_const.dart';
import 'package:cordelia/templates/gravia/constants/gravia_value_const.dart';
import 'package:cordelia/templates/gravia/widgets/gravia_glass_icon_button.dart';
import 'package:cordelia/templates/gravia/widgets/gravia_hero_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:cordelia/templates/gravia/widgets/gravia_switcher.dart';
import 'package:core/core/base/base_screen.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/blocks/collapsing_header_sheet.dart';
import 'package:core/core/ui/molecules/error_view.dart';

import '../../../../../home/domain/entities/category_entity.dart';
import '../../../bloc/categories_bloc.dart';
import '../widgets/categories_skeleton_body.dart';
import '../widgets/category_group_section.dart';

class CategoriesScreen extends BaseScreen {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends BaseScreenState<CategoriesScreen>
    with ActiveStoreCapture {
  void _openCategoryDetails(CategoryEntity category) => context.push(
    AppRoutes.categoryDetailsPath(category.id, category.name),
    extra: storeId,
  );

  Widget _header() => GraviaHeroHeader.page(
    title: GraviaValueConst.categoriesPageTitle,
    trailing: GraviaGlassIconButton(
      asset: GraviaImageConst.search,
      onTap: () => context.push(AppRoutes.search, extra: storeId),
    ),
  );

  @override
  SystemUiOverlayStyle? overlayStyle(BuildContext context) =>
      BaseScreenState.lightStatusIcons;

  @override
  Widget body(BuildContext context) {
    return BlocConsumer<CategoriesBloc, CategoriesState>(
      listener: (context, state) {
        if (state case CategoriesError(:final message)) showSnackBar(message);
        // Warm-start background refresh failed — cached content is still
        // showing, so this is a toast, not an error view.
        if (state case CategoriesLoaded(refreshFailed: true)) {
          showSnackBar(GraviaValueConst.categoriesRefreshFailedMessage);
        }
      },
      builder: (context, state) => GraviaSwitcher(
        child: switch (state) {
          CategoriesLoading() => CollapsingHeaderSheet(
            key: const ValueKey('loading'),
            initialHeaderHeight: GraviaDimenConst.headerHeightRegular,
            header: _header(),
            body: const CategoriesSkeletonBody(),
          ),
          CategoriesError() => SafeArea(
            key: const ValueKey('error'),
            child: ErrorView(
              message: GraviaValueConst.categoriesLoadErrorMessage,
              onRetry: () => context.read<CategoriesBloc>().add(
                const CategoriesEvent.started(),
              ),
            ),
          ),
          CategoriesLoaded(:final categories) => CollapsingHeaderSheet(
            key: const ValueKey('loaded'),
            initialHeaderHeight: GraviaDimenConst.headerHeightRegular,
            header: _header(),
            body: Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl4),
              child: Column(
                children: [
                  for (var i = 0; i < categories.groups.length; i++) ...[
                    if (i > 0) const SizedBox(height: AppSpacing.xl4),
                    CategoryGroupSection(
                      group: categories.groups[i],
                      onCategoryTap: _openCategoryDetails,
                    ),
                  ],
                ],
              ),
            ),
          ),
        },
      ),
    );
  }
}
