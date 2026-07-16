part of 'cart_bloc.dart';

@freezed
sealed class CartEvent with _$CartEvent {
  const factory CartEvent.started() = CartStarted;
}
