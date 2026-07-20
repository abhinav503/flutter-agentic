import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:core/core/base/base_screen.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/blocks/collapsing_header_sheet.dart';
import 'package:core/core/ui/molecules/error_view.dart';

import 'package:gravia/constants/app_routes.dart';
import 'package:gravia/constants/image_const.dart';
import 'package:gravia/constants/value_const.dart';
import 'package:gravia/widgets/gravia_glass_icon_button.dart';
import 'package:gravia/widgets/gravia_hero_header.dart';

import '../../../home/domain/entities/category_entity.dart';
import '../bloc/categories_bloc.dart';
import '../widgets/categories_skeleton_body.dart';
import '../widgets/category_group_section.dart';

class CategoriesScreen extends BaseScreen {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends BaseScreenState<CategoriesScreen> {
  void _openCategoryDetails(CategoryEntity category) =>
      context.push(AppRoutes.categoryDetailsPath(category.id, category.name));

  Widget _header() => GraviaHeroHeader.page(
    title: ValueConst.categoriesPageTitle,
    trailing: GraviaGlassIconButton(
      asset: ImageConst.search,
      onTap: () => context.push(AppRoutes.search),
    ),
  );

  @override
  Widget body(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: BlocConsumer<CategoriesBloc, CategoriesState>(
        listener: (context, state) {
          if (state case CategoriesError(:final message)) showSnackBar(message);
          // Warm-start background refresh failed — cached content is still
          // showing, so this is a toast, not an error view.
          if (state case CategoriesLoaded(refreshFailed: true)) {
            showSnackBar(ValueConst.categoriesRefreshFailedMessage);
          }
        },
        builder: (context, state) => AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: switch (state) {
            CategoriesLoading() => CollapsingHeaderSheet(
              key: const ValueKey('loading'),
              initialHeaderHeight: 130,
              header: _header(),
              body: const CategoriesSkeletonBody(),
            ),
            CategoriesError() => SafeArea(
              key: const ValueKey('error'),
              child: ErrorView(
                message: ValueConst.categoriesLoadErrorMessage,
                onRetry: () => context.read<CategoriesBloc>().add(
                  const CategoriesEvent.started(),
                ),
              ),
            ),
            CategoriesLoaded(:final categories) => CollapsingHeaderSheet(
              key: const ValueKey('loaded'),
              initialHeaderHeight: 130,
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
      ),
    );
  }
}
