import 'package:core/core/error/failure.dart';
import 'package:fpdart/fpdart.dart';

import '../entities/applied_coupon_entity.dart';
import '../entities/cart_item_entity.dart';

abstract interface class CouponsRepository {
  /// Validates [code] against the current cart lines and returns the
  /// discount the order will be granted for them. A rejected code (expired,
  /// wrong scope, limits…) comes back as a server Failure whose message is
  /// the shopper-facing reason.
  Future<Either<Failure, AppliedCouponEntity>> validateCoupon(
    String storeId,
    String code,
    List<CartItemEntity> items,
  );
}
