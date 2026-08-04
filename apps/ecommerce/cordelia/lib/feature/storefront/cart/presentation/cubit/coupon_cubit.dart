import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/applied_coupon_entity.dart';
import '../../domain/entities/cart_item_entity.dart';
import '../../domain/usecase/validate_coupon_usecase.dart';

/// The applied coupon's lifecycle — exhaustively switched by the promo rows.
sealed class CouponState {
  const CouponState();
}

class CouponNone extends CouponState {
  const CouponNone();
}

class CouponApplying extends CouponState {
  const CouponApplying();
}

class CouponApplied extends CouponState {
  final AppliedCouponEntity coupon;
  const CouponApplied({required this.coupon});
}

/// Carries the entered [code] so the row can retry without the shopper
/// retyping it (the error-retry-context rule).
class CouponFailed extends CouponState {
  final String message;
  final String code;
  const CouponFailed({required this.message, required this.code});
}

/// The coupon applied to the current store's cart — provided at the app root
/// beside [CartCubit], since the promo row (Cart) and the flow that consumes
/// the code (Checkout) live on separate GoRouter pages.
///
/// The held discount is only ever the server's figure for a specific set of
/// lines, so cart screens call [revalidate] when the cart changes and the
/// order transaction re-prices the code regardless — a stale preview can
/// never change what's charged.
class CouponCubit extends Cubit<CouponState> {
  final ValidateCouponUseCase _validateCoupon;

  CouponCubit({required ValidateCouponUseCase validateCouponUseCase})
    : _validateCoupon = validateCouponUseCase,
      super(const CouponNone());

  Future<void> apply(
    String storeId,
    String code,
    List<CartItemEntity> items,
  ) async {
    final trimmed = code.trim();
    if (trimmed.isEmpty || items.isEmpty) return;
    emit(const CouponApplying());
    final result = await _validateCoupon(
      ValidateCouponParams(storeId: storeId, code: trimmed, items: items),
    );
    result.fold(
      (failure) => emit(CouponFailed(message: failure.message, code: trimmed)),
      (coupon) => emit(CouponApplied(coupon: coupon)),
    );
  }

  /// Re-prices the applied code against the cart's new lines. An empty cart
  /// or a code that stopped qualifying surfaces as [CouponFailed] (with the
  /// server's reason), so the discount never silently lingers on lines it
  /// wasn't priced for.
  Future<void> revalidate(String storeId, List<CartItemEntity> items) async {
    final current = state;
    if (current is! CouponApplied) return;
    if (items.isEmpty) {
      emit(const CouponNone());
      return;
    }
    await apply(storeId, current.coupon.code, items);
  }

  void remove() => emit(const CouponNone());

  /// Store switch / sign-out / order placed — same job as CartCubit.reset.
  void reset() => emit(const CouponNone());
}
