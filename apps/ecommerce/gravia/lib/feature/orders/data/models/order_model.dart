import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:gravia/enums/order_status.dart';
import 'package:gravia/feature/address/data/models/address_model.dart';

import '../../domain/entities/order_entity.dart';
import 'order_line_item_model.dart';

part 'order_model.freezed.dart';
part 'order_model.g.dart';

@freezed
abstract class OrderModel with _$OrderModel {
  const OrderModel._();

  const factory OrderModel({
    required String id,
    required String status,
    // Defaulted: orders placed before the refund axis existed (and the
    // fromEntity path) omit it — parsed to RefundStatus.none in toEntity.
    @JsonKey(name: 'refund_status') @Default('NONE') String refundStatus,
    @JsonKey(name: 'placed_at') required String placedAt,
    @JsonKey(name: 'delivery_otp') required String deliveryOtp,
    required List<OrderLineItemModel> items,
    // Reuses AddressModel — the server serializes the snapshot through the
    // same shape the /users/addresses endpoints use. Nullable: legacy orders
    // predate the field.
    @JsonKey(name: 'delivery_address') AddressModel? deliveryAddress,
  }) = _OrderModel;

  factory OrderModel.fromJson(Map<String, dynamic> json) =>
      _$OrderModelFromJson(json);

  factory OrderModel.fromEntity(OrderEntity e) => OrderModel(
    id: e.id,
    // Matches OrderStatusParse's expected wire format — inlined here rather
    // than a reusable enum -> string extension, since orders.json is
    // read-only mock data and this direction has no other caller.
    status: switch (e.status) {
      OrderStatus.pending => 'PENDING',
      OrderStatus.inProcess => 'IN_PROCESS',
      OrderStatus.delivered => 'DELIVERED',
      OrderStatus.cancelled => 'CANCELLED',
    },
    refundStatus: switch (e.refundStatus) {
      RefundStatus.none => 'NONE',
      RefundStatus.pending => 'PENDING',
      RefundStatus.processed => 'PROCESSED',
      RefundStatus.failed => 'FAILED',
    },
    placedAt: e.placedAt.toIso8601String(),
    deliveryOtp: e.deliveryOtp,
    items: e.items.map(OrderLineItemModel.fromEntity).toList(),
    deliveryAddress: e.deliveryAddress == null
        ? null
        : AddressModel.fromEntity(e.deliveryAddress!),
  );

  OrderEntity toEntity() => OrderEntity(
    id: id,
    status: status.toOrderStatus(),
    refundStatus: refundStatus.toRefundStatus(),
    placedAt: DateTime.parse(placedAt),
    deliveryOtp: deliveryOtp,
    items: items.map((m) => m.toEntity()).toList(),
    deliveryAddress: deliveryAddress?.toEntity(),
  );
}
