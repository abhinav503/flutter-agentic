part of 'checkout_bloc.dart';

@freezed
sealed class CheckoutState with _$CheckoutState {
  const factory CheckoutState.idle() = CheckoutIdle;
  const factory CheckoutState.submitting() = CheckoutSubmitting;
  const factory CheckoutState.success({required OrderEntity order}) =
      CheckoutSuccess;

  /// [items] is the exact cart snapshot the failed attempt submitted — a
  /// retry re-dispatches with these, same "error carries retry context"
  /// convention as every other `*Error` state in this app.
  const factory CheckoutState.failure({
    required String message,
    required List<CartItemEntity> items,
  }) = CheckoutFailure;
}
