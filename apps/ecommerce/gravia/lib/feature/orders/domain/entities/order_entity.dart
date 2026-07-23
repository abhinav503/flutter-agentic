import 'package:gravia/enums/order_status.dart';
import 'package:gravia/feature/address/domain/entities/address_entity.dart';

import 'order_line_item_entity.dart';

class OrderEntity {
  final String id;
  final OrderStatus status;

  /// Whether this order's payment has been returned — only meaningful once
  /// [status] is [OrderStatus.cancelled]; [RefundStatus.none] otherwise.
  final RefundStatus refundStatus;

  final DateTime placedAt;

  /// 4-digit code the delivery agent verifies on handoff for the whole
  /// order — only meaningful while [status] is [OrderStatus.inProcess];
  /// empty for delivered/cancelled orders (nothing left to hand off).
  final String deliveryOtp;

  /// The products in this order — an order is one delivery of possibly
  /// several products, each with its own quantity and line price, not a
  /// single product by itself.
  final List<OrderLineItemEntity> items;

  /// The delivery address chosen at checkout, snapshotted onto the order by
  /// the server — null only for legacy orders placed before the address
  /// step existed (the server sends an empty address for those).
  final AddressEntity? deliveryAddress;

  const OrderEntity({
    required this.id,
    required this.status,
    required this.placedAt,
    required this.deliveryOtp,
    required this.items,
    this.refundStatus = RefundStatus.none,
    this.deliveryAddress,
  });
}

extension OrderEntityX on OrderEntity {
  double get totalPrice => items.total;
}

/// A domain-specific display format ("Mon, Mar 9, 2026 at 10:15 AM"), not a
/// generic date formatter — no `intl` dependency for one bounded format, and
/// [DateTime.placedAt] is stored/parsed as a naive local timestamp (the mock
/// JSON's `placed_at` has no timezone suffix), so this never re-interprets
/// it through the device's own timezone.
extension OrderPlacedAtX on DateTime {
  static const _weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  static const _months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  String get orderPlacedLabel {
    final weekday = _weekdays[this.weekday - 1];
    final month = _months[this.month - 1];
    final hour12 = hour % 12 == 0 ? 12 : hour % 12;
    final minute = this.minute.toString().padLeft(2, '0');
    final period = hour < 12 ? 'AM' : 'PM';
    return '$weekday, $month $day, $year at $hour12:$minute $period';
  }

  /// The filter sheet's date-field format ("Mar 01, 2026") — zero-padded day,
  /// no weekday/time, per the kit's Order Filter screen.
  String get filterDateLabel {
    final month = _months[this.month - 1];
    final paddedDay = day.toString().padLeft(2, '0');
    return '$month $paddedDay, $year';
  }
}
