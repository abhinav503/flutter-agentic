import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:core/core/base/base_page.dart';

import 'package:gravia/di/injection_container.dart';

import '../bloc/category_details_bloc.dart';
import 'category_details_screen.dart';

class CategoryDetailsPage extends BasePage {
  final String categoryId;
  final String categoryName;

  const CategoryDetailsPage({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  State<CategoryDetailsPage> createState() => _CategoryDetailsPageState();
}

class _CategoryDetailsPageState extends BasePageState<CategoryDetailsPage> {
  // No AppBar: the screen renders its own coloured hero header (back +
  // search glass controls + filter chip row) as part of the body, per the
  // pack's "coloured header canvas" composition — same reasoning as
  // Home/Search/Product Details.
  @override
  Widget buildBody(BuildContext context) => BlocProvider(
    create: (_) => CategoryDetailsBloc(getCategoryDetailsUseCase: sl())
      ..add(
        CategoryDetailsEvent.started(
          categoryId: widget.categoryId,
          categoryName: widget.categoryName,
        ),
      ),
    child: CategoryDetailsScreen(categoryName: widget.categoryName),
  );
}
