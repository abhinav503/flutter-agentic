import 'package:flutter/material.dart';
import 'package:core/core/base/base_page.dart';
import '../../../bloc/category_details_bloc_provider.dart';
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
  // No AppBar: the screen renders its own coloured hero header (back +
  // search glass controls + filter chip row) as part of the body, per the
  // pack's "coloured header canvas" composition — same reasoning as
  // Home/Search/Product Details.
  @override
  Widget buildBody(BuildContext context) => categoryDetailsBlocProvider(
    storeId: widget.storeId,
    categoryId: widget.categoryId,
    categoryName: widget.categoryName,
    child: CategoryDetailsScreen(
      storeId: widget.storeId,
      categoryName: widget.categoryName,
    ),
  );
}
