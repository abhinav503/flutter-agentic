part of 'address_bloc.dart';

@freezed
sealed class AddressEvent with _$AddressEvent {
  const factory AddressEvent.started() = AddressStarted;
  const factory AddressEvent.selected({required String addressId}) =
      AddressSelected;

  /// Dispatched when the Add/Edit Address form returns a result — an id
  /// already in the list is an edit (replaced in place); an unrecognised id
  /// is a new address (appended and auto-selected, since the user just
  /// created it to use it).
  const factory AddressEvent.saved({required AddressEntity address}) =
      AddressSaved;
}
