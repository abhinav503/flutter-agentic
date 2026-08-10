/// What a store charges to deliver, and where it delivers at all.
///
/// Display-only on this side. The server recomputes both halves from the same
/// store doc when it prices the cart and again when it places the order, so
/// nothing here decides what a shopper pays — it decides what they're *told*
/// before they get there, and spares them a refused checkout.
class StoreDeliveryEntity {
  /// Charged per order in the store's currency. 0 = never charged.
  final double fee;

  /// Basket total at or above which [fee] is waived. 0 = no threshold.
  final double freeAbove;

  /// Postal-code prefixes the store delivers to; empty = everywhere.
  final List<String> areas;

  const StoreDeliveryEntity({
    this.fee = 0,
    this.freeAbove = 0,
    this.areas = const [],
  });

  /// Free delivery, everywhere — what every store did before the policy
  /// existed, and what a store doc without the field still means.
  static const StoreDeliveryEntity free = StoreDeliveryEntity();
}

extension StoreDeliveryX on StoreDeliveryEntity {
  /// Whether [postalCode] is inside [areas].
  ///
  /// Mirrors the server's `isServiceable` exactly, including its two lenient
  /// cases: no areas means the store delivers everywhere, and an address with
  /// no postal code (the field is optional in the form, and predates it
  /// entirely) is never blocked on a code it was never asked for.
  bool serves(String postalCode) {
    if (areas.isEmpty) return true;
    final code = _normalize(postalCode);
    if (code.isEmpty) return true;
    return areas.any((prefix) => code.startsWith(prefix));
  }

  /// The fee on a basket of [goodsSubtotal] — the total **after** any coupon,
  /// which is the same figure the server measures the threshold against.
  double feeFor(double goodsSubtotal) {
    if (fee <= 0) return 0;
    if (freeAbove > 0 && goodsSubtotal >= freeAbove) return 0;
    return fee;
  }

  /// Whether this store ever charges for delivery. A store that doesn't can
  /// print "Free" without consulting the basket.
  bool get isAlwaysFree => fee <= 0;
}

String _normalize(String code) =>
    code.replaceAll(RegExp(r'\s+'), '').toUpperCase();
