/// What a notification is *about*, independent of how any storefront draws
/// it. The shared data layer carries this; each template maps it to its own
/// pack glyph (see `GraviaImageConst` / `DailyMartImageConst`) — an asset
/// path in the data would pin every store to one pack's artwork.
enum NotificationKind {
  discount,
  orderPlaced,
  orderDelivered,
  payment,
  account,
  security,
}

/// Wire value → enum. Tolerates an unknown kind (a backend that starts
/// sending `shipmentDelayed` shouldn't blank the list) by falling back to
/// `account`, the pack-neutral "something happened to you" glyph.
extension NotificationKindParse on String {
  NotificationKind toNotificationKind() => switch (this) {
    'discount' => NotificationKind.discount,
    'orderPlaced' => NotificationKind.orderPlaced,
    'orderDelivered' => NotificationKind.orderDelivered,
    'payment' => NotificationKind.payment,
    'security' => NotificationKind.security,
    _ => NotificationKind.account,
  };
}
