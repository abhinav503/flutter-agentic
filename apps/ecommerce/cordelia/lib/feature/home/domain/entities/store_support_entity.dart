/// How a shopper reaches the people who can fix their order.
///
/// The store's own contact, published by its owner in the console. Every
/// field is optional and an unfilled one is not a dead end: the Help &
/// Support screen always offers the CordeliaApps address underneath, which
/// is also the right channel for the problems a store cannot help with —
/// signing in, the app itself, deleting an account.
class StoreSupportEntity {
  /// Where a shopper writes about an order. Empty = the store publishes none.
  final String email;

  /// Dialled as typed by the owner, country code included. Empty = none.
  final String phone;

  /// When someone answers, in the store's own words and language
  /// ("Mon–Sat, 9am–7pm"). Empty = the store hasn't said.
  final String hours;

  const StoreSupportEntity({this.email = '', this.phone = '', this.hours = ''});

  /// What a store that has never opened the support settings publishes —
  /// and what every store predating the field reads back as.
  static const StoreSupportEntity none = StoreSupportEntity();
}

extension StoreSupportX on StoreSupportEntity {
  bool get hasEmail => email.isNotEmpty;
  bool get hasPhone => phone.isNotEmpty;
  bool get hasHours => hours.isNotEmpty;

  /// Whether this store publishes any way to reach it. False means the
  /// screen renders the platform fallback alone — still a channel, just not
  /// the store's own.
  bool get hasAny => hasEmail || hasPhone;
}
