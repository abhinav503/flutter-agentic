import 'package:flutter/material.dart';

import 'package:core/core/base/base_page.dart';
import 'package:cordelia/feature/storefront/presentation/chromeless_page.dart';

import '../../../bloc/product_details_bloc_provider.dart';
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

class _ProductDetailsPageState extends BasePageState<ProductDetailsPage>
    with ChromelessStorefrontPage {
  @override
  Widget buildBody(BuildContext context) => productDetailsBlocProvider(
    storeId: widget.storeId,
    productId: widget.productId,
    child: ProductDetailsScreen(storeId: widget.storeId),
  );
}
