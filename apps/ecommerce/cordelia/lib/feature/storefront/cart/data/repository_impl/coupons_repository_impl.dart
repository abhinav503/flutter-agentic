import 'package:core/core/base/base_repository.dart';
import 'package:core/core/error/failure.dart';
import 'package:fpdart/fpdart.dart';

import '../../domain/entities/applied_coupon_entity.dart';
import '../../domain/entities/cart_item_entity.dart';
import '../../domain/repository/coupons_repository.dart';
import '../data_source/coupons_remote_data_source.dart';

class CouponsRepositoryImpl with BaseRepository implements CouponsRepository {
  final CouponsRemoteDataSource _dataSource;

  const CouponsRepositoryImpl(this._dataSource);

  @override
  Future<Either<Failure, AppliedCouponEntity>> validateCoupon(
    String storeId,
    String code,
    List<CartItemEntity> items,
  ) => handleRequest(() async {
    try {
      final model = await _dataSource.validateCoupon(storeId, code, items);
      return right(model.toEntity());
    } on CouponRejectedException catch (e) {
      // Already a finished sentence in the shopper's language — handleRequest's
      // generic mapping would replace it with the server's English fallback.
      return left(Failure.server(statusCode: 400, message: e.message));
    }
  });
}
