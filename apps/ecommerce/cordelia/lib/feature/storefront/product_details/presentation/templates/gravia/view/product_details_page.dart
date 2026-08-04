import 'package:flutter/material.dart';
import 'package:core/core/base/base_page.dart';
import '../../../bloc/product_details_bloc_provider.dart';
import 'product_details_screen.dart';

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
  // No AppBar: the screen renders its own coloured hero header (back +
  // favourite glass controls over the photo carousel) as part of the body,
  // per the pack's "coloured header canvas" composition — a generic top bar
  // on top of it would double up, same reasoning as Home/Search.
  @override
  Widget buildBody(BuildContext context) => productDetailsBlocProvider(
    storeId: widget.storeId,
    productId: widget.productId,
    child: ProductDetailsScreen(storeId: widget.storeId),
  );
}
