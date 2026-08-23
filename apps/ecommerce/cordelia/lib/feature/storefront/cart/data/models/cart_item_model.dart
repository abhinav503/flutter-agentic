import 'package:cordelia/feature/storefront/home/data/models/product_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/cart_item_entity.dart';

part 'cart_item_model.freezed.dart';
part 'cart_item_model.g.dart';

/// Wire shape of one entry in the cart GET/PUT `items[]` response — the
/// server always joins the stored `{productId, sizeValue, quantity}` against
/// live product data, so the response carries a full product (plus the
/// resolved per-size prices when a size was selected), not just ids.
/// The PUT *request* body is the inverse shape (`{productId, sizeValue,
/// quantity}`); that's built inline in `CartRemoteDataSourceImpl` since it's
/// a one-off request payload, not a DTO ever parsed back.
@freezed
abstract class CartItemModel with _$CartItemModel {
  const CartItemModel._();

  const factory CartItemModel({
    required ProductModel product,
    required int quantity,
    // Absent ("" from the server, or missing from a pre-variant backend) =
    // a simple product's line.
    @JsonKey(name: 'variant_id') @Default('') String variantId,
    @JsonKey(name: 'variant_label') @Default('') String variantLabel,
    int? available,
    // All three absent for a base-pack line (and on every pre-variant
    // response) — the entity falls back to the product's own price/size.
    @JsonKey(name: 'size_value') double? sizeValue,
    @JsonKey(name: 'unit_price') double? unitPrice,
    @JsonKey(name: 'original_unit_price') double? originalUnitPrice,
  }) = _CartItemModel;

  factory CartItemModel.fromJson(Map<String, dynamic> json) =>
      _$CartItemModelFromJson(json);

  factory CartItemModel.fromEntity(CartItemEntity e) => CartItemModel(
    product: ProductModel.fromEntity(e.product),
    quantity: e.quantity,
    variantId: e.variantId ?? '',
    variantLabel: e.variantLabel,
    available: e.available,
    sizeValue: e.sizeValue,
    unitPrice: e.unitPrice,
    originalUnitPrice: e.originalUnitPrice,
  );

  CartItemEntity toEntity() => CartItemEntity(
    product: product.toEntity(),
    quantity: quantity,
    variantId: variantId.isEmpty ? null : variantId,
    variantLabel: variantLabel,
    available: available,
    sizeValue: sizeValue,
    unitPrice: unitPrice,
    originalUnitPrice: originalUnitPrice,
  );
}
