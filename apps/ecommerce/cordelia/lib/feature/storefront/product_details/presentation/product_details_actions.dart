import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:cordelia/constants/app_routes.dart';
import 'package:cordelia/feature/auth/presentation/sign_in_gate.dart';

import '../../home/domain/entities/product_entity.dart';
import '../domain/entities/product_detail_entity.dart';
import '../domain/entities/size_variant_entity.dart';
import 'bloc/product_details_bloc.dart';

/// The screen logic every template's Product Details repeats identically —
/// add-to-cart, size selection, self-push navigation, and load retry.
/// Quantity state lives in the separate `QuantitySelection` mixin (which the
/// add-to-cart sheets also use), so hosts declare
/// `with QuantitySelection, ProductDetailsActions`. Only the layouts differ
/// per pack, so this lives once beside the shared bloc, same split as
/// `SelectedAddressLabelState`.
mixin ProductDetailsActions<T extends StatefulWidget> on State<T> {
  /// The store this details screen is scoped to — the host's routing param.
  String get storeId;

  /// The tapped "Select QTY" chip, or null before any tap — the effective
  /// selection then defaults through [selectedVariant] to the variant
  /// matching the product's own pack, so the page opens priced the same as
  /// the card that led here.
  int? selectedSizeIndex;

  void selectSize(int index) => setState(() => selectedSizeIndex = index);

  int effectiveSizeIndex(ProductDetailEntity detail) {
    final tapped = selectedSizeIndex;
    if (tapped != null && tapped < detail.sizeVariants.length) return tapped;
    final base = detail.sizeVariants.indexWhere(
      (v) => v.value == detail.product.unitValue,
    );
    return base == -1 ? 0 : base;
  }

  /// Null only when the product has no size picker at all.
  SizeVariantEntity? selectedVariant(ProductDetailEntity detail) =>
      detail.sizeVariants.isEmpty
      ? null
      : detail.sizeVariants[effectiveSizeIndex(detail)];

  Future<bool> addToCart(ProductEntity product, int qty) =>
      context.addToCartOrSignIn(product, qty);

  /// Add-to-cart for the details CTA — carries the selected size so the cart
  /// line is priced by its variant; a size-less product adds the base pack,
  /// same as a card's quick-add.
  ///
  /// False when a guest backed out of the gate — the caller's "added"
  /// snackbar and quantity reset both hang off this, so neither fires for
  /// a line that never went in.
  Future<bool> addSelectedToCart(ProductDetailEntity detail, int qty) {
    final variant = selectedVariant(detail);
    if (variant == null) {
      return addToCart(detail.product, qty);
    }
    return context.addToCartOrSignIn(
      detail.product,
      qty,
      sizeValue: variant.value,
      unitPrice: variant.price,
      originalUnitPrice: variant.originalPrice,
    );
  }

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
