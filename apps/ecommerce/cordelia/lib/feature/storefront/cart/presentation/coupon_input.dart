import 'package:flutter/widgets.dart';

import '../domain/entities/applied_coupon_entity.dart';
import 'cubit/coupon_cubit.dart';

/// The promo-code field's state, shared by every template.
///
/// Each pack draws the row very differently — a recessed strip, a dashed
/// voucher, a pill — but underneath, all three were keeping the same
/// controller, deriving the same three values out of [CouponState] with the
/// same three switches, and clearing the field the same way on remove. Only
/// the chrome was ever pack-specific.
///
/// Hosts supply where the state comes from and what to do about it; the
/// widget keeps its own layout:
///
/// ```dart
/// class _RowState extends State<PromoRow> with CouponInput {
///   @override CouponState get couponState => widget.couponState;
///   @override ValueChanged<String> get onApplyCoupon => widget.onApply;
///   @override VoidCallback get onRemoveCoupon => widget.onRemove;
/// }
/// ```
mixin CouponInput<T extends StatefulWidget> on State<T> {
  CouponState get couponState;
  ValueChanged<String> get onApplyCoupon;
  VoidCallback get onRemoveCoupon;

  /// The typed code. Owned here so the clear-on-remove can't be forgotten
  /// in one pack and not another.
  final codeController = TextEditingController();

  @override
  void dispose() {
    codeController.dispose();
    super.dispose();
  }

  /// The coupon currently on the basket, or null — what tells a row to show
  /// its applied state instead of its input.
  AppliedCouponEntity? get appliedCoupon => switch (couponState) {
    CouponApplied(:final coupon) => coupon,
    _ => null,
  };

  /// Why the last attempt was refused, or null. Rendered by the row, not
  /// snackbarred: the field that caused it is right there.
  String? get couponError => switch (couponState) {
    CouponFailed(:final message) => message,
    _ => null,
  };

  /// True while the server is checking — rows disable the field and swap
  /// their action for a busy indicator.
  bool get isApplyingCoupon => couponState is CouponApplying;

  void applyCoupon() => onApplyCoupon(codeController.text);

  /// Clears the field as well as the basket: leaving the removed code
  /// sitting in the input reads as though it were still applied.
  void removeCoupon() {
    codeController.clear();
    onRemoveCoupon();
  }
}
