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
    sizeValue: e.sizeValue,
    unitPrice: e.unitPrice,
    originalUnitPrice: e.originalUnitPrice,
  );

  CartItemEntity toEntity() => CartItemEntity(
    product: product.toEntity(),
    quantity: quantity,
    sizeValue: sizeValue,
    unitPrice: unitPrice,
    originalUnitPrice: originalUnitPrice,
  );
}
