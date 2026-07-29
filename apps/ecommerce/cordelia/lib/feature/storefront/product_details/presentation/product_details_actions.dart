import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:cordelia/constants/app_routes.dart';
import 'package:cordelia/feature/storefront/cart/presentation/cubit/cart_cubit.dart';

import '../../home/domain/entities/product_entity.dart';
import 'bloc/product_details_bloc.dart';

/// The screen logic every template's Product Details repeats identically —
/// add-to-cart, self-push navigation, and load retry. Quantity state lives
/// in the separate `QuantitySelection` mixin (which the add-to-cart sheets
/// also use), so hosts declare `with QuantitySelection, ProductDetailsActions`.
/// Only the layouts differ per pack, so this lives once beside the shared
/// bloc, same split as `SelectedAddressLabelState`.
mixin ProductDetailsActions<T extends StatefulWidget> on State<T> {
  /// The store this details screen is scoped to — the host's routing param.
  String get storeId;

  void addToCart(ProductEntity product, int qty) =>
      context.read<CartCubit>().addToCart(product, qty);

  /// Pushes a new copy of this same route for the tapped similar product —
  /// each detail screen owns its own quantity/size selection, so a fresh
  /// route (not a replace) is the correct navigation, same as any other
  /// "product card in a list -> its own detail page" flow in this app.
  void openProductDetails(ProductEntity product) =>
      context.push(AppRoutes.productDetailsPath(product.id), extra: storeId);

  /// Re-dispatches the load from an error state's retry context.
  void retryLoad({required String storeId, required String productId}) =>
      context.read<ProductDetailsBloc>().add(
        ProductDetailsEvent.started(storeId: storeId, productId: productId),
      );
}
