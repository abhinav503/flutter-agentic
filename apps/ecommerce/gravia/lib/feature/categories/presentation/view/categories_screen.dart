import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:core/core/base/base_screen.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/loading_indicator.dart';
import 'package:core/core/ui/blocks/collapsing_header_sheet.dart';
import 'package:core/core/ui/molecules/error_view.dart';

import 'package:gravia/constants/app_routes.dart';
import 'package:gravia/constants/value_const.dart';

import '../../../home/domain/entities/category_entity.dart';
import '../bloc/categories_bloc.dart';
import '../widgets/categories_hero_header.dart';
import '../widgets/category_group_section.dart';

class CategoriesScreen extends BaseScreen {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends BaseScreenState<CategoriesScreen> {
  void _openCategoryDetails(CategoryEntity category) => context.push(
    AppRoutes.categoryDetailsPath(category.id, category.name),
  );

  @override
  Widget body(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: BlocConsumer<CategoriesBloc, CategoriesState>(
        listener: (context, state) {
          if (state case CategoriesError(:final message)) showSnackBar(message);
        },
        builder: (context, state) => switch (state) {
          CategoriesLoading() => Container(
            color: cs.primary,
            child: const SafeArea(child: Center(child: LoadingIndicator())),
          ),
          CategoriesError() => SafeArea(
            child: ErrorView(
              message: ValueConst.categoriesLoadErrorMessage,
              onRetry: () =>
                  context.read<CategoriesBloc>().add(const CategoriesEvent.started()),
            ),
          ),
          CategoriesLoaded(:final categories) => CollapsingHeaderSheet(
            initialHeaderHeight: 130,
            header: CategoriesHeroHeader(
              onSearchTap: () => context.push(AppRoutes.search),
            ),
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
