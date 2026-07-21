part of 'checkout_bloc.dart';

@freezed
sealed class CheckoutEvent with _$CheckoutEvent {
  const factory CheckoutEvent.submitted({
    required List<CartItemEntity> items,
    required String addressId,
  }) = CheckoutSubmitted;
}
