part of 'address_bloc.dart';

@freezed
sealed class AddressEvent with _$AddressEvent {
  const factory AddressEvent.started() = AddressStarted;
  const factory AddressEvent.selected({required String addressId}) =
      AddressSelected;

  /// Dispatched when the Add/Edit Address form returns a result — an empty
  /// id is a new address (created via the API, appended with the
  /// server-assigned id, and auto-selected since the user just created it
  /// to use it); a non-empty id is an edit (updated and replaced in place).
  const factory AddressEvent.saved({required AddressEntity address}) =
      AddressSaved;
}
