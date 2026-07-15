import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:core/core/base/base_page.dart';

import 'package:gravia/di/injection_container.dart';

import '../bloc/product_details_bloc.dart';
import 'product_details_screen.dart';

class ProductDetailsPage extends BasePage {
  final String productId;

  const ProductDetailsPage({super.key, required this.productId});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends BasePageState<ProductDetailsPage> {
  // No AppBar: the screen renders its own coloured hero header (back +
  // favourite glass controls over the photo carousel) as part of the body,
  // per the pack's "coloured header canvas" composition — a generic top bar
  // on top of it would double up, same reasoning as Home/Search.
  @override
  Widget buildBody(BuildContext context) => BlocProvider(
    create: (_) => ProductDetailsBloc(getProductDetailsUseCase: sl())
      ..add(ProductDetailsEvent.started(productId: widget.productId)),
    child: const ProductDetailsScreen(),
  );
}
