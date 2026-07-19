part of 'checkout_bloc.dart';

@freezed
sealed class CheckoutEvent with _$CheckoutEvent {
  const factory CheckoutEvent.submitted({
    required List<CartItemEntity> items,
  }) = CheckoutSubmitted;
}
