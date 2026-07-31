part of 'checkout_bloc.dart';

@freezed
sealed class CheckoutEvent with _$CheckoutEvent {
  /// The "Proceed to Checkout" CTA, after a delivery address is picked. The
  /// BLoC runs the whole flow from here (payment intent → provider checkout →
  /// order placement); the screen never touches the payment provider.
  const factory CheckoutEvent.submitted({
    required List<CartItemEntity> items,
    required String addressId,
  }) = CheckoutSubmitted;
}
