import 'package:flutter/material.dart';

import 'package:core/core/base/base_page.dart';

import '../../../../../reviews/presentation/bloc/product_reviews_bloc_provider.dart';
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
    with ChromelessPage {
  @override
  // The reviews bloc wraps the screen, not just the reviews section: the
  // write sheet is opened from the screen's own state, which has to be under
  // the provider to dispatch. It opens empty and the screen seeds it from
  // the details payload it is already loading.
  Widget buildBody(BuildContext context) => productDetailsBlocProvider(
    storeId: widget.storeId,
    productId: widget.productId,
    child: productReviewsBlocProvider(
      storeId: widget.storeId,
      productId: widget.productId,
      child: ProductDetailsScreen(storeId: widget.storeId),
    ),
  );
}
