/// A coupon the backend has validated against the current cart — [discount]
/// is the server's figure for these exact lines, never computed client-side
/// (scope rules need catalog data the cart doesn't carry). Checkout sends
/// only [code]; the server re-prices at order time.
class AppliedCouponEntity {
  final String code;
  final double discount;

  const AppliedCouponEntity({required this.code, required this.discount});
}
