import 'package:core/core/extensions/date_time_extensions.dart';

import 'package:cordelia/constants/value_const.dart';
import 'package:cordelia/enums/order_status.dart';
import 'package:cordelia/feature/storefront/address/domain/entities/address_entity.dart';

import 'order_line_item_entity.dart';
import 'order_status_change_entity.dart';

class OrderEntity {
  final String id;
  final OrderStatus status;

  /// Whether this order's payment has been returned — only meaningful once
  /// [status] is [OrderStatus.cancelled]; [RefundStatus.none] otherwise.
  final RefundStatus refundStatus;

  final DateTime placedAt;

  /// Every status this order has been through, oldest first — the only
  /// record of *when* it moved, since [status] holds just the current value.
  /// Read it through [statusReachedAt] rather than scanning it directly.
  ///
  /// Empty only for mock-data orders; the server always sends at least the
  /// placement entry, synthesizing one for orders that predate the field
  /// (their later steps are then undated).
  final List<OrderStatusChangeEntity> statusHistory;

  /// The gateway payment this order was placed against — the reference a
  /// shopper quotes to support. Empty when the order went through the
  /// test-mode payment-less path (the web preview, which can't run the
  /// native checkout SDK).
  final String paymentId;

  /// The coupon this order was placed with — '' / 0 when none. The server's
  /// recorded total is already net of [couponDiscount]; client-side,
  /// [OrderEntityX.payableTotal] applies it over the line-item sum.
  final String couponCode;
  final double couponDiscount;

  /// What delivery cost on this order, snapshotted by the server at
  /// placement — 0 both for a store that delivers free and for every order
  /// placed before stores could charge for it. Included in the recorded
  /// total, and in [OrderEntityX.payableTotal].
  final double deliveryFee;

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

  /// The shopper's rating of this *delivery*, 1–5, or 0 when they haven't
  /// rated it. A different question from what they thought of a product —
  /// that's a product review, which anyone signed in may write. Only a
  /// delivered order can carry one.
  final int rating;
  final String reviewText;

  /// When the rating was last given; null when unrated.
  final DateTime? reviewedAt;

  const OrderEntity({
    required this.id,
    required this.status,
    required this.placedAt,
    required this.deliveryOtp,
    required this.items,
    this.refundStatus = RefundStatus.none,
    this.deliveryAddress,
    this.statusHistory = const [],
    this.paymentId = '',
    this.couponCode = '',
    this.couponDiscount = 0,
    this.deliveryFee = 0,
    this.rating = 0,
    this.reviewText = '',
    this.reviewedAt,
  });
}

extension OrderEntityX on OrderEntity {
  double get totalPrice => items.total;

  /// Whether this order can be rated at all — only after it arrives. An
  /// order still on its way, or cancelled, has no delivery to judge.
  bool get canBeRated => status == OrderStatus.delivered;

  bool get isRated => rating > 0;

  /// What was actually charged — the line-item sum net of the coupon plus
  /// the delivery fee, the same figure the server recorded as the order's
  /// total.
  double get payableTotal => items.total - couponDiscount + deliveryFee;

  /// Whether any line item's product name contains [term], case-insensitively
  /// — an order is searchable by what's *in* it, since it has no name of its
  /// own. An empty term matches everything, so the caller needn't special-case
  /// "nothing typed yet".
  bool matchesSearch(String term) {
    final query = term.trim().toLowerCase();
    if (query.isEmpty) return true;
    return items.any((item) => item.productName.toLowerCase().contains(query));
  }

  /// When this order reached [status], or null if it never did — or did
  /// before the server recorded transition times.
  ///
  /// The **last** matching entry, not the first: the history is append-only,
  /// so an admin correcting a mistaken status leaves the same status in it
  /// twice, and the later one is when the order actually settled there.
  DateTime? statusReachedAt(OrderStatus status) {
    for (final change in statusHistory.reversed) {
      if (change.status == status) return change.at;
    }
    return null;
  }
}

/// The order-domain display formats, composed from core's locale-aware
/// [DateTimePartsX] renderings.
///
/// `DateFormat` renders a `DateTime` in *its own* zone, so every timestamp
/// reaching these formats must already be local — the data layer converts on
/// the way in (`OrderModel.toEntity`). It did not always: this comment used
/// to claim order timestamps were naive-local, which was true of the bundled
/// mock JSON and stopped being true the day the backend began sending
/// `toISOString()`. The claim outlived its data and is why nobody noticed an
/// IST shopper reading their 9:33 PM order as 4:04 PM.
extension OrderPlacedAtX on DateTime {
  /// "Mon, Mar 9, 2026 at 10:15 AM" · de: "Mo., 9. März 2026 um 10:15".
  /// The connector is copy (it isn't "at" everywhere) and the two operands are
  /// locale-ordered by their skeletons, so no piece of this is hardcoded.
  String get orderPlacedLabel =>
      ValueConst.orderPlacedAtLabel(asWeekdayDate, asTime);

  /// The compact date form ("Mar 9, 2026") — no weekday or time, per the kit's
  /// Order Filter screen. Used by gravia's filter sheet date fields and by
  /// dailymart's order card, which has room for a date only if it drops the
  /// weekday and time. `as*` naming (like core's `asPrice`) keeps it from
  /// colliding with the sheet's `GraviaValueConst.filterDateLabel` copy const.
  ///
  /// The day is no longer zero-padded: padding was the kit's English-only
  /// cosmetic, and the locale's own skeleton decides digit width along with
  /// the piece order it needs anyway.
  String get asFilterDate => asCompactDate;
}
