part of 'address_bloc.dart';

@freezed
sealed class AddressState with _$AddressState {
  const factory AddressState.loading() = AddressLoading;
  const factory AddressState.loaded({
    required List<AddressEntity> addresses,
    required String selectedAddressId,
    // One-shot "couldn't save" signal for the screen's snackbar. The list
    // keeps its pre-save contents (saves aren't optimistic — nothing to
    // roll back); the next selection/save emit resets it via the default.
    @Default(false) bool saveFailed,
    // Same one-shot pattern as [saveFailed], for a failed delete.
    @Default(false) bool deleteFailed,
  }) = AddressLoaded;
  const factory AddressState.error({required String message}) = AddressError;
}
