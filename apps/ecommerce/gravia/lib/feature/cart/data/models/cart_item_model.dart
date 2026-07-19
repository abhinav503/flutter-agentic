import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../home/data/models/product_model.dart';
import '../../domain/entities/cart_item_entity.dart';

part 'cart_item_model.freezed.dart';
part 'cart_item_model.g.dart';

/// Wire shape of one entry in the cart GET/PUT `items[]` response — the
/// server always joins the stored `{productId, quantity}` against live
/// product data, so the response carries a full product, not just its id.
/// The PUT *request* body is the inverse shape (`{productId, quantity}`);
/// that's built inline in `CartRemoteDataSourceImpl` since it's a one-off
/// request payload, not a DTO ever parsed back.
@freezed
abstract class CartItemModel with _$CartItemModel {
  const CartItemModel._();

  const factory CartItemModel({
    required ProductModel product,
    required int quantity,
  }) = _CartItemModel;

  factory CartItemModel.fromJson(Map<String, dynamic> json) =>
      _$CartItemModelFromJson(json);

  factory CartItemModel.fromEntity(CartItemEntity e) => CartItemModel(
    product: ProductModel.fromEntity(e.product),
    quantity: e.quantity,
  );

  CartItemEntity toEntity() =>
      CartItemEntity(product: product.toEntity(), quantity: quantity);
}
