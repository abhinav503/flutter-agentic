import '../../domain/entities/cart_item_entity.dart';
import '../models/applied_coupon_model.dart';

/// A coupon the server priced and refused, carrying copy the *client* built.
///
/// One rejection names an amount ("minimum of …"), and only this side can
/// write it: the amount's currency belongs to the store and its separators to
/// the shopper's locale, neither of which the API knows without loading the
/// store doc on a payment path. So the server sends `minOrderValue` as a bare
/// number plus a `code`, and the data source turns it into a sentence.
class CouponRejectedException implements Exception {
  final String message;

  const CouponRejectedException(this.message);

  @override
  String toString() => message;
}

abstract interface class CouponsRemoteDataSource {
  /// POST .../coupons/validate — the server prices the code against these
  /// exact lines (productId/quantity/sizeValue only, never a client price)
  /// and answers with the discount it will grant at order time.
  Future<AppliedCouponModel> validateCoupon(
    String storeId,
    String code,
    List<CartItemEntity> items,
  );
}
