import 'package:cordelia/enums/order_status.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/order_status_change_entity.dart';

part 'order_status_change_model.freezed.dart';
part 'order_status_change_model.g.dart';

/// One entry of an order's `status_history` — the server's dated record of a
/// single transition.
@freezed
abstract class OrderStatusChangeModel with _$OrderStatusChangeModel {
  const OrderStatusChangeModel._();

  const factory OrderStatusChangeModel({
    required String status,
    required String at,
  }) = _OrderStatusChangeModel;

  factory OrderStatusChangeModel.fromJson(Map<String, dynamic> json) =>
      _$OrderStatusChangeModelFromJson(json);

  factory OrderStatusChangeModel.fromEntity(OrderStatusChangeEntity e) =>
      OrderStatusChangeModel(
        status: e.status.wireValue,
        at: e.at.toUtc().toIso8601String(),
      );

  OrderStatusChangeEntity toEntity() => OrderStatusChangeEntity(
    status: status.toOrderStatus(),
    // Local, for the same reason as OrderModel.placedAt — every dated step
    // in a status timeline arrives as a UTC string.
    at: DateTime.parse(at).toLocal(),
  );
}
