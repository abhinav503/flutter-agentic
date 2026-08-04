import '../../domain/entities/cart_item_entity.dart';
import '../models/applied_coupon_model.dart';

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
