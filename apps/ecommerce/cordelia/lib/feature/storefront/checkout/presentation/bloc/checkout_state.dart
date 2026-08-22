part of 'checkout_bloc.dart';

@freezed
sealed class CheckoutState with _$CheckoutState {
  const factory CheckoutState.idle() = CheckoutIdle;

  /// The whole checkout flow is in flight — payment intent, provider
  /// checkout, and order placement all run under this one state, so the CTA
  /// simply shows its loading state from tap to finish.
  const factory CheckoutState.submitting() = CheckoutSubmitting;

  const factory CheckoutState.success({required OrderEntity order}) =
      CheckoutSuccess;

  /// [items], [addressId], and [couponCode] are the exact inputs the failed
  /// attempt submitted — a retry re-dispatches with these, same "error
  /// carries retry context" convention as every other `*Error` state in
  /// this app.
  ///
  /// [code] is *why*, when the server named it: [message] is what the
  /// shopper reads, the code is what the screen acts on. Anything the
  /// server didn't name — a network drop, a cancelled payment sheet —
  /// arrives as [CheckoutRefusalCode.other].
  const factory CheckoutState.failure({
    required String message,
    required List<CartItemEntity> items,
    required String addressId,
    @Default(CheckoutRefusalCode.other) CheckoutRefusalCode code,
    @Default('') String couponCode,
  }) = CheckoutFailure;
}
