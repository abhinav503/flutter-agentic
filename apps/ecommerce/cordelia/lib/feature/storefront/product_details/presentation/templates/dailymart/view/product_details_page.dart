import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:core/core/base/base_page.dart';

import 'package:cordelia/di/injection_container.dart';

import '../../../bloc/product_details_bloc.dart';
import 'product_details_screen.dart';

/// `dailymart` template's Product Details entry — same shared
/// [ProductDetailsBloc] as the gravia template, different skin.
class ProductDetailsPage extends BasePage {
  final String storeId;
  final String productId;

  const ProductDetailsPage({
    super.key,
    required this.storeId,
    required this.productId,
  });

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends BasePageState<ProductDetailsPage> {
  @override
  Color? backgroundColor(BuildContext context) =>
      Theme.of(context).colorScheme.surface;

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) => null;

  @override
  Widget buildBody(BuildContext context) => BlocProvider(
    create: (_) => ProductDetailsBloc(getProductDetailsUseCase: sl())
      ..add(
        ProductDetailsEvent.started(
          storeId: widget.storeId,
          productId: widget.productId,
        ),
      ),
    child: ProductDetailsScreen(storeId: widget.storeId),
  );
}
