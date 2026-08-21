import 'package:cordelia/enums/order_status.dart';
import 'package:cordelia/feature/storefront/address/data/models/address_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/order_entity.dart';
import 'order_line_item_model.dart';
import 'order_status_change_model.dart';

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
    // Defaulted: the bundled mock orders carry no timeline, and neither does
    // the fromEntity path.
    @JsonKey(name: 'status_history')
    @Default(<OrderStatusChangeModel>[])
    List<OrderStatusChangeModel> statusHistory,
    @JsonKey(name: 'delivery_otp') required String deliveryOtp,
    // Defaulted: empty on the payment-less path, and absent from the mock
    // orders and from orders serialized before the field existed.
    @JsonKey(name: 'payment_id') @Default('') String paymentId,
    // Defaulted: orders placed without a coupon (and those predating the
    // feature) omit both.
    @JsonKey(name: 'coupon_code') @Default('') String couponCode,
    @JsonKey(name: 'coupon_discount') @Default(0) double couponDiscount,
    // Defaulted for the same reason as the coupon pair: orders placed before
    // stores could charge for delivery carry no field, and 0 is the true
    // figure for them — they were all delivered free.
    @JsonKey(name: 'delivery_fee') @Default(0) double deliveryFee,
    // The shopper's rating of this delivery. Defaulted: 0 is every order
    // that hasn't been rated, including every one placed before the feature
    // existed, and reviewed_at is absent for exactly the same set.
    @Default(0) int rating,
    @JsonKey(name: 'review_text') @Default('') String reviewText,
    @JsonKey(name: 'reviewed_at') @Default('') String reviewedAt,
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
    status: e.status.wireValue,
    statusHistory: e.statusHistory
        .map(OrderStatusChangeModel.fromEntity)
        .toList(),
    refundStatus: switch (e.refundStatus) {
      RefundStatus.none => 'NONE',
      RefundStatus.pending => 'PENDING',
      RefundStatus.processed => 'PROCESSED',
      RefundStatus.failed => 'FAILED',
    },
    placedAt: e.placedAt.toUtc().toIso8601String(),
    deliveryOtp: e.deliveryOtp,
    paymentId: e.paymentId,
    couponCode: e.couponCode,
    couponDiscount: e.couponDiscount,
    deliveryFee: e.deliveryFee,
    rating: e.rating,
    reviewText: e.reviewText,
    reviewedAt: e.reviewedAt?.toUtc().toIso8601String() ?? '',
    items: e.items.map(OrderLineItemModel.fromEntity).toList(),
    deliveryAddress: e.deliveryAddress == null
        ? null
        : AddressModel.fromEntity(e.deliveryAddress!),
  );

  OrderEntity toEntity() => OrderEntity(
    id: id,
    status: status.toOrderStatus(),
    refundStatus: refundStatus.toRefundStatus(),
    // toLocal(): the server sends UTC (`new Date().toISOString()`, with the
    // Z suffix), and DateTime.parse keeps a Z string in UTC. DateFormat then
    // renders a DateTime in *its own* zone, so without this an IST shopper
    // read their 9:33 PM order as 4:04 PM — and a US one would read the wrong
    // day. UTC on the wire is right; converting on the way in is the fix.
    placedAt: DateTime.parse(placedAt).toLocal(),
    statusHistory: statusHistory.map((m) => m.toEntity()).toList(),
    deliveryOtp: deliveryOtp,
    paymentId: paymentId,
    couponCode: couponCode,
    couponDiscount: couponDiscount,
    deliveryFee: deliveryFee,
    rating: rating,
    reviewText: reviewText,
    // '' (unrated) and a malformed value both read as null — the rating
    // itself is what says whether one exists.
    reviewedAt: DateTime.tryParse(reviewedAt)?.toLocal(),
    items: items.map((m) => m.toEntity()).toList(),
    deliveryAddress: deliveryAddress?.toEntity(),
  );
}
