import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:cordelia/constants/app_routes.dart';
import 'package:cordelia/feature/auth/presentation/sign_in_gate.dart';

import '../../home/domain/entities/product_entity.dart';
import '../../home/domain/entities/product_variant_entity.dart';
import '../domain/entities/product_detail_entity.dart';
import 'bloc/product_details_bloc.dart';

/// One option row on Product Details: its name and the values a shopper can
/// pick, each with whether a variant exists for it *given the other rows'
/// current picks* — a Colour that no variant offers in the chosen Size is
/// shown, but not pickable.
class OptionAxis {
  final int index;
  final String name;
  final List<OptionValue> values;
  const OptionAxis({
    required this.index,
    required this.name,
    required this.values,
  });
}

class OptionValue {
  final String value;
  final bool selected;
  final bool available;
  const OptionValue({
    required this.value,
    required this.selected,
    required this.available,
  });
}

/// The screen logic every template's Product Details repeats identically —
/// add-to-cart, variant selection, self-push navigation, and load retry.
/// Quantity state lives in the separate `QuantitySelection` mixin (which the
/// add-to-cart sheets also use), so hosts declare
/// `with QuantitySelection, ProductDetailsActions`. Only the layouts differ
/// per pack, so this lives once beside the shared bloc, same split as
/// `SelectedAddressLabelState`.
///
/// Selection is per option axis (Size, Colour, …), resolved to the one
/// variant that matches every pick. A pack-size product is the one-axis
/// case ("Size": 500 g / 1 kg), so the same rows serve a grocery store and
/// an apparel one.
mixin ProductDetailsActions<T extends StatefulWidget> on State<T> {
  /// The store this details screen is scoped to — the host's routing param.
  String get storeId;

  /// The value picked per axis, or null where nothing was tapped yet — the
  /// effective pick then defaults through [defaultVariant] so the page
  /// opens priced the same as the card that led here.
  final Map<int, String> _picked = {};

  // Tracked on its own: a map keeps a re-assigned key's original position,
  // so "the axis the shopper just changed" can't be read off its order.
  int? _lastPickedAxis;

  void selectOption(int axis, String value) => setState(() {
    _picked[axis] = value;
    _lastPickedAxis = axis;
  });

  /// The variant the page opens on: the product's own pack when one of the
  /// variants is it, else the cheapest unit still in stock, else the first.
  ProductVariantEntity? defaultVariant(ProductDetailEntity detail) {
    final product = detail.product;
    if (!product.hasVariants) return null;
    final own = product.variants.where(
      (v) => v.packSize > 0 && v.packSize == product.unitValue,
    );
    if (own.isNotEmpty) return own.first;
    final inStock = product.variants.where((v) => !v.isOutOfStock).toList();
    final pool = inStock.isEmpty ? product.variants : inStock;
    return pool.reduce((a, b) => b.price < a.price ? b : a);
  }

  /// The effective pick for every axis — what was tapped, or the default
  /// variant's value for that axis.
  List<String> effectivePicks(ProductDetailEntity detail) {
    final fallback = defaultVariant(detail);
    return [
      for (var axis = 0; axis < detail.product.optionNames.length; axis++)
        _picked[axis] ??
            (fallback == null || axis >= fallback.options.length
                ? ''
                : fallback.options[axis]),
    ];
  }

  /// Null only when the product has no variants at all.
  ProductVariantEntity? selectedVariant(ProductDetailEntity detail) {
    final product = detail.product;
    if (!product.hasVariants) return null;
    final picks = effectivePicks(detail);
    for (final v in product.variants) {
      if (_matches(v, picks)) return v;
    }
    // The picks name a combination nobody sells (the shopper changed one
    // axis and the other no longer fits): keep the axis they just changed
    // and resolve the rest to any variant that offers it, so the price and
    // stock on screen are always a real unit's.
    final lastAxis = _lastPickedAxis ?? -1;
    if (lastAxis >= 0) {
      for (final v in product.variants) {
        if (lastAxis < v.options.length &&
            v.options[lastAxis] == picks[lastAxis]) {
          return v;
        }
      }
    }
    return defaultVariant(detail);
  }

  bool _matches(ProductVariantEntity v, List<String> picks) {
    for (var i = 0; i < picks.length; i++) {
      if (i >= v.options.length || v.options[i] != picks[i]) return false;
    }
    return true;
  }

  /// The rows to render, with each value's availability judged against the
  /// other axes' current picks.
  List<OptionAxis> optionAxes(ProductDetailEntity detail) {
    final product = detail.product;
    if (!product.hasVariants) return const [];
    final selected = selectedVariant(detail);
    final picks = selected?.options ?? effectivePicks(detail);
    return [
      for (var axis = 0; axis < product.optionNames.length; axis++)
        OptionAxis(
          index: axis,
          name: product.optionNames[axis],
          values: [
            for (final value in product.optionValues(axis))
              OptionValue(
                value: value,
                selected: axis < picks.length && picks[axis] == value,
                available: product.variants.any(
                  (v) =>
                      axis < v.options.length &&
                      v.options[axis] == value &&
                      !v.isOutOfStock &&
                      _matchesExcept(v, picks, axis),
                ),
              ),
          ],
        ),
    ];
  }

  bool _matchesExcept(ProductVariantEntity v, List<String> picks, int axis) {
    for (var i = 0; i < picks.length; i++) {
      if (i == axis) continue;
      if (i >= v.options.length || v.options[i] != picks[i]) return false;
    }
    return true;
  }

  // --- what the rest of the page reads off the selection ---------------

  double unitPrice(ProductDetailEntity detail) =>
      selectedVariant(detail)?.price ?? detail.product.price;

  double originalUnitPrice(ProductDetailEntity detail) =>
      selectedVariant(detail)?.originalPrice ?? detail.product.originalPrice;

  double discountPercentage(ProductDetailEntity detail) =>
      selectedVariant(detail)?.discountPercentage ??
      detail.product.discountPercentage;

  /// The unit's own stock on a product with variants, the product's otherwise.
  int? selectedStock(ProductDetailEntity detail) {
    final v = selectedVariant(detail);
    return v == null ? detail.product.stock : v.stock;
  }

  bool isSelectedOutOfStock(ProductDetailEntity detail) {
    final v = selectedVariant(detail);
    return v == null ? detail.product.isOutOfStock : v.isOutOfStock;
  }

  bool isSelectedLowStock(ProductDetailEntity detail) {
    final v = selectedVariant(detail);
    return v == null ? detail.product.isLowStock : v.isLowStock;
  }

  int? selectedPurchaseLimit(ProductDetailEntity detail) {
    final v = selectedVariant(detail);
    return v == null ? detail.product.purchaseLimit : v.purchaseLimit;
  }

  /// "500 g" for a pack variant, the product's own pack otherwise — the
  /// weight slot every template prints beside the price.
  String packLabel(ProductDetailEntity detail, String Function(double) format) {
    final v = selectedVariant(detail);
    if (v != null && v.packSize > 0) return format(v.packSize);
    if (v != null) return v.label;
    return format(detail.product.unitValue);
  }

  Future<bool> addToCart(ProductEntity product, int qty) =>
      context.addToCartOrSignIn(product, qty);

  /// Add-to-cart for the details CTA — carries the selected variant so the
  /// cart line is that unit, priced and stock-checked as such; a simple
  /// product adds itself, same as a card's quick-add.
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
      variantId: variant.id,
      variantLabel: variant.label,
      available: variant.purchaseLimit,
      sizeValue: variant.packSize > 0 ? variant.packSize : null,
      unitPrice: variant.price,
      originalUnitPrice: variant.originalPrice,
    );
  }

  /// Pushes a new copy of this same route for the tapped similar product —
  /// each detail screen owns its own quantity/variant selection, so a fresh
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
