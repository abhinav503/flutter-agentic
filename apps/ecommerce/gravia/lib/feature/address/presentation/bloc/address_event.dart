part of 'address_bloc.dart';

@freezed
sealed class AddressEvent with _$AddressEvent {
  const factory AddressEvent.started() = AddressStarted;
  const factory AddressEvent.selected({required String addressId}) =
      AddressSelected;
}
