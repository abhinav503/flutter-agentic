import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:core/core/base/base_page.dart';

import 'package:cordelia/di/injection_container.dart';

import '../../../bloc/category_details_bloc.dart';
import 'category_details_screen.dart';

class CategoryDetailsPage extends BasePage {
  final String storeId;
  final String categoryId;
  final String categoryName;

  const CategoryDetailsPage({
    super.key,
    required this.storeId,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  State<CategoryDetailsPage> createState() => _CategoryDetailsPageState();
}

class _CategoryDetailsPageState extends BasePageState<CategoryDetailsPage> {
  /// No app bar anywhere in this pack — the screen renders its own back disc
  /// and search bar as the first row of its body (spec sheet §8).
  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) => null;

  @override
  Color? backgroundColor(BuildContext context) =>
      Theme.of(context).colorScheme.surface;

  @override
  Widget buildBody(BuildContext context) => BlocProvider(
    create: (_) => CategoryDetailsBloc(getCategoryDetailsUseCase: sl())
      ..add(
        CategoryDetailsEvent.started(
          storeId: widget.storeId,
          categoryId: widget.categoryId,
          categoryName: widget.categoryName,
        ),
      ),
    child: CategoryDetailsScreen(
      storeId: widget.storeId,
      categoryName: widget.categoryName,
    ),
  );
}
