import 'package:core/core/error/failure.dart';
import 'package:core/core/usecase/usecase.dart';
import 'package:fpdart/fpdart.dart';

import '../entities/applied_coupon_entity.dart';
import '../entities/cart_item_entity.dart';
import '../repository/coupons_repository.dart';

class ValidateCouponParams {
  final String storeId;
  final String code;
  final List<CartItemEntity> items;

  const ValidateCouponParams({
    required this.storeId,
    required this.code,
    required this.items,
  });
}

class ValidateCouponUseCase
    extends
        UseCase<Either<Failure, AppliedCouponEntity>, ValidateCouponParams> {
  final CouponsRepository _repository;

  const ValidateCouponUseCase(this._repository);

  @override
  Future<Either<Failure, AppliedCouponEntity>> call(
    ValidateCouponParams params,
  ) => _repository.validateCoupon(params.storeId, params.code, params.items);
}
