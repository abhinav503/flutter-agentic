import 'package:cordelia/constants/api_constants.dart';
import 'package:cordelia/constants/value_const.dart';
import 'package:cordelia/services/firebase_auth_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show visibleForTesting;

import 'package:core/core/extensions/num_extensions.dart';
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

    try {
      return await _post(storeId, code, items, idToken);
    } on DioException catch (e) {
      final rejection = rejectionFrom(e);
      if (rejection == null) rethrow;
      throw rejection;
    }
  }

  /// A 400 the server tagged with a machine-readable `code`, rendered here so
  /// the amount carries the store's currency. Anything else returns null and
  /// falls through to the usual Dio → Failure mapping, which surfaces the
  /// server's own `error` text.
  ///
  /// Exposed for tests: reaching it through [validateCoupon] would need a live
  /// HTTP call, and the translation is the part that regressed.
  @visibleForTesting
  CouponRejectedException? rejectionFrom(DioException e) {
    final body = e.response?.data;
    if (body is! Map) return null;
    if (body['code'] != 'min_order') return null;
    final minimum = body['minOrderValue'];
    if (minimum is! num) return null;
    return CouponRejectedException(
      ValueConst.couponMinOrderMessage(minimum.asPrice),
    );
  }

  Future<AppliedCouponModel> _post(
    String storeId,
    String code,
    List<CartItemEntity> items,
    String? idToken,
  ) async {
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
                if (item.variantId != null) 'variantId': item.variantId,
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
