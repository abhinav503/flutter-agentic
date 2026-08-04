import 'package:cordelia/constants/api_constants.dart';
import 'package:cordelia/services/firebase_auth_service.dart';
import 'package:dio/dio.dart';

import 'package:core/core/network/http_service.dart';

import '../../domain/entities/cart_item_entity.dart';
import '../models/applied_coupon_model.dart';
import 'coupons_remote_data_source.dart';

class CouponsRemoteDataSourceImpl implements CouponsRemoteDataSource {
  const CouponsRemoteDataSourceImpl();

  // Token-verified because per-user limits key on the caller's uid — the
  // server rejects a missing/invalid token with 401, surfaced as a Failure.
  @override
  Future<AppliedCouponModel> validateCoupon(
    String storeId,
    String code,
    List<CartItemEntity> items,
  ) async {
    final idToken = await FirebaseAuthService.instance.idToken();

    final response = await HttpService.instance.post<Map<String, dynamic>>(
      ApiConstants.couponValidatePath(storeId),
      data: {
        'code': code,
        // Same line payload as order creation, so the previewed discount is
        // priced against exactly what checkout will send.
        'items': items
            .map(
              (item) => {
                'productId': item.product.id,
                'quantity': item.quantity,
                if (item.sizeValue != null) 'sizeValue': item.sizeValue,
              },
            )
            .toList(),
      },
      options: Options(headers: {'Authorization': 'Bearer $idToken'}),
    );
    return AppliedCouponModel.fromJson(response.data!);
  }
}
