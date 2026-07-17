import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/order_line_item_entity.dart';

part 'order_line_item_model.freezed.dart';
part 'order_line_item_model.g.dart';

@freezed
abstract class OrderLineItemModel with _$OrderLineItemModel {
  const OrderLineItemModel._();

  const factory OrderLineItemModel({
    @JsonKey(name: 'product_name') required String productName,
    required String weight,
    required String image,
    required double price,
    required int quantity,
  }) = _OrderLineItemModel;

  factory OrderLineItemModel.fromJson(Map<String, dynamic> json) =>
      _$OrderLineItemModelFromJson(json);

  factory OrderLineItemModel.fromEntity(OrderLineItemEntity e) =>
      OrderLineItemModel(
        productName: e.productName,
        weight: e.weight,
        image: e.imageUrl,
        price: e.price,
        quantity: e.quantity,
      );

  OrderLineItemEntity toEntity() => OrderLineItemEntity(
    productName: productName,
    weight: weight,
    imageUrl: image,
    price: price,
    quantity: quantity,
  );
}
